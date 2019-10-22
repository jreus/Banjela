/**
Functional example of using TrillRaw UGen
**/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 4; // should match the settings on the Bela
s.initTree;
s.startAliveThread;
);

s.plotTree;
s.freeAll;


(
{
		var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
		var i2c_address = 0x18; // I2C address of Trill sensor
		var thresh = 30; // noise threshold, must be one of: {0, 10, 20, 30, 40, 50, 60}
		var prescaler = 8; // lower values = higher sensitivity, must be one of: {1, 2, 4, 8, 16, 32}
		var vals, valsMF, fft;

    	fft = FFT(LocalBuf(1024), WhiteNoise.ar);
    	valsMF = MFCC.kr(fft);
		vals = TrillRaw.kr(i2c_bus, i2c_address, thresh, prescaler);

		//vals.poll(1);
		vals.poll(0.5);
		//SendReply.kr(Impulse.kr(0.5), "/trill", vals);
		WhiteNoise.ar(SinOsc.ar(1.0).unipolar) * 0.1;
}.play(s);
);

OSCdef(\trill, {|msg| msg.postln }, "/trill");

);
