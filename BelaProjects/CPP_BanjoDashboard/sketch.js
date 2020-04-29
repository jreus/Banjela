/***** Banjo Dashboard GUI *****/

//**************************************************************************************
// GUI CLASSES
//**************************************************************************************


/* ---------------------------------------------
// TrillBar ~ Trill Bar Sensor GUI Widget
----------------------------------------------*/
if(typeof TrillBar === "undefined") {
	TrillBar = class {
		constructor(sketch, length, height, position = [50, 50], touchScale=0.75) {
			this.s = sketch;
			this.position = position;
			this.dimensions = [ length, height ];
			this.cornerRadius = 10;
			console.log("Building trill sensor GUI " + this.dimensions[0] + " x " + this.dimensions[1] + " pos: " + this.position);
			this.touches = {
				num: 5,
				scale: touchScale,
				sizes: new Array(5),
				locations: new Array(5),
				activations: [0, 0, 0, 0, 0],
				colors: [ 'honeydew', 'azure', 'lavenderblush', 'ivory', 'navajowhite' ]
				//colors: [ 'red', 'blue', 'yellow', 'white', 'cyan' ]
			}
		}

		draw() {
			this.s.fill(35);
	        this.s.rect(this.position[0], this.position[1], this.dimensions[0], this.dimensions[1], this.cornerRadius);

	        for(let t = 0; t < this.touches.num; t++) {
	        	if(this.touchActive(t)) {
	        		this.drawTouch(t);
	        		this.touches.activations[t] = 0;
	        	}
	        }
		}

		updateTouch(i, location, size) {
			if(i<5) {
				this.touches.activations[i] = 1;
				location = this.s.constrain(location, 0, 1);
				this.touches.locations[i] = this.dimensions[0]*location;
				size = this.s.constrain(size, 0, 1);
				this.touches.sizes[i] = size;
			}
		}

		activeTouches() {
			return this.touches.activations.filter(Boolean).length;
		}

		touchActive(i) {
			if(i<5)
				return this.touches.activations[i];
		}

		setTouchState(i, state) {
			if(i<5)
				this.touches.activations[t] = Boolean(state);
		}

		drawTouch(i) {
			if(i<5) {
				this.s.fill(this.touches.colors[i]);
				let diameter = this.dimensions[1]*this.touches.sizes[i]*this.touches.scale;
				this.s.ellipse(this.position[0] + this.touches.locations[i], this.position[1] + this.dimensions[1]/2, diameter);
			}
		}

		changeTouchColor(i, newColor) {
			this.touches.colors[i] = this.s.color(newColor);
		}

		changeTouchScale(scale) {
			if(scale <=1 ) {
				this.touches.scale = scale;
			}
		}

		resize(length, height) {
			this.dimensions = [length, height];
		}
	}
}

