<img src="./proto_front_02.jpg" width=400>


# Hacking the Five-String Banjo
In the summer of 2019 I was graciously received by Andrew McPherson and the whole Augmented Instruments Lab at C4DM for a series of micro-residencies. I've had a longstanding interest in "old time" American folk music since getting wrapped up in that musical world a lifetime ago when I lived and worked in Northern Florida.

Florida is the state where, the farther north you go, before you know it, you're in The South. A lot of that hands-on, material/social-oriented cultural ethos still sticks with me in the way that I approach digital music. It has always fascinated me the ways in which American folk instruments and music transformed historically through twisting evolutionary paths, geographic enclaves and waypoints, and heterogeneous mixtures of cultural attitudes towards music and instrumentality.

<img src="./banjo_history_monarch_2.jpg" width=500>

The American banjo is a really interesting example of that. It's an instrument that's the result of a confluence of cultures and is representative of a complex history with extremes of deep inequalities based on race and class at one end, and the ambitions of elites and industrialists at the other.

The banjo has a strange and complex relationship to technological innovation as well. During a period in the 19th century there were certain (white) entrepreneurs who, many through a certain idealism and love for the instrument, wanted to... for lack of a better term, "rescue" the banjo from its reputation as a crude and vulgar instrument (a reputation strongly linked to its association with African music). The modern elite of the time connected civilization with the spread and growth of a technologized society. So there was a push by many entrepreneurial luthiers to "civilize" the banjo by adding more machinic refinement. This is the time when the American banjo started morphing from wooden designs to the designs with metal tone rings and tension brackets that you see today.

There are still specialty luthiers out there making "mountain" banjos, which is kind of a catch-all for any kind of banjo-like instrument made from wood or gourd, smaller and varied pot sizes, fretless and fretted, often home-made.

<br>

<img src="./banjo_smithsonian.png" width=4000>


