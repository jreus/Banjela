

/* UNFINISHED ...
 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
 ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀
     ▐░▌     ▐░▌       ▐░▌▐░▌
     ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌
     ▐░▌     ▐░░░░░░░░░░▌ ▐░▌
     ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌
     ▐░▌     ▐░▌       ▐░▌▐░▌
     ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄
     ▐░▌     ▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌
      ▀       ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀

******** HALLELUJAH, SACRED HARP */
(
Ndef(\jo, {
  var mix, insig, s5, strings, stringsmix, thumbsig, slidesig, mag1, mag2, mic;
  var buf1, buf2, buf3, b1frames, b2frames, b3frames, smpl1, smpl2, spos1, spos2, spos3, b3dur, pos3var, graintrig;
  var t_mag1, t_mag2, magmap1, magmap2, mt1, mt2, seq1, seq2;
  var centroids, range_bottom=[0.4, 0.44], range_top=[0.48, 0.56], range_necktop=[0.0, 0.36], range_neckbottom=[0.88, 1.0], range_slide = [0.6, 0.84];
  var t_bottom, t_top, t_necktop, t_slide, mode = 0, t1, t2, t3;

  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  mic = In.ar(2, 1) * 2.0;
  mag1 = In.ar(6,1);
  mag2 = In.ar(7,1);

  // STRINGS INPUT
  insig = [In.ar(4,1), In.ar(5,1)];
  insig = SVF.ar(insig, nastynoise_hz*2, 0.01 ,0,0,0,1,0);
  insig = Compander.ar(insig, insig, 0.1, 3.0, 1.0, 0.005, 0.01); // get rid of low noise
  s5 = insig[0] * 1; // drone
  strings = insig[1] * 3.0; // other four strings

  // TRILL INPUT
  centroids = TrillCentroids.kr(1, 0x18, 60, 1);

  // MODE TOGGLE: 0.4-0.44 bottom segment bounds
  t_bottom = (centroids[1] >= range_bottom[0]) * (centroids[1] <= range_bottom[1]);
  mode = Stepper.kr(t_bottom,0,0,1);
  //t_bottom.poll(1);

  // THUMB TAPS ON NECK TOPSIDE
  // for the 0.0 segment you need an extra test that there is indeed a touch recognized, because all touches default to 0!
  t_necktop = (centroids[2] > 10) * (centroids[1] >= range_necktop[0]) * (centroids[1] <= range_necktop[1]);
  t2 = [Gate.kr(centroids[1], t_necktop), centroids[2]];// pos, size
  thumbsig = Pulse.ar(t2[0].linexp(0.0, 0.36, 50, 1000)) * Lag.kr(centroids[2].linlin(10, 2000, 0.0, 0.7), 3.0) * t_necktop; // mode0
  thumbsig = AllpassC.ar(thumbsig, 0.2, 0.1, 3);

  // SAMPLE DRAG ON SLIDER
  buf3 = ~bufs["Hallelujah_Amazing_Grace_001"];
  b3frames = BufFrames.kr(buf3);
  t_slide = (centroids[2] > 10) * (centroids[1] >= range_slide[0]) * (centroids[1] <= range_slide[1]);
  t3 = Gate.kr([centroids[1], centroids[2]], t_slide); // pos, size
  b3dur = BufDur.kr(buf3);
  pos3var = b3dur * t3[1].linlin(10, 1000, 0.05, 0.4);
  b3dur = b3dur - pos3var + LFNoise1.ar(50).range(-1 * pos3var, pos3var);
  spos3 = t3[0].linlin(range_slide[0], range_slide[1], 0, b3dur);
  spos3 = Lag.ar(K2A.ar(spos3), 0.2);
  b3dur = t3[1].linlin(10, 1000, 0.05, 1.0);
  graintrig = Impulse.ar(10);
  slidesig = TGrains.ar(2, graintrig, buf3, 1.0, spos3, b3dur, TRand.ar(-1.0, 1.0, graintrig), 1.0);
  slidesig = FreeVerb.ar(slidesig, 0.3, 0.5, 0.3);


  // *STRING SIGNAL POST PRODUCTION* output processing
  s5=s5*4.0; strings=strings*6.0; // boost
  strings = Compander.ar(strings, strings, 0.7, 1.0, 0.1, 0.001, 0.1, mul: 10.0);
  stringsmix = GVerb.ar(s5+strings, 1, 1, 0.2, 0.2, 5, 1.0, 1.0, 0.4) * 2.0;


  mix = stringsmix+slidesig+thumbsig;

  //mix = SinOsc.ar() * 0.3 * EnvGen.ar(Env.perc, t_mag1, timeScale: 0.2);

  Limiter.ar(LeakDC.ar(mix * 0.5), 1.0, 0.001);
}).play(0, numChannels: 2, group: s);

);