/* -----------------------------------------------------------
// TrillCraft ~ More flexible segmented Trill widget
----------------------------------------------*/
if(typeof TrillCraft === "undefined") {
	TrillCraft = class {
		// segmentSpecs is an array of spec arrays, one for each segment
		// a spec array contains the following [range, length, height, position, orientation, touchScale]
		constructor(sketch, numSegments, segmentSpecs) {
			this.s = sketch;
			this.numSegments = numSegments;
			this.segments = new Array(numSegments);
			segmentSpecs.forEach((spec, idx) => {
				let newspec = {
					num: idx, range: spec[0], dimensions: [spec[1], spec[2]],
					position: spec[3], orientation: spec[4], touchScale: spec[5],
				};
				segments[idx] = newspec;
			});
			this.cornerRadius = 10;
			console.log("Building trill craft GUI ");

			this.touches = {
				num: 5,
				segments: new Array(numSegments),
				sizes: new Array(5),
				locations: new Array(5),
				activations: [0, 0, 0, 0, 0],
				colors: [ 'honeydew', 'azure', 'lavenderblush', 'ivory', 'navajowhite' ]
			}
		}

		draw() {
			this.s.fill(35);

			// draw segments
			this.segments.forEach((seg, idx) => {
				this.s.rect(seg.position[0], seg.position[1], seg.dimensions[0], seg.dimensions[1], this.cornerRadius);
			});

			// draw touches
	   	for(let t = 0; t < this.touches.num; t++) {
	    	if(this.touchActive(t)) {
	      	this.drawTouch(t);
	      	this.touches.activations[t] = 0;
	      }
	   	}
		}

		touchActive(i) {
			if(i<5)
				return this.touches.activations[i];
		}

		drawTouch(i) {
			if(i<5) {
				this.s.fill(this.touches.colors[i]);
				if(this.touches.segments[i] != null) {
					let seg = this.segments[this.touches.segments[i]];
					let diameter = seg.dimensions[1] * this.touches.sizes[i] * seg.touchScale;
					this.s.ellipse(seg.position[0] + this.touches.locations[i], seg.position[1] + seg.dimensions[1]/2, diameter);
				}
			}
		}

		updateTouch(i, location, size) {
			if(i<5) {
				this.touches.activations[i] = 1;
				location = this.s.constrain(location, 0, 1);
				let segment_num = null;
				for(let k = 0; k < this.segments.length; k++) {
						if(location >= this.segments[k].range[0] && location <= this.segments[k].range[k]) {
							segment_num = k;
							break;
						}
				}
				if(segment_num != null) {
					let seg = this.segments[segment_num];
					let mapped_location = this.s.map(location, seg.range[0], seg.range[1], 0.0, 1.0);
					this.touches.locations[i] = seg.dimensions[0]*mapped_location;
					this.touches.segments[i] = segment_num;
					size = this.s.constrain(size, 0, 1);
					this.touches.sizes[i] = size;
				} else {
					this.touches.segments[i] = null; // not displayed on any segment
				}
			}
		}

		activeTouches() {
			return this.touches.activations.filter(Boolean).length;
		}


		setTouchState(i, state) {
			if(i<5)
				this.touches.activations[t] = Boolean(state);
		}

		changeTouchColor(i, newColor) {
			this.touches.colors[i] = this.s.color(newColor);
		}

		changeTouchScale(segment, scale) {
			if(scale <=1 ) {
				this.segments[segment].touchScale = scale;
			}
		}

		resizeSegment(segment, length, height) {
			this.segments[segment].dimensions = [length, height];
		}
	}
}

if(typeof WaveForm === "undefined") {
	WaveForm = class {
		// orientation: 0 (horizontal), 1 (vertical)
		constructor(sketch, length, height, position = [50, 50], orientation = 0, bufferSize = 512, multiplier = 1.0) {
			this.s = sketch;
			this.position = position;
			this.dimensions = [ length, height ];
			this.multiplier = multiplier;
			this.orientation = orientation;
			this.feedbackText = "";
			this.bufferSize = bufferSize;
			this.segmentSize = this.dimensions[this.orientation] / this.bufferSize;
			if(this.orientation == 0) { // horizontal
				this.xOffset = this.position[0];
				this.yOffset = this.position[1] + (this.dimensions[1] / 2);
			} else { // vertical
				this.xOffset = this.position[0] + (this.dimensions[0] / 2);
				this.yOffset = this.position[1];
			}
			this.buffer = new Array(bufferSize);
		}

		draw() {
			this.s.fill(20);
			this.s.noStroke();
	        this.s.rect(this.position[0], this.position[1], this.dimensions[0], this.dimensions[1], 10);

	    	let startX = 0.0, startY = 0.0;
	    	if(this.orientation == 0) { // horizontal
	    		startY = this.buffer[0] * this.multiplier * (this.dimensions[1] / 2);
	    	} else { // vertical
	    		startX = this.buffer[0] * this.multiplier * (this.dimensions[0] / 2);
	    	}

			this.s.strokeWeight(1);
			this.s.stroke(255, 55, 230);
	        for(let i = 1; i < this.bufferSize; i++) {
				let destX, destY;

				if(this.orientation == 0) {
					destX = startX + this.segmentSize;
					destY = this.buffer[i] * this.multiplier * (this.dimensions[1] / 2);
				} else {
					destY = startY + this.segmentSize;
					destX = this.buffer[i] * this.multiplier * (this.dimensions[0] / 2);
				}

				this.s.line(
					startX + this.xOffset,
					startY + this.yOffset,
					destX + this.xOffset,
					destY + this.yOffset
				);
				startX = destX; startY = destY;
	        }

	        // feedback
	        this.s.textFont('Monospace');
	        this.s.strokeWeight(1);
	        this.s.textSize(12);
	        this.s.stroke(255, 255, 255);
	        this.s.fill(255, 255, 255);
			this.s.text(this.feedbackText, this.position[0] + 5, this.position[1] + this.dimensions[1] - 5);

		}

		// newData must be an array of normalized, zero-centered floats with this.bufferSize elements
		updateBuffer(newData) {
			if(newData.length != this.bufferSize) {
				throw "WaveForm.updateBuffer: new buffer data array is of the wrong length!" + " Received: " + newData.length + "  Expecting: " + this.bufferSize;
			}
			this.buffer = newData;
		}
	}
}

