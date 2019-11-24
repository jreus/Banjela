/*****
Live coding the banjo

*****/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 8; // should match the settings on the Bela
s.initTree;
s.startAliveThread;
);

s.plotTree;
s.freeAll;

// Simple passthrough with "magpick" tremolo effect on mic and Bela noise removal
(
Ndef(\jo, {
  var mixL, mixR;
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
  insig = [In.ar(4,1), In.ar(5,1)] * 1.0;
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*12, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*24, 0.01 ,0,0,0,1,0);
  insig = SVF.ar(insig, nastynoise_hz*28, 0.01 ,0,0,0,1,0);
  insig = LPF.ar(insig, noise_co_hz);

  s5 = insig[0]; // drone
  s1 = s2 = s3 = s4 = insig[1] * 2.0;

  mic = FreeVerb.ar(mic, 0.7, 0.95, 0.1) * (mag1 * 20.0).abs;
  mixL = Mix([s5,mic]);
  mixR = Mix([s1,mic]);
  //mixL = Mix([s1,s2,s3,s4,s5]);
  //mixR = s5;
  Limiter.ar(LeakDC.ar([mixL, mixR] * amp), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

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

  s_pitch1 = mag1.linlin(0.00, 1.0, 0.0007, 0.003);
  s_pitch2 = mag2.linlin(0.00, 1.0, 391.95.reciprocal, 0.005);
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




