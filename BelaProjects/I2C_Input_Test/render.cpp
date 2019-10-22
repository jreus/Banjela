#include <Bela.h>
#include <Trill.h>

Trill ts;

AuxiliaryTask i2cReadTask;
int readInterval = 500; // every 500ms
int readIntervalSamples = 0;

void readTouch(void*) 
{
	if(ts.ready()) {
		ts.readI2C();
		for(unsigned int i=0; i < sizeof(ts.rawData)/sizeof(int); i++) {
			printf("%5d ", ts.rawData[i]);			
		}
		printf("\n");
	}
}

bool setup(BelaContext *context, void *userData)
{
	ts.setup();
	i2cReadTask = Bela_createAuxiliaryTask(readTouch, 50, "I2C-read", NULL);
	readIntervalSamples = context->audioSampleRate * (readInterval/1000);
	return true;
}

void render(BelaContext *context, void *userData)
{
	static int readCount = 0;
	for(unsigned int n=0; n < context->audioFrames; n++) {
		if(++readCount >= readIntervalSamples) {
			readCount = 0;
			Bela_scheduleAuxiliaryTask(i2cReadTask); // run the aux task every so many samples
		}
	}
}

void cleanup(BelaContext *context, void *userData)
{
	ts.cleanup();
}