//**************************************************************************************
// END GUI CLASSES
//**************************************************************************************
//**************************************************************************************
//**************************************************************************************







/*--------------------------------------------------------------------
// MAIN APP
-------------------------------------------------------*/
var guiSketch = new p5(function( sketch ) {

    let canvas_dimensions = [sketch.windowWidth, sketch.windowHeight];

	let verbose = true; // set true to get console feedback
	let verboseEvery = 30; // print feedback every 30 frames
	let verboseFrameCounter = 0;

	// This must match GUI_BUFFER_LENGTH in render.cpp
	let bufSize = 256;

	// This must match GUI_FRAME_RATE in render.cpp
	let frameRate = 30;

	// Indexes of data buffers coming from the Bela over websockets
    let idxNumActiveTouches = 0, idxTouchLocations = 1, idxTouchSizes = 2;
    //let idxString1 = 3, idxString2 = 4, idxString3 = 5, idxString4 = 6, idxString5 = 7;
    //let idxMag1 = 8, idxMag2 = 9, idxMag3 = 10;
    //let idxMic = 11, idxPiezo = 12;

    //hack
    let idxStrings = 3, idxMag = 4, idxMic = 6, idxPiezo = 5;

	// TOUCH GUI
    let spacing, activeTouches = 0, sliderLength = 0.0, sliderHeight = 0.0, touchSizeScale = 1.25;

    sketch.setup = function() {
        sketch.createCanvas(canvas_dimensions[0], canvas_dimensions[1]);
        //sketch.frameRate(120);
        sketch.frameRate(30);

        // Microphone input
        let xpos = 10, ypos = 40;
				let micWidth = 80, micLength = 150;
				let micWaveformScale = 1.0;
				sketch.sigMic = new WaveForm(sketch, micLength, micWidth, [xpos, ypos], 0, bufSize, micWaveformScale);

    		// String waveforms
        let stringsWidth = 200;
        let stringsLength = 300;
        xpos = 200; ypos = 30;
        let stringGap = 5;
        let stringWidth = ((stringsWidth - (stringGap * 4)) / 5);
        let stringWaveformScale = 5.0;
        // 5th string is a bit shorter
        sketch.sigString5 = new WaveForm(sketch, stringWidth, stringsLength * 0.8, [xpos, ypos + stringsLength * 0.2], 1, bufSize, stringWaveformScale);

				// other 4 strings
        sketch.sigString4 = new WaveForm(sketch, stringWidth, stringsLength, [xpos + ((stringWidth + stringGap)*1), ypos], 1, bufSize, stringWaveformScale);
        sketch.sigString3 = new WaveForm(sketch, stringWidth, stringsLength, [xpos + ((stringWidth + stringGap)*2), ypos], 1, bufSize, stringWaveformScale);
        sketch.sigString2 = new WaveForm(sketch, stringWidth, stringsLength, [xpos + ((stringWidth + stringGap)*3), ypos], 1, bufSize, stringWaveformScale);
        sketch.sigString1 = new WaveForm(sketch, stringWidth, stringsLength, [xpos + ((stringWidth + stringGap)*4), ypos], 1, bufSize, stringWaveformScale);

				// Mag waveforms
        let magXpos = 130;
        let magYpos = ypos + stringsLength + 50;
        let magHeight = 80, magWidth = 100;
        let magWaveformScale = 10.00;
        sketch.magSense1 = new WaveForm(sketch, magWidth - 10, magHeight - 30, [magXpos, magYpos], 1, bufSize, magWaveformScale);
        sketch.magSense2 = new WaveForm(sketch, magWidth, magHeight, [magXpos - 40, magYpos + magWidth - 30], 1, bufSize, magWaveformScale);
				sketch.magSense3 = new WaveForm(sketch, magWidth - 10, magHeight - 30, [magXpos, magYpos + magWidth + magWidth - 30], 1, bufSize, magWaveformScale);


    		// Piezo pickup
				let piezoXpos = xpos + 30;
				let piezoYpos = ypos + stringsLength + 100;
				let piezoWidth = 120, piezoLength = 180;
				let piezoWaveformScale = 1.0;
				sketch.sigPiezo = new WaveForm(sketch, piezoLength, piezoWidth, [piezoXpos, piezoYpos], 0, bufSize, piezoWaveformScale);

				// a spec array contains the following [range, length, height, position, orientation, touchScale]
				let segmentSpecs = [
					[[0.0, 0.2], 100, 40, [400, 50], 0, 1.0],
					[[0.201, 0.4], 100, 40, [400, 150], 0, 1.0],
					[[0.401, 0.7], 100, 40, [400, 250], 0, 1.0],
					[[0.701, 0.8], 100, 40, [400, 350], 0, 1.0],
					[[0.801, 1.0], 100, 40, [400, 450], 0, 1.0],
				];

				sketch.trillCraft = new TrillCraft(sketch, 5, segmentSpecs);

				/*
        // Trill Segments (TODO: Refactor this class to display multiple segments of a single trill sensor)
        sliderLength = 600;
        sliderHeight = 60;
        let sliderXpos = 440, sliderYpos = 40;
        let sliderScale = 2.0;
        sketch.trillBar = new TrillBar(sketch, sliderHeight, sliderLength, [sliderXpos, sliderYpos], sliderScale);
				*/
    }; // end setup function

    sketch.draw = function() {
        sketch.background(255, 10); // fading opacity background fun...

        sketch.strokeWeight(2);
        sketch.stroke('black');
        sketch.fill('honeydew');
        sketch.ellipse(300, 600, 500);
    		sketch.textSize(32);
    		sketch.textFont("Helvetica");
	    	sketch.fill(5, 5, 5);
				sketch.text("BANJELA", 10, 32);

        // DEBUGGING in VERBOSE MODE
        if(verbose && (verboseFrameCounter % verboseEvery == 0)) {
    		// console.log() // put slow debug logging here
        }
				verboseFrameCounter += 1;

    		// Draw the audio input signal guis
				sketch.sigMic.updateBuffer(Bela.data.buffers[idxMic]);
				sketch.sigMic.draw();
				sketch.sigPiezo.updateBuffer(Bela.data.buffers[idxPiezo]);
				sketch.sigPiezo.draw();

				// Draw the touch gui
        sketch.strokeWeight(1);

        // TODO: implement resizing if necessary
        //sliderLength = sketch.width-100
        //sketch.trillBar.resize(sliderLength, sliderHeight);
        activeTouches = Bela.data.buffers[idxNumActiveTouches];
        for(let t = 0; t < activeTouches; t++) {
        	sketch.trillCraft.updateTouch(t, Bela.data.buffers[idxTouchLocations][t], Bela.data.buffers[idxTouchSizes][t]);
        }
        sketch.trillCraft.draw();

        sketch.sigString1.updateBuffer(Bela.data.buffers[idxStrings].slice(0,bufSize));
        sketch.sigString2.updateBuffer(Bela.data.buffers[idxStrings].slice(bufSize, (bufSize*2)));
        sketch.sigString3.updateBuffer(Bela.data.buffers[idxStrings].slice((bufSize*2), (bufSize*3)));
        sketch.sigString4.updateBuffer(Bela.data.buffers[idxStrings].slice((bufSize*3), (bufSize*4)));
        sketch.sigString5.updateBuffer(Bela.data.buffers[idxStrings].slice((bufSize*4)));
        sketch.sigString1.draw();
        sketch.sigString2.draw();
        sketch.sigString3.draw();
        sketch.sigString4.draw();
        sketch.sigString5.draw();

				// Draw the MagSense signal guis

				sketch.magSense1.updateBuffer(Bela.data.buffers[idxMag].slice(0,bufSize)); // hack
				sketch.magSense1.feedbackText = Bela.data.buffers[idxMag][0].toFixed(5); //hack
				sketch.magSense2.updateBuffer(Bela.data.buffers[idxMag].slice(bufSize,bufSize*2)); // hack
				sketch.magSense2.feedbackText = Bela.data.buffers[idxMag][bufSize].toFixed(5); //hack
				sketch.magSense3.updateBuffer(Bela.data.buffers[idxMag].slice(bufSize*2)); // hack
				sketch.magSense3.feedbackText = Bela.data.buffers[idxMag][(bufSize*2)].toFixed(5); //hack
				sketch.magSense1.draw();
				sketch.magSense2.draw();
				sketch.magSense3.draw();
    }; // end draw func
}, 'gui');
