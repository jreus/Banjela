/**
Functional example of using TrillCentroids UGen

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
	~tr = {|t_recalibrate=0.0|
		var i2c_bus = 1;
		var i2c_address = 0x18;
		var noiseThreshold = 80; // int: 5-255 with 255 being the highest noise thresh
		var prescalerOpt = 1; // int: 0-4 with 0 being the highest sensitivity
		var touchsigs = DC.ar(0).dup(2);
		var centroids;
		var mix, out, ping;

		centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThreshold, prescalerOpt, t_recalibrate);

/*
		// slap tappy
		touchsigs[0] = Resonz.ar(Pluck.ar(PinkNoise.ar, (centroids[2] > 0), 0.2, centroids[1].linexp(0.0, 1.0, 800, 2400).reciprocal, 20, 0.5, mul: 6.0), centroids[1].linexp(0.0, 1.0, 800, 2400), 0.1, 4.0).tanh;
		touchsigs[1] = Pluck.ar(WhiteNoise.ar, (centroids[4] > 0), 0.2, centroids[3].linexp(0.0, 1.0, 70, 300).reciprocal, 5, 0.9);
		//touchsigs[0] = EnvGen.ar(Env.perc(0.001, 0.2), (centroids[6] > 0.0)) * SinOsc.ar([40, 45, 60, 61, 100], mul: 1.0).sum;
		//touchsigs[1] = Pluck.ar(WhiteNoise.ar, (centroids[8] > 0), 0.2, centroids[7].linexp(0.0, 1.0, 50, 400).reciprocal, 1.0, 0.8);
		//touchsigs[0] = Pluck.ar(WhiteNoise.ar, (centroids[10] > 0), 0.2, centroids[9].linexp(0.0, 1.0, 1000, 2000).reciprocal, 0.5, 0.5);
		
		// synthy
		//touchsigs[0] = Ringz.ar(Trig1.ar(centroids[2] > 0.0, 0.01), centroids[1].linexp(0.0, 1.0, 4000, 1000), 0.1, mul: 1.0).tanh * (centroids[2] > 0.0);
		//touchsigs[1] = PMOsc.ar((centroids[3]+0.001) * 2500, 500, centroids[4].linexp(0.0, 3000, 0.1, 12.0), 0.1) * 0.2 * EnvGen.ar(Env.perc, (centroids[4] > 0.0), timeScale: centroids[4].linexp(500, 3000, 0.3, 5.0));

		//out = Mix([touchsigs[0], touchsigs[1]]);
		//out = GVerb.ar(out, 20, centroids[5].linlin(0.0, 1.0, 2,5),  mul: (centroids[6] > 0) * 0.5) + out;
		*/
		
		out = [touchsigs[0], touchsigs[1]];
		SendReply.kr(Impulse.kr(2.0), "/trill", centroids);
		ping = EnvGen.ar(Env.perc, t_recalibrate) * SinOsc.ar(440);
		out + ping;
	}.play;


	OSCdef(\trill, {|msg| msg.postln }, "/trill");
	
	{
		loop {
			20.wait;
			"Reset Trill baseline".postln;
			~tr.set(\t_recalibrate, 1);
		};
	}.fork;
};
