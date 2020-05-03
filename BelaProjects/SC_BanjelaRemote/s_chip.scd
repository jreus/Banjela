/ /\ \/ // // /\ \/ // /\ \/ /\ \/ /\ \/ // /
 \  /  \  /  /  /  \  /  /  \  /  \  /  \  /  /
 /  \  /  \  /  \  /  \  /  /  \  /  /  \  /  \
/ /\ \/ /\ \/ /\ \/ /\ \/ // /\ \/ // /\ \/ /\ \
 /  \  /  \  /  \  /  \  /  /  \  /  /  \  /  \
 \  /  /  /  /  \  /  /  /  \  /  /  \  /  \  \
\ \/ // // // /\ \/ // // /\ \/ // /\ \/ /\ \\ \
 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌
▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌
▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌
▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░▌          ▐░█▀▀▀▀█░█▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀
▐░▌          ▐░▌     ▐░▌  ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌
▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ▐░▌          ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░▌
▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌          ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌
 ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀            ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀

 \  /  /  /  /  \  /  /  /  \  /  /  \  /  \  \
 /  \  /  \  /  /  \  /  /  \  /  \  \  \  /  \
/ /\ \/ /\ \/ // /\ \/ // /\ \/ /\ \\ \\ \/ /\ \
 /  \  /  \  /  /  \  /  /  \  /  \  \  \  /
---------------------------------------------------------------------/*

Amaj >> G E A Cs E

WEAVE 2 > CRIPPLE CHIP Amaj
*/
s.freeAll;
(
~jo.free;
~jo = {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var stringmix, synthmix, mix, insig;
  var s5, s4, s3, s2, s1, strings, m1, m2, m3;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  var mode = 0, sequence = 0;
  var centroids, t_neckbottom, t_top, t_necktop;
  var chain1, chain2, chain3, chain4, chain5;
  var onsets1, onsets2, onsets3, onsets4, onsets5;
  var p1, p2, p3, p4, p5;
  var seq1, seq2, seq3, seq4, seq5, dur1, dur2, dur3, dur4, dur5;

  m1 = In.ar(~in.m1, 1);
  m2 = In.ar(~in.m2, 1);
  m3 = In.ar(~in.m3, 1);

  // Strings
  s5 = In.ar(~tr.s5, 1); s4 = In.ar(~tr.s4, 1); s3 = In.ar(~tr.s3, 1);
  s2 = In.ar(~tr.s2, 1); s1 = In.ar(~tr.s1, 1);
  strings = In.ar(~tr.pickup, 1);

  centroids = TrillCentroids.kr(~tr.i2c_bus, ~tr.i2c_addr, ~tr.noiseThresh, ~tr.prescalerOpt);

  // FX TOGGLE: neckbottom echo/decay
  t_neckbottom = (centroids[1] >= ~tr.nbottom2[0]) * (centroids[1] <= ~tr.nbottom2[1]);
  mode = Stepper.kr(t_neckbottom,0,0,1);

  // NOTE SEQUENCE TOGGLE: necktop toggles pitch range
  t_necktop = (centroids[2] > 10) * (centroids[1] >= ~tr.ntop[0]) * (centroids[1] <= ~tr.ntop[1]);
  sequence = Stepper.kr(t_necktop,0,0,3);

  // onset detection for each string
  chain1 = FFT(LocalBuf(512), s1, 0.5, 1);
  onsets1 = Onsets.kr(chain1, 0.5, \power); // try different algorithms for CPU usage
  chain2 = FFT(LocalBuf(512), s2, 0.5, 1);
  onsets2 = Onsets.kr(chain2, 0.5, \power);
  chain3 = FFT(LocalBuf(512), s3, 0.5, 1);
  onsets3 = Onsets.kr(chain3, 0.5, \power);
  chain4 = FFT(LocalBuf(512), s4, 0.5, 1);
  onsets4 = Onsets.kr(chain4, 0.5, \power);
  chain5 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  onsets5 = Onsets.kr(chain5, 0.5, \power);

  // drone string sequence
  p5 = Select.kr(sequence, [
    [[\a4.f, \e5.f], [\gs4.f, \d4.f], [\fs3.f, \a4.f]],
    [[\cs4.f, \fs4.f], [\e3.f, \b4.f], [\d3.f, \a3.f]],
    [[\cs4.f, \fs4.f], [\e3.f, \b4.f], [\d3.f, \a3.f]] / 2.0,
  ]);
  seq5 = Select.kr(Stepper.kr(onsets5, 0, 0, 2), p5);
  dur5 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq5 = Pulse.ar(seq5, mul: 1.0).sum * 0.6 * EnvGen.ar(Env.perc(0.01, dur5), onsets5);
  seq5 = Select.ar(mode, [
		AllpassC.ar(seq5, 0.2, 0.2, 2.0),   // 0 - delay
		seq5,                               // 1
  ]);

  // 4-strings sequence
  p1 = Select.kr(sequence, [
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 4,       //0
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 2,   //1
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 5.5,   //2
    [[\e5.f, \cs4.f, \d3.f], [\a3.f, \cs4.f], [\a4.f, \cs2.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]],   //2
  ]);
	seq1 = Select.kr(Stepper.kr(onsets1, 0, 0, 3), pitches1);
  seq1 = Pulse.ar(seq1, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, dur1), onsets1);
  seq1 = Select.ar(mode, [
    AllpassC.ar(seq1, 0.1, 0.1, 1.0) + seq1,
    seq1,
  ]);

	stringmix = Mix([s1,s2,s3,s4,s5]);
	synthmix = Mix([se1, seq5]);
	mix = synthmix + GVerb.ar(stringmix, 15, 1, 0.2, 0.2, 5, 1.0, 0.5, 0.1);
	mix = Limiter.ar(LeakDC.ar(mix), 1.0, 0.001);
	//RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
	mix * 1.0;
}.play(s, outbus: 0, fadeTime: 0.01, addAction: \addToTail);
);

~jo.free;
s.freeAll;


