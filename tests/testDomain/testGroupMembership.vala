using GLib;
using Sonus;

public class TestGroupMembership : Object {

    private int random_id(){
        return Random.int_range(2, 10001);
    }

    //--- TESTS ---
    
    //test constructor
    public void test_constructor() throws DomainError {
        int p_id = random_id();
        int g_id = random_id();
        
        var membership = new GroupMembership(p_id, g_id);
        
        assert(membership.get_person_id() == p_id);
        assert(membership.get_group_id() == g_id);
    }
    

    public void test_invalid_ids() throws DomainError{

        try {
            new GroupMembership(0, 5);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            new GroupMembership(5, -1);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            new GroupMembership(-2, -1);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            new GroupMembership(0, 0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }
    }

    public void test_setters() throws DomainError {
        var m = new GroupMembership(1, 1);

        int p_id = random_id();
        int g_id = random_id();
        
        m.set_person_id(p_id);
        assert(m.get_person_id() == p_id);
        
        m.set_group_id(g_id);
        assert(m.get_group_id() == g_id);
        
        try {
            m.set_person_id(-5);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
            assert(m.get_person_id() == p_id); 
        }

        try {
            m.set_group_id(0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
            assert(m.get_group_id() == g_id); 
        }
        
    }

    
}