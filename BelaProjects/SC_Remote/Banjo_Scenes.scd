/*****
Live coding the banjo

*****/

( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 8; // should match the settings on the Bela
s.initTree;
s.startAliveThread;

// fill ~sf with a graph of available sample files
~readSounds = {
  ~spath = "/root/banjer/samples/";
  ~sf = Dictionary.new;
  PathName("../../samples".resolveRelative).filesDo {|path|
    var category, label = path.folderName;
    category = ~sf[label];
    if(category.isNil) {
      category = Dictionary.new;
      ~sf.put(label, category);
    };
    category.put(path.fileNameWithoutExtension, path);
  };
};
);

s.plotTree;
s.freeAll;

// SNIPPET RECORDER>>
b = Buffer.alloc(s, s.sampleRate * 30.0, 2); // 30 seconds of audio, 2 channels
// write to file (warning, may disconnect from the Bela due to the file write taking up all the system resources!)
b.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_snip.wav", "WAV", "float");

Ndef.clear;

// ONSET DRIVEN PITCH SEQUENCER - Amaj open tuning
( // c+pplc+

Ndef(\jo, {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var mix, insig, s1, s2, s3, s4, s5, mag1, mag2, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers

  var mode = 0, sequence = 0;
  var centroids, range_bottom=[0.4, 0.44], range_top=[0.48, 0.56], range_necktop=[0.0, 0.36], range_neckbottom=[0.88, 1.0];
  var t_bottom, t_top;

  var chain1, chain2, onsets1, onsets2, pitches1, pitches2, seq1, seq2, dur1, dur2;

  mic = In.ar(2, 1);
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);

  insig = [In.ar(4,1), In.ar(5,1)];
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = Compander.ar(insig, insig, 0.05, 2.5, 1.0, 0.005, 0.01); // get rid of low noise
  s5 = insig[0] * 1; // drone
  s1 = s2 = s3 = s4 = insig[1] * 3.0; // other four strings

  // trill sensor
  centroids = TrillCentroids.kr(1, 0x18, 60, 1);

  // MODE TOGGLE: 0.4-0.44 bottom segment bounds
  t_bottom = (centroids[1] >= range_bottom[0]) * (centroids[1] <= range_bottom[1]);
  mode = Stepper.kr(t_bottom,0,0,1);
  //t_bottom.poll(1);

  // SEQUENCE TOGGLE: 0.48-0.56
  t_top = (centroids[1] >= range_top[0]) * (centroids[1] <= range_top[1]);
  sequence = Stepper.kr(t_top,0,0,2);

  // string onset detection
  chain1 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  chain2 = FFT(LocalBuf(512), s1, 0.5, 1); // other strings
  onsets1 = Onsets.kr(chain1, 0.5, \power); // try different algorithms for CPU
  onsets2 = Onsets.kr(chain2, 0.5, \power); // try different algorithms for CPU

  // amp for output
  s5=s5*4.0;
  s1=s1*1.0;
  s1 = Compander.ar(s1, s1, 0.5, 1.0, 0.2, 0.01, 0.1, mul: 5.0);

  // Drone string
  pitches1 = [[\a4.f, \e5.f], [\gs4.f, \d4.f], [\fs3.f, \a4.f]];
  seq1 = Select.kr(Stepper.kr(onsets1, 0, 0, 2), pitches1);
  dur1 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq1 = Pulse.ar(seq1, mul: 1.0).sum * 0.6 * EnvGen.ar(Env.perc(0.01, dur1), onsets1);
  seq1 = Select.ar(mode, [
    AllpassC.ar(seq1, 0.2, 0.2, 2.0),  // 0
    seq1,                               // 1
  ]);

  // 4-strings
  pitches2 = Select.kr(sequence, [
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]],       //0
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 2,   //1
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 3,   //2
  ]);
  seq2 = Select.kr(Stepper.kr(onsets2, 0, 0, 3), pitches2);
  seq2 = Pulse.ar(seq2, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, dur1), onsets2);
  seq2 = Select.ar(mode, [
    AllpassC.ar(seq2, 1.0, 0.1, 1.0) + seq2,
    seq2,
  ]);

  mix = seq1 + seq2 + GVerb.ar(s5+(s1*2.0), 5, 3, 0.2, 0.2, 5, 1.0, 1.0, 0.1);
  mic = Compander.ar(mic, mic, 0.6, 1.5, 0.1, 0.01, 0.1, mul: 20.0);
  mix = mix + FreeVerb.ar(mic, 1.0, 0.8, 0.4);
  mix = Limiter.ar(LeakDC.ar(mix * 0.8), 1.0, 0.001);
  //RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix;
}).play(0, numChannels: 2, group: s);


);





