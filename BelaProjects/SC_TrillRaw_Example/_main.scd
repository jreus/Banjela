/**
Functional example of using TrillRaw UGen

(C) 2019 Jonathan Reus

**/
s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.numDigitalChannels = 16;
s.options.maxLogins = 8;

s.options.pgaGainLeft = 5;     // sets the pregain for the left audio input (dB)
s.options.pgaGainRight = 5;    // sets the pregain for the right audio input (dB)
s.options.headphoneLevel = -1; // sets the headphone level (-dB)
s.options.speakerMuted = 1;    // set true to mute the speaker amp and draw a little less power
s.options.dacLevel = 0;       // sets the gain of the analog dac to (dB)
s.options.adcLevel = 0;       // sets the gain of the analog adc to (dB)

s.options.blockSize = 16;
s.options.numInputBusChannels = 10;
s.options.numOutputBusChannels = 2;


s.waitForBoot {
	~tr = {|t_updateTrill = 0.0|
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x18; // I2C address of Trill sensor
	var thresh = 6; // noise threshold, int: 0-6 (6=highest threshold)
	var prescaler = 1; // sensitvity, int: 0-5 (0=highest sensitivity, play with this for complex Trill Craft setups)
	var rawvals;
	var sig, ping;

	rawvals = TrillRaw.kr(i2c_bus, i2c_address, thresh, prescaler, t_updateTrill);
	SendReply.kr(Impulse.kr(1.0), "/trill", rawvals);
	sig = Saw.ar(rawvals.linlin(0.0, 1300, 30, 2000), mul: rawvals.linlin(0.0, 1300, 0.0, 1.0)) * 0.5;
	sig = Splay.ar(sig);
	ping = EnvGen.ar(Env.perc, t_updateTrill) * SinOsc.ar(440);
	sig + ping;
	}.play;

	OSCdef(\trill, {|msg| msg[3..].postln }, "/trill");
	
	{
		loop {
			20.wait;
			"Reset Trill baseline".postln;
			~tr.set(\t_updateTrill, 1);
		};
	}.fork;
};
