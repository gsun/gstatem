import sm.SM;
import TestCb.TestState;
import TestMsg.TestEvent;

class TestSM  extends haxe.unit.TestCase {

    public function testSimple () {
        
        var sm:SM<TestState, TestEvent> = sm.SMBuilder.buildSM("umltest", "TestState", "TestEvent");  
        
        //StateA Event1 guard1(false) 
        var cb = new TestCb(TestState.StateA);        
        var event = new TestMsg(TestEvent.Event1);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateE);  
        
        //StateA Event1 guard1(true) 
        cb = new TestCb(TestState.StateA);
        cb.guard1 = function guard1(event:TestMsg<TestEvent>) : Bool {
            trace("guard1");
            return true;
        }
        var event = new TestMsg(TestEvent.Event1);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateB);
        
        //StateA Event7 
        cb = new TestCb(TestState.StateA);
        var event = new TestMsg(TestEvent.Event7);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateB);  

        //StateB Event3       
        cb = new TestCb(TestState.StateB);
        var event = new TestMsg(TestEvent.Event3);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateB); 
        
        //StateB Event2
        cb = new TestCb(TestState.StateB);
        var event = new TestMsg(TestEvent.Event2);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateA);            
 
        //StateE Event4 guard4(true)
        cb = new TestCb(TestState.StateE);
        var event = new TestMsg(TestEvent.Event4);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateK); 

        //StateE Event4 guard3(true)
        cb = new TestCb(TestState.StateE);
        cb.guard4 = function guard4(event:TestMsg<TestEvent>) : Bool {
            trace("guard4");
            return false;
        }
        cb.guard3 = function guard3(event:TestMsg<TestEvent>) : Bool {
            trace("guard3");
            return true;
        }
        var event = new TestMsg(TestEvent.Event4);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateJ); 

        //StateE Event4
        cb = new TestCb(TestState.StateE);
        cb.guard4 = function guard4(event:TestMsg<TestEvent>) : Bool {
            trace("guard4");
            return false;
        }
        var event = new TestMsg(TestEvent.Event4);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateF); 
        
        //StateE Event8
        cb = new TestCb(TestState.StateE);
        var event = new TestMsg(TestEvent.Event8);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateA);
  
        //StateF Event3
        cb = new TestCb(TestState.StateF);        
        var event = new TestMsg(TestEvent.Event3);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateF);  
        
        //StateF Event5
        cb = new TestCb(TestState.StateF);        
        var event = new TestMsg(TestEvent.Event5);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateE);  
        
        //StateF Event1 guard1(true)
        cb = new TestCb(TestState.StateF);        
        var event = new TestMsg(TestEvent.Event1);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateJ); 

        //StateF Event1 guard1(false)
        cb = new TestCb(TestState.StateF);      
        cb.guard2 = function guard2(event:TestMsg<TestEvent>) : Bool {
            trace("guard2");
            return false;
        }        
        var event = new TestMsg(TestEvent.Event1);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateK); 
        
        //StateI Event8
        cb = new TestCb(TestState.StateK);
        var event = new TestMsg(TestEvent.Event8);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateB);
        
        //StateK Event6
        cb = new TestCb(TestState.StateK);
        var event = new TestMsg(TestEvent.Event6);
        sm.processEvent(cb, event);
        assertEquals(cb.state, TestState.StateE);       

    }
}