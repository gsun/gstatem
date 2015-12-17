import sm.SM.Msg;

@:build(sm.SMBuilder.buildEvent("umltest")) enum TestEvent {}

class TestMsg<TestEvent> extends Msg<TestEvent> {

    public var sm(get, never) : String;    
    private var my_sm:String; 
    
    public function get_sm() : String {
        return this.my_sm;
    }
    
    public function new(e:TestEvent) {
        super(e);
        this.my_sm = "umltest";     
    }
}