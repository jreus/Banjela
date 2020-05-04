( // connect to the already-running remote belaserver
Server.default = s = Server("belaServer", NetAddr("192.168.7.2", 57110));
s.options.maxLogins = 8; // should match the settings on the Bela
s.initTree;
s.startAliveThread;

// IO parameters
~in = (mic: 3, pickup: 2, s1: 6, s2: 9, s3: 8, s4: 5, s5: 4, m1: 11, m2: 10, m3: 7);
~tr = (
	ntop: [0.01, 0.3104], slide: [0.5171, 0.7242], nbottom: [0.7579, 0.8621],
	rimtop: [0.3447, 0.4138], rimbottom: [0.8964, 0.9311],
	i2c_bus: 1,
	i2c_addr: 0x38,
	noiseThresh: 30, // int: 5-255 with 255 being the highest noise thresh
	prescalerOpt: 1, // int: 0-4 with 0 being the highest sensitivity
);

// fill ~sf with a graph of available sample files
~path_bela = "/root/Banjela";
~spath_bela = ~path_bela +/+ "samples"; // sample path on Bela filesystem
~spath_local = "../../samples".resolveRelative; // sample path on Local filesystem
~readSounds = {
  ~sf = Dictionary.new;
  PathName(~spath_local).filesDo {|path|
    var category, label = path.folderName;
    category = ~sf[label];
    if(category.isNil) {
      category = Dictionary.new;
      ~sf.put(label, category);
    };
    category.put(path.fileNameWithoutExtension, path);
  };
};

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
--------------------------------------------*/

// allocate 30 seconds of audio, 2 channels, record to it in patches below...
b = Buffer.alloc(s, s.sampleRate * 30.0, 2);

// write to file (warning: may disconnect IDE from the Bela, file write takes up all system resources)
b.write(~path_bela +/+ Date.getDate.stamp ++ "_snip.wav", "WAV", "float");


/* --------------------------------------------------------------------------------------
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

LOAD SAMPLES

---------------------------------------------------------------------------------------- */
(
Ndef.clear;
if(~jo.notNil) { ~jo.free; ~jo=nil; };
~readSounds.(); // load buffers
if(~bufs.notNil) { ~bufs.keysValuesDo {|key,val| val.free } };
~bufs = Dictionary.new;
[ // minimize this only to buffers being used
  ~sf["ambient"]["sample_A1"], ~sf["voice"]["Ahhhs"], ~sf["voice"]["Moonshiner"], ~sf["percussive"]["Chinga_002"], ~sf["percussive"]["JapaDrum1_13"],
  ~sf["voice"]["Hallelujah_Amazing_Grace_001"], ~sf["voice"]["Ahhhs_mono"], ~sf["percussive"]["Chinga_0122"]].do {|it,idx| ~bufs[it.fileNameWithoutExtension] = ~spath_bela +/+ it.folderName +/+ it.fileName };

// Read buffers: slowly now.. take it easy now...
{
  ~bufs.keysValuesDo {|key, val, idx|
    var buf = Buffer.read(s, val);
    "Loading %".format(val).postln;
    ~bufs.put(key, buf);
	0.25.wait;
  };
  "Done...".postln;
}.fork;

);

// Check samples all loaded
~bufs;
~bufs.keys;