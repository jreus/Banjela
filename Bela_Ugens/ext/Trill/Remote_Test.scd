/**
Remote control of Bela
**/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 4; // should match the settings on the Bela
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
  var limitTouches = 5;
  var touchsigs = DC.ar(0).dup(5);
  var centroids;

  centroids = TrillCentroids.kr(i2c_bus, i2c_address, thresh, prescaler, limitTouches);

  touchsigs[0] = PMOsc.ar((centroids[1]+0.001) * 1500, 1500, (centroids[2]+1) / 500., 0.1) * 0.2;

  //vals.poll(1);
  //vals.poll(0.5);
  //SendReply.kr(Impulse.kr(0.5), "/trill", vals);
  //WhiteNoise.ar() * 0.1 * SinOsc.ar(centroids[0] + 1);
  Splay.ar(touchsigs);
}).play(0, numChannels: 2, group: s);

);


