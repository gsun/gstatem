# gstatem
The state machine for Haxe.

1.draw the UML with WhiteStarUml, and export with xmi format.
2.define the class extend the sm.SM.Context, which hold the state.
3.define teh class extend sm.SM.Msg, which hold the event.
4.import the xmi file as resource in hxml.

Note:
the event will be autobuilt with sm.SMBuilder.buildEvent.
the state will be autobuilt with sm.SMBuilder.buildState.
the state machine will be autobuilt with sm.SMBuilder.buildSM.

License:
this project follows the Apache V2 license.
