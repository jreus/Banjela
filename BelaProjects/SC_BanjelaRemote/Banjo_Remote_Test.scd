/*****
Test Banjo Functionality Remotely
*****/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 8; // should match the settings on the Bela
s.initTree;
s.startAliveThread;
~in = (mic: 2, pickup: 3, s1: 6, s2: 9, s3: 8, s4: 5, s5: 4, m1: 11, m2: 10, m3: 7);
~tr = (
	ntop: [0.01, 0.3104], nbottom1: [0.5171, 0.7242], nbottom2: [0.7579, 0.8621],
	rimtop: [0.3447, 0.4138], rimbottom: [0.8964, 0.9311],
	i2c_bus: 1,
	i2c_addr: 0x38,
	noiseThresh: 30, // int: 5-255 with 255 being the highest noise thresh
	prescalerOpt: 1, // int: 0-4 with 0 being the highest sensitivity
);
);

s.plotTree;
s.freeAll;

Ndef.fadeTime
// Remember to set the pregain for the PGA in the stereo audio input (mic/pickup)
s.options.pgaGainLeft = 24;
s.options.pgaGainRight = 24;


// In channel listing
// 0- ??
// 1- ??
// 2- MIC
// 3- PICKUP
// 4- 5th string
// 5- 4th string
// 6- 1st string
// 7- 3rd mag pickup
// 8- 3rd string
// 9- 2nd string
// 10- middle mag pickup
// 11- top mag pickup


( // Basic input / output of analog signals
Ndef(\jo).fadeTime = 0;
Ndef(\jo, {
	var mix, mic, pickup;
	var s1, s2, s3, s4, s5;
	var m1, m2, m3;
	mic = In.ar(~in.mic,1);
	pickup = In.ar(~in.pickup,1) * 2.0;

	s1 = In.ar(~in.s1,1);
	s2 = In.ar(~in.s2,1);
	s3 = In.ar(~in.s3,1);
	s4 = In.ar(~in.s4,1) * 2.0;
	s5 = In.ar(~in.s5,1);

	m3 = In.ar(~in.m3,1);
	m2 = In.ar(~in.m2,1);
	m1 = In.ar(~in.m1,1);
	m3 = SinOsc.ar(1000) * m3;
	m2 = SinOsc.ar(200) * m2;
	m1 = SinOsc.ar(540) * m1;

	//mix = Mix([mic, pickup]);
	//mix = Splay.ar([s5,s4,s3,s2,s1]);
	//mix = Mix([m1,m2,m3]);
	//mix = SinOsc.ar * EnvGen.ar(Env.perc, Changed.ar(s1, 0.01)); // test for string signal
	mix = Mix([mic, pickup, m1, m2, m3] ++ Splay.ar([s5, s4, s3, s2, s1]));
	mix = mix * 2.0;
	mix = LeakDC.ar(Limiter.ar(mix, 1.0, 0.001));
	mix * 1.0;
}).play(out: 0, numChannels: 2, group: s, addAction: \addToTail);
);


// The Mag Sensor is a hard one to grokk..
//   it basically causes perturbations
//   what you can measure is the size and
//   shape of the perturbation

// One option would be to sample it as a
//    control waveform and then
//    stretch that control gesture
//    over the shape of a buffer?
// TODO: need a double exponential mapping
Ndef.clear;
( // Simple mag sensor pitch mapping with optimal range
Ndef(\jo).fadeTime = 0;
Ndef(\jo, {
  var mix;
  var m1, m2, m3;
  var mapped1, mapped2, mapped3;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers

  m1 = In.ar(~in.m1,1);
  m2 = In.ar(~in.m2,1);
  m3 = In.ar(~in.m3,1);

  m1 = Lag2.ar(m1, 0.1);
  m1 = m1.linlin(-0.002, 0.002, -1.0, 1.0);

  m2 = Lag2.ar(m2, 0.2);
  m2 = m2.linlin(-0.0019, 0.0017, -1.0, 1.0);

  m3 = Lag2.ar(m3, 0.2);
  m3 = m2.linlin(-0.002, 0.002, -1.0, 1.0);


  // testing max/min values
  RunningMax.ar(m1, Impulse.ar(0.5)).poll(1);
  //RunningMin.ar(m2, Impulse.ar(1)).poll(4);

  mapped1 = m1.linexp(-1,1,50,3000);
  mapped2 = m2.linexp(-1,1,50,8000);
  mapped3 = m3.linexp(-1,1, 1, 1000);
  mix = Splay.ar([Pulse.ar(mapped1), BLowPass4.ar(WhiteNoise.ar, mapped2, 0.8), PMOsc.ar(mapped1, mapped3, 1.0, mul: 1)]);
  mix = mix * 2.0;
  Limiter.ar(LeakDC.ar(mix * 0.2), 1.0, 0.001);
}).play(out: 0, numChannels: 2, group: s, addAction: \addToTail);

);

