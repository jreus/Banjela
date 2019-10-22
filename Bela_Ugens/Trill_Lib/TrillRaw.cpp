/******
See the Server Plugin API for more info
http://doc.sccode.org/Reference/ServerPluginAPI.html
*****/

#include "Bela.h"
#include "Trill.h"
#include "SC_PlugIn.h"

// InterfaceTable contains pointers to functions in the host (scserver).
static InterfaceTable *ft;

// These functions are provided by Xenomai
int rt_printf(const char *format, ...);
int rt_fprintf(FILE *stream, const char *format, ...);

// Holds UGen state variables
struct TrillRaw : public Unit {
  Trill sensor;
  AuxiliaryTask i2cReadTask;
  unsigned int readInterval; // read interval in ms
  unsigned int readIntervalSamples;
  unsigned int readCount;
};

static void TrillRaw_Ctor(TrillRaw* unit); // constructor
static void TrillRaw_Dtor(TrillRaw* unit); // destructor
static void TrillRaw_next_k(TrillRaw* unit, int inNumSamples); // audio callback


void readSensor(void* data)
{
  TrillRaw *unit = (TrillRaw*)data;
	if(unit->sensor.isReady()) {
		unit->sensor.readI2C();
	}
}

void TrillRaw_Ctor(TrillRaw* unit) {
  int i2c_bus, i2c_address, mode, threshold, prescaler;

  // Get initial arguments to UGen for I2C setup
  i2c_bus = IN0(0);
  i2c_address = IN0(1);
  mode = Trill::DIFF; // read all sensors, return differential from baseline
  threshold = IN0(2);
  prescaler = IN0(3);

  rt_printf("thresh: %d  prescaler: %d", threshold, prescaler);

  unit->readInterval = 10; // read every 10ms
  unit->readCount = 0;
  if(unit->sensor.setup(i2c_bus, i2c_address, mode, threshold, prescaler) != 0) {
      fprintf(stderr, "Unable to initialize touch sensor\n");
      Print("Unable to initialize touch sensor\n");
      return;
  }

  unit->sensor.printDetails();

/* for some reason the craft sensor appears as devicetype NONE
  just comment this out for now
  // Exit if no Trill sensor found
  if(unit->sensor.deviceType() == Trill::NONE) {
  	 fprintf(stderr, "TrillRaw UGen must be used with an attached Trill sensor. \n");
     Print("TrillRaw UGen must be used with an attached Trill sensor. \n");
     return;
   }
*/

  unit->i2cReadTask = Bela_createAuxiliaryTask(readSensor, 50, "I2C-read", (void*)unit);
  unit->readIntervalSamples = SAMPLERATE * (unit->readInterval / 1000);

  if(unit->sensor.isReady()) {
    unit->sensor.readI2C();
  } else {
    fprintf(stderr, "Trill Sensor is not ready for I2C read.\n");
    Print("Trill Sensor is not ready for I2C read.\n");
    return;
  }

  SETCALC(TrillRaw_next_k); // Use the same calc function no matter what the input rate is.
  TrillRaw_next_k(unit, 1); // calc 1 sample of output so that downstream UGens don't access garbage memory
}

void TrillRaw_Dtor(TrillRaw* unit)
{
	unit->sensor.cleanup();
}


// the calculation function can have any name, but this is conventional. the first argument must be "unit."
// this function is called every control period (64 samples is typical)
// Don't change the names of the arguments, or the helper macros won't work.
void TrillRaw_next_k(TrillRaw* unit, int inNumSamples) {

  // *** DEBUGGING ***
  static unsigned int debugCounter = 0;
  static unsigned char debugPrintRate = 4; // 4 times per second
  bool DEBUG = false;
  debugCounter += inNumSamples;
  if(debugCounter >= (SAMPLERATE / debugPrintRate)) {
    debugCounter = 0;
    DEBUG = true;
  }
  // *** END DEBUGGING ***


  // TODO: make sure multiple UGens access the same I2C data.
  //      This follows the idiom of Input UGens accessing global signal busses.
  //      ?? < does this mean I2C data should be global?
  //static int readCount = 0; // NOTE: probably not a good idea to use static variables here, might be shared between plugin instances!
  // 26 kr outputs, one for each trill sensor raw value


  // check if another read is necessary before setting output samples
  for(unsigned char n=0; n < inNumSamples; n++) {
    // This kind of sample-precision is not possible
    //   in the callback with Aux tasks, BUT this is realibly
    //   counting samples so the AUX task is called at a regular rate.
    // Running Aux tasks is more of a "request" than a demand..
    //   if an Aux task is called a second time the first call will be
    //   ignored...
    if(++unit->readCount >= unit->readIntervalSamples) {
      unit->readCount = 0;
      Bela_scheduleAuxiliaryTask(unit->i2cReadTask);
    }
  }

  for (unsigned char i = 0; i < unit->sensor.numSensors(); i++) {
      OUT0(i) = unit->sensor.rawData[i];
  }
}

PluginLoad(TrillRaw) {
    ft = inTable; // store pointer to InterfaceTable
    DefineSimpleUnit(TrillRaw);
}