(
Ndef.clear;
~readSounds.();
if(~bufs.notNil) { ~bufs.keysValuesDo {|key,val| val.free } }; // free up any existing buffers
~bufs = Dictionary.new;
// Let's load a couple samples in buffers
[~sf["voice"]["Ahhhs"], ~sf["voice"]["Moonshiner"]].do {|it,idx|
  ~bufs[it.fileNameWithoutExtension] = ~spath +/+ it.folderName +/+ it.fileName;
};
~offsets = Dictionary.with(*[
  "Moonshiner" -> [1.503, 4.043, 6.738, 10.1, 19.0, 31.007, 28.6, 37.44],
  "Moonshiner_verses" -> [1.503, 13.726, 25.414, 37.428, 48.943, 60.96, 71.9, 83.89, 96.23, 108.4],
]);

// one at a time... slowly...
{
  ~bufs.keysValuesDo {|key, val, idx|
    var buf = Buffer.read(s, val);
    "Loading %".format(val).postln;
    ~bufs.put(key, buf);
  };
  "Done...".postln;
}.fork;

);
~bufs; // check if this looks ok! If all data has been updated...

//********** M00ncyn ***************//
// ONSET DRIVEN SAMPLE PATTERN PLAYER
( // MOONSHINER
Ndef(\jo, {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var mix, insig, strings, s5, stringsmix, mag1, mag2, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers

  var chain1, chain2, onsets1, onsets2;
  var b1offsets, b2offsets, noffsets1, noffsets2;
  var seq1, seq2;
  var buf1, buf2, bpos1, bpos2, boffset1, boffset2, b1frames, b2frames;

  buf1 = ~bufs["Ahhhs"];
  buf2 = ~bufs["Moonshiner"];

  mic = In.ar(2, 1);
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);

  insig = [In.ar(4,1), In.ar(5,1)];
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = Compander.ar(insig, insig, 0.1, 3.0, 1.0, 0.005, 0.01); // get rid of low noise
  s5 = insig[0] * 1; // drone
  strings = insig[1] * 7.0; // other four strings

  // *ANALYSIS*
  // strings: onset detection before processing string signal further
  chain1 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  chain2 = FFT(LocalBuf(512), strings, 0.5, 1); // other strings
  onsets1 = Onsets.kr(chain1, 0.5, \power); // try different algorithms for CPU
  onsets2 = Onsets.kr(chain2, 0.5, \power); // try different algorithms for CPU

  // SEQUENCER 1 > Ahhhs, drone string (evenly spaced sample offsets - could also be algorithmic)
  b1frames = BufFrames.kr(buf1);
  noffsets1 = 10;
  b1offsets = Array.series(noffsets1, 0.0, 1.0 / (noffsets1-1)) * b1frames;
  boffset1 = Stepper.kr(onsets1, 0, 0, noffsets1-1);
  boffset1 = Select.kr(boffset1, b1offsets);
  bpos1 = Phasor.ar(onsets1, BufRateScale.kr(buf1), 0, b1frames, boffset1);
  seq1 = BufRd.ar(2, buf1, bpos1, 0.0, 2) * EnvGen.ar(Env.perc, onsets1, timeScale: 2.0);

  // SEQUENCER 2 > Moonshiner, other strings (use pre-calculated offsets)
  b2frames = BufFrames.kr(buf2);
  b2offsets = ~offsets["Moonshiner_verses"]; // OFFSETS IN SECONDS!
  noffsets2 = b2offsets.size;
  //b2offsets = ~offsets["Moonshiner_verses"];
  boffset2 = Stepper.kr(onsets2, 0, 0, noffsets2-1);
  boffset2 = Select.kr(boffset2, b2offsets);
  boffset2.poll(1);
  boffset2 = boffset2 * BufSampleRate.kr(buf2); // CONVERT OFFSET IN SECONDS TO OFFSET IN FRAMES!

  bpos2 = Phasor.ar(onsets2, BufRateScale.kr(buf2), 0, b2frames, boffset2);
  seq2 = BufRd.ar(2, buf2, bpos2, 0.0, 2) * EnvGen.ar(Env.perc, onsets2, timeScale: 10.0);


  // *STRING SIGNAL POST PRODUCTION* output processing
  s5=s5*2.0; strings=strings*1.0; // boost
  strings = Compander.ar(strings, strings, 0.8, 1.0, 0.6, 0.01, 0.1, mul: 4.0);
  stringsmix = GVerb.ar(s5+strings, 15, 3, 0.2, 0.2, 5, 1.0, 1.0, 0.4);


  //mix = seq1 + seq2 + stringsmix;

  mix = FreeVerb.ar(seq1+seq2, 0.3, 0.8, 0.3, mul: 2.0) + stringsmix;
  //mic = Compander.ar(mic, mic, 0.6, 1.5, 0.1, 0.01, 0.1, mul: 20.0);
  //mix = mix + FreeVerb.ar(mic, 1.0, 0.8, 0.4);

  mix = Limiter.ar(LeakDC.ar(mix * 0.8), 1.0, 0.001);
  RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix;
}).play(0, numChannels: 2, group: s);

);



