 /**
	Banjo Status Dashboard

 * 
 * 
 **/
#include <Bela.h>
#include <cmath>
#include <libraries/Gui/Gui.h>
#include <libraries/Trill/Trill.h>


/** Audio Input Channel Mappings **/
#define MIC_INCHAN 0

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
#define GUI_FRAME_RATE 30; // gui framerate (in Hz) -> should match framerate of P5 sketch
#define GUI_BUFFER_LENGTH 256 // this number must match the buffer length in sketch.js
float gTimePeriod; // period (in seconds) between data sends to the GUI


// arrays for sending data to the gui
float sigString1[GUI_BUFFER_LENGTH];
float sigString2[GUI_BUFFER_LENGTH];
float sigString3[GUI_BUFFER_LENGTH];
float sigString4[GUI_BUFFER_LENGTH];
float sigString5[GUI_BUFFER_LENGTH];
float sigMag1[GUI_BUFFER_LENGTH];
float sigMag2[GUI_BUFFER_LENGTH];
float sigMic[GUI_BUFFER_LENGTH];



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

			// Send string/audio signals
			gui.sendBuffer(3, sigString1); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(4, sigString2); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(5, sigString3); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(6, sigString4); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(7, sigString5); // Bela.data.buffers[idx], value (scalar, array, vector)
		
			
			// Send mag sensor values
			gui.sendBuffer(8, sigMag1); // Bela.data.buffers[idx], value (scalar, array, vector)
			gui.sendBuffer(9, sigMag2); // Bela.data.buffers[idx], value (scalar, array, vector)

			// Send mic input signal
			gui.sendBuffer(10, sigMic);	
}



bool setup(BelaContext *context, void *userData)			
{
	// Init signal state vars
	gInverseSampleRate = 1.0 / context->audioSampleRate;
	gPhase = 0.0;
	gTimePeriod = 1.0 / GUI_FRAME_RATE; 
	
	// zero GUI buffers
	for(int i = 0; i < GUI_BUFFER_LENGTH; i++) {
		sigString1[i] = 0.0;
		sigString2[i] = 0.0;
		sigString3[i] = 0.0;
		sigString4[i] = 0.0;
		sigString5[i] = 0.0;
		sigMag1[i] = 0.0;
		sigMag2[i] = 0.0;
		sigMic[i] = 0.0;
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

		// GUI feedback
		static unsigned int count = 0;
		static unsigned int c = 0;


		// every block add a sample to the gui buffer
		if(n == 0) {
			sigString1[c] = analogRead(context, n, STRING1_INCHAN) - 0.5;
			sigString2[c] = analogRead(context, n, STRING2_INCHAN) - 0.5;
			sigString3[c] = analogRead(context, n, STRING3_INCHAN) - 0.5;
			sigString4[c] = analogRead(context, n, STRING4_INCHAN) - 0.5;
			sigString5[c] = analogRead(context, n, STRING5_INCHAN) - 0.5;


			sigMag1[c] = analogRead(context, n, MAG1_INCHAN) - 0.5;
			sigMag2[c] = analogRead(context, n, MAG2_INCHAN) - 0.5;

			//sigMic[c] = audioRead(context, n, MIC_INCHAN);


			c++;
			if(c >= GUI_BUFFER_LENGTH) {
				c = 0;
			}
		};
		
		
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