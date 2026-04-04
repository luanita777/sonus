using GLib;

public class TestPerformerType : Object {

    public void test_map_int() {
    assert(PerformerType.map_int(0) == PerformerType.PERSON);
    assert(PerformerType.map_int(1) == PerformerType.GROUP);
    assert(PerformerType.map_int(99) == PerformerType.UNKNOWN);
    }
}