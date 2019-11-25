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

// SNIPPET RECORDER>>
b = Buffer.alloc(s, s.sampleRate * 10.0, 2); // 10 seconds of audio, 2 channels

// write to file
b.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_snip.wav", "WAV", "float");



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


Ndef.clear;

// ONSET DRIVEN PITCH SEQUENCER - Amaj open tuning
( // CRPL CR33+

Ndef(\jo, {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var mix, insig, s1, s2, s3, s4, s5, mag1, mag2, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers

  var chain1, chain2, onsets1, onsets2;
  var pitches1, pitches2;
  var seq1, seq2;

  mic = In.ar(2, 1);
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);

  insig = [In.ar(4,1), In.ar(5,1)];
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  //insig = SVF.ar(insig, nastynoise_hz*12, 0.01 ,0,0,0,1,0);
  //insig = SVF.ar(insig, nastynoise_hz*24, 0.01 ,0,0,0,1,0);
  //insig = SVF.ar(insig, nastynoise_hz*28, 0.01 ,0,0,0,1,0);
  //insig = LPF.ar(insig, noise_co_hz);
  insig = Compander.ar(insig, insig, 0.05, 2.5, 1.0, 0.005, 0.01); // get rid of low noise
  s5 = insig[0] * 1; // drone
  s1 = s2 = s3 = s4 = insig[1] * 3.0; // other four strings

  chain1 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  chain2 = FFT(LocalBuf(512), s1, 0.5, 1); // other strings
  onsets1 = Onsets.kr(chain1, 0.5, \power); // try different algorithms for CPU
  onsets2 = Onsets.kr(chain2, 0.5, \power); // try different algorithms for CPU

  // amp for output
  s5=s5*4.0;
  s1=s1*1.0;
  s1 = Compander.ar(s1, s1, 0.5, 1.0, 0.2, 0.01, 0.1, mul: 5.0);

  pitches1 = [[\a4.f, \e5.f], [\g4.f, \ds4.f], [\f3.f, \a4.f]];
  pitches2 = [[\e5.f, \c4.f], [\a3.f, \c4.f], [\e4.f, \g5.f], [\g3.f, \b4.f]] * 2;

  seq1 = Select.kr(Stepper.kr(onsets1, 0, 0, 2), pitches1);
  seq2 = Select.kr(Stepper.kr(onsets2, 0, 0, 3), pitches2);
  seq1 = Pulse.ar(seq1, mul: 1.0).sum * 0.6 * EnvGen.ar(Env.perc(0.01, 0.2), onsets1);
  seq2 = Pulse.ar(seq2, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, 0.5), onsets2);
  seq2 = AllpassC.ar(seq2, 1.0, 0.1, 1.0) + seq2;
  mix = seq1 + seq2 + GVerb.ar(s5+(s1*2.0), 5, 3, 0.2, 0.2, 5, 1.0, 1.0, 0.1);
  mic = Compander.ar(mic, mic, 0.6, 1.5, 0.1, 0.01, 0.1, mul: 20.0);
  mix = mix + FreeVerb.ar(mic, 1.0, 0.8, 0.4);
  mix = Limiter.ar(LeakDC.ar(mix * 0.8), 1.0, 0.001);
  //RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix;
}).play(0, numChannels: 2, group: s);


);


( // All SoundFiles...
~spath = "/root/banjer/samples/";
~soundfiles = Dictionary.new;
PathName("../../samples".resolveRelative).filesDo {|path|
  var category, label = path.folderName;
  category = ~soundfiles[label];
  if(category.isNil) {
    category = Dictionary.new;
    ~soundfiles.put(label, category);
  };
  category.put(path.fileNameWithoutExtension, path);
};
);

(
// Let's load a couple samples in buffers
~loadfiles = [~soundfiles["voice"]["Ahhhs"], ~soundfiles["voice"]["Moonshiner"]]; ~samplebufs = ~loadfiles.collect {|it| ~spath +/+ it.folderName +/+ it.fileName };

// one at a time... slowly...
{
  ~samplebufs.do {|it, idx|
    ~samplebufs[idx] = Buffer.read(s, ~samplebufs[idx]);
    "Loading %".format(~samplebufs[idx]).postln;
    5.wait;
  };
  "Done...".postln;
}.fork;

);