// MAG SENSOR GESTURE RECORDING
//
Ndef(\jo).clear;

b = Buffer.alloc(s, s.sampleRate * 10.0, 2); // 10 seconds of data, 2 channels
c = Buffer.alloc(s, s.sampleRate * 10.0, 1); // 10 seconds of string audio, mono

( // Record 10 seconds of Mag Signals alongside string audio
x = {
  var mix, pickup, m1, m2, m3, amp=1.0;
  pickup = In.ar(~in.pickup,1);
  m1 = In.ar(~in.m1,1);
  m2 = In.ar(~in.m2,1);
  m3 = In.ar(~in.m3,1);
  RecordBuf.ar([m1, m2, m3], b, loop: 0, doneAction: 2); // record mag signals
  RecordBuf.ar(pickup, c, loop: 0); // record string audio
  pickup!2;
}.play(s, outbus: 0);

);

// write buffer to file in project data directory on the bela
b.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_magsense.wav", "WAV", "float");
c.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_audio.wav", "WAV", "float");


Ndef.clear; // clear all

//******************
// **** DEMONSTRATION OF TRILL CRAFT SEGMENTATION & TOUCH POSITION LATCHING **** //
/****
Trill sensor is segmented into five segments:
 * bottom neck segments control synth parameters
 * top neck is a string plucking synth
 * rim bottom segment toggles between three synth modes
    0- Gransynth
    1- Resonant Noise
2- String Plucking (top segment only)
 * rim top segment toggles reverb
*****/
(
Ndef(\jo).fadeTime=0;
Ndef(\jo, {
	var centroids, t1, t_t1on, t_t1off, t2, t3;
	var insig, mix, out, sig1, sig2, sig3, sig4;
	var mode = 0, verb = 0, seg_necktop, seg_slide, seg_neckbottom, seg_top, seg_bottom;
	var t_necktop, t_slide, t_neckbottom, t_top, t_bottom;
	var pickup, m1, m2, m3, mic;

	pickup = In.ar(~in.pickup,1) * 2.0;
	centroids = TrillCentroids.kr(~tr.i2c_bus, ~tr.i2c_addr, ~tr.noiseThresh, ~tr.prescalerOpt, 0.0);

	// SYNTH MODEL TOGGLE: 0.4-0.44 bottom segment bounds
	t_bottom = (centroids[1] >= ~tr.rimbottom[0]) * (centroids[1] <= ~tr.rimbottom[1]);
	t_top = (centroids[1] >= ~tr.rimtop[0]) * (centroids[1] <= ~tr.rimtop[1]);
	mode = Stepper.kr(t_bottom,0,0,2,1);
	verb = Stepper.kr(t_top,0,0,1,1);
	mode.poll(1);

	// CONTINUOUS SYNTH (latching):
	// Latching touch position on bottom neck segments
	t1 = [centroids[1], centroids[2]]; // touch1 [pos, size]
	t_t1on = (t1[1] > 10) * (((t1[0] >= ~tr.nbottom1[0]) * (t1[0] <= ~tr.nbottom1[1])) + ((t1[0] >= ~tr.nbottom2[0]) * (t1[0] <= ~tr.nbottom2[1])));
	// TODO: write a segmented remapping function, like linlin or linexp...
	t1 = [Gate.kr(t1[0], t_t1on), t1[1]]; // gate and hold control signal if not within segment range

	sig1 = Select.ar(mode, [
	CombL.ar(GrainFM.ar(1, Dust.ar(40), 0.03, t1[0].linexp(0.6, 1.0, 60,4000), t1[1].linlin(0,2000, 30, 2000), 0.1, mul: 0.5), 0.2, 0.2, 3.0), // mode 0
    Resonz.ar(WhiteNoise.ar, t1[0].linexp(0.6, 1.0, 60, 14000), 0.3), // mode 1
    DC.ar(0), // mode 2 (silent)
	]);

	// TRIGGERED SYNTH (non latching): top necktop segment
	// for the 0.0 segment you need an extra test that there is indeed a touch recognized, because all touches default to 0!
	t_necktop = (centroids[2] > 10) * (centroids[1] >= ~tr.ntop[0]) * (centroids[1] <= ~tr.ntop[1]);
	t2 = [Gate.kr(centroids[1], t_necktop), centroids[2]];// pos, size
	sig2 = Select.ar(mode, [
		SinOsc.ar(centroids[1].linlin(0.0, 0.36, 200, 600)) * 0.5 * EnvGen.ar(Env.perc, t_necktop), // mode0
		Pulse.ar(centroids[1].linexp(0.0, 0.36, 80, 1000)) * 0.5 * EnvGen.ar(Env.perc, t_necktop), // mode1
		Resonz.ar(Pluck.ar(PinkNoise.ar, 1 - t_necktop, 0.2, t2[0].linexp(0.0, 0.36, 80, 1000).reciprocal, 3.0, 0.8, mul: 6.0), t2[0].linexp(0.0, 0.36, 800, 2400), 0.1, 4.0).tanh, // mode2
	]);

	//centroids[1].poll(1);
	//t_necktop.poll(1);

	mix = Mix([sig1, sig2, pickup]);
	mix = Select.ar(verb, [mix, FreeVerb.ar(mix, 0.7)]);
	mix = Limiter.ar(LeakDC.ar(mix));
	mix * 2.0;
}).play(0, numChannels: 2, group: s, addAction: \addToTail);

//OSCdef(\trilldata, {|msg| msg[3..].postln}, "/trill");
);

