/**
This script exemplifies the use of SuperCollider on Bela.
When a project contains a `_main.scd` file, `sclang` is started
and the content of the file is executed.
If you want to interact with SuperCollider running on the board
from within the SuperCollider IDE on your computer, check out 
the 12-SuperCollider/remote examples instead.
Those files also include more code examples to interface with
Bela-specific UGens.
 */
s = Server.default;

s.options.numAnalogInChannels = 8;
s.options.numAnalogOutChannels = 8;
s.options.numDigitalChannels = 16;

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.options.postln;

s.waitForBoot({
	{
		var vals;
		vals = TrillIn.kr();
		SendReply.kr(Impulse.kr(1), "/trill", vals);
		WhiteNoise.ar(SinOsc.ar(1.0).unipolar) * 0.1;
	}.play;

	OSCdef(\trill, {|msg| msg.postln }, "/trill")
});
