/******
See the Server Plugin API for more info
http://doc.sccode.org/Reference/ServerPluginAPI.html
*****/

// TODO: make sure multiple Trill UGens access the same I2C data?
//      This follows the idiom of Input UGens accessing global signal busses.
//      ?? does this mean I2C data should be global?


#include "Bela.h"
#include "Trill.h"
#include "SC_PlugIn.h"

// number of sensors per Trill device
#define NUM_SENSORS 26

// InterfaceTable contains pointers to global functions in the host (scserver).
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

  // Readins for all the different pads on the Trill Craft
  float sensorReading[NUM_SENSORS] = { 0.0 };


  // DEBUGGING bookkeeping
  unsigned int debugCounter = 0;
  unsigned char debugPrintRate = 4; // 4 times per second
};

// Prescaler options for Trill sensor
int gPrescalerOpts[6] = {1, 2, 4, 8, 16, 32};
// Threshold options for Trill sensor
int gThresholdOpts[7] = {0, 10, 20, 30, 40, 50, 60};


static void TrillRaw_Ctor(TrillRaw* unit); // constructor
static void TrillRaw_Dtor(TrillRaw* unit); // destructor
static void TrillRaw_next_k(TrillRaw* unit, int inNumSamples); // audio callback

/*
/*
 * Function to be run on an auxiliary task that reads data from the Trill sensor.
 * Here, a loop is defined so that the task runs recurrently for as long as the
 * audio thread is running.
void loop(void*)
{
	// loop
	while(!gShouldStop)
	{
		if(touchSensor.isReady()) {
			// Read raw data from sensor
			touchSensor.readI2C();
			for(unsigned int i = 0; i < NUM_SENSORS; i++) {
				gSensorReading[i] = map(touchSensor.rawData[i], gSensorRange[0], gSensorRange[1], 0, 1);
				gSensorReading[i] = constrain(gSensorReading[i], 0, 1);
			}
		} else {
			printf("Sensor is not ready\n");
		}

		// Sleep for ... milliseconds
		usleep(gTaskSleepTime);
	}
}


*/

// read I2C without a constant loop (this is handled in the audio thread)
void readSensor(void* data)
{
  TrillRaw *unit = (TrillRaw*)data;
	if(unit->sensor.isReady()) {
		unit->sensor.readI2C();
    for(unsigned int i=0; i < NUM_SENSORS; i++) {
      //unit->sensorReading[i] = map(unit->sensor.rawData[i], 200, 2000, 0.0, 1.0);
      unit->sensorReading[i] = unit->sensor.rawData[i];
    }
  } else {
      printf("Sensor is not ready to read!\n");
  }
}

void TrillRaw_Ctor(TrillRaw* unit) {
  int i2c_bus, i2c_address, mode, thresholdOpt, prescalerOpt;

  // Get initial arguments to UGen for I2C setup
  i2c_bus = (int)IN0(0);
  i2c_address = (int)IN0(1);
  mode = Trill::DIFF; // read all sensors, return differential from baseline
  thresholdOpt = (int)IN0(2);
  prescalerOpt = (int)IN0(3);

  // zero outputs
  for (int j = 0; j < unit->mNumOutputs; j++)
    OUT0(j) = 111.f;


  unit->readInterval = 500; // read every 500ms
  unit->readIntervalSamples = 0;
  unit->readCount = 0;
  unit->i2cReadTask = Bela_createAuxiliaryTask(readSensor, 30, "I2C-read", (void*)unit);
  unit->readIntervalSamples = SAMPLERATE * (unit->readInterval / 1000);


  if(unit->sensor.setup(i2c_bus, i2c_address, Trill::DIFF) != 0) {
      fprintf(stderr, "Unable to initialize touch sensor\n");
      return;
  } else {
    // DEFAULT OPTS are defined in TrillUGens.sc
    unit->sensor.setPrescaler(gPrescalerOpts[prescalerOpt]);
    unit->sensor.setNoiseThreshold(gThresholdOpts[thresholdOpt]);
    printf("Trill sensor found: devtype %d, firmware_v %d\n", unit->sensor.deviceType(), unit->sensor.firmwareVersion());
    printf("Initialized with outputs: %d  i2c_bus: %d  i2c_addr: %d  mode: %d  thresh: %d  pre: %d\n", unit->mNumOutputs, i2c_bus, i2c_address, mode, threshold, prescaler);
  }

/* for some reason the craft sensor appears as devicetype NONE
  just comment this out for now
  // Exit if no Trill sensor found
  if(unit->sensor.deviceType() == Trill::NONE) {
  	 fprintf(stderr, "TrillRaw UGen must be used with an attached Trill sensor. \n");
     Print("TrillRaw UGen must be used with an attached Trill sensor. \n");
     return;
   }
*/

  if(unit->sensor.isReady()) {
    unit->sensor.readI2C();
  } else {
    fprintf(stderr, "Trill Sensor is not ready for I2C read.\n");
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


  // NOTE: In general it's not a good idea to use static variables here
  //       they might be shared between plug-in instances!
  //static int readCount = 0;
  //       Put them in the unit struct instead!


  //*** DEBUGGING BOOKKEEPING ***/
  bool DEBUG = false;
  unit->debugCounter += inNumSamples;
  if(unit->debugCounter >= (SAMPLERATE / unit->debugPrintRate)) {
    unit->debugCounter = 0;
    DEBUG = true;
  }
  //*** END DEBUGGING ***/




  // check if another read is necessary before setting output samples
  for(unsigned int n=0; n < inNumSamples; n++) {
    // This kind of sample-precision is not possible
    //   in the callback with Aux tasks, BUT this is realibly
    //   counting samples so the AUX task is called at a regular rate.
    // Running Aux tasks is more of a "request" than a demand..
    //   if an Aux task is called a second time the first call will be
    //   ignored...
    unit->readCount += 1;
    if(unit->readCount >= unit->readIntervalSamples) {
      unit->readCount = 0;
      Bela_scheduleAuxiliaryTask(unit->i2cReadTask); // run the i2c read every so many samples
    }
  }

  // TODO: maybe use unit->sensor.numSensors() instead
  //       and modify TrillRaw.sc to specify a variable number of sensors

  for (int i = 0; i < unit->mNumOutputs; i++) {
    OUT0(i) = unit->sensorReading[i];
  }
}

PluginLoad(TrillRaw) {
    ft = inTable; // store pointer to InterfaceTable
    DefineSimpleUnit(TrillRaw);
}
