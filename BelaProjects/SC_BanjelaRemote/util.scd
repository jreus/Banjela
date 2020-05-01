( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 8; // should match the settings on the Bela
s.initTree;
s.startAliveThread;

// fill ~sf with a graph of available sample files
~readSounds = {
  ~spath = "/root/banjer/samples/";
  ~sf = Dictionary.new;
  PathName("../../samples".resolveRelative).filesDo {|path|
    var category, label = path.folderName;
    category = ~sf[label];
    if(category.isNil) {
      category = Dictionary.new;
      ~sf.put(label, category);
    };
    category.put(path.fileNameWithoutExtension, path);
  };
};

// trill segment ranges
~ranges = Dictionary.with(*[\bottom->[0.4, 0.44], \top->[0.48, 0.56], \necktop->[0.0, 0.36], \neckbottom->[0.88, 1.0], \slide->[0.6, 0.84]]);
);

s.plotTree;
s.freeAll;

Platform.systemExtensionDir;
Platform.userExtensionDir;


/*-------------------------------------------
█▄▄▄▄ ▄███▄   ▄█▄    ████▄ █▄▄▄▄ ██▄
█  ▄▀ █▀   ▀  █▀ ▀▄  █   █ █  ▄▀ █  █
█▀▀▌  ██▄▄    █   ▀  █   █ █▀▀▌  █   █
█  █  █▄   ▄▀ █▄  ▄▀ ▀████ █  █  █  █
  █   ▀███▀   ▀███▀          █   ███▀
 ▀                          ▀
*/
b = Buffer.alloc(s, s.sampleRate * 30.0, 2); // 30 seconds of audio, 2 channels
// write to file (warning, may disconnect from the Bela due to the file write taking up all the system resources!)
b.write("/root/banjer/data/" +/+ Date.getDate.stamp ++ "_snip.wav", "WAV", "float");


/*
 ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄        ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░▌      ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌
▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀
▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌▐░▌ ▐░▌▐░▌▐░▌
▐░▌          ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄
▐░▌          ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌
▐░▌          ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌     ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀
▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌       ▐░▌▐░▌
▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░▌      ▐░▌       ▐░▌▐░░░░░░░░░░░▌
 ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀        ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀

*/
(
Ndef.clear;
~jo.free;
~readSounds.();
if(~bufs.notNil) { ~bufs.keysValuesDo {|key,val| val.free } };
~bufs = Dictionary.new;
[
  ~sf["voice"]["Ahhhs"], ~sf["voice"]["Moonshiner"], ~sf["percussive"]["Chinga_002"], ~sf["percussive"]["JapaDrum1_13"],
  ~sf["voice"]["Hallelujah_Amazing_Grace_001"], ~sf["voice"]["Ahhhs_mono"], ~sf["percussive"]["Chinga_0122"],
].do {|it,idx| ~bufs[it.fileNameWithoutExtension] = ~spath +/+ it.folderName +/+ it.fileName };

~offsets = Dictionary.with(*[å
  "Moonshiner_verses" -> [1.503, 13.726, 25.414, 37.428, 48.943, 60.96, 71.9, 83.89, 96.23, 108.4],
]);

// slowly now.. take it easy now...
{
  ~bufs.keysValuesDo {|key, val, idx|
    var buf = Buffer.read(s, val);
    "Loading %".format(val).postln;
    ~bufs.put(key, buf);
  };
  "Done...".postln;
}.fork;

);
~bufs;
~bufs.keys;