using GLib;
using Sonus;

public class TestAlbum : Object {

    private static string[] NAMES = {"Album1", "Album2", "Album3", "Album4", "Album5"};

    private int random_id(){
        return Random.int_range(2, 10001);
    }

    private string random_name() {
        return NAMES[Random.int_range(0, NAMES.length)];
    }

    private string random_path() {
        return "/music/" + random_name();
    }

    private int random_year() {
        return 1900 + Random.int_range(0, 150);
    }


    // -- TESTS --

    public void test_constructor() throws DomainError {
        int r = random_id();

        try{
            new Album(0, "n", "/p");
            assert_not_reached();
        } catch (Error e){
            assert(e is DomainError.INVALID_DATA);
        }

        
        try{
            new Album(-1, "n", "/p");
            assert_not_reached();
        } catch (Error e){
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            new Album(r,"", "/p");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        try {
            new Album(r,"n", "");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        int id = random_id();
        string name = random_name();
        string path = random_path();
        int year = random_year();

        var album = new Album(id, name, path, year);

        assert(album.get_id() == id);
        assert(album.get_name() == name);
        assert(album.get_path() == path);
        assert(album.get_year() == year);
        
    }


    public void test_id() throws DomainError {
        var album = new Album(1, "n", "/p");

        try {
            album.set_id(10);
            assert(album.get_id() == 10);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            album.set_id(0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            album.set_id(-1);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int new_id = random_id();
        assert(album.get_id() != new_id);
        album.set_id(new_id);
        assert(album.get_id() == new_id); 
    }


    public void test_name() throws DomainError {
        var album = new Album(1, "n", "/p");

        try {
            album.set_name(""); 
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }
        
        try {
            album.set_name("   ");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        string new_name = random_name();
        album.set_name("   name   ");
        assert(album.get_name() == "name");
        assert(album.get_name() != new_name);
        album.set_name(new_name);
        assert(album.get_name() == new_name);
    }


    public void test_path() throws DomainError {
        var album = new Album(1, "n", "/p");
        
        try {
            album.set_path("");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        try {
            album.set_path("    ");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        try {
            album.set_path("~/path/music.mp3");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }
        
        string new_path = random_path();
        assert(album.get_path() != new_path);
        album.set_path(new_path);
        assert(album.get_path() == new_path);
    }


    public void test_year() throws DomainError {
        var album = new Album(1, "n", "/p");

        try {
            album.set_year(-10);
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int year = random_year();
        album.set_year(year);
        assert(album.get_year() == year);
        album.set_year(null);
        assert(album.get_year() == null);
        
    }

    public void test_complete_album() throws DomainError{
        var album = new Album(1, "n", "/p", 20);

        int id = random_id();
        string name = random_name();
        string path = random_path();
        int year = random_year();

        album.set_id(id);
        album.set_name(name);
        album.set_path(path);
        album.set_year(year);

        assert(album.get_id() == id);
        assert(album.get_name() == name);
        assert(album.get_path() == path);
        assert(album.get_year() == year);  
   
    }
    
    
}