Five-string fretless banjo, src: [National Museum of American History](https://www.si.edu/object/five-string-fretless-banjo:nmah_605678)


<img src="./banjo_history_harpers.jpeg" width=300>
<!-- While some European Americans were working to "civilize" the banjo through technological enhancement, at the same time there was a trend in white America that embraced the "uncivilized" image of the banjo, presenting it as the perfect parlor instrument for the idealized upper class woman; whose whims and emotional storms fit such an "untamed" instrument. -->

-------------------

# Belanjo Banjela


I had started sketching out plans for a prototype electric/programmable mountain banjo a few months before coming to London. I was mainly interested in exploring how to build digital extended techniques that could expand on "stroke" styles. "Stroke" styles are a stringed instrument playing technique where the player strokes down with the back of their fingernails on to a melody string and then pulls up with the thumb on another string (usually tuned as a drone). People often refer to this kind of playing as "frailing" or "clawhammer", but their origins, like the banjo's, are rooted in West African folk instruments like the Akonting of the Jola people (see [Daniel Jatta](https://www.youtube.com/watch?v=lzt0v9roU6g)) and the Gimbri used in Gnawa music (see [Yassir Chadly](https://www.youtube.com/watch?v=WsGgkt2OpSQ)).

---

<img src="./banjo_raw2.jpg" width=500>

I found a lovely little "mountain banjo" kit from the luthier shop [Backyard Music](https://www.backyardmusic.com/banjos.html). I chose the backyard music kit because, unlike most banjos, it doesn't have a drum skin head, but rather a very thin piece of wood that can easily be modified or swapped out for other materials. It also sounds surprisingly good, has a full-size neck, and can handle steel strings without a problem (really important for the magnet-based pickup design I used). Pictured is the bare-bones kit with additional 3D-printed brackets used for holding the whole neck+pot+head assembly together without glue.

---

# Right Hand Technique

<img src="./dana_03.png" width=400>

When I used to work at STEIM in Amsterdam, we would often talk about finding the "core" of your instrument and building an extended practice from there. For stroke-style, the core is the right hand and being in the pocket of its rhythm. These kinds of techniques are sometimes called "knocking", because of the way you knock on the head of the banjo like knocking on a door. It's a more or less constant motion and you don't want to 'break rhythm'.

While in London I teamed up with banjo diva Dana Immanuel, of [Dana Immanuel and the Stolen Band](http://danaimmanuel.com/), to experiment with possibilities for extended right hand techniques.

More skilled banjoists like Dana like to work the right hand at different positions up and down the pot and the neck while playing to vary the timbre and make the banjo stand out when it needs to, or to move emphasis from rhythm to melody.
Appalachian
There is a sweet spot for frailing near the 19th fret of most banjos (sometimes accompanied by a scoop carved into the neck). This is the location of one of the banjo's noisiest natural harmonics, and is used to emphasize the "cluck", a technique where the right hand activates the string harmonics to make a sharp percussive sound when the banjo is serving more of a percussion/rhythm role. As the right hand moves down to the bridge the strings resonate with generally more upper harmonics, creating a more cutting, twanging timbre. Banjoists like Dana like to work this range as they play to vary up tonality and make the banjo stand out more when it needs to, or to move the emphasis from rhythm to melody.

---

# Trill and Magsense

From here it was pretty clear that an old-time knocking banjo player has a good amount of free bandwidth in their right hand that could be built upon.

To do this I leveraged two technologies that were being prototyped at the Augmented Instruments Lab, the touch-sensing Trill and the magnetic-field sensing tech used to sense guitar picking motions in the Magpick.

<figure>
<img src="./MAGSENSE_WAVEFORM.png">
<figcaption>Waveform of a single right-hand stroke captured by the mag sensor.</figcaption>
</figure>

The magpick sensors were integrated into the head of the banjo to track frailing motions and knocking, while custom-made trill touch inlays were positioned at different places along the pot and lower part of the neck to function like extra strings, above the 5th and below the 1st.

<figure>
<img src="./dana_01.png" width=400>
<figcaption>Dana testing potential locations for magsense hot spots and Trill inlays.</figcaption>
</figure>

<figure>
<img src="./proto_magsense.jpg" width=500>
<figcaption>Inside of the pot of a later version of the protoype, with sensor coils on the back of the head.</figcaption>
</figure>

---
# Sketching Trill Inlays

From the first time the Bela team introduced me to Trill I started thinking about making touch-responsive copper inlays for the banjo. I'm a big fan of the inlay work done on 19th century American folk instruments and furniture, and the kinds of ornamentation that was popular during the [American Fancy movement](https://en.wikipedia.org/wiki/American_Fancy). I had an Architect friend who told me once that modernist aesthetics have caused us to collectively forget how to be ornamental. I tend to agree. Let's imagine a digital future for ornamentation.

After designing some paper prototypes, taped to the banjo and testing the ergonomics of these along with Dana, I moved on to making some copper stick-on inlays using a vinyl cutter and copper foil.

I also used the QMUL laser cutter to fashion a new head for the banjo from blue acryllic, featuring some ornamental patterns inspired by the fancy aesthetic.

<img src="./proto_lasercuts.jpg" width=500>

<figure>
<img src="./inlays_vinyl.jpg" width=400><br>
<figcaption>First copper inlays made on the vinyl cutter.</figcaption>
</figure>

To attach the inlays I first transferred the cut foil to a piece of thin acetate using transfer tape. Once on the acetate each inlay segment was (carefully!) soldered to a thin-gauge piece of hookup wire. Finally, the whole thing gets 'sealed' to the acetate using a piece of transparent packing tape. The packing tape layer has the double benefit of both holding the assembly together and providing an extra thin layer of isolation on the copper, which makes the sensor response more linear when you attach it to a Trill craft board.

After cutting out the sensor sandwiches from the acetate sheet they're then attached to the banjo using some double sided tape.

This works for now as a proof of concept and playability. For the future I'm still torn between either designing these as flex sensors and running a ribbon connector down the neck, or milling them out of copper plate and mounting the wires behind each segment. In either case, I'd like to give my router and chisel skills a brush up and set them into the neck.

<br>
<img src="./proto_inlay_02.jpg" width=400>

<img src="./proto_inlay_3.jpg" width=400>

<img src="./proto_inlay_03.jpg" width=400>

---

# Going Electric

Now how about amplifying those strings? One thing I really love about stroke-style playing is the expressive dynamic variation most players put into it. Give a listen to [this recording of Sourwood Mountain](https://www.youtube.com/watch?v=TrOv7qHgo3k) performed by Boone Reid. The dynamics ebb and swell, even on a per-string basis. Contrast this against the much more widely known 3-finger "Scruggs-style" techniques used in bluegrass and a lot of modern jazz-inspired banjo playing. The latter is played using metal fingerpicks and has a punchier, more consistent dynamic level. I feel the Scruggs-like styles have dynamics like a freight train. While stroke style is like a rain storm, more diffuse and temperamental.

At Queen Mary Andrew introduced me to the work of Laurel Pardue, one of the researchers at the AIL and digital instrument luthier par excellence. In her svampolin, a hybrid digital/acoustic violin, she uses a quirky electric pickup system based on Michael Edinger's [StringAmp](https://www.stringamp.com/stringamp/) which has a couple exciting features like per-string amplification and a non-invasive design. Signals are picked up at the tail end of the instrument from the strings and created by placing fixed magnets in close proximity to where each string vibrates. It's a bit like an inversion of the classic electric guitar pickup design.

Getting the pickup system to work was a lot of trial and error, and required a bit of basic lutherie skills to remove some frets and fashion a new tail from a bone blank. For the moment the fixed magnets are embedded into a wooden frame so they can be easily adjusted to different locations. In the future I'm looking to embed them into the neck, as they're currently occupying an inconvenient space where the neck meets the pot - an important spot for the right hand.

<figure>
<a href="./pickup_magnet_placement.m4v">Video: experimenting with magnet placement</a>
<figcaption>Experimenting with signal strength and interference with different magnet placements.</figcaption>
</figure>

<br>

<figure>
<img src="./magnet-frames.jpg" width=300>
<figcaption>Lasercut frames to experiment with non-destructive mounting of different magnet sizes.</figcaption>
</figure>

<br>
<figure>
<img src="./tail_bone_01.jpg" width=300>
inputs
<img src="./tail_bone_neck.jpg" width=300>
<figcaption>Installing a bone tail to replace the conductive fret built into the kit.</figcaption>
</figure>


<br>
<figure>
<img src="./woodwork_tailpiece.jpg" width=300>
<figcaption>Modified hoop-string tail system for picking up signals from the strings.</figcaption>
</figure>

---

---

# What's Inside

Inside the banjo is a Bela mini with analog inputs used to full capacity: five independent signals (one for each string pickup) going into the Bela's first 5 analog inputs, three magpick sensors going into the remaining 3 analog inputs, and the copper inlay sensors wired to a Trill craft, connected to the Bela mini via I2C.

<img src="./proto_back_01.jpg" height=300>

The whole thing is a stand-alone hybrid electronic instrument, powered by an off-the-shelf USB power bank. There's a single stereo 3.5mm headphone jack output that combines the banjo's acoustic signal with reprogrammable DSP and synthesis, written using the SuperCollider music programming language. The banjo can be reprogrammed live, or live coded, if you hook it up to a laptop via USB.

---


# Acoustic Signals: Voice and Pickups

The Bela mini's highest quality audio comes in through the main stereo inputs, which go to a specialty audio codec chip instead of the lower quality ADCs used by the 8 general purpose analog inputs. I reserved these two channels for capturing the acoustic sound of the banjo.

One stereo input is dedicated to a piezo pickup attached to the banjo's head right behind the bridge. This allows for creating a mix between the acoustic sound and electric pickups in software. The second channel of the stereo input is left open to plug in whatever you like - opening up the possibility of feeding instrument signals from other musicians into the banjo for analysis and processing.

I was most interested in using this second input for live sampling and processing of voice. American folk music tradition nearly always involves vocalizing in as many ways as there are individuals. Hollars and work songs are remixed into gospel and blues. What European music calls "untrained" is more a deafness to the connection between music and lived experience. So let's celebrate the voice.

I built a combined preamp circuit (powered by the Bela mini) that provides a high-Z interface for the piezo pickup and also a powered input for electret microphones. For voice work while playing, there are a number of lovely little head-mounted condenser microphones, or you can build your own. I've been using the [t.bone Headmike](https://www.thomann.de/intl/the_tbone_headmike_o_ew.htm), which is a discount model designed to be compatible with Sennheiser "EW" wireless mic systems. Most of these microphones need a bit of power to work ~ the Bela Mini's 3.3V supply is just enough, fed through a 2.2kΩ resistor.

<img src="./INPUT_SCHEMATIC.png" width=500>

---

# Embedded Processing: A Bird's Eye View

That's a lot of signals going in and out of that little Bela mini. Wouldn't it be nice to see what's coming in from the banjo somehow?

Around the time when I was doing my residency the Bela team had just released a new browser-based GUI system. Using the Bela GUI example sketches for the Trill sensor I built out a GUI to keep track of all the incoming signals into the Bela from the Banjo. This meant building a couple new GUI widgets. One widget for the Trill craft, that could be broken up into multiple segments in the configuration I was using it. And a second custom widget to represent real-time audio waveforms - kind of like an oscilloscope.

All in all I had the following that needed to be represented:
* one microphone signal
* one piezo pickup acoustic signal
* five audio signals, one for each of the five strings
* three magpick sensors on the head
* one trill craft broken into five segments  (two long segments on the bottom of the neck, one on the top by the thumb, and two small segments on the pot)

<div style="padding:56.25% 0 0 0;position:relative;"><iframe src="https://player.vimeo.com/video/413710173?byline=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>
<a href="https://vimeo.com/413710173">Banjela GUI Interface demo</a>

---

# Sound Design and Songwriting

<figure>
<img src="./banjer_desk.jpg" width=400>
<figcaption>Songwriting and soundmaking at the C4DM studio</figcaption>
</figure>

For a first attempt at songwriting for this instrument I made a suite of three songs, each exploring different extended techniques. Mapping and sound synthesis in this case was a pretty elaborate process, a bit too much to get into here. Below is the DSP code for one song that shows off a couple key signal processing tactics, like mapping the Trill segments above and below the lower part of the neck to act like additional strings (connected to a string synthesis physical model), and using the magpick sensors on the head of the banjo to control forward/backwards sample playback of percussion instruments.

```
/*
.----------------------------.
|\  /\  /\  /\  /\  /\  /\  /|
| )(  )(  )(  )(  )(  )(  )( |
|(  )(  )(  )(  )(  )(  )(  )|
███╗   ███╗ █████╗  ██████╗  ██████╗ ██╗███████╗     ██████╗ ███╗   ██╗    ████████╗██╗  ██╗███████╗
████╗ ████║██╔══██╗██╔════╝ ██╔════╝ ██║██╔════╝    ██╔═══██╗████╗  ██║    ╚══██╔══╝██║  ██║██╔════╝
██╔████╔██║███████║██║  ███╗██║  ███╗██║█████╗      ██║   ██║██╔██╗ ██║       ██║   ███████║█████╗
██║╚██╔╝██║██╔══██║██║   ██║██║   ██║██║██╔══╝      ██║   ██║██║╚██╗██║       ██║   ██╔══██║██╔══╝
██║ ╚═╝ ██║██║  ██║╚██████╔╝╚██████╔╝██║███████╗    ╚██████╔╝██║ ╚████║       ██║   ██║  ██║███████╗
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝╚══════╝     ╚═════╝ ╚═╝  ╚═══╝       ╚═╝   ╚═╝  ╚═╝╚══════╝
██████╗ ██╗   ██╗███████╗
██╔══██╗██║   ██║██╔════╝
██████╔╝██║   ██║███████╗
██╔══██╗██║   ██║╚════██║
██████╔╝╚██████╔╝███████║
╚═════╝  ╚═════╝ ╚══════╝
╚═════╝  ╚═════╝ ╚══════╝    ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝
    ___    ___     ___     ___     _       ___   __  __    ___
   | _ \  | _ \   / _ \   | _ )   | |     | __| |  \/  |  / __|
   |  _/  |   /  | (_) |  | _ \   | |__   | _|  | |\/| |  \__ \
  _|_|_   |_|_\   \___/   |___/   |____|  |___| |_|__|_|  |___/
_| """ |_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'

    ___    ___     ___     ___     _       ___   __  __    ___
   | _ \  | _ \   / _ \   | _ )   | |     | __| |  \/  |  / __|
   |  _/  |   /  | (_) |  | _ \   | |__   | _|  | |\/| |  \__ \
  _|_|_   |_|_\   \___/   |___/   |____|  |___| |_|__|_|  |___/
_| """ |_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'

    ___    ___     ___     ___     _       ___   __  __    ___
   | _ \  | _ \   / _ \   | _ )   | |     | __| |  \/  |  / __|
   |  _/  |   /  | (_) |  | _ \   | |__   | _|  | |\/| |  \__ \
  _|_|_   |_|_\   \___/   |___/   |____|  |___| |_|__|_|  |___/
_| """ |_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'

F modal tuning >> g C Bb C Eb
*/
(
~jo = {
  var mix, verbmix, insig, s5, strings, stringsmix, thumbsig, slidesig, mag1, mag2, mic;
  var buf1, buf2, buf3, b1frames, b2frames, b3frames, smpl1, smpl2, spos1, spos2, spos3, b3dur, pos3var, graintrig;
  var t_mag1, t_mag2, magmap1, magmap2, mt1, mt2, seq1, seq2;
  var centroids, t_bottom, t_top, t_necktop, t_slide, mode = 0, t1, t2, t3;

  var nastynoise_hz = 230, noise_co_hz = 7000; // magic numbers
  mic = In.ar(2, 1) * 2.0;
  mag1 = In.ar(6,1);
  mag2 = In.ar(7,1);

  // STRINGS INPUT
	s5 = In.ar(4,1);
	strings = In.ar(5,1);
	s5 = SVF.ar(s5, nastynoise_hz*1, 0.01 ,0,0,0,1,0);
	strings = SVF.ar(strings, nastynoise_hz*1, 0.01 ,0,0,0,1,0);

	// pull out the good signal, get rid of digital noise
	s5 = Compander.ar(s5, s5, 0.02, 4.0, 1.0, 0.05, 0.01, mul: 15.0);
	strings = Compander.ar(strings, strings, 0.02, 2.5, 1.0, 0.01, 0.01, mul: 80.0);


  // TRILL INPUT
  centroids = TrillCentroids.kr(1, 0x18, 60, 1);

  // MODE TOGGLE: 0.4-0.44 bottom segment bounds
  t_bottom = (centroids[1] >= ~ranges[\bottom][0]) * (centroids[1] <= ~ranges[\bottom][1]);
  mode = Stepper.kr(t_bottom,0,0,1);
  //t_bottom.poll(1);

  // SIXTH STRING ON NECK TOPSIDE
  // for the 0.0 segment you need an extra test that there is indeed a touch recognized, because all touches default to 0!
  t_necktop = (centroids[2] > 10) * (centroids[1] >= ~ranges[\necktop][0]) * (centroids[1] <= ~ranges[\necktop][1]);
  t2 = [Gate.kr(centroids[1], t_necktop), centroids[2]];// pos, size
  thumbsig = Resonz.ar(Pluck.ar(PinkNoise.ar, Changed.kr(t_necktop), 0.2, t2[0].linexp(0.0, 0.36, 50, 1000).reciprocal, 15.8, 0.8, mul: 6.0), [60, 300,2200], 0.1, 10.0).sum.clip; // mode0

  // SAMPLE DRAG ON AND PULL ON THE SLIDE SENSOR
  buf3 = ~bufs["Chinga_0122"];
  b3frames = BufFrames.kr(buf3);
  t_slide = (centroids[2] > 10) * (centroids[1] >= ~ranges[\slide][0]) * (centroids[1] <= ~ranges[\slide][1]);
  t3 = Gate.kr([centroids[1], centroids[2]], t_slide); // pos, size
  spos3 = t3[0].linlin(~ranges[\slide][0], ~ranges[\slide][1], 0, BufFrames.kr(buf3));
  spos3 = Lag.ar(K2A.ar(spos3), 4.0);
  slidesig = BufRd.ar(1, buf3, spos3, 0.0);
  //slidesig = AllpassC.ar(slidesig, 0.5, 0.3, 2.0) + slidesig;


  // mag signals
  mag1 = Lag2.ar(mag1, 0.1);
  mag1 = mag1.linlin(-0.002, 0.002, -1.0, 1.0);

  mag2 = Lag2.ar(mag2, 0.1);
  mag2 = mag2.linlin(-0.002, 0.002, -1.0, 1.0);

  buf1 = ~bufs["Chinga_002"];
  buf2 = ~bufs["JapaDrum1_13"];
  b1frames = BufFrames.kr(buf1);
  b2frames = BufFrames.kr(buf2);


  // magsense trigger thresholds
  mt1 = 0.4;
  mt2 = 0.4;
  t_mag1 = Trig1.kr(mag1.abs > mt1, 0.1);
  t_mag2 = Trig1.kr(mag2.abs > mt2, 0.1);
  magmap1 = mag1.abs.explin(mt1, 1, 0.2, 0.05); // map to sample playback speed on approach
  magmap2 = mag2.abs.explin(mt2, 1, 0.2, 0.05);

  seq1 = (1..10) / 10.0; // drum pitches
  seq1 = Select.kr(Stepper.kr(t_mag1, 0, 0, 10), seq1);
  // chinga
  spos1 = EnvGen.ar(Env.new([0, 0, 1], [magmap1, seq1], \lin), t_mag1, b1frames, 0, BufDur.kr(buf1));

  // japanese drum
  spos2 = EnvGen.ar(Env.new([0, 0, 1], [magmap2, 1.0], \lin), t_mag2, b2frames, 0, BufDur.kr(buf2));

  smpl1 = BufRd.ar(1, buf1, spos1, 0.0, 2);
  smpl2 = BufRd.ar(1, buf2, spos2, 0.0, 2);

	// *STRING SIGNAL POST PRODUCTION* output processing
	strings = Compander.ar(strings, strings, 0.2, 1.3, 0.3, 0.1, 0.1, mul: 5.0);
	//s5 = s5 + AllpassC.ar(s5, 0.2, 0.01, 3.0);
	//stringsmix = AllpassC.ar(s5+strings, 0.2, 0.01, 1.0) + strings + s5;
	//stringsmix = BPeakEQ.ar(stringsmix, 1200, 0.3, 6);
	stringsmix = (s5 * 1.0) + (strings * 1.0);
	stringsmix = FreeVerb.ar(stringsmix, 0.2, 0.5, 0.5);
	verbmix = thumbsig + slidesig + smpl1 + smpl2;
	verbmix = GVerb.ar(verbmix, 65, 3, 0.2, 0.2, 5, 1.0, 1.0, 0.4) * 2.0;

	mix = (stringsmix * 1.0) + (verbmix * 0.5);
	mix = Limiter.ar(LeakDC.ar(mix * 1.0), 1.0, 0.001);
	mix;
}.play(s, outbus: 0);

);
```

---

<img src="./AmmyPhull-IKLECTIK.JPG" width=400>

---

Made with the support of a development grant from the <a href="https://stimuleringsfonds.nl/en/">Dutch Creative Industries Fund</a>
<a href="https://stimuleringsfonds.nl/en/"><img src="sci_logo.jpg" height=100></a>


# Bio

Jonathan Reus is a Dutch-American composer-researcher, born in Manhattan NY and thereafter raised in Amsterdam and then Florida, where he became involved in the American folk-art scene. Years later he moved to the Netherlands where he worked at the adventurous performance-technology lab [STEIM](https://en.wikipedia.org/wiki/STEIM), developing a uniquely intimate practice cutting across the disciplines of music, performance art, science and digital culture. His work uses collages of technologies past and present to reflect the simultaneous times and histories we inhabit.

He has received commissions as a composer, performer and installation artist by Slagwerk Den Haag, Stedelijk Museum Amsterdam, Club Guy & Roni and Asko-Schönberg ensemble. Most recently he composed the music for and built a large-scale tape machine instrument for the nationally-touring production Brave New World 2.0, based on Aldous Huxley's dystopian novel. 

In addition to his artistic work, Jonathan has tirelessly demonstrated his support for local, bottom-up artistic initiatives and novel artist-education formats through curation and community organization. Since 2013 he has worked as a founding member of the non-profit cultural initiative [iii](https://instrumentinventors.org/) in The Hague. From 2015-2019 he organized and curated [The Reading Room](https://platformtm.tumblr.com/), at STROOM Den Haag. In 2017 he organized the first Berlin-based Algorave at transmediale festival, along with the performance program The Instrumental Subconscious, showcasing experimental musicians working with self-made instruments. And in 2016 he helped to design the Digital Media bachelors program at Leuphana University's Center for Digital Cultures, where he won the teaching prize for cross-disciplinary education for his courses on computational literacy through sound and body.

Besides his artistic and educational work, Jonathan is an experienced researcher in the field of electronic music instruments and sonic interaction design. He recieved the W. J. Fulbright fellowship for his work in the research of new digital instruments for music. He has also lectured on the topic of performative sound and technological mediation at academies of art and design, music conservatories and universities.

https://jonathanreus.com/

---
