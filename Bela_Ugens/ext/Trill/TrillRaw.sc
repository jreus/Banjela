TrillRaw : MultiOutUGen {
    /*
      i2c_bus     I2C bus to use on BeagleBone
      i2c_address I2C address of Trill sensor
      threshold   noise threshold, one of: {0, 10, 20, 30, 40, 50, 60}
      prescaler   lower values=higher sensitivity, one of {1, 2, 4, 8, 16, 32}
    */
    *kr {arg i2c_bus=1, i2c_address=0x18, threshold, prescaler;
        ^this.multiNew('control', i2c_bus, i2c_address, threshold, prescaler);
    }

  // default to 26 outputs for now
	init { arg ... theInputs;
		inputs = theInputs;
		^this.initOutputs(26, rate);
	}

}


/*
Examples of other MultiOutUGens

MFCC : MultiOutUGen {
	*kr { arg chain, numcoeff=13;
		^this.multiNew('control', chain, numcoeff);
	}

	init { arg ... theInputs;
		inputs = theInputs;

		^this.initOutputs(theInputs[1], rate);
	}
}



//6 outs
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