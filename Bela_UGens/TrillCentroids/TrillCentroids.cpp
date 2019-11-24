/******
See the Server Plugin API for more info
http://doc.sccode.org/Reference/ServerPluginAPI.html
*****/

// TODO: make sure multiple Trill UGens access the same I2C data?
//      This follows the idiom of Input UGens accessing global signal busses.
//      ?? does this mean I2C data should be global?
//  Add functionality to keep track of number of active Trill UGens and throw an error if there is more than one...

#include <Bela.h>
#include <libraries/Trill/Trill.h>
#include "SC_PlugIn.h"

// maximum number of touch centroids
#define NUM_TOUCH 5

// InterfaceTable contains pointers to global functions in the host (scserver).
static InterfaceTable *ft;

// Track the number of active Trill UGens
static int numTrillUGens = 0;

// These functions are provided by Xenomai
int rt_printf(const char *format, ...);
int rt_fprintf(FILE *stream, const char *format, ...);

// Holds UGen state variables
struct TrillCentroids : public Unit {
  Trill sensor;
  int i2c_bus, i2c_address;
  int mode;
  int noiseThreshold;
  int prescalerOpt;

  AuxiliaryTask i2cTask;
  unsigned int readInterval; // read interval in ms
  unsigned int readIntervalSamples;
  unsigned int readCount;

  bool updateNeeded = false;
  bool updateNoiseThreshold = false;
  bool updatePrescalerOpt = false;
  bool updateBaseLine = false;

  // trigger
  float prevtrig = 0.0;

  // CENTROID STATE VARIABLES
  float touchLocations[NUM_TOUCH] = { 0.0, 0.0, 0.0, 0.0, 0.0 };
  float touchSizes[NUM_TOUCH] = { 0.0, 0.0, 0.0, 0.0, 0.0 };
  int numActiveTouches = 0;

  // DEBUGGING bookkeeping
  unsigned int debugCounter = 0;
  unsigned char debugPrintRate = 4; // 4 times per second
};

/*
the "noise threshold" parameter is an integer from 5-255, where 5 is the lowest noise thresh
the touch location of centroid mode is 0-3200, normalized to 0.0-1.0 in the readSensor function
prescaler values can be 1-16 in powers of 2, although nobody is really sure what it does intuitively
it seems to adjust the timing system and has something to do with the amount of capacitance
that can be read by the circuit
*/
// Prescaler options for Trill sensor, can be a value from 1-16 in powers of 2
int gPrescalerOpts[5] = {1, 2, 4, 8, 16};

static void TrillCentroids_Ctor(TrillCentroids* unit); // constructor
static void TrillCentroids_Dtor(TrillCentroids* unit); // destructor
static void TrillCentroids_next_k(TrillCentroids* unit, int inNumSamples); // audio callback

// I2C read/write function executed in an auxiliary task
// all I2C communications are enapsulated into a single thread to avoid
// colliding read/writes
// NO I2C reads or writes should happen in the audio thread!
void updateTrill(void* data)
{
  TrillCentroids *unit = (TrillCentroids*)data;

  // 1. First update any settings that have been flagged for updating...
  if(unit->updateNeeded) {
    if(unit->updateNoiseThreshold && (unit->sensor.setNoiseThreshold(unit->noiseThreshold) != 0)) {
  		fprintf(stderr, "ERROR: Unable to set noise threshold on Trill Sensor!\n");
  	}
  	if(unit->updatePrescalerOpt && (unit->sensor.setPrescaler(gPrescalerOpts[unit->prescalerOpt]) != 0)) {
  		fprintf(stderr, "ERROR: Unable to set prescaler on Trill Sensor!\n");
  	}
    if(unit->updateBaseLine && (unit->sensor.updateBaseLine() != 0)) {
  		fprintf(stderr, "ERROR: Unable to update baseline on Trill Sensor!\n");
  	}
    if(unit->sensor.prepareForDataRead() != 0) {
  		fprintf(stderr, "ERROR: Unable to prepare Trill Sensor for reading data\n");
  	}
    unit->updateNoiseThreshold = false;
    unit->updatePrescalerOpt = false;
    unit->updateBaseLine = false;
    unit->updateNeeded = false;
  }


  // 2. Update the sensor data
  unit->sensor.readLocations(); // read latest i2c data & calculate centroids
  // Remap locations so that they are expressed in a 0-1 range
	for(int i = 0; i <  unit->sensor.numberOfTouches(); i++) {
		unit->touchLocations[i] = map(unit->sensor.touchLocation(i), 0, 3200, 0.f, 1.f);
		unit->touchSizes[i] = unit->sensor.touchSize(i);
	 }
	 unit->numActiveTouches = unit->sensor.numberOfTouches();

	 // For all inactive touches, set location and size to 0
	 for(int i = unit->numActiveTouches; i <  NUM_TOUCH; i++) {
		unit->touchLocations[i] = 0.f;
		unit->touchSizes[i] = 0.f;
	 }
}



