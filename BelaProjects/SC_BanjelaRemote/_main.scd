/*******************
Use this program to boot scsynth on the Bela.
This script simply starts scsynth, which then waits for messages.
Use the code in the other .scd files in this project to interact with the board
from the SuperCollider IDE running on the host.

(c) 2019 Jonathan Reus

Input channels:
// 0- ??
// 1- ??
// 2- AUDIO IN L
// 3- AUDIO IN R?
// 4- DIFF PICKUP 1 ON PREBOARD 1 (drone string)
// 5- DIFF PICKUP 2 ON PREBOARD 1 (4 strings)
// 6- MAG PICKUP 1 ON PREBOARD 2 (RIGHT INPUT COIL)
// 7- MAG PICKUP 2 ON PREBOARD 2 (LEFT INPUT COIL)
// 8- MAG PICKUP 1 ON PREBOARD 1 (drone string)
// 9- MAG PICKUP 2 ON PREBOARD 1 (4 strings)

*/

s = Server.default;

s.options.numAnalogInChannels = 8; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 8; // can be 2, 4 or 8
s.options.numDigitalChannels = 2;
s.options.maxLogins = 8; // NOTE: does this actually do anything? - I get the following response in the client:
// belaServer: server process has maxLogins 8 - adjusting my options accordingly.


s.options.pgaGainLeft = 24;   // mic
s.options.pgaGainRight = 30;  // pickup
s.options.headphoneLevel = 0; // headphone output (main stereo out) level (-dB)
s.options.speakerMuted = 1;    // 1=mute the speaker amp
s.options.dacLevel = 0;       // sets the gain of the analog outputs (+dB)
s.options.adcLevel = 0;       // sets the gain of the analog inputs (+dB)

s.options.blockSize = 128; // max blocksize possible on the Bela is 128, good when doing analysis & MML stuff

// analog inputs 2-7 will still be available through the AnalogIn Ugen.
s.options.numInputBusChannels = 12; // Use stereo input + all 8 analog inputs as audio input channels
s.options.numOutputBusChannels = 2; // Use only the L/R audio output channels

s.options.memSize = 8192 * 2; // kilobytes memory reserved for allocating synths, the default is 8192
s.options.numWireBufs = 64 * 2; // max number of Ugen interconnection buffers, limits complexity of synths

s.boot;
