package sm;

class Msg <Event> {

  public var event(get, never) : Event;
  private var my_event : Event; 
 
  public function get_event() : Event {
      return this.my_event;
  }
  public function new(event : Event) {
      my_event = event;
  }
  
  public function destructor() {}

}

class Context <State> {

  public var state(get, set) : State;
  private var my_state : State;

  public function get_state() : State {
      return this.my_state;
  }
  public function set_state(state : State) : State {
      return this.my_state = state;
  }
  
  public function new(state : State) {
      my_state = state;
  }

  public function destructor() {}

}

class TransitionBehavior <State, Event> {
    public var description : String;

    public var transit : String;
    public var entryExit: String;
    
    public var nextState : State;

    public function new(a, b, c, d) {
        this.description = a;
        this.transit = b;
        this.entryExit = c;
        this.nextState = d;
    }
} 
 
class SmTransition <State, Event> {

  public var description : String;

  public var fromState : State;

  public var eventId : Event;

  public var guard : String;
 
  public var behaviors : Array<TransitionBehavior<State, Event>>;

  public var toState : State;
  
    public function new(a, b, c, d, e, f) {
        this.description = a;
        this.fromState = b;
        this.eventId = c;
        this.behaviors = d;
        this.toState = e;
        this.guard = f;
    }
}
 
class SmVertex <State, Event> {

  public var state : State;

  public var pseudostate : Bool; 
  
  public var finalstate:Bool;

  public var outTransition : Array<SmTransition<State, Event>>;
  
    public function new(a, b, c, d) {
        this.state = a;
        this.outTransition = b;
        this.pseudostate = c;
        this.finalstate = d;
    }
}
 
class SM <State, Event> {

  private var name : String;

  private var vertices : Map<State, SmVertex<State, Event>>;

  private static var sms : Map<String, Dynamic> = new Map(); 

  public function new(a, b) {
        this.name = a;
        this.vertices = b;
  }
  
  public static function getSM(name:String) {
        return sms.get(name);
  }
  
  public static function setSM(name:String, sm:Dynamic) {
        return sms.set(name, sm);
  }
   
  public static function listNames() {
        return sms.keys();
  }
  
  public function findTransition(state : State, event : Event, context : Dynamic,  msg : Dynamic) : SmTransition<State, Event> {      
      var vertix = this.vertices.get(state);
      if (vertix == null) return null;  
      
      for (transition in vertix.outTransition) {
          if (((transition.eventId != null) && 
               (transition.eventId != event)) || 
              ((transition.guard != null) && 
               (Reflect.callMethod(context, Reflect.field(context, transition.guard), [msg]) != true))) {
              continue;
          }
          return transition;
      }
      
      return null;
  }
  
  public function isPseudoState(state: State) : Bool {
      var vertix = this.vertices.get(state);
      
      if (vertix != null) {       
          return (vertix.pseudostate == true) ? true : false;
      }   
      
      return true;
  }
  
  public function isFinalState(state: State) : Bool {
      var vertix = this.vertices.get(state);
      
      if (vertix != null) {       
          return (vertix.finalstate == true) ? true : false;
      }   
      
      return true;
  }
  
  
  public function processEvent (context : Dynamic,  msg : Dynamic) : Void {
      var my_stateId = Reflect.getProperty(context, "state"); //state will change during processing
      var my_eventId = Reflect.getProperty(msg, "event");  //event will change if exception
      var my_msg = msg;
      var my_orig_stateId = my_stateId;
      var my_orig_eventId = my_eventId;
      var transition = this.findTransition(my_stateId, my_eventId, context, my_msg);

      while (transition != null) {            
          for (behavior in transition.behaviors) {        
              if ((behavior.transit == null) &&
                  (behavior.nextState != my_stateId)) {
                  //get next state for loop
                  my_stateId = behavior.nextState;
                  trace("dynamic state before transition " + my_stateId);
                  
                  //set the state for the object
                  if (this.isPseudoState(my_stateId) != true) {
                      Reflect.setProperty(context, "state", behavior.nextState);
                      trace("object state before transition " + behavior.nextState);
                  }
              }               
              
              var my_excpt_msg = null;
              if (behavior.transit != null) {
                  try {
                      Reflect.callMethod(context, Reflect.field(context, behavior.transit), [my_msg]);
                  } catch (err : Dynamic) {
                      my_excpt_msg =  err;
                  }
              } 
              else if (behavior.entryExit != null) {
                  try {
                      Reflect.callMethod(context, Reflect.field(context, behavior.entryExit), []);
                  } catch (err : Dynamic) {
                      my_excpt_msg =  err;
                  }
              }
              
              if ((behavior.transit != null) &&
                  (behavior.nextState != my_stateId)) {
                  //get next state for loop
                  my_stateId = behavior.nextState;
                  trace("dynamic state after  transition " + my_stateId);
                  
                  //set the state for the object
                  if (this.isPseudoState(my_stateId) != true) {
                      Reflect.setProperty(context, "state", behavior.nextState);
                      trace("object state after  transition " + context.state);
                  }
              }
              
              if (my_excpt_msg != null) {
                 my_msg.destructor();
                 my_msg = my_excpt_msg;
                 my_eventId = Reflect.getProperty(my_excpt_msg, "event");
                 break;
              }                   
          }
          
          /*the state and event unchanged after transition, break the loop here.*/
          if ((my_stateId == my_orig_stateId) && (my_eventId == my_orig_eventId)) break;
          
          /*find next transition if my_stateId/my_eventId changed, which is used for pesudo state or exception event.*/
          transition = this.findTransition(my_stateId, my_eventId, context, my_msg);
      }
      
      my_msg.destructor();

      if (isFinalState(my_stateId))
      {
        context.destructor();
      }
  }
  
  public function toString(from=null, to=null, event=null) : Void {
      for (vertix in this.vertices) {
          if ((from != null) && (vertix.state != from))
              continue;
          trace("Vertix state " + vertix.state);
          for (transition in vertix.outTransition) {
              if ((to != null) && (transition.toState != to))
                  continue;
              trace("  Transition from state " + vertix.state + " to state " + transition.toState);
              for (behavior in transition.behaviors) {
                  trace("    Behavior "+ Std.string(behavior));
              }
          }
      }  
  }
  
  static inline public function err(msg:String) : Void {
      #if debug
          trace(msg);
      #end
      #if macro
          haxe.macro.Context.error(msg, haxe.macro.Context.currentPos());
      #else
          throw msg;
      #end
  }
}

