/***** Banjo Dashboard GUI *****/

//**************************************************************************************
// GUI CLASSES
//**************************************************************************************
//**************************************************************************************
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


if(typeof WaveForm === "undefined") {
	WaveForm = class {
		// orientation: 0 (horizontal), 1 (vertical)
		constructor(sketch, length, height, position = [50, 50], orientation = 0, bufferSize = 512, amplitudeScale = 1.0) {
			this.s = sketch;
			this.position = position;
			this.dimensions = [ length, height ];
			this.amplitudeScale = amplitudeScale;
			this.orientation = orientation;
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
	    		startY = this.buffer[0] * this.amplitudeScale * (this.dimensions[1] / 2);
	    	} else { // vertical
	    		startX = this.buffer[0] * this.amplitudeScale * (this.dimensions[0] / 2);
	    	}
	    	
			this.s.strokeWeight(1);
			this.s.stroke(255, 55, 230);
	        for(let i = 1; i < this.bufferSize; i++) {
				let destX, destY;
				
				if(this.orientation == 0) {
					destX = startX + this.segmentSize;
					destY = this.buffer[i] * this.amplitudeScale * (this.dimensions[1] / 2);
				} else {
					destY = startY + this.segmentSize;
					destX = this.buffer[i] * this.amplitudeScale * (this.dimensions[0] / 2);
				}
				
				this.s.line(
					startX + this.xOffset, 
					startY + this.yOffset, 
					destX + this.xOffset, 
					destY + this.yOffset
				);
				startX = destX; startY = destY;
	        }
	        
	        this.verboseFrameCounter += 1;
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








// MAIN APP
var guiSketch = new p5(function( sketch ) {

    let canvas_dimensions = [sketch.windowWidth, sketch.windowHeight];

	let verbose = true; // set true to get console feedback
	let verboseEvery = 30; // print feedback every 30 frames
	let verboseFrameCounter = 0;

	// TOUCH GUI
    let spacing;
    let activeTouches = 0;
    let sliderLength = 0.0;
    let sliderHeight = 0.0;
    let touchSizeScale = 1.25;

	// MAG SENSE GUI

	// AUDIO SIGNAL GUI

    sketch.setup = function() {
        sketch.createCanvas(canvas_dimensions[0], canvas_dimensions[1]);
        //sketch.frameRate(120);
        sketch.frameRate(30);
        sliderLength = sketch.width-100;
        sliderHeight = 60.0;
        console.log("Slider Length: " + sliderLength);
        sketch.trillBar = new TrillBar(sketch, sliderLength*0.60, sliderHeight, [10,10], 1.25);
        
        let stringsXpos = 450;
        let stringsYpos = 80;
        let stringsWidth = 80;
        let bufSize = 512;
        let stringsLength = bufSize;
        let ampScale = 10.0;
        sketch.sigString5 = new WaveForm(sketch, stringsWidth, stringsLength, [stringsXpos, stringsYpos], 1, bufSize, ampScale);
        sketch.sigString4 = new WaveForm(sketch, stringsWidth, stringsLength, [stringsXpos + 110, stringsYpos], 1, bufSize, ampScale);
        sketch.sigString3 = new WaveForm(sketch, stringsWidth, stringsLength, [stringsXpos + 220, stringsYpos], 1, bufSize, ampScale);
        sketch.sigString2 = new WaveForm(sketch, stringsWidth, stringsLength, [stringsXpos + 330, stringsYpos], 1, bufSize, ampScale);
        sketch.sigString1 = new WaveForm(sketch, stringsWidth, stringsLength, [stringsXpos + 440, stringsYpos], 1, bufSize, ampScale);
        
        let magYpos = 80;
        let magXpos = 10;
        let magWidth = 100;
        let magLength = 400;
        sketch.magSense1 = new WaveForm(sketch, magLength, magWidth, [magXpos, magYpos], 0, bufSize, ampScale);
        sketch.magSense2 = new WaveForm(sketch, magLength, magWidth, [magXpos, magYpos + 110], 0, bufSize, ampScale);
        
    };

    sketch.draw = function() {
        
        // Draw a white background with opacity
        sketch.background(255, 10);
        
        // Retreive the data being sent from render.cpp

		// Indexes of data buffers coming from the Bela over websockets
        let idxNumActiveTouches = 0, idxTouchLocations = 1, idxTouchSizes = 2;
        let idxString1 = 3, idxString2 = 4, idxString3 = 5, idxString4 = 6, idxString5 = 7;
        let idxMag1 = 8, idxMag2 = 9;
        //console.log(sine);
    	let sine = Bela.data.buffers[idxString1][0];
        
    
    
    	/*
    	
        // Draw a circle whose size changes with the value received from render.cpp
        sketch.noFill();
        sketch.strokeWeight(10);
        sketch.ellipse(sketch.windowWidth / 2, sketch.windowHeight / 2, (sketch.windowHeight-100)*sine, (sketch.windowHeight-100)*sine);
        
        // Draw a circle on the left hand side whose position changes with the values received from render.cpp
        sketch.ellipse(100, sketch.windowHeight/2 + (((sketch.windowHeight/2)-100)*sine), 50, 50);
        // Draw the zero crossing line
        sketch.line(50,sketch.windowHeight/2,150,sketch.windowHeight/2);

		*/

		// Draw the touch gui
        sketch.strokeWeight(1);
        sliderLength = sketch.width-100
        sketch.trillBar.resize(sliderLength, sliderHeight);
        activeTouches = Bela.data.buffers[idxNumActiveTouches];
        for(let t = 0; t < activeTouches; t++) {
        	sketch.trillBar.updateTouch(t, Bela.data.buffers[idxTouchLocations][t], Bela.data.buffers[idxTouchSizes][t]);
        }
        sketch.trillBar.draw();
        
        // Draw the audio signal guis
        sketch.sigString1.updateBuffer(Bela.data.buffers[idxString1]);
        sketch.sigString2.updateBuffer(Bela.data.buffers[idxString2]);
        sketch.sigString3.updateBuffer(Bela.data.buffers[idxString3]);
        sketch.sigString4.updateBuffer(Bela.data.buffers[idxString4]);
        sketch.sigString5.updateBuffer(Bela.data.buffers[idxString5]);
        
        sketch.sigString1.draw();
        sketch.sigString2.draw();
        sketch.sigString3.draw();
        sketch.sigString4.draw();
        sketch.sigString5.draw();
        
        if(verbose && (verboseFrameCounter % verboseEvery == 0)) {
        	console.log("S1 Segment: " + sketch.sigString1.segmentSize);
        	console.log("S1 Buffer: " + sketch.sigString1.buffer);
        }
        
		// Draw the MagSense signal guis
		sketch.magSense1.updateBuffer(Bela.data.buffers[idxMag1]);
		sketch.magSense1.draw();
		sketch.magSense2.updateBuffer(Bela.data.buffers[idxMag2]);
		sketch.magSense2.draw();

		verboseFrameCounter += 1;

    };
    
}, 'gui');