import TestMsg;
import sm.SM.Context;

@:build(sm.SMBuilder.buildState("umltest")) enum TestState {}

class TestCb <TestState> extends Context<TestState>  {
  
  public function action1(event:TestMsg<TestEvent>) : Void {
    trace("action1");
    return null;
  }
  
  public function action2(event:TestMsg<TestEvent>) : Void{
    trace("action2");
    return null;
  }
  
  public function action3(event:TestMsg<TestEvent>) : Void {
    trace("action3");
    return null;
  }
  
  public function action4(event:TestMsg<TestEvent>) : Void{
    trace("action4");
    return null;
  }
  
  public function actionb(event:TestMsg<TestEvent>) : Void{
    trace("actionb");
    return null;
  }
  
  public function entryc() : Void{
    trace("entryc");
    return null;
  }

  public function exitb() : Void {
    trace("exitb");
    return null;
  }
  
  public function exitc() : Void {
    trace("exitc");
    return null;
  }
  
  public function entryd() : Void{
    trace("entryd");
    return null;
  }

  public function exitd() : Void {
    trace("exitd");
    return null;
  }
  
  public function exiti() : Void {
    trace("exiti");
    return null;
  }
  
  public function entryf() : Void{
    trace("entryf");
    return null;
  }

  public dynamic function guard1(event:TestMsg<TestEvent>) : Bool {
    trace("guard1");
    return false;
  }

  public dynamic function guard2(event:TestMsg<TestEvent>) :Bool {
    trace("guard2");
    return true;
  }

  public dynamic function guard3(event:TestMsg<TestEvent>) :Bool {
    trace("guard3");
    return false;
  }
  
  public dynamic function guard4(event:TestMsg<TestEvent>) :Bool {
    trace("guard4");
    return true;
  }
}