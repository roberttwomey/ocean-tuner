
// basic example
(
w = Window.new("The Eightfold Path").front;
m = PopUpMenu(w, Rect(10, 10, 180, 20));

m.items = [
 "right view", "right thinking", "right mindfulness", "right speech",
 "right action", "right diligence", "right concentration", "right livelihood"
];

m.background_(Color.green(0.7));  // only changes the look of displayed item
m.stringColor_(Color.white);   // only changes the look of displayed item
m.font_(Font("Courier", 13));   // only changes the look of displayed item
m.action = { arg menu;
 [menu.value, menu.item].postln;
};
)

m.value;   // returns the index of the current item;
m.item;    // returns the String or Symbol of the current item

m.value_(2);  // changes the displayed item, but does not evaluate the action
m.valueAction_(3); // evaluates the action.


// sound example
(
s.waitForBoot({

 var w, menu, snd, funcs, b;

 w = Window.new.front;

 menu = PopUpMenu(w, Rect(10, 10, 90, 20))
  .items_(["Sine", "Saw" , "Noise" , "Pulse"]);

 funcs = [
  { SinOsc.ar(440, 0, 0.3) },
  { Saw.ar(440, 0.3) },
  { WhiteNoise.ar(0.3) },
  { Pulse.ar(440, 0.2, 0.3) }
 ];

 b = Button(w, Rect(110, 10, 180, 20))
  .states_([["play", Color.black, Color.green]])
  .mouseDownAction_({
    snd = funcs.at(menu.value).play;
   })
  .action_({ arg butt, mod;
    snd.release;
   });

 w.front;

 p = CmdPeriod.add({ b.value_(0) }); // set button to 0 on hitting Cmd-period
 w.onClose_{ snd.release; CmdPeriod.removeAll }; // clean up when window is closed

})
)