~sf["banjo"].keys

(
Ndef.clear;
~readSounds.();
~bufpaths = [~sf["percussive"]["Chinga_002"], ~sf["percussive"]["JapaDrum1_13"]];
~bufpaths = ~bufpaths.collect {|it,idx|
  ~spath +/+ it.folderName +/+ it.fileName;
};
c.free; d.free;
c = Buffer.read(s, ~bufpaths[0]);
d = Buffer.read(s, ~bufpaths[1]);
);

// Check that these look good
[c,d];


//***** MAGSENSOR SAMPLE TRIGGERING / SCRUBBING *****//
(
Ndef(\jo, {
  var mix, insig, s1, s2, s3, s4, s5, mag1, mag2, mic;
  var buf1, buf2, b1frames, b2frames, smpl1, smpl2, spos1, spos2;
  var t_mag1, t_mag2, magmap1, magmap2, mt1, mt2, seq1, seq2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  mic = In.ar(2, 1) * 2.0;
  mag1 = In.ar(6,1);
  mag2 = In.ar(7,1);

  s5 = In.ar(4,1) * 6.0; // drone
  s1 = s2 = s3 = s4 = In.ar(5,1) * 9.0; // other four strings

  // Start your code here
  mag1 = Lag2.ar(mag1, 0.1);
  mag1 = mag1.linlin(-0.002, 0.002, -1.0, 1.0);

  mag2 = Lag2.ar(mag2, 0.1);
  mag2 = mag2.linlin(-0.002, 0.002, -1.0, 1.0);


  buf1 = c;
  buf2 = d;
  b1frames = BufFrames.kr(buf1);
  b2frames = BufFrames.kr(buf2);

  //mapped2 = mag2.linlin(-1,1,50,3000);
  //mix = [Pulse.ar(mapped1), BLowPass4.ar(WhiteNoise.ar, mapped2, 0.1)];

  // magsense trigger thresholds
  mt1 = 0.4;
  mt2 = 0.4;
  t_mag1 = Trig1.kr(mag1.abs > mt1, 0.1);
  t_mag2 = Trig1.kr(mag2.abs > mt2, 0.1);
  magmap1 = mag1.abs.explin(mt1, 1, 0.2, 0.05); // map to sample playback speed on approach
  magmap2 = mag2.abs.explin(mt2, 1, 0.2, 0.05);

  seq1 = (1..10) / 10.0; // drum pitches
  seq1 = Select.kr(Stepper.kr(t_mag1, 0, 0, 10), seq1);
  // drum
  spos1 = EnvGen.ar(Env.new([0, 0, 1], [magmap1, seq1], \lin), t_mag1, b1frames, 0, BufDur.kr(buf1));

  // rattle
  spos2 = EnvGen.ar(Env.new([0, 0, 1], [magmap2, 1.0], \lin), t_mag2, b2frames, 0, BufDur.kr(buf2));
  //mag1.poll(4);

  //spos1 = Phasor.ar(1, BufRateScale.kr(buf1), 0, b1frames);
  //smpl1 = BufRd.ar(1, buf1, spos1, 0.0, 2) + BufRd.ar(1, buf1, b1frames - spos1, 0.0, 2);

  smpl1 = BufRd.ar(1, buf1, spos1, 0.0, 2);
  smpl2 = BufRd.ar(1, buf2, spos2, 0.0, 2);

  mix = (smpl1+smpl2)!2;

  //mix = SinOsc.ar() * 0.3 * EnvGen.ar(Env.perc, t_mag1, timeScale: 0.2);

  Limiter.ar(LeakDC.ar(mix * 0.5), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

);







