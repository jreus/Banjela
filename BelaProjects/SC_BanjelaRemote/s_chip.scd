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

---------------------------------------------------------------------

WEAVE 2 > CRIPPLE CHIP Amaj

--------------------------------------------------------------------- */

(
// Sequences

// base
~sb = [
	"e5/cs4 a3/cs4 e4/gs5 gs3/b4".notes.f,
	"e5/cs4 a3/cs4 e4/gs5 gs3/b4".notes.f,
	"e5/cs4 a3/cs4 e4/gs5 gs3/b4".notes.f,
	"e5/cs4/d3 a3/cs4 a4/cs2 e4/gs5 gs3/b4".notes.f,
];

~s5 = [
    "a4/e5 gs4/d4 fs3/a4".notes.f * 2.0,
	"cs4/fs4 e3/b4 d3/a3".notes.f * 3.0,
	"cs4/fs4 e3/b4 d3/a3".notes.f * 4.0,
];

~s4 = [
	~sb[0] * 2,
	~sb[0] * 2,
	~sb[0] * 2.5,
	~sb[0] * 1.5,
];


~s3 = [
	~sb[0] * 2,
	~sb[0] * 2,
	~sb[0] * 2.5,
	~sb[0] * 1.5,
];

~s2 = [
	~sb[0] * 3,
	~sb[0] * 3.5,
	~sb[0] * 5,
	~sb[0] * 3,
];

~s1 = [
	~sb[0] * 5,
	~sb[0] * 4,
	~sb[0] * 6,
	~sb[0] * 4,
];
);

s.freeAll;
(
~jo.free;
~jo = {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var stringmix, synthmix, mix, insig, verbin, verbmix;
  var s5, s4, s3, s2, s1, strings, m1, m2, m3;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  var mode = 0, sequence = 0;
  var centroids, t_neckbottom, t_top, t_necktop;
  var chain1, chain2, chain3, chain4, chain5;
  var onsets1, onsets2, onsets3, onsets4, onsets5;
  var seq1, seq2, seq3, seq4, seq5, dur1, dur2, dur3, dur4, dur5;

  m1 = In.ar(~in.m1, 1);
  m2 = In.ar(~in.m2, 1);
  m3 = In.ar(~in.m3, 1);

  // Strings
  s5 = In.ar(~in.s5, 1); s4 = In.ar(~in.s4, 1); s3 = In.ar(~in.s3, 1);
  s2 = In.ar(~in.s2, 1); s1 = In.ar(~in.s1, 1);
  strings = In.ar(~in.pickup, 1);

  centroids = TrillCentroids.kr(~tr.i2c_bus, ~tr.i2c_addr, ~tr.noiseThresh, ~tr.prescalerOpt);

  // FX TOGGLE: neckbottom echo/decay
  t_neckbottom = (centroids[1] >= ~tr.nbottom2[0]) * (centroids[1] <= ~tr.nbottom2[1]);
  mode = Stepper.kr(t_neckbottom,0,0,1);

  // NOTE SEQUENCE TOGGLE: necktop toggles pitch range
  t_necktop = (centroids[2] > 10) * (centroids[1] >= ~tr.ntop[0]) * (centroids[1] <= ~tr.ntop[1]);
  sequence = Stepper.kr(t_necktop,0,0,3);

  // onset detection for each string, also trigger thresholds
  chain1 = FFT(LocalBuf(512), s1, 0.5, 1);
  onsets1 = Onsets.kr(chain1, 0.9, \power); // try different algorithms for CPU usage
  chain2 = FFT(LocalBuf(512), s2, 0.5, 1);
  onsets2 = Onsets.kr(chain2, 0.7, \power);
  chain3 = FFT(LocalBuf(512), s3, 0.5, 1);
  onsets3 = Onsets.kr(chain3, 0.7, \power);
  chain4 = FFT(LocalBuf(512), s4, 0.5, 1);
  onsets4 = Onsets.kr(chain4, 0.6, \power);
  chain5 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  onsets5 = Onsets.kr(chain5, 0.9, \power);

  // drone string sequence
  seq5 = Select.kr(Stepper.kr(onsets5, 0, 0, 2), Select.kr(sequence, ~s5));
  dur5 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq5 = Pulse.ar(seq5, mul: 1.0).sum * 0.4 * EnvGen.ar(Env.perc(0.01, dur5), onsets5);
  seq5 = Select.ar(mode, [AllpassC.ar(seq5, 0.5, 0.2, 2.0), seq5,]);

  // other 4 strings
  seq1 = Select.kr(Stepper.kr(onsets1, 0, 0, 3), Select.kr(sequence, ~s1));
  dur1 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq1 = Pulse.ar(seq1, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, dur1), onsets1);
  seq1 = Select.ar(mode, [AllpassC.ar(seq1, 0.5, 0.2, 2.0) + seq1, seq1,]);

  seq2 = Select.kr(Stepper.kr(onsets2, 0, 0, 3), Select.kr(sequence, ~s2));
  dur2 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq2 = Pulse.ar(seq2, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, dur2), onsets2);
  seq2 = Select.ar(mode, [AllpassC.ar(seq2, 0.5, 0.2, 2.0) + seq2, seq2,]);

  seq3 = Select.kr(Stepper.kr(onsets3, 0, 0, 3), Select.kr(sequence, ~s3));
  dur3 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq3 = Pulse.ar(seq3, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, dur3), onsets3);
  seq3 = Select.ar(mode, [AllpassC.ar(seq3, 0.5, 0.2, 2.0) + seq3, seq3,]);

  seq4 = Select.kr(Stepper.kr(onsets4, 0, 0, 2), Select.kr(sequence, ~s4));
  dur4 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq4 = Pulse.ar(seq4, mul: 1.0).sum * 0.6 * EnvGen.ar(Env.perc(0.01, dur4), onsets4);
  seq4 = Select.ar(mode, [AllpassC.ar(seq4, 0.6, 0.2, 2.0), seq4, ]);

  stringmix = strings;
  synthmix = Mix([seq1 * 0.5, seq2 * 0.4, seq3 * 0.3, seq4 * 0.5, seq5 * 0.4]) * 0.8;
  verbin = Select.ar(mode, [(stringmix * 1.3) + (synthmix*0.7), stringmix * 0.01]);
  verbmix = GVerb.ar(verbin, 30, 10, 0.2, 0.2, 25, 0.4, 0.8, 0.8, mul: 0.4);
	mix = synthmix + verbmix;
	mix = Limiter.ar(LeakDC.ar(mix), 1.0, 0.001);
	//RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
	mix * 4.5;
}.play(s, outbus: 0, fadeTime: 0.01, addAction: \addToTail);
);

~jo.free;
s.freeAll;