// **** SIMPLE TRILL LIVE SAMPLER **** ///
();

// **** SIMPLE TRILL SCENE CHANGE **** ///
();






// Simple passthrough with "magpick" tremolo effect on mic and Bela noise removal
(
Ndef(\jo, {
  var mix;
  var insig;
  var s1, s2, s3, s4, s5;
  var mag1, mag2;
  var mic;
  var amp = 1.0;

  var mag_lag = 0.1;
  var nastynoise_hz = 230;
  var noise_co_hz = 4000;

  mic = In.ar(2, 1) * 2.0;

  mag1 = Lag.ar(In.ar(7, 1), mag_lag) * 100.0;
  mag2 = Lag.ar(In.ar(8, 1), mag_lag) * 100.0;

  // Bela Noise removal
  insig = [In.ar(4,1), In.ar(5,1)];
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*12, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*24, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*28, 0.01 ,0,0,0,1,0);
  insig = LPF.ar(insig, noise_co_hz);

  s5 = insig[0] * 5.0; // drone
  s1 = s2 = s3 = s4 = insig[1] * 11.0;

  mic = FreeVerb.ar(mic, 0.7, 0.95, 0.1) * (mag1 * 20.0).abs;
  mix = [s5+mic, s1+mic];
  Amplitude.kr(mix.sum).poll(2);
  Limiter.ar(LeakDC.ar(mix * amp), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

);



// Trill raw data test
(
Ndef(\test, {
  var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
  var i2c_address = 0x18; // I2C address of Trill sensor
  var thresh = 6; // noise threshold, int: 0-6 (6=highest threshold)
  var prescaler = 1; // sensitvity, int: 0-5 (0=highest sensitivity, might have issues with complex craft setups)
  var rawvals;
  var sig;

  rawvals = TrillRaw.kr(i2c_bus, i2c_address, thresh, prescaler);
  SendReply.kr(Impulse.kr(1.0), "/trill", rawvals);

  sig = Saw.ar(rawvals.linlin(0.0, 4100, 30, 2000), mul: Lag.kr(rawvals.linlin(0.0, 4100, 0.0, 1.0), 0.1)) * 0.3;
  //sig = CombL.ar(sig, 0.2, 0.2, 1.0) + sig;
  Splay.ar(sig.tanh);
}).play(0, numChannels: 2, group:s);

);

OSCdef(\trill, {|msg| msg.postln }, "/trill");



// Trill Centroid patch
(

Ndef(\banjo, {
  var i2c_bus = 1;
  var i2c_address = 0x18;
  var thresh = 6;
  var prescaler = 0;
  var touchsigs = DC.ar(0).dup(5);
  var centroids;
  var mix, out;
  var s1, s2, s3, s4, s5;
  var strings;
  var mag1, mag2;

  var str_co_hz = 2200;
  var mag_co_hz = 15;
  s1 = s3 = s5 = LeakDC.ar(LPF.ar(LPF.ar(LPF.ar(In.ar(4, 1), str_co_hz), str_co_hz), str_co_hz));
  s2 = s4 = LeakDC.ar(LPF.ar(LPF.ar(LPF.ar(In.ar(5, 1), str_co_hz), str_co_hz), str_co_hz));
  strings = [s1,s2,s3,s4,s5];
  //strings = (strings * 15.0).tanh;

  strings = CompanderD.ar(strings, 0.01, 2.0, 1.0, 0.001, 0.01);

  mag1 = LPF.ar(In.ar(7, 1), mag_co_hz, mul: 10.0);
  mag2 = LPF.ar(In.ar(8, 1), mag_co_hz, mul: 10.0);

  centroids = TrillCentroids.kr(i2c_bus, i2c_address, thresh, prescaler);



  // slap tappy
  touchsigs[0] = Resonz.ar(Pluck.ar(PinkNoise.ar, (centroids[2] > 0), 0.2, centroids[1].linexp(0.0, 1.0, 800, 2400).reciprocal, 20, 0.5, mul: 6.0), centroids[1].linexp(0.0, 1.0, 800, 2400), 0.1, 4.0).tanh;
  touchsigs[1] = Pluck.ar(WhiteNoise.ar, (centroids[4] > 0), 0.2, centroids[3].linexp(0.0, 1.0, 70, 300).reciprocal, 5, 0.9);
  touchsigs[2] = EnvGen.ar(Env.perc(0.001, 0.2), (centroids[6] > 0.0)) * SinOsc.ar([40, 45, 60, 61, 100], mul: 1.0).sum;
  touchsigs[3] = Pluck.ar(WhiteNoise.ar, (centroids[8] > 0), 0.2, centroids[7].linexp(0.0, 1.0, 50, 400).reciprocal, 1.0, 0.8);
  touchsigs[4] = Pluck.ar(WhiteNoise.ar, (centroids[10] > 0), 0.2, centroids[9].linexp(0.0, 1.0, 1000, 2000).reciprocal, 0.5, 0.5);
  mix = Splay.ar(touchsigs);

  //Pulse.ar([mag1,mag2].linlin(-1.0, 1.0, 50, 1000)) * [mag1.abs, mag2.abs];

  Limiter.ar(mix + (Splay.ar(strings)));

}).play(0, numChannels: 2, group: s);

//OSCdef(\trilldata, {|msg| msg[3..].postln}, "/trill");

);


( // Expansion on the drone string
Ndef(\jo, {
  var mix;
  var insig;
  var s1, s2, s3, s4, s5;
  var s_amp, s_pitch1, s_pitch2, s_haspitch;
  var mag1, mag2;
  var mic;
  var beat1 = 8, beat2 = 8;
  var amp = 1.0;
  var mag_lag = 0.1;
  var nastynoise_hz = 230;
  var noise_co_hz = 7000;
  mic = In.ar(2, 1) * 2.0;
  mag1 = Lag.ar(In.ar(7, 1).abs * 100.0, mag_lag) * 10.0;
  mag1 = (mag1 > 0.25) * (mag1 - 0.25);
  mag2 = Lag.ar(In.ar(8, 1).abs * 100.0, mag_lag) * 10.0;
  mag2 = (mag2 > 0.25) * (mag2 - 0.25);
  insig = [In.ar(4,1), In.ar(5,1)] * 1.0;
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*12, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*24, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*28, 0.01 ,0,0,0,1,0);
  insig = LPF.ar(insig, noise_co_hz);
  s5 = insig[0] * 6.0; // drone
  s1 = s2 = s3 = s4 = insig[1] * 9.0; // other four strings

  // Start your code here
  // slopebelow > 1.0 (noise gating), slopeabove > 1.0 (expansion)
  s5 = Compander.ar(s5, s5, 0.05, 2.0, 1.0, 0.005, 0.01, mul: 1.0);
  s1 = Compander.ar(s1, s1, 0.05, 2.0, 1.0, 0.005, 0.01, mul: 3.0);
  //Amplitude.kr(s5).poll(2);
  //Amplitude.kr(s1).poll(2);
  s_amp = Amplitude.kr(s5);
  //# s_pitch, s_haspitch = Pitch.kr(s5, ampThreshold: 0.02, median: 7);
  //s5 = Pluck.ar(PinkNoise.ar(), (s_amp > 0.1), 0.02, 0.2, 1.0) * 0.1;


  beat1 = 12 * s_amp;
  beat2 = 50 * s_amp;
  s_pitch2 = 391.95; // G5

  s_pitch1 = mag1.linlin(0.00, 1.0, 0.0007, 0.005);
  s_pitch2 = mag2.linlin(0.00, 1.0, 391.95.reciprocal, 0.01);
  mag2.poll(2);
  //BeatTrack2
  s5 = s5 +
  [Pluck.ar(WhiteNoise.ar(), Impulse.ar(beat1), 0.2, s_pitch1, 0.2, 0.5, mul: 2.0),
    Pluck.ar(WhiteNoise.ar(), Impulse.ar(beat2), 0.2, s_pitch2, 0.2, 0.5, mul: 2.0)];
  //s1 = CombL.ar(s1, 0.2, 0.001, 0.1);

  mix = FreeVerb.ar(s1+s5);


  Limiter.ar(LeakDC.ar(mix * amp), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

);
