/**
Functional example of using TrillCentroids UGen

(C) 2019 Jonathan Reus

**/

s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.numDigitalChannels = 16;
s.options.maxLogins = 6;

s.options.pgaGainLeft = 5;     // sets the pregain for the left audio input (dB)
s.options.pgaGainRight = 5;    // sets the pregain for the right audio input (dB)
s.options.headphoneLevel = -1; // sets the headphone level (-dB)
s.options.speakerMuted = 1;    // set true to mute the speaker amp and draw a little less power
s.options.dacLevel = 0;       // sets the gain of the analog dac to (dB)
s.options.adcLevel = 0;       // sets the gain of the analog adc to (dB)

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;


s.waitForBoot({
	{
		var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
		var i2c_address = 0x18; // I2C address of Trill sensor
		var thresh = 5; // noise threshold option, int: 0-5 (5=highest noise threshold)
		var prescaler = 0; // sensitivity, int: 0-5 (0=highest sensitivity)
		var limitTouches = 2; // limit number of touch centroids returned by UGen
		var vals;
		var sig;
		
		vals = TrillCentroids.kr(i2c_bus, i2c_address, thresh, prescaler, limitTouches);
		SendReply.kr(Impulse.kr(2), "/trill", vals);
		//sig = Saw.ar(max(20, vals), mul: Lag.kr(vals > 30, 0.1)) * 0.4;
		//sig = CombL.ar(sig, 0.2, 0.2, 1.0) + sig;
		//Splay.ar(sig);
		WhiteNoise.ar * 0.1;
	}.play;

	OSCdef(\trill, {|msg| msg[3..].postln }, "/trill")
});
