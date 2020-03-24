# Making Music with Metal and Trill Craft






![Tailpiece](woodwork_tailpiece.jpg)

![Magnet Frames](magnet-frames.jpg)

![Prototype Front](proto_front_02.jpg)

![Prototype Electronics](proto_back_02.jpg)

![A clawhammer ergonomics lesson from Dana Immanuel](dana_03.png)
[Dana Immanuel and the Stolen Band](http://danaimmanuel.com/)

![Vinyl Cut Inlays](inlays_vinyl.jpg)


![Programming Bela GUI interface in the Studio at C4DM](banjer_desk.jpg)

![Performance IKLECTIK](AmmyPhull-IKLECTIK.JPG)

-------------------
In the summer of 2019 I began a series of micro-residencies at the Augmented Instruments Lab at C4DM. Drawing on a longstanding interest in American folk music histories and the ways in which American folk instruments and music transformed historically through twisting evolutionary paths. Oral histories and the embodied histories of playing and performing - tacit histories.

Recently I've been exploring forms of storytelling through music, technology and language. This is partly where the interest in social and cultural histories within US folk music traditions stems. How do the instruments of folk tradition relate to memory, myth and spirituality? What kind of technological ecology do they engender? And what narrative do they propose around the question concerning technology?

# Augmenting an Appalachian Banjo

For my weeks at C4DM I had focused on building augmentations on an appalachian mountain banjo. To start with I acquired a banjo kit from the luthier shop [Backyard Music](https://www.backyardmusic.com/banjos.html). These banjo kits are especially nice for prototyping because of their all-wood construction and absence of a drum skin-head. They also sound surprisingly good.

At the time I started my intention was to explore the potential for embedding sensor inlays into areas of the banjo that would support the family of "old time", stroke styles whose roots lie in the West African instrument makers/players who were brought to the American South as slaves. Some of these original instrument traditions still exist (thankfully) ~ e.g. in the akonting of the Jola people (see [Daniel Jatta](https://www.youtube.com/watch?v=lzt0v9roU6g)).

It's a very specific way of playing a stringed instrument whereby the player strokes down with the back of their fingernails on to a melody string and then pulls up with the thumb on another string (usually tuned as a drone).

In addition to examining the mechanics of right-hand stroke-style playing techniques. I was also looking to electrify the vibrations from each of the strings. Stroke style banjo playing is notable for the amount of dynamic play that happens on a per string basis.

One lovely thing about a lot of stroke-style playing is the very expressive dynamic variation most players put into it. Give a listen to [this recording of Sourwood Mountain](https://www.youtube.com/watch?v=TrOv7qHgo3k) performed by Boone Reid. The dynamics ebb and swell, even on a per-string basis. Contrast this against the much more widely known 3-finger "bluegrass" style, played using fingerpicks, which has a much punchier, more consistent dynamic level. You could say 3-finger style has the dynamics of a freight train. While stroke style is more like a rain storm.

In electrifying the banjo I was looking for a way of getting independent signals for each string so as to be able to take advantage of this dynamic control, and use it for triggering electronic sounds on a per-string basis. 

The first output of this project is an anthropological and hands-on exploration of the Appalachian mountain banjo. At Queen Mary I have used their facilities to build a hyper-banjo fitted with new sensor technologies currently under development at the lab. Through this project I have received one-on-one assistance from Andrew McPherson, leader of the AIL, and have interviewed a number of virtuoso folk instrumentalists, working with them to understand the individual relationship they have to playing techniques and the context of the instruments themselves.

Besides providing the opportunity to create new networks in the UK and London music technology community, this residency has opened up new directions for my own work as a composer, instrumentalist, performer and instrument designer. After a successful debut performance of the hyper-banjo at IKLECTIK Art Lab, Andrew has offered to continue our collaboration into 2020. We are also in discussion about bringing some of the London music technology community here to the Netherlands for performances and workshops.


The sonic circuit sculpture creatures featured in this post are a series of interactive sound art installations. The creatures were made by [Helen Leigh](https://twitter.com/helenleigh) in collaboration with sound designer and composer [Andrew Hockey](https://www.andrewhockey.com/). The videos below demonstrate two of the creatures: one a synthy bass creature with two modes of modulation and the other a harp-like melodic creature.

# Bass Circuit Sculpture Creature

{% include youtube.html youtube="J-wa163c2Vw" %}

This creature has a pitch range of one octave, is tuned to C minor and the rightmost limbs trigger two effects: a tremolo and a delay. It is made of brass, solder and paper, and is powered by a [Bela Mini](https://shop.bela.io/bela-mini) and [PocketBeagle](https://beagleboard.org/pocket).

{% include youtube.html youtube="LM3rKevSr5M" %}


# Harp Circuit Sculpture Creature

{% include youtube.html youtube="sqhyhH7Hu3Y" %}

This creature is tuned to C harmonic minor and has a three octave range from left to right. It is made of steel wire, solder and paper, and is powered by a [Bela cape](https://shop.bela.io/bela) and [BeagleBone Black](https://beagleboard.org/black).

{% include single-image.html fileName="helen/harp close.JPG" %}

# Working with Trill Craft

At the core of each sculpture is the new Trill Craft sensor that is available as part of the [Trill Kickstarter Campaign](https://www.kickstarter.com/projects/423153472/trill-touch-sensing-for-makers).

{% include single-image.html fileName="trill/craft_specs-01.png" %}

Trill Craft is a 30-channel capacitive sensing breakout board that lets you make your own touch interfaces out of anything conductive. In this case it is used to identify when contact is made with the metal rods attached to the board. Trill Craft is then connected to the Bela cape on top of a BeagleBone which make it quick and easy to get the readings from the sensor producing sound.

{% include single-image.html fileName="helen/black-bread-board.jpg" %}

The code that powers both instruments was written in [Pure Data](https://blog.bela.io/2019/03/06/pure-data-and-bela/) and runs via the Bela browser-based IDE. The Pure Data patch receives a reading from the Trill Craft capacitive sensor and then triggers the playback of a sample when the reading on each channel passes a certain threshold. This is similar to one of the default examples that comes with Bela which you can explore on the [Trill github repository](https://github.com/BelaPlatform/Trill/tree/master/examples/Bela/Trill_sample_trigger_pd).

{% include single-image.html fileName="helen/pd-thresholding.png" %}

# About Helen Leigh

Helen Leigh is a hacker, writer, musician, presenter, educator, artist & self-professed nerd. She is the author of [The Crafty Kid’s Guide to DIY Electronics](https://www.amazon.co.uk/gp/product/1260142833?pf_rd_p=330fbd82-d4fe-42e5-9c16-d4b886747c64&pf_rd_r=HV3QWBMFBTVC3XE58Y1W) and the creator of the [MINI·MU glove](https://doitkits.com/portfolio-item/minimuglove/).

{% include single-image.html fileName="helen/harp creature prototyping.jpg" %}

# Visit Trill on Kickstarter

The Trill touch sensors are now [live on Kickstarter](https://www.kickstarter.com/projects/423153472/trill-touch-sensing-for-makers)! This new family of sensors from Bela bring precise and easy-to-use touch interaction to your digital projects.

{% include youtube.html youtube="xzaf2bBKuQI" %}

<div style="text-align: center; margin-bottom: 10px;"><a href="https://www.kickstarter.com/projects/423153472/trill-touch-sensing-for-makers" name="Trill on Kickstarter"><button name="button" style="font-size: larger; font-weight: bold; cursor: pointer; color: #ffffff; padding: 30px; background-color: #00bea4; border-radius: 15px; border: 4px #00bea4;">See our Rewards on Kickstarter</button></a></div>

The campaign runs until 5pm 18th October so don't miss your chance to get your hands on this new family of touch sensors for makers. See you on Kickstarter and stay tuned for updates!
