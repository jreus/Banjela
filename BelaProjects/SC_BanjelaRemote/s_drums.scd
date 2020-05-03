/*
.----------------------------.
|\  /\  /\  /\  /\  /\  /\  /|
| )(  )(  )(  )(  )(  )(  )( |
|(  )(  )(  )(  )(  )(  )(  )|
███╗   ███╗ █████╗  ██████╗  ██████╗ ██╗███████╗     ██████╗ ███╗   ██╗    ████████╗██╗  ██╗███████╗
████╗ ████║██╔══██╗██╔════╝ ██╔════╝ ██║██╔════╝    ██╔═══██╗████╗  ██║    ╚══██╔══╝██║  ██║██╔════╝
██╔████╔██║███████║██║  ███╗██║  ███╗██║█████╗      ██║   ██║██╔██╗ ██║       ██║   ███████║█████╗
██║╚██╔╝██║██╔══██║██║   ██║██║   ██║██║██╔══╝      ██║   ██║██║╚██╗██║       ██║   ██╔══██║██╔══╝
██║ ╚═╝ ██║██║  ██║╚██████╔╝╚██████╔╝██║███████╗    ╚██████╔╝██║ ╚████║       ██║   ██║  ██║███████╗
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝╚══════╝     ╚═════╝ ╚═╝  ╚═══╝       ╚═╝   ╚═╝  ╚═╝╚══════╝
██████╗ ██╗   ██╗███████╗
██╔══██╗██║   ██║██╔════╝
██████╔╝██║   ██║███████╗
██╔══██╗██║   ██║╚════██║
██████╔╝╚██████╔╝███████║
╚═════╝  ╚═════╝ ╚══════╝
╚═════╝  ╚═════╝ ╚══════╝
    ___    ___     ___     ___     _       ___   __  __    ___
   | _ \  | _ \   / _ \   | _ )   | |     | __| |  \/  |  / __|
   |  _/  |   /  | (_) |  | _ \   | |__   | _|  | |\/| |  \__ \
  _|_|_   |_|_\   \___/   |___/   |____|  |___| |_|__|_|  |___/
_| """ |_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'
---------------------------------------------------------------------------

F modal >> g C Bb C Eb

------------------------------*/

// This song needs these four samples and a livesampling buf.
(
[~bufs["Chinga_002"], ~bufs["JapaDrum1_13"], ~bufs["Chinga_0122"]].postln;
if(~bufs["livesampler"].notNil) { ~bufs["livesampler"].free; ~bufs["livesampler"]=nil };
~bufs["livesampler"] = Buffer.alloc(s, 5 * s.sampleRate, 1);
);

