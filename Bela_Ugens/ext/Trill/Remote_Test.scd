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

Ndef(\centroid, {
  var i2c_bus = 1;
  var i2c_address = 0x18;
  var thresh = 6;
  var prescaler = 0;
  var limitTouches = 3;
  var touchsigs = DC.ar(0).dup(5);
  var centroids;

  centroids = TrillCentroids.kr(i2c_bus, i2c_address, thresh, prescaler, limitTouches);


  touchsigs[0] = Resonz.ar(Impulse.ar(centroids[2].linexp(300,3000,0.2,20)), centroids[1].linexp(0.0, 1.0, 400, 10000), 0.01, mul: 1000.0).tanh * (centroids[2] > 0.0);

  touchsigs[1] = PMOsc.ar((centroids[3]+0.001) * 2500, 500, centroids[4].linexp(0.0, 3000, 0.1, 12.0), 0.1) * 0.2 * (centroids[4] > 0.0);


  //centroids.poll(0.5);
  SendReply.kr(Impulse.kr(0.5), "/trill", centroids);
  //WhiteNoise.ar() * 0.1 * SinOsc.ar(centroids[0] + 1);
  Splay.ar(touchsigs);
}).play(0, numChannels: 2, group: s);

OSCdef(\trillcentroids, {|msg| msg[3..].postln}, "/trill");

);


