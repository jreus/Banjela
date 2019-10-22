 /**
 * \example Gui/simple
 *
 * GUI simple
 * =========
 *
 * New GUI fuctionality for Bela!
 *
 * Is this project you can find a sketch.js file which is a p5.js file that is rendered
 * in a browser tab. Click the GUI button (next to the Scope button) in the IDE to see the rendering of this file.
 * 
 * This example sends a buffer of data from the Bela render to the browser via a web socket every few milliseconds 
 * containing the value of a sinewave LFO:
 * 	`gui.sendBuffer(0, sineValue);`
 * 
 * The p5.js file displays the position of the sinewave in two different ways.
 * 
 * If you want to edit sketch.js you can do so in the browser but must write your p5.js code in instance mode.
 * 
 * Useful bits from Trill.h
int rawData[kNumSensors];


enum Modes {
	NORMAL = 0,		// centroid calculation
	RAW = 1,		// raw values
	BASELINE = 2,	
	DIFF = 3		// choses a baseline and gives you raw value differences from that
};

enum Devices {
	NONE = 0,
	ONED = 1,
	TWOD = 2
};

int setup(int i2c_bus = 1, int i2c_address = 0x18, int mode = NORMAL);

// threshhold -> sensitivity percentage: 0-100 in multiples of 10
// prescaler -> sensitivity, a multiple of two > higher it is, the less sensitive
int setup(int i2c_bus, int i2c_address, int mode, int threshold, int prescaler);

 * 
 * 
 **/
#include <Bela.h>
#include <cmath>
#include <libraries/Gui/Gui.h>
#include <libraries/Trill/Trill.h>


/** Analog Input Channel Mappings **/
#define STRING1_INCHAN 0
#define STRING2_INCHAN 0
#define STRING3_INCHAN 0
#define STRING4_INCHAN 1
#define STRING5_INCHAN 1
#define MAG1_INCHAN 2
#define MAG2_INCHAN 3



/** Trill Sensor **/
#define NUM_TOUCH 5 // Number of simultaneous touches detectable on Trill sensor

Trill touchSensor;
int gPrescalerOpts[6] = {1, 2, 4, 8, 16, 32}; // possible prescaler (sensitivity) settings, lower = more sensitvive
int gThresholdOpts[7] = {0, 10, 20, 30, 40, 50, 60}; // noise threshhold settings

// Touch range on which the re-mapping will be done
int gTouchSizeRange[2] = { 100, 6000 };

// Touchpad state variables
float gTouchLocation[NUM_TOUCH] = { 0.0, 0.0, 0.0, 0.0, 0.0 }; // touch positions
float gTouchSize[NUM_TOUCH] = { 0.0, 0.0, 0.0, 0.0, 0.0 }; // touch sizes
int gNumActiveTouches = 0; // Number of active touches

// Sleep time (microseconds) for auxiliary sensor read task
int gTaskSleepTime = 1000;


/** GUI **/
Gui gui;
int gFrameRate = 30; // gui framerate (in Hz) -> should match framerate of P5 sketch
float gTimePeriod; // period (in seconds) between data sends to the GUI

// this number must match the buffer length in sketch.js
#define GUI_BUFFER_LENGTH 512

// arrays for sending data to the gui
float sigString1[GUI_BUFFER_LENGTH];
float sigString2[GUI_BUFFER_LENGTH];
float sigString3[GUI_BUFFER_LENGTH];
float sigString4[GUI_BUFFER_LENGTH];
float sigString5[GUI_BUFFER_LENGTH];
float sigMag1[GUI_BUFFER_LENGTH];
float sigMag2[GUI_BUFFER_LENGTH];



// variable for the Low Frequency Oscillator
float gFrequency = 0.1;
float gPhase;
float gInverseSampleRate;


/*
* Function to be run on an auxiliary task that reads data from the Trill sensor.
* Here, a loop is defined so that the task runs recurrently for as long as the
* audio thread is running.
*/
void auxiliarySensorReadLoop(void*)
{
 // ????? Where is gShouldStop defined?
 while(!gShouldStop)
 {
	 // Read locations from Trill sensor
	 touchSensor.readLocations();
	 
	 // Normalize location and size so that they are expressed in a 0-1 range
	 for(int i = 0; i <  touchSensor.numberOfTouches(); i++) {
		 gTouchLocation[i] = map(touchSensor.touchLocation(i), 0, 3200, 0, 1);
		 gTouchLocation[i] = constrain(gTouchLocation[i], 0, 1);
		 gTouchSize[i] = map(touchSensor.touchSize(i), gTouchSizeRange[0], gTouchSizeRange[1], 0, 1);
		 gTouchSize[i] = constrain(gTouchSize[i], 0, 1);
	 }
	 gNumActiveTouches = touchSensor.numberOfTouches();
	 // For all innactive touches, set location and size to 0
	 for(int i = gNumActiveTouches; i <  NUM_TOUCH; i++) {
		 gTouchLocation[i] = 0.0;
		 gTouchSize[i] = 0.0;
	 }

	 // Sleep for ... micro seconds
	 usleep(gTaskSleepTime);
 }
}

