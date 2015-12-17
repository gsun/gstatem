# gstatem
the state machine for Haxe.

1.draw the UML with WhiteStarUml, and export with xmi format.
2.define the class extend the sm.SM.Context, which hold the state.
3.define teh class extend sm.SM.Msg, which hold the event.

Note:
the event will be autobuild with sm.SMBuilder.buildEvent.
the state will be autobuild with sm.SMBuilder.buildState.
the state machine will be autobuild with sm.SMBuilder.buildSM.

License:
this project follow Apache V2 license.
