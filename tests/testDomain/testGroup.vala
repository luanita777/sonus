using GLib;
using Sonus;

public class TestGroup : Object {

    private static string[] NAMES = { "Group1", "Group2", "Group3", "Group4", "Group5"};
    
    private int random_id(){
        return Random.int_range(2, 10001);
    }

    private string random_stage_name() {
        return NAMES[Random.int_range(0, NAMES.length)];
    }

    // --- TESTS ---
    public void test_constructor() throws DomainError {
        int id = random_id();
        string stage = random_stage_name();
        string start = "1990-01-01"; 
        string end = "2000-01-01";

        var group = new Group(id, stage, start, end);

        assert(group.get_id() == id);
        assert(group.get_name() == stage);
        assert(group.get_performer_type() == PerformerType.GROUP);
        assert(group.get_start_date() == start);
        assert(group.get_end_date() == end);
    }

    public void test_dates() throws DomainError {
        var g = new Group(1, "n");
        
        string[] valid_dates = {"1988-05-05", "2024-01-01", "1800-11-28"};
        foreach (var d in valid_dates) {
            g.set_start_date(null); 
            g.set_end_date(null);

            g.set_start_date(d);
            assert(g.get_start_date() == d);
            
            g.set_end_date(d);
            assert(g.get_end_date() == d);
        }
        
        
        string[] invalid_dates = {"05-05-1988", "2024/01/01", "this-is-not-a-date", "202-1-1"};
        foreach (var d in invalid_dates) {
            try {
                g.set_start_date(d);
                assert_not_reached();
            } catch (DomainError e) {
                assert(e is DomainError.INVALID_DATA);
            }
        }
        
        foreach (var d in invalid_dates) {
            try {
                g.set_end_date(d);
                assert_not_reached();
            } catch (DomainError e) {
                assert(e is DomainError.INVALID_DATA);
            }
        }
        
        g.set_start_date(null);
        assert(g.get_start_date() == null);
        g.set_end_date(null);
        assert(g.get_end_date() == null);
    }

    //end before start
    public void test_chronology_error() throws DomainError {

        var g = new Group(1, "Group time Traveler");

        //try start then end back in time
        g.set_start_date("2000-01-01");
        try {
            g.set_end_date("1990-01-01");
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        //clean
        g.set_start_date(null);
        g.set_end_date(null);

        //inverted way (try end then start later in time)
        g.set_end_date("1990-01-01");
        try {
            g.set_start_date("2000-01-01");
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }    
        
    }

    public void test_no_update_if_error_with_dates() throws DomainError{
        var g = new Group(random_id(), "name");
        g.set_start_date("1990-01-01");
        g.set_end_date("2000-01-01"); 

        try {
            g.set_end_date("1985-01-01"); 
            assert_not_reached(); 
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
            assert(g.get_end_date() == "2000-01-01");
        }
    }

    public void test_same_day_start_end() throws DomainError {
        var g = new Group(random_id(), "name");
        string same_day = "1120-11-20";
        
        g.set_start_date(same_day);
        
        try {
            g.set_end_date(same_day);
            assert(g.get_end_date() == same_day);
            assert(g.get_start_date() == g.get_end_date());
        } catch (DomainError e) {
            assert_not_reached();
        }
    }

    public void test_complete_group() throws DomainError {
        
        int id = random_id();
        string stage = random_stage_name();
        string start = "1970-01-01";
        string end = "2020-05-15";

        var group = new Group(id, stage, start, end);

        assert(group.get_id() == id);
        assert(group.get_name() == stage);
        assert(group.get_performer_type() == PerformerType.GROUP);
        assert(group.get_start_date() == start);
        assert(group.get_end_date() == end);

        //modify everything
        int new_id = id + 1;
        string new_stage = "New " + stage;
        
        group.set_id(new_id);
        group.set_name(new_stage);
        group.set_start_date("1990-01-01");
        group.set_end_date(null);
        
        //check again
        assert(group.get_id() == new_id);
        assert(group.get_name() == new_stage);
        assert(group.get_start_date() == "1990-01-01");
        assert(group.get_end_date() == null);
    }
}