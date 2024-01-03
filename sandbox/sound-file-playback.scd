

// sampler https://schollz.com/tinker/sampler/

File.getcwd
thisProcess.nowExecutingPath

(
//this loads into a buffer the default sound that comes with SuperCollider
//.read brings in the whole sound at once
/*b = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav"); //store handle to Buffer in global */

b = Buffer.read(s,"/Volumes/Work/Projects/birch-aquarium/sounds/LJsiteB-20150529-072919-singlegrunt-filtered.wav"); //store handle to Buffer in global


SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1;
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop),0.0)
	)
}).add;
)


//Example with GUI controlling Synth

(
var w, rateslid, trigslid, startposslid, loopslid, a;
a=Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);

w=Window("PlayBuf Example",Rect(10,200,300,150));
w.front;
//control positioning of new GUI elements so I don't have to think too hard about it

w.view.decorator= FlowLayout(w.view.bounds);


v = PathName.new("/Volumes/Work/Projects/birch-aquarium/sounds/").files.scramble.copyFromStart(20);

menu = PopUpMenu(w, Rect(10, 10, 90, 20))
  .items_(v);

//James' shortcut slider class
//250@24 means a Point of size 250 by 24
//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function
rateslid= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);
trigslid= EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);
startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);
loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);
w.onClose_({a.free;});
)