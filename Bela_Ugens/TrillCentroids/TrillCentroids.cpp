/******
See the Server Plugin API for more info
http://doc.sccode.org/Reference/ServerPluginAPI.html
*****/

// TODO: make sure multiple Trill UGens access the same I2C data?
//      This follows the idiom of Input UGens accessing global signal busses.
//      ?? does this mean I2C data should be global?

#include <Bela.h>
#include <libraries/Trill/Trill.h>
#include "SC_PlugIn.h"

// maximum number of touch centroids
#define NUM_TOUCH 5

// InterfaceTable contains pointers to global functions in the host (scserver).
static InterfaceTable *ft;

// These functions are provided by Xenomai
int rt_printf(const char *format, ...);
int rt_fprintf(FILE *stream, const char *format, ...);

// Holds UGen state variables
struct TrillCentroids : public Unit {
  Trill sensor;
  AuxiliaryTask centroidReadTask;
  unsigned int readInterval; // read interval in ms
  unsigned int readIntervalSamples;
  unsigned int readCount;

  // CENTROID STATE VARIABLES
  float touchLocations[NUM_TOUCH] = { 0.0, 0.0, 0.0, 0.0, 0.0 };
  float touchSizes[NUM_TOUCH] = { 0.0, 0.0, 0.0, 0.0, 0.0 };
  int numActiveTouches = 0;

  // DEBUGGING bookkeeping
  unsigned int debugCounter = 0;
  unsigned char debugPrintRate = 4; // 4 times per second
};

// Prescaler options for Trill sensor
int gPrescalerOpts[6] = {1, 2, 4, 8, 16, 32};
// Threshold options for Trill sensor
int gThresholdOpts[7] = {0, 10, 20, 30, 40, 50, 60};


static void TrillCentroids_Ctor(TrillCentroids* unit); // constructor
static void TrillCentroids_Dtor(TrillCentroids* unit); // destructor
static void TrillCentroids_next_k(TrillCentroids* unit, int inNumSamples); // audio callback

void readSensor(void* data)
{
  TrillCentroids *unit = (TrillCentroids*)data;
  unit->sensor.readLocations(); // read latest i2c data & calculate centroids

  // Remap locations so that they are expressed in a 0-1 range
	for(int i = 0; i <  unit->sensor.numberOfTouches(); i++) {
		unit->touchLocations[i] = map(unit->sensor.touchLocation(i), 0, 3200, 0.f, 1.f);
		unit->touchSizes[i] = unit->sensor.touchSize(i);
	 }
	 unit->numActiveTouches = unit->sensor.numberOfTouches();

	 // For all innactive touches, set location and size to 0
	 for(int i = unit->numActiveTouches; i <  NUM_TOUCH; i++) {
		unit->touchLocations[i] = 0.f;
		unit->touchSizes[i] = 0.f;
	 }
}

void TrillCentroids_Ctor(TrillCentroids* unit) {
  int i2c_bus, i2c_address, mode, thresholdOpt, prescalerOpt;

  // Get initial arguments to UGen for I2C setup
  i2c_bus = (int)IN0(0);
  i2c_address = (int)IN0(1);
  mode = Trill::NORMAL; // tell sensor to calculate touch centroids
  thresholdOpt = (int)IN0(2);
  prescalerOpt = (int)IN0(3);

  // zero outputs
  OUT0(0) = 0.f;
  for (int j = 0; j < NUM_TOUCH; j++) {
    OUT0(j*2+1) = 0.f;  // location i
    OUT0(j*2+2) = 0.f;  // size i
  }

  unit->readInterval = 100; // read every 100ms
  unit->readIntervalSamples = 0;
  unit->readCount = 0;
  unit->centroidReadTask = Bela_createAuxiliaryTask(readSensor, 50, "I2C-read", (void*)unit);
  unit->readIntervalSamples = SAMPLERATE * (unit->readInterval / 1000);

  if(unit->sensor.setup(i2c_bus, i2c_address, mode) != 0) {
    fprintf(stderr, "Unable to initialize touch sensor\n");
    return;
  } else {
    // DEFAULT OPTS are defined in TrillUGens.sc
    unit->sensor.setPrescaler(gPrescalerOpts[prescalerOpt]);
    unit->sensor.setNoiseThreshold(gThresholdOpts[thresholdOpt]);

    printf("Trill sensor found: devtype %d, firmware_v %d\n", unit->sensor.deviceType(), unit->sensor.firmwareVersion());
    printf("Initialized with outputs: %d  i2c_bus: %d  i2c_addr: %d  mode: %d  thresh: %d  pre: %d\n", unit->mNumOutputs, i2c_bus, i2c_address, mode, gThresholdOpts[thresholdOpt], gPrescalerOpts[prescalerOpt]);
  }

  // Exit if using a 2D Trill sensor
  if(unit->sensor.deviceType() == Trill::TWOD) {
  	fprintf(stderr, "TrillCentroids UGen cannot be used with a 2D Trill sensor.\n");
    return;
  }

  unit->sensor.readLocations();

  SETCALC(TrillCentroids_next_k); // Use the same calc function no matter what the input rate is.
  TrillCentroids_next_k(unit, 1); // calc 1 sample of output so that downstream UGens don't access garbage memory
}

void TrillCentroids_Dtor(TrillCentroids* unit)
{
	unit->sensor.cleanup();
}


/*
Called every control period (64 samples is typical)
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

  for(unsigned int n=0; n < inNumSamples; n++) {
    // This kind of sample-precision is not possible using aux tasks.
    //   But at least the samples are being counted reliably, so this way
    //   the AUX task is "requested" to run at a regular rate.
    unit->readCount += 1;
    if(unit->readCount >= unit->readIntervalSamples) {
      unit->readCount = 0;
      Bela_scheduleAuxiliaryTask(unit->centroidReadTask); // run the i2c read every so many samples
    }
  }
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
