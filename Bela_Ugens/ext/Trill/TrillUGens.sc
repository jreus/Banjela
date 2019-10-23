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

i2c_bus        I2C bus to use on BeagleBone
i2c_address    I2C address of Trill sensor
thresholdOpt   noise threshold, int: 0-6, 6=highest noise threshold
prescalerOpt   int: 0-5, lower values=higher sensitivity
*/
TrillCentroids : MultiOutUGen {
  *kr {arg i2c_bus=1, i2c_address=0x18, thresholdOpt=6, prescalerOpt=0;
    if(thresholdOpt.inclusivelyBetween(0,6).not) { Exception("Threshold option % out of bounds. Must be an index from 0 to 6.".format(thresholdOpt)).throw };
    if(prescalerOpt.inclusivelyBetween(0,5).not) { Exception("Prescaler option % out of bounds. Must be an index from 0 to 5.".format(thresholdOpt)).throw };

    ^this.multiNew('control', i2c_bus, i2c_address, threshold, prescaler);
  }

  //
  init { arg ... theInputs;
    inputs = theInputs;
    ^this.initOutputs(26, rate);
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