// ONSET DRIVEN SAMPLE PATTERN PLAYER
( // MOONSHINER
Ndef(\jo, {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var mix, insig, stringsmix, s1, s2, s3, s4, s5, mag1, mag2, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers

  var chain1, chain2, onsets1, onsets2;
  var b1offsets, b2offsets, noffsets1, noffsets2;
  var seq1, seq2;
  var buf1, buf2, bpos1, bpos2, boffset1, boffset2, b1frames, b2frames;

  mic = In.ar(2, 1);
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);

  insig = [In.ar(4,1), In.ar(5,1)];
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = Compander.ar(insig, insig, 0.1, 3.0, 1.0, 0.005, 0.01); // get rid of low noise
  s5 = insig[0] * 1; // drone
  s1 = s2 = s3 = s4 = insig[1] * 5.0; // other four strings


  // strings: onset detection
  chain1 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  chain2 = FFT(LocalBuf(512), s1, 0.5, 1); // other strings
  onsets1 = Onsets.kr(chain1, 0.5, \power); // try different algorithms for CPU
  onsets2 = Onsets.kr(chain2, 0.5, \power); // try different algorithms for CPU

  // strings: output processing
  s5=s5*2.0;
  s1=s1*1.0;
  s1 = Compander.ar(s1, s1, 0.8, 1.0, 0.6, 0.01, 0.1, mul: 2.0);
  stringsmix = GVerb.ar(s5+(s1*2.0), 15, 3, 0.2, 0.2, 5, 1.0, 1.0, 0.4);


  buf1 = ~samplebufs[0];
  buf2 = ~samplebufs[1];
  b1frames = BufFrames.kr(buf1);
  b2frames = BufFrames.kr(buf2);

  noffsets1 = 10;
  noffsets2 = 20;
  b1offsets = Array.series(noffsets1, 0.0, 1.0 / (noffsets1-1)) * b1frames;
  b2offsets = Array.series(noffsets2, 0.0, 1.0 / (noffsets2-1)) * b2frames;
  boffset1 = Stepper.kr(onsets1, 0, 0, noffsets1-1);
  boffset2 = Stepper.kr(onsets2, 0, 0, noffsets2-1);
  boffset2.poll(1);

  boffset1 = Select.kr(boffset1, b1offsets);
  boffset2 = Select.kr(boffset2, b2offsets);


  bpos1 = Phasor.ar(onsets1, BufRateScale.kr(buf1), 0, b1frames, boffset1);
  seq1 = BufRd.ar(2, buf1, bpos1, 0.0, 2) * EnvGen.ar(Env.perc, onsets1, timeScale: 2.0);

  bpos2 = Phasor.ar(onsets2, BufRateScale.kr(buf2), 0, b2frames, boffset2);
  seq2 = BufRd.ar(2, buf2, bpos2, 0.0, 2) * EnvGen.ar(Env.perc, onsets2, timeScale: 2.0);



  //mix = seq1 + seq2 + stringsmix;

  mix = FreeVerb.ar(seq1+seq2, 0.3, 0.8, 0.3, mul: 2.0) + stringsmix;
  //mic = Compander.ar(mic, mic, 0.6, 1.5, 0.1, 0.01, 0.1, mul: 20.0);
  //mix = mix + FreeVerb.ar(mic, 1.0, 0.8, 0.4);

  mix = Limiter.ar(LeakDC.ar(mix * 0.8), 1.0, 0.001);
  //RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix;
}).play(0, numChannels: 2, group: s);

);


(
~bufpaths = [~soundfiles["voice"]["Ahhhs"], ~soundfiles["voice"]["Moonshiner"]].collect {|it,idx|
  ~spath +/+ it.folderName +/+ it.fileName;
};
);

Ndef.clear;
c.free; c.free;
c = Buffer.read(s, ~bufpaths[0]);
d = Buffer.read(s, ~bufpaths[1]);


( // Magsensor Sample Envelope/Triggering
Ndef(\jo, {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var mix, insig, s1, s2, s3, s4, s5, mag1, mag2, mic;
  var buf1, buf2, b1frames, b2frames, smpl1, smpl2, spos1, spos2;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  mic = In.ar(2, 1) * 2.0;
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);

  s5 = In.ar(4,1) * 6.0; // drone
  s1 = s2 = s3 = s4 = In.ar(5,1) * 9.0; // other four strings

  // Start your code here
  mag1 = Lag2.ar(mag1, magSmooth);
  mag1 = mag1.linlin(magMin, magMax, -1.0, 1.0);

  mag2 = Lag2.ar(mag2, magSmooth);
  mag2 = mag2.linlin(magMin, magMax, -1.0, 1.0);


  buf1 = c;
  buf2 = d;
  b1frames = BufFrames.kr(buf1);
  b2frames = BufFrames.kr(buf2);

  mapped1 = mag1.linlin(-1,1,0,b1frames);
  //mapped2 = mag2.linlin(-1,1,50,3000);
  //mix = [Pulse.ar(mapped1), BLowPass4.ar(WhiteNoise.ar, mapped2, 0.1)];

  spos1 = mapped1;
  smpl1 = BufRd.ar(2, buf1, spos1, 0.0, 2);


  mix = smpl1;
  Limiter.ar(LeakDC.ar(mix * 0.2), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

);







