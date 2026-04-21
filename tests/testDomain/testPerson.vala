using GLib;
using Sonus;

public class TestPerson : Object {

    private static string[] NAMES = { "Name1", "Name2", "Name3", "Name4", "Name5"};
    private static string[] FIRST_NAMES = {"fName1", "fName2", "fName3", "fName4", "fName5"};
    private static string[] LAST_NAMES  = {"lName1", "lName2", "lName3", "lName4", "lName5"};
    
    private int random_id(){
        return Random.int_range(2, 10001);
    }
    
    private string random_stage_name() {
        return NAMES[Random.int_range(0, NAMES.length)];
    }
    
    private string random_real_name(){
        return FIRST_NAMES[Random.int_range(0, FIRST_NAMES.length)]
        + " "
            + LAST_NAMES[Random.int_range(0, LAST_NAMES.length)];
    }
    
    
    // --- TESTS ---
    
    public void test_constructor() throws DomainError {
        
        int id = random_id();
        string stage = random_stage_name();
        string real = random_real_name();
        string birth = "1990-01-01"; 
        string death = "2000-01-01";
        
        var person = new Person(id, stage, real, birth, death);
        
        assert(person.get_id() == id);
        assert(person.get_name() == stage);
        assert(person.get_performer_type() == PerformerType.PERSON);
        assert(person.get_real_name() == real);
        assert(person.get_birth_date() == birth);
        assert(person.get_death_date() == death);
    }
    
    public void test_real_name() throws DomainError{
        var p = new Person(random_id(), "Stage Name");
        
        try{
            p.set_real_name("");
            assert_not_reached();
        } catch (Error e){
            assert(e is DomainError.EMPTY_FIELD);
        }
        
        try{
            p.set_real_name("   ");
            assert_not_reached();
        } catch (Error e){
            assert(e is DomainError.EMPTY_FIELD);
        }
            
        p.set_real_name("   Real Name   ");
        assert(p.get_real_name() == "Real Name");
        p.set_real_name(null);
        assert(p.get_real_name() == null);
    }
    
        
    public void test_dates() throws DomainError {
        var p = new Person(1, "n");
        
        string[] valid_dates = {"1988-05-05", "2024-01-01", "1800-11-28"};
        foreach (var d in valid_dates) {
            p.set_birth_date(null); 
            p.set_death_date(null);

            p.set_birth_date(d);
            assert(p.get_birth_date() == d);
            
            p.set_death_date(d);
            assert(p.get_death_date() == d);
        }
        
        
        string[] invalid_dates = {"05-05-1988", "2024/01/01", "this-is-not-a-date", "202-1-1"};
        foreach (var d in invalid_dates) {
            try {
                p.set_birth_date(d);
                assert_not_reached();
            } catch (DomainError e) {
                assert(e is DomainError.INVALID_DATA);
            }
        }
        
        foreach (var d in invalid_dates) {
            try {
                p.set_death_date(d);
                assert_not_reached();
            } catch (DomainError e) {
                assert(e is DomainError.INVALID_DATA);
            }
        }
        
        p.set_birth_date(null);
        assert(p.get_birth_date() == null);
        p.set_death_date(null);
        assert(p.get_death_date() == null);
    }

    //die before birth
    public void test_chronology_error() throws DomainError {

        var p = new Person(1, "Time Traveler");

        //try birth then die back in time
        p.set_birth_date("2000-01-01");
        try {
            p.set_death_date("1990-01-01");
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        //clean
        p.set_birth_date(null);
        p.set_death_date(null);

        //inverted way (try die then birth later in time)
        p.set_death_date("1990-01-01");
        try {
            p.set_birth_date("2000-01-01");
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }    
        
    }

    public void test_no_update_if_error_with_dates() throws DomainError{
        var p = new Person(random_id(), "name");
        p.set_birth_date("1990-01-01");
        p.set_death_date("2000-01-01"); 

        try {
            p.set_death_date("1985-01-01"); 
            assert_not_reached(); 
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
            assert(p.get_death_date() == "2000-01-01");
        }
    }

    public void test_same_day_birth_death() throws DomainError {
        var p = new Person(random_id(), "name");
        string same_day = "1120-11-20";
        
        p.set_birth_date(same_day);
        
        try {
            p.set_death_date(same_day);
            assert(p.get_death_date() == same_day);
            assert(p.get_birth_date() == p.get_death_date());
        } catch (DomainError e) {
            assert_not_reached();
        }
    }

    public void test_complete_person() throws DomainError {
        
        int id = random_id();
        string stage = random_stage_name();
        string real = random_real_name();
        string birth = "1970-01-01";
        string death = "2020-05-15";

        var person = new Person(id, stage, real, birth, death);

        assert(person.get_id() == id);
        assert(person.get_name() == stage);
        assert(person.get_performer_type() == PerformerType.PERSON);
        assert(person.get_real_name() == real);
        assert(person.get_birth_date() == birth);
        assert(person.get_death_date() == death);

        //modify everything
        int new_id = id + 1;
        string new_stage = "New " + stage;
        string new_real = "New " + real;
        
        person.set_id(new_id);
        person.set_name(new_stage);
        person.set_real_name(new_real);
        person.set_birth_date("1990-01-01");
        person.set_death_date(null);
        
        //check again
        assert(person.get_id() == new_id);
        assert(person.get_name() == new_stage);
        assert(person.get_real_name() == new_real);
        assert(person.get_birth_date() == "1990-01-01");
        assert(person.get_death_date() == null);
    }
}
