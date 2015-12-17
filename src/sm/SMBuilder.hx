package sm;

import haxe.macro.Expr;
import haxe.macro.Context;

class SMBuilder {
    macro public static function buildState(resourceName:String) : Array<Field> {
        var pos = haxe.macro.Context.currentPos();
        var cl = new Array();
        var umlParser = UmlParser.findUmlParser(resourceName);

        for(c in umlParser.stateDetails) {
            cl.push({ name : c.name, doc : null, meta : [], access : [], kind : FVar(null,null), pos : pos });
        }   
        return cl;
    }
    
    macro public static function buildEvent(resourceName:String) : Array<Field> {
        var pos = haxe.macro.Context.currentPos();
        var cl = new Array();
        var umlParser = UmlParser.findUmlParser(resourceName);
        var events:Array<String> = [];
        
        //different transition may have the same event, so filter the additional same events.
        for(c in umlParser.eventDetails) {
            if (Lambda.has(events, c.name) == false) events.push(c.name);
        }   
        
        for(c in events) {
            cl.push({ name : c, doc : null, meta : [], access : [], kind : FVar(null,null), pos : pos });
        }   
        return cl;
    }
    
    macro public static function buildSM(resourceName:String, State:String, Event:String) :Expr  {
       var code : String = '';
       var expr : Expr = null;
       var umlParser = UmlParser.findUmlParser(resourceName);
       
       //init the state machine and verteics
       code += '\nvar vertics = new Map<' + State + ', sm.SM.SmVertex<' + State +', ' + Event + '>>();';
       code += '\nvar stm = new sm.SM<' + State + ',' + Event +'> ("' + resourceName + '" ,vertics);';
       
       for (stateId in umlParser.vertics.keys()) {
           var stateDetail = umlParser.stateDetails.get(stateId);
           var priorityItems = umlParser.vertics.get(stateId);
           
           code += '\n{';
           
           //init the vertix and transition array.
           code += '\nvar transitions = new Array<sm.SM.SmTransition<' + State + ',' + Event + '>>();';
           code += '\nvar vertix = new sm.SM.SmVertex<' + State + ',' + Event + '>(' + stateDetail.name + ',transitions,' + stateDetail.pseudo + ',' + stateDetail.final + ');';
           code += '\nvertics.set(' + stateDetail.name + ',vertix);';
           
           for (priorityItem in priorityItems) {
               var transition = umlParser.flattenedTransDetails.get(priorityItem.transId);
               
               code += '\n{';
               
               //init the behavior array.
               code += '\nvar behaviors = new Array<sm.SM.TransitionBehavior<' + State +',' + Event + '>>();';
               code += '\nvar behavior = null;';
               
               for (behavior in transition.behaviors) {            
                   //init the behavior entrie and add it into the array
                   var transit = behavior.transit!=null?('"'+behavior.transit+'"'):null;
                   var entryExit = behavior.entryExit!=null?('"'+behavior.entryExit+'"'):null;
                   code += '\nbehavior = new sm.SM.TransitionBehavior<' + State + ',' + Event + '>("' + behavior.description + '",' + transit + ',' + entryExit + ',' + behavior.nextState + ');';                                   
                   code += '\nbehaviors.push(behavior);';
               }
              
               //init the transition and add it into the v
               var guard = transition.guard!=null?('"'+transition.guard+'"'):null;
               code += '\nvar transition = new sm.SM.SmTransition<' + State + ',' + Event + '>("' + transition.description + '",' +  transition.source + ',' + transition.event + ',behaviors,' + transition.target + ',' + guard + ');';         

               code += '\ntransitions.push(transition);';
               code += '\n}';
               
          }
          code += '\n}';
       }
       
       code += '\nsm.SM.setSM("' + resourceName +'",' + 'stm);';
       code += '\nreturn stm;';
              
       code = '(function() :sm.SM<' + State + ',' + Event +'> {' + code + '})()';
       expr = Context.parseInlineString(code, Context.makePosition({ min:0, max:0, file:resourceName}));
       
       #if debug
       trace(code);  
       #end
       
       return expr;
    }
}