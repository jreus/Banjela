/************************************************************
UGen class definitions for using Trill Sensors on the Bela

2019 (C) Jonathan Reus

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License https://www.gnu.org/licenses/
for more details.
*************************************************************/


/*
Default values are chosen which are viable for most usage scenarios.
By default noise threshold is high and sensitivity is high.

i2c_bus        I2C bus to use on BeagleBone
i2c_address    I2C address of Trill sensor
thresholdOpt   noise threshold, int: 0-6, 6=highest noise threshold
prescalerOpt   int: 0-5, lower values=higher sensitivity
*/
TrillRaw : MultiOutUGen {
  *kr {arg i2c_bus=1, i2c_address=0x18, thresholdOpt=6, prescalerOpt=0;
    if(thresholdOpt.inclusivelyBetween(0,6).not) { Exception("Threshold option % out of bounds. Must be an index from 0 to 6.".format(thresholdOpt)).throw };
    if(prescalerOpt.inclusivelyBetween(0,5).not) { Exception("Prescaler option % out of bounds. Must be an index from 0 to 5.".format(thresholdOpt)).throw };

    ^this.multiNew('control', i2c_bus, i2c_address, threshold, prescaler);
  }

  // 26 fixed outputs (TODO: should be increased to 30 for latest Trill sensors)
  init { arg ... theInputs;
    inputs = theInputs;
    ^this.initOutputs(26, rate);
  }
}

/*
Default values are chosen which are viable for most usage scenarios.
By default noise threshold is high and sensitivity is high.
The outputs should be interpreted as the number of active touches, followed by location, size pairs for each touch centroid like so:

[numActive, loc1, size1, loc2, size2, loc3, size3, loc4, size4, loc5, size5]

Where:
loc - is a value from 0.-1. specifying the position on the trill bar.
size - is a value somewhere in the range of 0-6000 specifying the centroid size.

By default all 5 potential centroids are tracked (for a total of 10 kr outputs),
but the number of centroids can be limited to a smaller number using the
limitNumTouches argument.

i2c_bus          I2C bus to use on BeagleBone
i2c_address      I2C address of Trill sensor
thresholdOpt     noise threshold, int: 0-6, 6=highest noise threshold
prescalerOpt     int: 0-5, lower values=higher sensitivity
limitNumTouches  int: 1-5, limit number of simultaneous centroids returned
*/
TrillCentroids : MultiOutUGen {
  *kr {arg i2c_bus=1, i2c_address=0x18, thresholdOpt=6, prescalerOpt=0, limitNumTouches=5;
    if(thresholdOpt.inclusivelyBetween(0,6).not) { Exception("Threshold option % out of bounds. Must be an index from 0 to 6.".format(thresholdOpt)).throw };
    if(prescalerOpt.inclusivelyBetween(0,5).not) { Exception("Prescaler option % out of bounds. Must be an index from 0 to 5.".format(prescalerOpt)).throw };
    if(limitNumTouches.inclusivelyBetween(1,5).not) { Exception("Num touches limited to %. Value must be an integer from 1 to 5.".format(limitNumTouches)).throw };

    ^this.multiNew('control', i2c_bus, i2c_address, threshold, prescaler, limitNumTouches);
  }

  // TrillCentroids has a variable number of control rate output channels
  init { arg ... theInputs;
    inputs = theInputs;
    ^this.initOutputs((theInputs[4] * 2) + 1, rate);
  }
}



/* USEFUL EXAMPLES OF MULTI-OUT UGENS

// MFCC has a variable number of control rate output channels
// specified at instantiation.
MFCC : MultiOutUGen {
*kr { arg chain, numcoeff=13;
^this.multiNew('control', chain, numcoeff);
}

init { arg ... theInputs;
inputs = theInputs;
^this.initOutputs(theInputs[1], rate);
}
}



// BeatTrack2 has 6 fixed control rate output channels
BeatTrack2 : MultiOutUGen {
*kr { arg busindex, numfeatures, windowsize=2.0, phaseaccuracy=0.02, lock=0, weightingscheme;
^this.multiNew('control',busindex, numfeatures,windowsize, phaseaccuracy, lock, weightingscheme ? (-2.1));
}

init { arg ... theInputs;
inputs = theInputs;
^this.initOutputs(6, rate);
}
}
*/