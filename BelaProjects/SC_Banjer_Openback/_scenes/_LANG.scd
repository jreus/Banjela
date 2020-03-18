// MACROS

(
Macros.new('zeno', \rewrite, "zeno", "@pre@closer", {
{
		var sig = Resonz.ar(Saw.ar([400,5000,300, 760]/3).sum, [400,500,800] * XLine.ar(1,2,0.5), 0.1, mul: 1.0);
		Splay.ar(sig) * EnvGen.ar(Env.linen(0.5,0.5), doneAction: 2, timeScale: 2);
}.play;
});

Macros.new('closer', \rewrite, "closer", "@pre@and", {
{
		var sig = Resonz.ar(Saw.ar([400,5000,300, 560]/4).sum, [400,500,800] * XLine.ar(1,2,0.5), 0.1, mul: 1.0);
		Splay.ar(sig) * EnvGen.ar(Env.linen(0.5,0.5), doneAction: 2, timeScale: 2);
}.play;
});

Macros.new('and', \rewrite, "and", "@pre@closer.", {
{
		var sig = Resonz.ar(Saw.ar([400,5000,300, 1200]/3.5).sum, [400,500,800] * XLine.ar(1,2,0.5), 0.1, mul: 1.0);
		Splay.ar(sig) * EnvGen.ar(Env.linen(0.5,0.5), doneAction: 2, timeScale: 2);
}.play;
});

Macros.new('closer.', \rewrite, "closer.", "@pre@zeno", {
{
		var sig = Resonz.ar(Saw.ar([100, 120, 550, 400, 3000,5500]/3.75).sum, [400,500,1800] * XLine.ar(1,1,0.5), 0.1, mul: 1.0);
    sig = BLowPass4.ar(sig, 2200, 0.2) + BHiPass4.ar(BrownNoise.ar, 1000, mul: 0.1);
    sig = FreeVerb.ar(sig);
    Splay.ar(sig) * EnvGen.ar(Env.linen(0.5,0.5), doneAction: 2, timeScale: 0.5);
}.play;
});

Macros.new('distance', \rewrite, "distance", "@pre@tortoise",{
{
	var sig = Saw.ar(Saw.ar([30,40,500,170]).range(30,400));
	Splay.ar(sig) * EnvGen.ar(Env.perc, timeScale: 2, doneAction: 2) * 0.6;
}.play;
});


Macros.new('tortoise', \rewrite, "tortoise", "@pre@distance",{
{
	var sig = Saw.ar(Saw.ar([3,40,50,17]/2).range(50,2000));
	Splay.ar(sig) * EnvGen.ar(Env.perc, timeScale: 5, doneAction: 2) * 0.6;
}.play;
});


Macros.new('tock', \rewrite, "tock", "@pre@tick", {
{
	var sig = Resonz.ar(Impulse.ar(0.1), [209,388,399,400,1211,800,6000,8200,9000] / 2.211, 0.1, mul: 300.0);
	Splay.ar(sig) * EnvGen.ar(Env.perc(0.001,0.05), doneAction: 2);
}.play;
});

Macros.new('tick', \rewrite, "tick", "@pre@tock", {
{
	var sig = Resonz.ar(Impulse.ar(0.1), [209,388,399,400,1211,800,6000,8200,9000] / 1.2, 0.1, mul: 300.0);
	Splay.ar(sig) * EnvGen.ar(Env.perc(0.001,0.05), doneAction: 2);
}.play;
});

Macros.new('click', \rewrite, "click", "@pre@pop", {
{arg out, pan=0, amp=1.0;
	var sig = Resonz.ar(PinkNoise.ar, [209,388,399,400,1211,800] * 10, 0.1, mul: 100.0);
	sig = sig.sum * EnvGen.ar(Env.perc(0.001,0.001), doneAction: 2);
	Pan2.ar(sig, pan, amp);
}.play;
});

Macros.new('pop', \rewrite, "pop", "@pre@click", {
{arg out, pan=0, amp=1.0;
	var sig = Resonz.ar(Impulse.ar(0.1), [209,388,399,400,1211,800,6000,8200,9000] / 10, 0.5, mul: 300.0);
	sig = sig.sum * EnvGen.ar(Env.perc(0.0001,0.005), doneAction: 2);
	Pan2.ar(sig, pan, amp);
}.play;
});

Macros.new('littlebird', \command, "littlebird", nil, {
	s.scope(2);
});

);


