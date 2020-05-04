
/*                                             .__    .__
███╗   ███╗ ██████╗  ██████╗ ███╗   ██╗███████╗██╗  ██╗██╗███╗   ██╗███████╗██████╗
████╗ ████║██╔═████╗██╔═████╗████╗  ██║██╔════╝██║  ██║██║████╗  ██║██╔════╝██╔══██╗
██╔████╔██║██║██╔██║██║██╔██║██╔██╗ ██║███████╗███████║██║██╔██╗ ██║█████╗  ██████╔╝
██║╚██╔╝██║████╔╝██║████╔╝██║██║╚██╗██║╚════██║██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗
██║ ╚═╝ ██║╚██████╔╝╚██████╔╝██║ ╚████║███████║██║  ██║██║██║ ╚████║███████╗██║  ██║
╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
--------------------------------------------------------------------------------------
C modal >> G F Bb C Eb
-------------------------------------------------------------------------------------- */
~bufs["Moonshiner"];
~bufs["Ahhhs"];

// Sample offsets for each song verse
~offsets = Dictionary.with(*[
  "Moonshiner_verses" -> [1.503, 13.726, 25.414, 37.428, 48.943, 60.96, 71.9, 83.89, 96.23, 108.4],
]);
s.freeAll;
( // MOONSHINER
~jo.free;
~jo = {
  var mix, stringmix, synthmix, grainsig, strings, verbmix;
  var s5, s4, s3, s2, s1, stringsmix, m1, m2, m3, mic;
  var trill, mode=0, buf_select=0, t_bufchange, t_bottom, t_rimtop, t_top, t_slide, t1, t2, t3;
  var chain1, chain2, chain3, chain4, chain5, onsets1, onsets2, onsets3, onsets4, onsets5;
  var b1offsets, b2offsets, b1numoffsets, b2numoffsets, b1frames, b2frames, seq1, seq2;
  var buf1, buf2, b1pos, b2pos, b1offset, b2offset, b1dur, b2dur;
  var gbuf, gbufdur, t_grain, gpos_var, gpos, gdur, gdur_var;

  buf1 = ~bufs["Ahhhs"];
  buf2 = ~bufs["Moonshiner"];

  // inputs
  s5 = In.ar(~in.s5, 1); s1 = In.ar(~in.s1, 1);
  strings = In.ar(~in.pickup,1);
  trill = TrillCentroids.kr(~tr.i2c_bus, ~tr.i2c_addr, ~tr.noiseThresh, ~tr.prescalerOpt);

  // NECK BOTTOM TOGGLE SAMPLE PLAYBACK
  t_bottom = (trill[1] >= ~tr.nbottom[0]) * (trill[1] <= ~tr.nbottom[1]);
  mode = Stepper.kr(t_bottom, 0, 0, 2-1); // 2 modes

  // NECK TOP TOGGLES BUFFER
  t_top = (trill[2] > 10) * (trill[1] >= ~tr.ntop[0]) * (trill[1] <= ~tr.ntop[1]);
  buf_select = Stepper.kr(t_top, 0, 0, 3-1, 1); // 2 buffers
  t_bufchange = Changed.kr(buf_select);

  // NECK SLIDE DRAG ON SAMPLE GRAIN SLIDER
  gbuf = Select.kr(buf_select, [
    ~bufs["Ahhhs_mono"], ~bufs["Moonshiner"], ~bufs["Hallelujah_Amazing_Grace_001"]
  ]);
  t_slide = (trill[2] > 10) * (trill[1] >= ~tr.slide[0]) * (trill[1] <= ~tr.slide[1]);
  t3 = Gate.kr([trill[1], trill[2]], t_slide + t_bufchange); // pos, size
  gbufdur = BufDur.kr(gbuf);
  gpos_var = gbufdur * t3[1].linlin(10, 1000, 0.05, 0.4);
  gbufdur = gbufdur - gpos_var + LFNoise1.ar(50).range(-1 * gpos_var, gpos_var);
  gpos = t3[0].linlin(~tr.slide[0], ~tr.slide[1], 0, gbufdur);
  gpos = Lag.ar(K2A.ar(gpos), 0.1);
  gpos_var = LFNoise1.ar(20).range(-0.5, 0.5);
  gdur = t3[1].linlin(10, 1000, 0.1, 1.5);
  t_grain = Impulse.ar(10);
  grainsig = Select.ar(mode, [
    DC.ar(0), // mode 0, no sampling
    TGrains.ar(2, t_grain, gbuf, t3[1].linexp(10, 2000, -0.5, -2.0), gpos + gpos_var, gdur, TRand.ar(-1.0, 1.0, t_grain), t3[1].linlin(10, 2000, 0.2, 2.0)).tanh, // mode 1, TGrains party with Ahhhs!
  ]);


  // onsets
  chain5 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  onsets5 = Onsets.kr(chain5, 0.94, \power);
  chain1 = FFT(LocalBuf(512), s1, 0.5, 1);
  onsets1 = Onsets.kr(chain1, 0.94, \power);

  // SEQUENCER 1 > Ahhhs, drone string (evenly spaced sample offsets - could also be algorithmic)
  b1frames = BufFrames.kr(buf1);
  b1numoffsets = 10;
  b1offsets = Array.series(b1numoffsets, 0.0, 1.0 / (b1numoffsets-1)) * b1frames;
  b1offset = Stepper.kr(onsets5, 0, 0, b1numoffsets-1);
  b1offset = Select.kr(b1offset, b1offsets);
  b1pos = Phasor.ar(onsets5, BufRateScale.kr(buf1), 0, b1frames, b1offset);
  seq1 = BufRd.ar(2, buf1, b1pos, 0.0, 2) * EnvGen.ar(Env.perc, onsets5, timeScale: 2.0);

  // SEQUENCER 2 > Moonshiner verses, string 1 (use pre-calculated offsets)
  b2frames = BufFrames.kr(buf2);
  b2offsets = ~offsets["Moonshiner_verses"]; // OFFSETS IN SECONDS!
  b2numoffsets = b2offsets.size;
  b2offset = Stepper.kr(onsets1, 0, 0, b2numoffsets-1);
  b2offset = Select.kr(b2offset, b2offsets);
  b2offset = b2offset * BufSampleRate.kr(buf2); // CONVERT OFFSET IN SECONDS TO OFFSET IN FRAMES!
  b2pos = Phasor.ar(onsets1, BufRateScale.kr(buf2), 0, b2frames, b2offset);
  seq2 = BufRd.ar(1, buf2, b2pos, 0.0, 2) * EnvGen.ar(Env.perc, onsets1, timeScale: 10.0);

  // SIGNAL CHAIN
  stringmix = strings;
  verbmix = Mix([seq1, seq2 * 0.5, grainsig * 0.8, strings * 0.7]);
  verbmix = GVerb.ar(verbmix * 0.5, 65, 3, 0.1, 0.2, 5, 0.9, 0.5, 0.7);
	mix = (verbmix * 0.5) + (stringmix * 0.01);
	mix = mix.tanh;
  mix = Limiter.ar(LeakDC.ar(mix), 1.0, 0.001);
  //RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix * 2.0;
}.play(s, outbus: 0, addAction: \addToTail, fadeTime: 0.01);

);
s.freeAll;
