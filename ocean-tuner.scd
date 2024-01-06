//
// Ocean Tuner for Worlds in Play playtest
// January 6 2024 - ASU MIX Center
// roberttwomey.com

// File.getcwd
// thisProcess.nowExecutingPath.dirname.asString
// this.class.filenameSymbol.asString.dirname


(
var w, rateaslide, ratebslide, ampslide, fadeslide, panslide, a, c, v, intbuff, ratecslide, enablec, healthysounds, noisesounds, interruption, menua, menub, menuc, fnames, maxv;

maxv = 10;

// ==== Define synths and load buffers ====

z = thisProcess.nowExecutingPath.dirname.asString;

// list healthy sounds
v = PathName.new(thisProcess.nowExecutingPath.dirname.asString+/+"sounds/healthy").files;
healthysounds= [];
v.do( {|i| i.fileName.asString.postln; healthysounds = healthysounds.add(i.fileName.asString)});
// healthysounds.postln;

// list noise sounds
v = PathName.new(thisProcess.nowExecutingPath.dirname.asString+/+"sounds/pollution").files;
noisesounds= [];
v.do( {|i| i.fileName.asString.postln; noisesounds = noisesounds.add(i.fileName.asString)});
// noisesounds.postln;

// interruption
v = PathName.new(thisProcess.nowExecutingPath.dirname.asString+/+"sounds/interruption").files;
interruption = [];
v.do( {|i| i.fileName.asString.postln; interruption = interruption.add(i.fileName.asString)});


// load starting sounds
b = Buffer.read(s,z+/+"sounds/healthy/LJsiteB-20150529-072919-singlegrunt-filtered.wav"); //store handle to Buffer in global
d = Buffer.read(s,z+/+"sounds/pollution/airplane.mp3"); //bleached reef for noise
intbuff = Buffer.read(s, z+/+"sounds/interruption/blue-whale.mp3"); // interruption

SynthDef("tuner", { arg out=0, fade=0, amp=0, pan=0, ratea = 1, buffnuma, rateb = 1, buffnumb, ratec=1, buffnumc, enablec=0;
	var a, rate = 1.0, trigger = 1, startPos = 0, loop = 1;

	// add noise sample
	a = a.add(
		PlayBuf.ar(1,buffnumb, BufRateScale.kr(buffnumb)*rateb, trigger, BufFrames.ir(buffnumb)*startPos, loop));

	// add environment sample
	a =  a.add(
		PlayBuf.ar(1,buffnuma, BufRateScale.kr(buffnuma)*ratea, trigger, BufFrames.ir(buffnuma)*startPos, loop));

	// add interruption sample
	a = a.add(
		PlayBuf.ar(1,buffnumc, BufRateScale.kr(buffnumc)*ratec, trigger, BufFrames.ir(buffnumc)*startPos, loop)*enablec);

	// cross-fade and pan
	Out.ar(out,
		Pan2.ar(
			SelectX.ar(fade*3, a),
			pan)*0.5*amp;
	);
}).add;

c=Synth(\tuner, [\out, 0, \fade, 0.5, \amp, 0.5, \pan, 0, \ratea, 1.0, \buffnuma, b.bufnum, \rateb, 1, \buffnumb, d.bufnum, \ratec, 1, \buffnumc, intbuff.bufnum, \enablec, 0]);

// ==== Create GUI and launch ====

w=Window("Ocean Tuner",Rect(10,200,300,600));
w.alwaysOnTop=true;
// w.front;

w.view.decorator= FlowLayout(w.view.bounds);

// healthy ocean sounds - SIGNAL
menua = PopUpMenu(w, Rect(10, 10, 200, 20)).items_(healthysounds);
menua.action = { arg menu;
	b = Buffer.read(s,z+/+"sounds/healthy"+/+menu.item); //store handle to Buffer in global
	c.set(\buffnuma, b.bufnum);
};
// menua.valueAction_(healthysounds.size.rand);

rateaslide= EZSlider(w, 250@24, "RateA", ControlSpec(0.1, 3, 'exponential', 0.01), {|ez| c.set(\ratea,ez.value)}, 1);


// other ocean sounds - NOISE
menub = PopUpMenu(w, Rect(10, 10, 200, 20)).items_(noisesounds);
menub.action = { arg menu;
	d = Buffer.read(s,z+/+"sounds/pollution"+/+menu.item); //store handle to Buffer in global
	c.set(\buffnumb, d.bufnum);
};
menub.valueAction_(noisesounds.size.rand);

ratebslide= EZSlider(w, 250@24, "RateB", ControlSpec(0.1, 3, 'exponential', 0.01), {|ez| c.set(\rateb,ez.value)}, 1);

// OVERALL CONTROLS
fadeslide= EZSlider(w, 250@24, "Noise", ControlSpec(0, 1, 'lin', 0.01), {|ez| c.set(\fade,ez.value)}, 1);
ampslide= EZSlider(w, 250@24, "Volume", ControlSpec(0.01, maxv, 'exponential', 0.01), {|ez| c.set(\amp,ez.value)}, 1);
panslide= EZSlider(w, 250@24, "Pan", ControlSpec(-1, 1, 'lin', 0.01), {|ez| c.set(\pan,ez.value)}, 0);

w.onClose_({a.free; d.free; c.free});

// 2d slider
t = Slider2D(w, Rect(0, 0, 292, 292))
.y_(0.5)
.x_(0.5)
.background_(Color.new255(0, 153, 254).vary) //Color.rand)
.knobColor_(Color.new255(0, 0, 204).vary)
.action_({|sl|
	c.set(\amp,sl.y);
	c.set(\fade, sl.x);
	ampslide.valueAction = sl.y*maxv;
	fadeslide.valueAction = sl.x;
});


// interruption sounds
menuc = PopUpMenu(w, Rect(10, 10, 200, 20)).items_(interruption);
menuc.action = { arg menu;
	intbuff = Buffer.read(s,z+/+"sounds/interruption/"+/+menu.item); //store handle to Buffer in global
	c.set(\buffnumc, intbuff.bufnum);
};
menub.valueAction_(interruption.size.rand);

ratecslide= EZSlider(w, 250@24, "RateC", ControlSpec(0.1, 3, 'exponential', 0.01), {|ez| c.set(\ratec,ez.value)}, 1);

enablec = EZSlider(w, 250@24, "Interrupt", ControlSpec(0, 1, 'lin', 1), {|ez| c.set(\enablec,ez.value)}, 0);

w.front;
)