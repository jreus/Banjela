/*--------------------------------------------------
Sketches for the newer OpenBack Banjer design.

(c) 2020 Jonathan Reus

----------------------------------------------------**/

(
Project.startup(s, false, false, true, 100, 1000, true, "".resolveRelative, onBoot: {|serv|
	"STARTUP".error;
});
);




(
Ndef(\banjer, {
	var strings, mic, mix;
	mic = SoundIn.ar(0, 1);
	strings = SoundIn.ar(2, 1);
	//mix = GVerb.ar(strings, 10, 1, 0.5, 0.5, 30, 1, 0.5, 0.5, mul: 0.2) + strings;
	//mix = SinOsc.ar([330,220]) * 0.1;
	mix = PitchShift.ar(strings, 0.1, [1.5,1.5], 0.0, 0.0) + (strings!2 * 0.5);
	mix=Limiter.ar(mix, 1.0);
	mix;
}).play(out: 0, numChannels: 2);
);

s.scope;



/* ------------------------------------------

Banjer Openback Livecoding

---------------------------------------------*/


(
Project.startup(s, verbose: false, showScenes: true, showMeters: false,
  limitSamplesLocal: 100, limitSamplesGlobal: 100, scOnly: true, rootPath: ".".resolveRelative,
  onBoot: {
    "Tell me a story...".postln;
    Macros.prefixStr = "///";
    Macros.postfixStr = "";
  });
);

(
"_LANG.scd".resolveRelative.load;
);

// ONLY WORKS ON OSX...
//"The one in your mind that says,".say2("Kyoko",out:Project.outclean,amp:0.4);
//"‘No, you can’t write that.".say2("Kyoko",out:Project.outverb,amp:1.0);

( // Editor
if(a.notNil.and {a.win.notNil}) { a.win.close(); a.win = nil };
a = ();
a.win = Window.new("wordweaving", Rect(800,800,800,400)).background = Color(1,1,1,1);
//Font.availableFonts;
a.text = WordWeaving.new(a.win, Rect(0,0, a.win.bounds.width, a.win.bounds.height));
a.text.font = Font("Monaco", 16, false, false, true);
a.text.palette = QPalette.dark;
a.text.enterInterpretsSelection = false; // skip SC-style evaluation...

// Pre-TextView Keyboard Interaction


a.win.visible = true;
a.win.alwaysOnTop = true;
);

( // extra functions and such...
a.text.keyDownAction = nil;
a.text.keyUpAction = nil;
);

a.text.string="a\nb\nc\nd\ne\nf\ng\nq\nr\ns\n";
a.text.line(2);
a.text.line_(2, ">>tick");
a.text.line_(2, Macros.eval(a.text.line(2)));
a.text.line_(3, ">>zeno");
a.text.line_(3, Macros.eval(a.text.line(3)));

(
Tdef(\ticktock, {
	inf.do {|i|
		i.postln;
		if(i%16 == 0) {
			a.text.line_(2, Macros.eval(a.text.line(2)));
		};
		if(i%64 == 0) {
			a.text.line_(3, Macros.eval(a.text.line(3)));
		};
		(1/16).wait;
	}
}).play(AppClock);
);
Tdef(\ticktock).clear;
