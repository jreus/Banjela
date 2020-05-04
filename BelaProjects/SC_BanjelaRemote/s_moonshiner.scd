
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

( // MOONSHINER
~jo.free;
~jo = {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var mix, stringmix, synthmix, insig, slidesig, strings, s5, stringsmix, m1, m2, m3, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  var centroids, mode=0, buf_select=0, t_bufchange, t_neckbottom, t_top, t_necktop, t_slide, t1, t2, t3;

  var chain1, chain2, chain3, chain4, chain5, onsets1, onsets2, onsets3, onsets4, onsets5;
  var b1offsets, b2offsets, noffsets1, noffsets2;
  var seq1, seq2;
  var b1, b2, b3, bpos1, bpos2, boffset1, boffset2, b1frames, b2frames, b3frames, b1dur, b2dur, b3dur;
  var t_grain, gpos_var, gpos, gdur, gdur_var;

  b1 = ~bufs["Ahhhs"];
  b2 = ~bufs["Moonshiner"];

  // inputs
  m1 = In.ar(~in.m1, 1); m2 = In.ar(~in.m2, 1); m3 = In.ar(~in.m3, 1);
  s5 = In.ar(~in.s5, 1); s1 = In.ar(~in.s1, 1);
  strings = In.ar(~in.pickup,1);
  centroids = TrillCentroids.kr(1, 0x18, 60, 1);

  // onsets
  chain5 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  onsets5 = Onsets.kr(chain5, 2.5, \power);
  chain1 = FFT(LocalBuf(512), s1, 0.5, 1);
  onsets1 = Onsets.kr(chain1, 4.0, \power);

  // NECK BOTTOM TOGGLE SAMPLE PLAYBACK
  t_neckbottom = (centroids[1] >= ~tr.nbottom2[0]) * (centroids[1] <= ~tr.nbottom2[1]);
  mode = Stepper.kr(t_neckbottom,0,0,2-1); // 2 modes

  // NECK TOP TOGGLES BUFFER
  t_necktop = (centroids[2] > 10) * (centroids[1] >= ~tr.ntop[0]) * (centroids[1] <= ~tr.ntop[1]);
  buf_select = Stepper.kr(t_necktop,0,0,3-1,1); // 2 buffers
  t_bufchange = Changed.kr(buf_select);

  // NECK SLIDE DRAG ON SAMPLE GRAIN SLIDER
  b3 = Select.kr(buf_select, [
    ~bufs["Ahhhs_mono"], ~bufs["Moonshiner"], ~bufs["Hallelujah_Amazing_Grace_001"]
  ]);
  b3frames = BufFrames.kr(b3);
  t_slide = (centroids[2] > 10) * (centroids[1] >= ~tr.slide[0]) * (centroids[1] <= ~tr.slide[1]);
  t3 = Gate.kr([centroids[1], centroids[2]], t_slide + t_bufchange); // pos, size
  b3dur = BufDur.kr(b3);
  gpos_var = b3dur * t3[1].linlin(10, 1000, 0.05, 0.4);
  b3dur = b3dur - gpos_var + LFNoise1.ar(50).range(-1 * gpos_var, gpos_var);
  gpos = t3[0].linlin(~tr.slide[0], ~tr.slide[1], 0, b3dur);
  gpos = Lag.ar(K2A.ar(gpos), 0.1);
  gpos_var = LFNoise1.ar(20).range(-0.5, 0.5);
  gdur = t3[1].linlin(10, 1000, 0.1, 1.5);
  t_grain = Impulse.ar(10);
  slidesig =
  slidesig = Select.ar(mode, [
    DC.ar(0), // mode 0, no sampling
    TGrains.ar(2, t_grain, b3, t3[1].linexp(10, 2000, -0.5, -2.0), gpos + gpos_var, gdur, TRand.ar(-1.0, 1.0, t_grain), t3[1].linlin(10, 2000, 0.2, 2.0)).tanh, // mode 1, TGrains party with Ahhhs!
  ]);

  // SEQUENCER 1 > Ahhhs, drone string (evenly spaced sample offsets - could also be algorithmic)
  b1frames = BufFrames.kr(b1);
  noffsets1 = 10;
  b1offsets = Array.series(noffsets1, 0.0, 1.0 / (noffsets1-1)) * b1frames;
  boffset1 = Stepper.kr(onsets1, 0, 0, noffsets1-1);
  boffset1 = Select.kr(boffset1, b1offsets);
  bpos1 = Phasor.ar(onsets1, BufRateScale.kr(b1), 0, b1frames, boffset1);
  seq1 = BufRd.ar(2, b1, bpos1, 0.0, 2) * EnvGen.ar(Env.perc, onsets1, timeScale: 2.0) * 1.0;

  // SEQUENCER 2 > Moonshiner, other strings (use pre-calculated offsets)
  b2frames = BufFrames.kr(b2);
  b2offsets = ~offsets["Moonshiner_verses"]; // OFFSETS IN SECONDS!
  noffsets2 = b2offsets.size;
  boffset2 = Stepper.kr(onsets2, 0, 0, noffsets2-1);
  boffset2 = Select.kr(boffset2, b2offsets);
  //boffset2.poll(1);
  boffset2 = boffset2 * BufSampleRate.kr(b2); // CONVERT OFFSET IN SECONDS TO OFFSET IN FRAMES!
  //boffset2.poll(1);
  bpos2 = Phasor.ar(onsets2, BufRateScale.kr(b2), 0, b2frames, boffset2);
  seq2 = BufRd.ar(1, b2, bpos2, 0.0, 2) * EnvGen.ar(Env.perc, onsets2, timeScale: 10.0) * 1.0;

  // SIGNAL CHAIN
  s5 = s5 + AllpassC.ar(s5, 0.2, 0.05, 5.0);
  stringmix = GVerb.ar(s5+strings, 65, 3, 0.1, 0.2, 5, 1.0, 0.4, 0.6);
  mix = FreeVerb.ar(seq1+seq2+slidesig, 0.5, 0.8, 0.3, mul: 1.0) + stringmix;
  mix = Limiter.ar(LeakDC.ar(mix), 1.0, 0.001);
  //RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix * 1.0;
}.play(s, outbus: 0, addAction: \addToTail, fadeTime: 0.01);

);
