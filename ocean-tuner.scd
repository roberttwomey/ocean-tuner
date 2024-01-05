

// sampler https://schollz.com/tinker/sampler/

File.getcwd
thisProcess.nowExecutingPath.dirname.asString

this.class.filenameSymbol.asString.dirname

(

z = thisProcess.nowExecutingPath.dirname.asString;


//this loads into a buffer the default sound that comes with SuperCollider
//.read brings in the whole sound at once
b = Buffer.read(s,z+/+"sounds/LJsiteB-20150529-072919-singlegrunt-filtered.wav"); //store handle to Buffer in global

d = Buffer.read(s,z+/+"sounds/barrier-reef-bleach.wav"); //bleached reef for noise


/*SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1;
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop),0.0)
	)
}).add;*/


SynthDef("tuner", { arg out=0, fade=0, amp=0, pan=0, ratea = 1, buffnuma, rateb = 1, buffnumb;
	var a, rate = 1.0, trigger = 1, startPos = 0, loop = 1;

/*	// add sample a
	a =  a.add(
		Pan2.ar(PlayBuf.ar(1,buffnuma, BufRateScale.kr(buffnuma)*rate, trigger, BufFrames.ir(buffnuma)*startPos, loop), 0.0));

	// sample b
	a = a.add(
		Pan2.ar(PlayBuf.ar(1,buffnumb, BufRateScale.kr(buffnumb)*rate, trigger, BufFrames.ir(buffnumb)*startPos, loop), 0.0));*/

		// add sample a
	a =  a.add(
		PlayBuf.ar(1,buffnuma, BufRateScale.kr(buffnuma)*ratea, trigger, BufFrames.ir(buffnuma)*startPos, loop));

	// sample b
	a = a.add(
		PlayBuf.ar(1,buffnumb, BufRateScale.kr(buffnumb)*rateb, trigger, BufFrames.ir(buffnumb)*startPos, loop));

	Out.ar(out,
		Pan2.ar(
			SelectX.ar(fade*2, a),
		pan)*0.5*amp;
	);

/*	Out.ar(out,
		Pan2.ar(
			SelectX.ar(fade*2, [SinOsc.ar(440), SinOsc.ar(220)]),
			pan)*0.5*amp;
	);*/


}).add;

)

b.inspect
c.inspect
//Example with GUI controlling Synth

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

//250@24 means a Point of size 250 by 24
//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function
rateslide= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| c.set(\ratea,ez.value)}, 1);
w.onClose_({a.free; c.free;});
fadeslide= EZSlider(w, 250@24, "Static", ControlSpec(0, 1, 'lin', 0.05), {|ez| c.set(\fade,ez.value)}, 1);
ampslide= EZSlider(w, 250@24, "Volume", ControlSpec(0.01, 5, 'exponential', 0.01), {|ez| c.set(\amp,ez.value)}, 1);
panslide= EZSlider(w, 250@24, "Pan", ControlSpec(-1, 1, 'lin', 0.05), {|ez| c.set(\pan,ez.value)}, 0);

w.onClose_({a.free; d.free; c.free});

// 2d slider
t = Slider2D(w, Rect(0, 0,292, 292))
.y_(0.05)
.x_(0.05)
.background_(Color.rand)
.knobColor_(Color.rand)
.action_({|sl|
	// a.set(\rate,sl.y*2);
	// rateslid.valueAction = sl.y*2;
	// c.set(\mx, sl.x);
	// c.set(\my, sl.y);
	c.set(\amp,sl.y);
	c.set(\fade, sl.x);
	ampslide.valueAction = sl.y*5;
	fadeslide.valueAction = sl.x;
});

w.front;
)