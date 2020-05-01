
 \  /  \  /  /  \  /  /  \  \  /  /  \  /  \  /
\ \/ /\ \/ // /\ \/ // /\ \\ \/ // /\ \/ /\ \/ /
 \  /  \  /  /  \  /  /  \  \  /  /  \  /  \  /
 \  /  \  /  /  /  \  /  /  \  /  \  /  \  /  /
\ \/ /\ \/ // // /\ \/ // /\ \/ /\ \/ /\ \/ // /
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
/* Amaj >> G E A Cs E */

( //******* WEAVE 2 > CRIPPLE CHIP Amaj ***************//
~jo.free;
~jo = {
  var magMax = 0.001, magMin = -0.001, magSmooth = 0.2; // magic numbers
  var stringmix, synthmix, mix, insig, s5, strings, mag1, mag2, mic;
  var s_amp, s_pitch1, s_pitch2, s_haspitch, beat1 = 8, beat2 = 8;
  var mapped1, mapped2;
  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  var mode = 0, sequence = 0;
  var centroids, t_neckbottom, t_top, t_necktop;
  var chain1, chain2, onsets1, onsets2, pitches1, pitches2, seq1, seq2, dur1, dur2;

  //mic = In.ar(2, 1);
  mag1 = In.ar(7,1);
  mag2 = In.ar(8,1);

	  // STRINGS INPUT
	s5 = In.ar(4,1);
	strings = In.ar(5,1);
	s5 = SVF.ar(s5, nastynoise_hz*1, 0.01 ,0,0,0,1,0);
	strings = SVF.ar(strings, nastynoise_hz*1, 0.01 ,0,0,0,1,0);

	// pull out the good signal, get rid of digital noise
	s5 = Compander.ar(s5, s5, 0.02, 4.0, 1.0, 0.05, 0.01, mul: 15.0);
	strings = Compander.ar(strings, strings, 0.02, 2.5, 1.0, 0.01, 0.01, mul: 80.0);



  // trill sensor
  centroids = TrillCentroids.kr(1, 0x18, 40, 1);

  // MODE TOGGLE: neckbottom toggles echo/delay
  t_neckbottom = (centroids[1] >= ~ranges[\neckbottom][0]) * (centroids[1] <= ~ranges[\neckbottom][1]);
  mode = Stepper.kr(t_neckbottom,0,0,1);
  //t_bottom.poll(2);
  //mode.poll(1);

  // SEQUENCE TOGGLE: necktop toggles pitch range
  t_necktop = (centroids[2] > 10) * (centroids[1] >= ~ranges[\necktop][0]) * (centroids[1] <= ~ranges[\necktop][1]);
  sequence = Stepper.kr(t_necktop,0,0,3);
  //t_necktop.poll(2);
  //sequence.poll(1);

  // string onset detection
  chain1 = FFT(LocalBuf(512), s5, 0.5, 1); // drone
  chain2 = FFT(LocalBuf(512), strings, 0.5, 1); // other strings
  onsets1 = Onsets.kr(chain1, 0.5, \power); // try different algorithms for CPU
  onsets2 = Onsets.kr(chain2, 0.5, \power); // try different algorithms for CPU


  // Drone string sequence
  pitches1 = Select.kr(sequence, [
    [[\a4.f, \e5.f], [\gs4.f, \d4.f], [\fs3.f, \a4.f]],
    [[\cs4.f, \fs4.f], [\e3.f, \b4.f], [\d3.f, \a3.f]],
    [[\cs4.f, \fs4.f], [\e3.f, \b4.f], [\d3.f, \a3.f]] / 2.0,
  ]);
  seq1 = Select.kr(Stepper.kr(onsets1, 0, 0, 2), pitches1);
  dur1 = Select.kr(mode, [0.6, 0.2, 0.2]);
  seq1 = Pulse.ar(seq1, mul: 1.0).sum * 0.6 * EnvGen.ar(Env.perc(0.01, dur1), onsets1);
  seq1 = Select.ar(mode, [
    AllpassC.ar(seq1, 0.2, 0.2, 2.0),  // 0
    seq1,                               // 1
  ]);

  // 4-strings sequence
  pitches2 = Select.kr(sequence, [
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 4,       //0
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 2,   //1
    [[\e5.f, \cs4.f], [\a3.f, \cs4.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]] * 5.5,   //2
    [[\e5.f, \cs4.f, \d3.f], [\a3.f, \cs4.f], [\a4.f, \cs2.f], [\e4.f, \gs5.f], [\gs3.f, \b4.f]],   //2
  ]);
  seq2 = Select.kr(Stepper.kr(onsets2, 0, 0, 3), pitches2);
  seq2 = Pulse.ar(seq2, mul: 1.0).sum * 0.5 * EnvGen.ar(Env.perc(0.01, dur1), onsets2);
  seq2 = Select.ar(mode, [
    AllpassC.ar(seq2, 0.1, 0.1, 1.0) + seq2,
    seq2,
  ]);

	stringmix = (s5 * 1.0) + (strings * 1.0);
	synthmix = (seq1 * 1.0) + (seq2 * 1.0);
  mix = synthmix + GVerb.ar(stringmix, 15, 1, 0.2, 0.2, 5, 1.0, 0.5, 0.1);
  mix = Limiter.ar(LeakDC.ar(mix * 1.0), 1.0, 0.001);
  //RecordBuf.ar(mix, b, loop: 0); // record first 10 seconds of audio
  mix;
}.play(s, outbus: 0);
);
~jo.free;



