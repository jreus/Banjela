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
			this.verbose = true;
			if(this.verbose) {
				console.log("Building trill sensor GUI " + this.dimensions[0] + " x " + this.dimensions[1] + " pos: " + this.position);
			}
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
				this.touches.locations[i] = this.dimensions[0] * location;
				size = this.s.constrain(size, 0, 1);
				this.touches.sizes[i] = size;
				if(this.verbose) {
					console.log("Touch", i, location, size);
				}
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
		// a spec array contains the following [range, length, thickness, position, orientation, invert, touchScale, cornerRadius]
		constructor(sketch, numSegments, segmentSpecs) {
			this.s = sketch;
			this.verbose = true;
			this.numSegments = numSegments;
			this.segments = new Array(numSegments);
			segmentSpecs.forEach((spec, idx) => {
				let newspec = {
					num: idx, range: spec[0], length: spec[1], thickness: spec[2],
					position: spec[3], orientation: spec[4], invert: spec[5], touchScale: spec[6], cornerRadius: spec[7],
				};
				console.log("Built segment", newspec);
				this.segments[idx] = newspec;
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
			let width, height;
			this.segments.forEach((seg, idx) => {
				switch(seg.orientation) {
					case 0: // horizontal
						width = seg.length; height = seg.thickness;
    					break;
					case 1: // vertical
						width = seg.thickness; height = seg.length;
    					break;
					default:
						throw new Error("Invalid Trill segment orientation", seg.orientation);
				} 
				this.s.rect(seg.position[0], seg.position[1], width, height, seg.cornerRadius);
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
					let diameter = seg.thickness * this.touches.sizes[i] * seg.touchScale;
					switch(seg.orientation) {
						case 0: // horizontal
							this.s.ellipse(seg.position[0] + this.touches.locations[i], seg.position[1] + seg.thickness/2, diameter);
							break;
						case 1: // vertical
							this.s.ellipse(seg.position[0] + seg.thickness/2, seg.position[1] + this.touches.locations[i], diameter);
							break;
						default:
							throw new Error("Invalid Trill segment orientation", seg.orientation);
					}
				}
			}
		}

		updateTouch(i, location, size) {
			if(i<5) {
				this.touches.activations[i] = 1;
				location = this.s.constrain(location, 0, 1);
				let segment_num = null;
				for(let k = 0; k < this.segments.length; k++) {
						if(location >= this.segments[k].range[0] && location <= this.segments[k].range[1]) {
							segment_num = k;
							break;
						}
				}
				if(segment_num != null) {
					let seg = this.segments[segment_num];
					let mapped_location = this.s.map(location, seg.range[0], seg.range[1], 0.0, 1.0);
					if(seg.invert) { // invert direction
						this.touches.locations[i] = seg.length * (1.0-mapped_location);
					} else {
						this.touches.locations[i] = seg.length * mapped_location;
					}
					this.touches.segments[i] = segment_num;
					size = this.s.constrain(size, 0, 1);
					this.touches.sizes[i] = size;
				} else {
					this.touches.segments[i] = null; // not displayed on any segment
				}
				if(this.verbose) {
					console.log("Updating touch", i, location, size, segment_num);
					
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
		constructor(sketch, length, thickness, position = [50, 50], orientation = 0, bufferSize = 512, multiplier = 1.0, cornerRadius = 1) {
			this.s = sketch;
			this.position = position;
			this.length = length;
			this.thickness = thickness;
			this.multiplier = multiplier;
			this.orientation = orientation;
			this.feedbackText = "";
			this.bufferSize = bufferSize;
			this.waveformColor = sketch.color(255, 55, 230);
			this.cornerRadius = cornerRadius;
			this.segmentSize = this.length / this.bufferSize;
			if(this.orientation == 0) { // horizontal
				this.xOffset = this.position[0];
				this.yOffset = this.position[1] + (this.thickness / 2);
			} else { // vertical
				this.xOffset = this.position[0] + (this.thickness / 2);
				this.yOffset = this.position[1];
			}
			this.buffer = new Array(bufferSize);
		}

		draw() {
			this.s.fill(20);
			this.s.noStroke();
			switch(this.orientation) {
				case 0: // horizontal
	        		this.s.rect(this.position[0], this.position[1], this.length, this.thickness, this.cornerRadius);
					break;
				case 1: // vertical
	        		this.s.rect(this.position[0], this.position[1], this.thickness, this.length, this.cornerRadius);
					break;
				default:
					throw new Error("Invalid waveform orientation" + this.orientation);
			}

	    	let startX = 0.0, startY = 0.0;
	    	if(this.orientation == 0) { // horizontal
	    		startY = this.buffer[0] * this.multiplier * (this.thickness / 2);
	    	} else { // vertical
	    		startX = this.buffer[0] * this.multiplier * (this.thickness / 2);
	    	}

			this.s.strokeWeight(1);
			this.s.stroke(this.waveformColor);
	        for(let i = 1; i < this.bufferSize; i++) {
				let destX, destY;

				if(this.orientation == 0) { // horizontal
					destX = startX + this.segmentSize;
					destY = this.buffer[i] * this.multiplier * (this.thickness / 2);
				} else {
					destY = startY + this.segmentSize;
					destX = this.buffer[i] * this.multiplier * (this.thickness / 2);
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
			this.s.text(this.feedbackText, this.position[0] + 5, this.position[1] + this.length - 5);

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
        let xpos = 20, ypos = 40;
				let micWidth = 60, micLength = 150;
				let micWaveformScale = 5.0;
				sketch.sigMic = new WaveForm(sketch, micLength, micWidth, [xpos, ypos], 0, bufSize, micWaveformScale, 5);

    		// String waveforms
        let stringsWidth = 180; // width of the entire block of strings
        let stringsLength = 350;
        xpos = 210; ypos = 5;
        let stringGap = 5;
        let s5ratio = 0.6;
        let stringThickness = ((stringsWidth - (stringGap * 4)) / 5);
        let stringWaveformScale = 6.0;
        // 5th string is a bit shorter
        sketch.sigString5 = new WaveForm(sketch, stringsLength * s5ratio, stringThickness, [xpos, ypos + stringsLength * (1-s5ratio)], 1, bufSize, stringWaveformScale, 0);

				// other 4 strings
        sketch.sigString4 = new WaveForm(sketch, stringsLength, stringThickness, [xpos + ((stringThickness + stringGap)*1), ypos], 1, bufSize, stringWaveformScale, 0);
        sketch.sigString3 = new WaveForm(sketch, stringsLength, stringThickness, [xpos + ((stringThickness + stringGap)*2), ypos], 1, bufSize, stringWaveformScale, 0);
        sketch.sigString2 = new WaveForm(sketch, stringsLength, stringThickness, [xpos + ((stringThickness + stringGap)*3), ypos], 1, bufSize, stringWaveformScale, 0);
        sketch.sigString1 = new WaveForm(sketch, stringsLength, stringThickness, [xpos + ((stringThickness + stringGap)*4), ypos], 1, bufSize, stringWaveformScale, 0);
        
        sketch.sigString5.waveformColor = 'olive';
        sketch.sigString4.waveformColor = 'olive';
        sketch.sigString3.waveformColor = 'olive';
        sketch.sigString2.waveformColor = 'olive';
        sketch.sigString1.waveformColor = 'olive';

				// Mag waveforms
        let magXpos = 165;
        let magYpos = ypos + stringsLength + 40;
        let magLength = 100, magThickness = 100;
        let magWaveformScale = 10.00;
        sketch.magSense1 = new WaveForm(sketch, magLength - 35, magThickness - 35, [magXpos - 20, magYpos], 1, bufSize, magWaveformScale, 40);
        sketch.magSense2 = new WaveForm(sketch, magLength, magThickness, [magXpos - 60, magYpos + magThickness - 15], 1, bufSize, magWaveformScale, 50);
		sketch.magSense3 = new WaveForm(sketch, magLength - 30, magThickness - 30, [magXpos + 20, magYpos + magThickness + magThickness], 1, bufSize, magWaveformScale, 40);


    		// Piezo pickup
				let piezoXpos = xpos + 50;
				let piezoYpos = ypos + stringsLength + 80;
				let piezoThickness = 130, piezoLength = 220;
				let piezoWaveformScale = 2.0;
				sketch.sigPiezo = new WaveForm(sketch, piezoLength, piezoThickness, [piezoXpos, piezoYpos], 0, bufSize, piezoWaveformScale, 5);

				// a spec array contains the following [range, length, thickness, position, orientation, invert, touchScale, cornerRadius]
				let segmentSpecs = [
					[[0.015237288162112236, 0.3103448152542114], 150, 15, [165, 200], 1, true, 3.0, 10], // top neck
					[[0.3448275923728943, 0.41379308700561523], 40, 40, [80, 330], 1, false, 3.0, 10], // rim top
					[[0.517241358757019, 0.7241379022598267], 150, 15, [420, 15], 1, false, 3.0, 10], // bottom neck /head end
					[[0.7586206793785095, 0.8620689511299133], 150, 15, [420, 200], 1, false, 3.0, 10], // bottom neck /pot end
					[[0.8965517282485962, 0.931034505367279], 40, 40, [490, 330], 1, false, 3.0, 10], // rim bottom
				];
				
				sketch.trillCraft = new TrillCraft(sketch, 5, segmentSpecs);
				sketch.trillCraft.verbose = false; // turn off console feedback
				//sketch.trillBar = new TrillBar(sketch, 600, 50, [400, 50], 2.0);
    }; // end setup function

    sketch.draw = function() {
        sketch.background(255, 10); // fading opacity background fun...

        sketch.strokeWeight(1);
        sketch.stroke('black');
        sketch.fill('gainsboro');
        sketch.ellipse(300, 500, 400);
    		sketch.textSize(22);
    		sketch.textFont("Helvetica");
	    	sketch.fill(5, 5, 5);
			sketch.text("BANJELA", 20, 30);

        // DEBUGGING in VERBOSE MODE
        if(verbose && (verboseFrameCounter % verboseEvery == 0)) {
    		// console.log() // put slow debug logging here
        }
				verboseFrameCounter += 1;

    		// Draw the audio input signal guis
				sketch.sigMic.updateBuffer(Bela.data.buffers[idxMic]);
				sketch.sigMic.draw();
				sketch.sigMic.feedbackText = "mic";
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
        	//sketch.trillBar.updateTouch(t, Bela.data.buffers[idxTouchLocations][t], Bela.data.buffers[idxTouchSizes][t]);
        }
        sketch.trillCraft.draw();
		 //sketch.trillBar.draw();

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

				sketch.magSense3.updateBuffer(Bela.data.buffers[idxMag].slice(0,bufSize)); // hack
				sketch.magSense3.feedbackText = Bela.data.buffers[idxMag][0].toFixed(5); //hack
				sketch.magSense2.updateBuffer(Bela.data.buffers[idxMag].slice(bufSize,bufSize*2)); // hack
				sketch.magSense2.feedbackText = Bela.data.buffers[idxMag][bufSize].toFixed(5); //hack
				sketch.magSense1.updateBuffer(Bela.data.buffers[idxMag].slice(bufSize*2)); // hack
				sketch.magSense1.feedbackText = Bela.data.buffers[idxMag][(bufSize*2)].toFixed(5); //hack
				sketch.magSense1.draw();
				sketch.magSense2.draw();
				sketch.magSense3.draw();
    }; // end draw func
}, 'gui');
