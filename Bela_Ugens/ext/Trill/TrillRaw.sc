TrillRaw : UGen {
    /*
      i2c_bus     I2C bus to use on BeagleBone
      i2c_address I2C address of Trill sensor
      threshold   noise threshold, one of: {0, 10, 20, 30, 40, 50, 60}
      prescaler   lower values=higher sensitivity, one of {1, 2, 4, 8, 16, 32}
    */
    *kr {arg i2c_bus=1, i2c_address=0x18, threshold, prescaler;
        ^this.multiNew('control', i2c_bus, i2c_address, threshold, prescaler);
    }
}
