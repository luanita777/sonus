using GLib;
using Sonus;

public class TestPerformer : Object {

    private static string[] NAMES = { "Name1", "Name2", "Name3", "Name4", "Name5"};

    //randoms
    private int random_id() {
        return Random.int_range(1, 10000);
    }

    private string random_name() {
        return NAMES[Random.int_range(0, NAMES.length)];
    }

    private PerformerType random_type() {
        return (PerformerType) Random.int_range(0, 3);
    }

    // --- TESTS ---

    //test for constructor
    public void test_constructor() throws DomainError {
        int id = random_id();
        string name = random_name();
        PerformerType type = random_type();

        try {
            var performer = new Performer(id, type, name);
            assert(performer.get_id() == id);
            assert(performer.get_name() == name);
            assert(performer.get_performer_type() == type);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            new Performer(0, type, name);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is  DomainError.INVALID_DATA);
        }

        try {
            new Performer(-5, type, name);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is  DomainError.INVALID_DATA);
        }

        try {
            new Performer(id, type, "   ");
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is  DomainError.EMPTY_FIELD);
        }
    }

    //test for id
    public void test_id() throws DomainError {
        var performer = new Performer(1, PerformerType.PERSON, "n");
        
        int new_id = random_id() + 10; 
        assert(performer.get_id() != new_id);

        performer.set_id(new_id);
        assert(performer.get_id() == new_id);

        try {
            performer.set_id(-1);
            assert(performer.get_id() == -1);
        } catch (Error e) {
            assert_not_reached();
        }
        
        try {
            performer.set_id(0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }
                
        try {
            performer.set_id(-50);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }
    }

    //test for name
    public void test_name() throws DomainError {
        var performer = new Performer(1, PerformerType.GROUP, "n");
        
        performer.set_name("   group   ");
        assert(performer.get_name() == "group"); 

        try {
            performer.set_name("");
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.EMPTY_FIELD);
        }
    }

    //test for type
    public void test_type() throws DomainError {
        var performer = new Performer(1, PerformerType.PERSON, "person");
        assert(performer.get_performer_type() == PerformerType.PERSON);

        performer.set_type(PerformerType.GROUP);
        assert(performer.get_performer_type() == PerformerType.GROUP);

        performer.set_type(PerformerType.UNKNOWN);
        assert(performer.get_performer_type() == PerformerType.UNKNOWN);
    }

    public void test_complete_performer() throws DomainError {
        var performer =  new Performer(1, PerformerType.PERSON, "person");

        int id = random_id();
        string name = random_name();
        PerformerType type = random_type();

        performer.set_id(id);
        performer.set_name(name);
        performer.set_type(type);

        assert(performer.get_id() == id);
        assert(performer.get_name() == name);
        assert(performer.get_performer_type() == type);
        
    }
}