void TrillCentroids_Ctor(TrillCentroids* unit) {
  // Get initial arguments to UGen for I2C setup
  unit->i2c_bus = (int)IN0(0);
  unit->i2c_address = (int)IN0(1);
  unit->mode = Trill::NORMAL; // tell sensor to calculate touch centroids
  unit->noiseThreshold = (int)IN0(2);
  unit->prescalerOpt = (int)IN0(3);

  numTrillUGens++;

  // zero control rate outputs
  OUT0(0) = 0.f; // num active touches
  for (int j = 0; j < NUM_TOUCH; j++) {
    OUT0((j*2)+1) = 0.f;  // location i
    OUT0((j*2)+2) = 0.f;  // size i
  }

  unit->readInterval = 100; // (MAGIC NUMBER) launch I2C aux task every 100ms
  unit->readIntervalSamples = 0; // launch I2C aux task every X samples
  unit->readCount = 0;

  // initialize / setup the Trill sensor
  if(unit->sensor.setup(unit->i2c_bus, unit->i2c_address, unit->mode, unit->noiseThreshold, gPrescalerOpts[unit->prescalerOpt]) != 0) {
    fprintf(stderr, "ERROR: Unable to initialize touch sensor\n");
    return;
  } else {
    printf("Trill sensor found: devtype %d, firmware_v %d activeUgens %d\n", unit->sensor.deviceType(), unit->sensor.firmwareVersion(), numTrillUGens);
    printf("Initialized with #outputs: %d  i2c_bus: %d  i2c_addr: %d  mode: %d  thresh: %d  pre: %d  deviceType: %d\n", unit->mNumOutputs, unit->i2c_bus, unit->i2c_address, unit->mode, unit->noiseThreshold, gPrescalerOpts[unit->prescalerOpt], unit->sensor.deviceType());
  }

  // Exit if using a 2D Trill sensor
  if(unit->sensor.deviceType() != Trill::ONED) {
    fprintf(stderr, "ERROR: You are using a sensor of device type %d that is not a Trill Bar. The UGen may not function properly.\n", unit->sensor.deviceType());
  }

  if(numTrillUGens != 1) {
    fprintf(stderr, "Big problem! There are %d active trill ugens! You may only have 1 Trill UGen active at a time.", numTrillUGens);
  }

  unit->i2cTask = Bela_createAuxiliaryTask(updateTrill, 50, "I2C-read", (void*)unit);
  unit->readIntervalSamples = SAMPLERATE * (unit->readInterval / 1000);
  //unit->sensor.readLocations(); I2C operation should not happen here..

  SETCALC(TrillCentroids_next_k); // Use the same calc function no matter what the input rate is.
  TrillCentroids_next_k(unit, 1); // calc 1 sample of output so that downstream UGens don't access garbage memory
}

void TrillCentroids_Dtor(TrillCentroids* unit)
{
	unit->sensor.cleanup(); // maybe this needs to happen on another thread?
  numTrillUGens--;
}


/*
Called every control period (16 samples is typical on the Bela)
The calculation function can have any name, but this is conventional.
the first argument must be named "unit" for the IN and OUT macros to work.
*/
void TrillCentroids_next_k(TrillCentroids* unit, int inNumSamples) {
  // NOTE: In general it's not a good idea to use static variables inside
  //        UGens as they might be shared between plug-in instances!
  //      Put state variables in the unit struct instead!
  //static int readCount = 0; // NO!

  //*** DEBUGGING BOOKKEEPING, for printing throttled output from the audio loop ***/
  bool DEBUG = false;
  unit->debugCounter += inNumSamples;
  if(unit->debugCounter >= (SAMPLERATE / unit->debugPrintRate)) {
    unit->debugCounter = 0;
    DEBUG = true;
  }
  //*** END DEBUGGING ***/

  // DO AUDIO RATE STUFF IN THIS LOOP
  for(unsigned int n=0; n < inNumSamples; n++) {
    // This kind of sample-precision is not possible using aux tasks.
    //   But at least the samples are being counted reliably, so this way
    //   the AUX task is "requested" to run at a regular rate.
    unit->readCount += 1;
    if(unit->readCount >= unit->readIntervalSamples) {
      unit->readCount = 0;
      Bela_scheduleAuxiliaryTask(unit->i2cTask); // run the i2c thread every so many samples
    }
  }

  // CHECK FOR A NONPOSITIVE->POSITIVE TRIGGER TO RECALCULATE THE BASELINE AND PRESCALER/NOISE THRESH
  float curtrig = IN0(4);
  if (curtrig > 0.f && unit->prevtrig <= 0.f) {
    int noiseThreshold = (int)IN0(2);
    int prescalerOpt = (int)IN0(3);
    if(noiseThreshold != unit->noiseThreshold) {
      unit->noiseThreshold = noiseThreshold;
      unit->updateNoiseThreshold = true;
    }
    if(prescalerOpt != unit->prescalerOpt) {
      unit->prescalerOpt = prescalerOpt;
      unit->updatePrescalerOpt = true;
    }
    unit->updateBaseLine = true;
    unit->updateNeeded = true;
  }
  unit->prevtrig = curtrig;


  // update control rate outputs
  OUT0(0) = unit->numActiveTouches;
  for (unsigned int i = 0; i < NUM_TOUCH; i++) {
    OUT0(i*2+1) = unit->touchLocations[i];
    OUT0(i*2+2) = unit->touchSizes[i];
  }
}

PluginLoad(TrillCentroids) {
    ft = inTable; // store pointer to InterfaceTable
    DefineSimpleUnit(TrillCentroids);
}
