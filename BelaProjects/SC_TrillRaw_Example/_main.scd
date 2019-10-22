/**
Functional example of using TrillRaw UGen
**/

s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.postln;

s.waitForBoot({
	{
		var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
		var i2c_address = 0x18; // I2C address of Trill sensor
		var thresh = 30; // noise threshold, must be one of: {0, 10, 20, 30, 40, 50, 60}
		var prescaler = 8; // lower values = higher sensitivity, must be one of: {1, 2, 4, 8, 16, 32}
		var vals;

		vals = TrillRaw.kr(i2c_bus, i2c_address, thresh, prescaler);
		SendReply.kr(Impulse.kr(0.4), "/trill", vals);
		WhiteNoise.ar(SinOsc.ar(1.0).unipolar) * 0.1;
	}.play;

	OSCdef(\trill, {|msg| msg.postln }, "/trill")
});
