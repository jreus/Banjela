/***** Banjo_Remote_Test.scd *****/


/**
Remote control of Bela
**/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 6; // should match the settings on the Bela
s.initTree;
s.startAliveThread;
);

s.plotTree;
s.freeAll;

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

  strings = CompanderD.ar(strings, 0.1, 2.0, 1.0, 0.001, 0.01);

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


