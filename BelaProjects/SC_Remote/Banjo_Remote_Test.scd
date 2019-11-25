/*****
Test Basic Banjo Functionality Remotely
*****/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 8; // should match the settings on the Bela
s.initTree;
s.startAliveThread;
);


s.plotTree;
s.freeAll;

// In channel listing
// 0- ??
// 1- ??
// 2- AUDIO IN L
// 3- AUDIO IN R?
// 4- DIFF PICKUP 1 ON PREBOARD 1 (drone string)
// 5- DIFF PICKUP 2 ON PREBOARD 1 (4 strings)
// 6- MAG PICKUP 1 ON PREBOARD 2 (RIGHT INPUT COIL)
// 7- MAG PICKUP 2 ON PREBOARD 2 (LEFT INPUT COIL)
// 8- MAG PICKUP 1 ON PREBOARD 1 (drone string)
// 9- MAG PICKUP 2 ON PREBOARD 1 (4 strings)

// The Mag Sensor is a hard one to grokk..
//   it basically causes perturbations
//   what you can measure is the size and
//   shape of the perturbation

// One option would be to sample it as a
//    control waveform and then
//    stretch that control gesture
//    over the shape of a buffer?
Ndef.clear;
( // Simple mag sensor pitch mapping with optimal range
Ndef(\jo, {
  var mix, insig, s1, s2, s3, s4, s5, mag1, mag2, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  //mic = In.ar(2, 1) * 2.0;
  mag1 = In.ar(6,1);
  mag2 = In.ar(7,1);

  //s5 = In.ar(4,1) * 6.0; // drone
  //s1 = s2 = s3 = s4 = In.ar(5,1) * 9.0; // other four strings


  // Start your code here
  mag1 = Lag2.ar(mag1, 0.1);
  mag1 = mag1.linlin(-0.002, 0.002, -1.0, 1.0);

  mag2 = Lag2.ar(mag2, 0.2);
  mag2 = mag2.linlin(-0.0019, 0.0017, -1.0, 1.0);

  // testing max/min values
  RunningMax.ar(mag1, Impulse.ar(0.5)).poll(1);
  //RunningMin.ar(mag2, Impulse.ar(1)).poll(4);


  mapped1 = mag1.linlin(-1,1,50,3000);
  mapped2 = mag2.linexp(-1,1,50,8000);
  mix = [Pulse.ar(mapped1), BLowPass4.ar(WhiteNoise.ar, mapped2, 0.1)];
  mix = mix * 0.05;
  Limiter.ar(LeakDC.ar(mix * 0.2), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

);

// MAG SENSOR GESTURE RECORDING
//
Ndef(\jo).clear;

b = Buffer.alloc(s, s.sampleRate * 10.0, 2); // 10 seconds of data, 2 channels
c = Buffer.alloc(s, s.sampleRate * 10.0, 1); // 10 seconds of string audio, mono

( // Record 10 seconds of Mag Signals alongside string audio
x = {
  var mix, insig, s5, strings, mag1, mag2, mic, amp=1.0;
  s5 = In.ar(4,1);
  strings = In.ar(5,1);
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);
  RecordBuf.ar([mag1, mag2], b, loop: 0, doneAction: 2); // record mag signals
  RecordBuf.ar(strings+s5, c, loop: 0); // record string audio
  [strings, s5];
}.play(s, outbus: 0);

);

// write buffer to file in project data directory on the bela
b.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_magsense.wav", "WAV", "float");
c.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_audio.wav", "WAV", "float");


Ndef.clear; // clear all








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