// API
(
~mediaDir = "../HEADmedia".resolveRelative;
~mediaByName = Dictionary.new;
~media = PathName(~mediaDir).filesDo {|file|
  ~mediaByName.put(file.fileNameWithoutExtension, file);
};

~show = {|filename|
  var res, file = ~mediaByName.at(filename);

  if(file.isNil) {
    res = "% not found".format(filename);
    res.error;
    ~mediaByName.keys.asArray.sort.do {|key| key.postln };
  } {
    res = file;
    "open %".format(file.fullPath).unixCmd;
  };
  res;
};

~initvc = {
  "VoiceClassifier_Lib.scd".resolveRelative.load;
  a.init;
};

~plotVoice = {|width=800, height=800| // plot the training data stored in ~t_data and ~t_labels
  var aspoints, dim = width@height;
  var domain, range;
  domain = [~t_data.collect({|vec| vec.minItem }).minItem, ~t_data.collect({|vec| vec.maxItem }).maxItem].asSpec;
  domain.postln;
  w = Window("Voice Features Plots", dim);
  j = ScatterPlotter.new(w, dim, a.asPoints(~t_data,~t_labels,0)).setAxes(domain, domain);
  j.drawAxes_(true).drawGrid_(true).drawGridValues_(true).gridResolution_(5@5).drawMethod_(\fillOval).symbolSize_(4@4);
  j.addPlot(a.asPoints(~t_data,~t_labels,1));
  w.alwaysOnTop_(true);
  w.front;
  ~xdim=0; ~ydim=0;
};

// change plotted dimensions of dataset
~plotDim = {|xdim=nil, ydim=nil|
  // cycle through dimensionality pairs if no args provided
  if(ydim.notNil) {
    ~ydim = ydim;
  } {
    ~ydim = ~ydim + 1;
  };
  if(~ydim == a.numfeats) {
    ~ydim = 0;
    ~xdim = ~xdim + 1;
    if(~xdim == a.numfeats) { ~xdim = 0 };
  };

  if(xdim.notNil) { ~xdim = xdim };

  ~xcol = ~t_data.getCol(~xdim);
  ~ycol = ~t_data.getCol(~ydim);
  "Xdim: % [% %]\nYdim: % [% %]".format(
    ~xdim, ~xcol.minItem.round(0.0001), ~xcol.maxItem.round(0.0001),
    ~ydim, ~ycol.minItem.round(0.0001), ~ycol.maxItem.round(0.0001)
  ).postln;

  j.data_(a.asPoints(~t_data, ~t_labels, 0, ~xdim, ~ydim ), 0);
  j.data_(a.asPoints(~t_data, ~t_labels, 1, ~xdim, ~ydim ), 1);

  j.setAxesLabels("DIM"+~xdim,"DIM"+~ydim);
};

// statistics / data optimization functions
~normalizeSample = {|v,min,max| (v - min) / (max - min) };
~denormalizeSample = {|v,min,max| (v * (max-min)) + min };
~denormalizeLine = {|line,min,max|
    var p1,p2, new_m, new_b, m=line[0], b=line[1];
    // calculate two normalized samples & denormalize them
    p1 = [-1,(-1 * m)+b]; p2 = [1,(1 * m)+b];
    p1 = ~denormalizeSample.(p1, min, max);
    p2 = ~denormalizeSample.(p2, min, max);
    // calculate denormalized decision boundary
    new_m = (p2[1]-p1[1]) / (p2[0]-p1[0]); // slope
    new_b = p1[1] - (new_m*p1[0]); // y-intercept
    [new_m,new_b];
};
~standardizeSample = {|v,mean,stddev| (v-mean) / stddev };
~destandardizeSample = {|v,mean,stddev| (v*stddev) + mean };


// optimize data for training
~optimizeData = {
// feature scaling of the dataset reduced to the 2 currently plotted dimensions
  var mean, stdev, dim, min, max;
  var s1,s2,s3,s4;
  var normalizeSample, denormalizeSample, standardizeSample, destandardizeSample;

  // reduce to two dimensions & cast as Matrix
  ~dReduced = a.reduce(~t_data, [~xdim, ~ydim]); // Simple Dimensionality Reduction
  ~dReduced = Matrix.newFrom(~dReduced);

  dim = ~dReduced.cols;
  mean = Array.newClear(dim);
  stdev = Array.newClear(dim);
  ~min = Array.newClear(dim);
  ~max = Array.newClear(dim);

  // TO NORMALIZE:
  // find min / max of features
  // normalized_value = (val - min) / (max - min)
  ~dNormal = Matrix.newClear(~dReduced.rows, ~dReduced.cols);

  dim.do {|i|
    var col = ~dReduced.getCol(i);
    ~min[i] = col.minItem;
    ~max[i] = col.maxItem;
    ~dNormal.putCol(i, ~normalizeSample.(col, ~min[i], ~max[i]) );
  };

  "MIN: %   MAX: %".format(~min, ~max).postln;

  // Test
  s1 = [-0.09, 1.45];
  s2 = ~normalizeSample.(s1, ~min, ~max);
  s3 = ~denormalizeSample.(s2, ~min, ~max);
  "NEW SAMPLE: %   NORMALIZED: %  DENORMALIZED: %".format(s1,s2,s3).postln;

  // TO STANDARDIZE:
  // calculate mean and standard deviation of each feature
  // subtract mean from each feature
  // divide features by standard deviation
  ~dStandard = Matrix.newClear(~dReduced.rows, dim);
  dim.do {|i|
    var col = ~dReduced.getCol(i);
    mean[i] = col.mean;
    stdev[i] = col.stdDev(mean[i]);
    ~dStandard.putCol(i, ~standardizeSample.(col, mean[i], stdev[i]));
  };

  // TEST
  "MEAN: %   STDDEV: %".format(mean, stdev).postln;
  s1 = [-0.09, 1.45];
  s2 = ~standardizeSample.(s1, mean, stdev);
  s3 = ~destandardizeSample.(s2, mean, stdev);
  "NEW SAMPLE: %   STANDARDIZED: %  DESTANDARDIZED: %".format(s1,s2,s3).postln;

}; // END SCALING & STANDARDIZATION OF FEATURES

~addBoundary = {|model, min, max, plot|
  var db;
  // plot the decision boundary
  db = model.decisionBoundary;
  db = ~denormalizeLine.(db, min, max);
  plot.addPlot([[0,db[1]],[1,db[0]+db[1]]]).drawMethod_(\lineTo,2).symbolColor_(Color.red).symbolSize_(1,2);

  // make it pretty
  plot.backgroundColor_(Color.black).drawAxes_(false);
  plot.symbolSize_(30,2).symbolColor_(Color.yellow,2);
  plot.symbolColor_(Color.new(1.0, 0.5, 0.5),0).symbolSize_(4@4,0).symbolColor_(Color.gray(0.85),1).symbolSize_(2@2,1);
};

);




