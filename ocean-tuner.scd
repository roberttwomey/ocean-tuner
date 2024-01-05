//
// Ocean Tuner for Worlds in Play playtest
// January 6 2024 - ASU MIX Center
// roberttwomey.com

// File.getcwd
// thisProcess.nowExecutingPath.dirname.asString
// this.class.filenameSymbol.asString.dirname

// Define synths and load buffers
(
z = thisProcess.nowExecutingPath.dirname.asString;

// load two starting sounds
b = Buffer.read(s,z+/+"sounds/LJsiteB-20150529-072919-singlegrunt-filtered.wav"); //store handle to Buffer in global
d = Buffer.read(s,z+/+"sounds/barrier-reef-bleach.wav"); //bleached reef for noise


SynthDef("tuner", { arg out=0, fade=0, amp=0, pan=0, ratea = 1, buffnuma, rateb = 1, buffnumb;
	var a, rate = 1.0, trigger = 1, startPos = 0, loop = 1;

	// add foreground sample
	a =  a.add(
		PlayBuf.ar(1,buffnuma, BufRateScale.kr(buffnuma)*ratea, trigger, BufFrames.ir(buffnuma)*startPos, loop));

	// add background sample
	a = a.add(
		PlayBuf.ar(1,buffnumb, BufRateScale.kr(buffnumb)*rateb, trigger, BufFrames.ir(buffnumb)*startPos, loop));

	// cross-fade and pan
	Out.ar(out,
		Pan2.ar(
			SelectX.ar(fade*2, a),
			pan)*0.5*amp;
	);
}).add;

)

b.inspect
c.inspect

// Create GUI and launch
(
var w, rateslide, ampslide, fadeslide, panslide, a, c, v, menu, fnames;

// playbuf
// a=Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);
// n=Synth(\playbuf, [\out, 0, \bufnum, d.bufnum]);


c=Synth(\tuner, [\out, 0, \fade, 0.5, \amp, 0.5, \pan, 0, \ratea, 1.0, \buffnuma, b.bufnum, \rateb, 1, \buffnumb, d.bufnum]);

w=Window("Ocean Tuner",Rect(10,200,300,450));
w.front;

w.view.decorator= FlowLayout(w.view.bounds);

v = PathName.new(thisProcess.nowExecutingPath.dirname.asString+/+"sounds/").files.scramble.copyFromStart(20);

fnames = [];
v.do( {|i| i.fileName.asString.postln; fnames = fnames.add(i.fileName.asString)});
fnames.postln;
menu = PopUpMenu(w, Rect(10, 10, 200, 20)).items_(fnames);
menu.action = { arg menu;
	[menu.value, menu.item].postln;
	// b = Buffer.read(s,"/Volumes/Work/Projects/birch-aquarium/sounds/"+/+menu.item); //store handle to Buffer in global
	b = Buffer.read(s,z+/+"sounds/"+/+menu.item); //store handle to Buffer in global
	c.set(\buffnuma, b.bufnum);

};

rateslide= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| c.set(\ratea,ez.value)}, 1);
w.onClose_({a.free; c.free;});
fadeslide= EZSlider(w, 250@24, "Static", ControlSpec(0, 1, 'lin', 0.05), {|ez| c.set(\fade,ez.value)}, 1);
ampslide= EZSlider(w, 250@24, "Volume", ControlSpec(0.01, 5, 'exponential', 0.01), {|ez| c.set(\amp,ez.value)}, 1);
panslide= EZSlider(w, 250@24, "Pan", ControlSpec(-1, 1, 'lin', 0.05), {|ez| c.set(\pan,ez.value)}, 0);

w.onClose_({a.free; d.free; c.free});

// 2d slider
t = Slider2D(w, Rect(0, 0, 292, 292))
.y_(0.5)
.x_(0.5)
.background_(Color.rand)
.knobColor_(Color.rand)
.action_({|sl|
	c.set(\amp,sl.y);
	c.set(\fade, sl.x);
	ampslide.valueAction = sl.y*5;
	fadeslide.valueAction = sl.x;
});

w.front;
)