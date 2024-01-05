

// sampler https://schollz.com/tinker/sampler/

File.getcwd
thisProcess.nowExecutingPath.dirname

this.class.filenameSymbol.asString.dirname

(
//this loads into a buffer the default sound that comes with SuperCollider
//.read brings in the whole sound at once
b = Buffer.read(s,"/Volumes/Work/Projects/birch-aquarium/sounds/LJsiteB-20150529-072919-singlegrunt-filtered.wav"); //store handle to Buffer in global

SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1;
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop),0.0)
	)
}).add;

SynthDef("tuner", { arg out=0, mx=0, my=0, amp=0.5;
	var a, n, mwrap;
    n = 8;
	// mx = MouseX.kr(0, 1, 0, 0.1);
	// my = MouseY.kr;
    mwrap = { |pmin, pmax, min, max| sin(mx * ExpRand(pmin, pmax)) + 1 * 0.5 * ExpRand(min, max) };
    a = {
        var freq, fmul, phase;
        freq = mwrap.(10, 40, 200, 5000) + ExpRand(200, 3000);
        fmul = LFNoise0.kr(ExpRand(0.1, 8)).round(1/6).exprange(1, Rand(1, 1.2));
        phase = LFNoise2.ar(mwrap.(1, 20, 10, 1000), Rand(2, 5));
        SinOsc.ar(freq * fmul, phase)
    } ! n;
    a = a.add(
        SinOsc.ar(LFDNoise0.kr(11, SetResetFF.kr(*Dust.kr([1, 2] * 0.3))).range(0, 700) + 220)
    );
	Out.ar(out,
		Pan2.ar(
			SelectXFocus.ar(mx * n, a, my * n) * 0.2 + OnePole.ar(PinkNoise.ar(0.5 ! 2), 0.4) * Line.kr(0, 1, 3), 0.0)*amp*0.5;
	);
}).add;

)

b.inspect

//Example with GUI controlling Synth

(
var w, rateslid, trigslid, startposslid, loopslid, ampslid, a, c, v, menu, fnames;

// playbuf
a=Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);

c=Synth(\tuner, [\out, 0, \mx, 0.5, \my, 0.5]);

w=Window("PlayBuf Example",Rect(10,200,300,450));
w.front;
//control positioning of new GUI elements so I don't have to think too hard about it

w.view.decorator= FlowLayout(w.view.bounds);


// v = PathName.new("/Volumes/Work/Projects/birch-aquarium/sounds/").files.scramble.copyFromStart(20);
v = PathName.new(thisProcess.nowExecutingPath.dirname+/+"sounds/").files.scramble.copyFromStart(20);

fnames = [];
v.do( {|i| i.fileName.asString.postln; fnames = fnames.add(i.fileName.asString)});
fnames.postln;
menu = PopUpMenu(w, Rect(10, 10, 200, 20)).items_(fnames);
menu.action = { arg menu;
	[menu.value, menu.item].postln;
	b = Buffer.read(s,"/Volumes/Work/Projects/birch-aquarium/sounds/"+/+menu.item); //store handle to Buffer in global
	a.set(\bufnum, b.bufnum);

};

//James' shortcut slider class
//250@24 means a Point of size 250 by 24
//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function
rateslid= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);
// trigslid= EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);
// startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);
// loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);
w.onClose_({a.free; c.free;});
ampslid= EZSlider(w, 250@24, "Static", ControlSpec(0.001, 1, 'exponential', 0.01), {|ez| c.set(\amp,ez.value)}, 1);
w.onClose_({a.free; c.free;});

// 2d slider
t = Slider2D(w, Rect(0, 0,292, 292))
.y_(0.05)
.x_(0.05)
.background_(Color.rand)
.knobColor_(Color.rand)
.action_({|sl|
	// a.set(\rate,sl.y*2);
	// rateslid.valueAction = sl.y*2;
	c.set(\mx, sl.x);
	c.set(\my, sl.y);
	c.set(\amp,sl.x*0.5);
	ampslid.valueAction = sl.x*0.5;
});

w.front;
)