// send data back to the browser gui
void updateGui() {
			// Send touch sensor data
			gui.sendBuffer(0, gNumActiveTouches);
			gui.sendBuffer(1, gTouchLocation);
			gui.sendBuffer(2, gTouchSize);

			// Send audio signals
			gui.sendBuffer(3, sigString1); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(4, sigString2); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(5, sigString3); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(6, sigString4); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(7, sigString5); // Bela.data.buffers[idx], value (scalar, array, vector)
		
			
			// Send mag sensor values
			gui.sendBuffer(8, sigMag1); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(9, sigMag2); // Bela.data.buffers[idx], value (scalar, array, vector)
}



bool setup(BelaContext *context, void *userData)			
{
	// Init signal state vars
	gInverseSampleRate = 1.0 / context->audioSampleRate;
	gPhase = 0.0;
	gTimePeriod = 1.0 / gFrameRate; 
	
	// zero GUI buffers
	for(int i = 0; i < GUI_BUFFER_LENGTH; i++) {
		sigString1[i] = 0.0;
		sigString2[i] = 0.0;
		sigString3[i] = 0.0;
		sigString4[i] = 0.0;
		sigString5[i] = 0.0;
		sigMag1[i] = 0.0;
		sigMag2[i] = 0.0;
	}
	
	// Init trill state, NORMAL==centroid, DIFF==different from baseline
	// baseline can be recomputed using touchSensor.updateBaseline()
	if(touchSensor.setup(1, 0x18, Trill::NORMAL, gThresholdOpts[6], gPrescalerOpts[0]) != 0) {
		fprintf(stderr, "Unable to initialise touch sensor\n");
		return false;
	}

	touchSensor.printDetails();

	 // Exit program if sensor is not a Trill Bar
	if(touchSensor.deviceType() != Trill::ONED) {
		fprintf(stderr, "This example is supposed to work only with a One-Dimensional Trill Sensor. \n You may have to adapt it to make it work with other Trill devices.\n");
		return false;
	}

	// Set and schedule auxiliary task for reading sensor data from the I2C bus
	Bela_scheduleAuxiliaryTask(Bela_createAuxiliaryTask(auxiliarySensorReadLoop, 50, "I2C-read", NULL));

	// Setup the GUI
	gui.setup(context->projectName);
	return true;
}

void render(BelaContext *context, void *userData)
{	
	for(unsigned int n = 0; n < context->audioFrames; n++) {
		/*
		float in_l = 0;
        float in_r = 0;
        float an0, an1, an2;
        
        // Read audio inputs
        in_l = audioRead(context,n,0);
        in_r = audioRead(context,n,1);
        
        an0 = analogRead(context,n,0);
        an1 = analogRead(context,n,1);
        an2 = analogRead(context,n,2);
		*/
		
		// GUI feedback
		static unsigned int count = 0;
		static unsigned int c = 0;
		// update gui buffers with latest samples (TODO: figure out these indexes by looking at the scope!)
		
		/* RANDOM NOISE
		
		if(c > 0) {
			sigString1[c] = sigString1[c-1] + (   (rand() / (float)RAND_MAX) - 0.5  );
			if(fabs(sigString1[c]) > 1.0) {
				sigString1[c] = 0.0;
			}
		}
		*/
		
		// every block add a sample to the gui buffer
		if(n == 0) {
			sigString1[c] = analogRead(context, n, STRING1_INCHAN) - 0.5;
			sigString2[c] = analogRead(context, n, STRING2_INCHAN) - 0.5;
			sigString3[c] = analogRead(context, n, STRING3_INCHAN) - 0.5;
			sigString4[c] = analogRead(context, n, STRING4_INCHAN) - 0.5;
			sigString5[c] = analogRead(context, n, STRING5_INCHAN) - 0.5;


			sigMag1[c] = analogRead(context, n, MAG1_INCHAN) - 0.5;
			sigMag2[c] = analogRead(context, n, MAG2_INCHAN) - 0.5;

			c++;
			if(c >= GUI_BUFFER_LENGTH) {
				c = 0;
			}
		};
		
		
		
		/*
		c++;
		if(c >= GUI_BUFFER_LENGTH) {
			c = 0;
		}
		*/

		if(count >= gTimePeriod*context->audioSampleRate) // send data every gTimePeriod seconds
		{
			count = 0;
			updateGui();
		}
		
		count++;
		
		
	}
}



void cleanup(BelaContext *context, void *userData)
{

}