s.freeAll;
( // ~jo is just a synth
~jo.free;
~jo = {
  var mix, verbmix, insig, s5, strings, stringsmix, thumbsig, slidesig, m1, m2, m3, mic;
  var b1, b2, b3, b4, b1frames, b2frames, b3frames, b4frames;
  var smpl1, smpl2, smpl3, spos1, spos2, spos3, b3dur, pos3var, graintrig;
  var t_mag1, t_mag2, t_mag3, magmap1, magmap2, magmap3, mt1, mt2, mt3, seq1, seq2;
  var centroids, t_bottom, t_top, t_necktop, t_slide, mode = 0, t1, t2, t3;

  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers

	mic = In.ar(~in.mic, 1);
	strings = In.ar(~in.pickup, 1);
  m1 = In.ar(~in.m1,1);
  m2 = In.ar(~in.m2,1);
  m3 = In.ar(~in.m3,1);
  centroids = TrillCentroids.kr(~tr.i2c_bus, ~tr.i2c_addr, ~tr.noiseThresh, ~tr.prescalerOpt);

  // BOTTOM SEGMENT MODE TOGGLE
  t_bottom = (centroids[1] >= ~tr.rimbottom[0]) * (centroids[1] <= ~tr.rimbottom[1]);
  mode = Stepper.kr(t_bottom,0,0,1);

  // VIRTUAL STRING ON NECK TOPSIDE
  t_necktop = (centroids[2] > 10) * (centroids[1] >= ~tr.ntop[0]) * (centroids[1] <= ~tr.ntop[1]);
  t2 = [Gate.kr(centroids[1], t_necktop), centroids[2]]; // pos, size
  thumbsig = Resonz.ar(Pluck.ar(PinkNoise.ar, Changed.kr(t_necktop), 0.2, t2[0].linexp(0.0, 0.36, 50, 1000).reciprocal, 15.8, 0.8, mul: 6.0), [60, 300,2200], 0.1, 10.0).sum.clip; // mode0

  // SLIDE SENSOR (bottom neck)
	/*
  b4 = ~bufs["livesampler"];
  RecordBuf.ar(mic, b4, loop: 1.0); // record string audio
  b4frames = BufFrames.kr(b4);
	t_slide = (centroids[2] > 10) * (((centroids[1] >= ~tr.nbottom1[0]) * (centroids[1] <= ~tr.nbottom1[1])) + ((centroids[1] >= ~tr.nbottom2[0]) * (centroids[1] <= ~tr.nbottom2[1])));
  t3 = Gate.kr([centroids[1], centroids[2]], t_slide); // pos, size
  // calculate sample pos from touch 0 location
  //spos3 = t3[0].linlin(~tr.nbottom1[0], ~tr.nbottom1[1], 0, BufFrames.kr(b4));
  // todo: need to make a fragmented mapping that can map multiple segments to a range...
  spos3 = t3[0].linlin(~tr.nbottom1[0], ~tr.nbottom2[1], 0, 1.0);
  spos3 = Lag.ar(K2A.ar(spos3), 1.0);
  //slidesig = BufRd.ar(1, b4, spos3, 0.0);
  slidesig = GrainBuf.ar(1, Impulse.ar(10), 0.5, b4, 1.0, spos3, 2, 0.0);
	*/
  slidesig = 0.0;

  // mag signals control percussion
  m1 = Lag2.ar(m1, 0.1);
  m1 = m1.linlin(-0.02, 0.02, -1.0, 1.0);
  m2 = Lag2.ar(m2, 0.1);
  m2 = m2.linlin(-0.02, 0.02, -1.0, 1.0);
  m3 = Lag2.ar(m3, 0.1);
  m3 = m3.linlin(-0.02, 0.02, -1.0, 1.0);

  b1 = ~bufs["Chinga_002"];
  b2 = ~bufs["JapaDrum1_13"];
  b3 = ~bufs["Chinga_0122"];
  b1frames = BufFrames.kr(b1);
  b2frames = BufFrames.kr(b2);
  b3frames = BufFrames.kr(b3);

  // magsense trigger thresholds
  mt1 = 0.4;
  mt2 = 0.4;
  mt3 = 0.4;
  t_mag1 = Trig1.kr(m1.abs > mt1, 0.1);
  t_mag2 = Trig1.kr(m2.abs > mt2, 0.1);
  t_mag3 = Trig1.kr(m3.abs > mt3, 0.1);
  magmap1 = m1.abs.explin(mt1, 1, 0.2, 0.05); // map to sample playback speed on approach
  magmap2 = m2.abs.explin(mt2, 1, 0.2, 0.05);
  magmap3 = m3.abs.explin(mt3, 1, 0.2, 0.05);

  seq1 = (1..10) / 10.0; // drum pitches
  seq1 = Select.kr(Stepper.kr(t_mag1, 0, 0, 10), seq1);
  // chinga
  spos1 = EnvGen.ar(Env.new([0, 0, 1], [magmap1, seq1], \lin), t_mag1, b1frames, 0, BufDur.kr(b1));

  // japanese drum
  spos2 = EnvGen.ar(Env.new([0, 0, 1], [magmap2, 1.0], \lin), t_mag2, b2frames, 0, BufDur.kr(b2));

  // chinga rattle
  spos3 = EnvGen.ar(Env.new([0, 0, 1], [magmap3, 1.0], \lin), t_mag3, b3frames, 0, BufDur.kr(b3));


  smpl1 = BufRd.ar(1, b1, spos1, 0.0, 2);
  smpl2 = BufRd.ar(1, b2, spos2, 0.0, 2);
  smpl3 = BufRd.ar(1, b3, spos3, 0.0, 2);

  // Signal Chain
  strings = (strings * 20).tanh;
  stringsmix = FreeVerb.ar(strings, 0.2, 0.5, 0.5);
  verbmix = Mix([thumbsig, smpl3]);
  verbmix = GVerb.ar(verbmix + stringsmix, 15, 1, 0.2, 0.2, 5, 1.0, 1.0, 0.4);
	mix = (stringsmix * 0.1) + (verbmix * 0.8) + Pan2.ar(smpl2, 0.0, 1.0) + Pan2.ar(smpl1, 1.0, LFNoise1.ar(2));
  mix = Limiter.ar(LeakDC.ar(mix), 1.0, 0.001);
  mix * 2.0;
}.play(s, outbus: 0, fadeTime: 0.01, addAction: \addToTail);
);

s.freeAll;
~jo.free;