using GLib;
using Sonus;

public class TestSong : Object {

    // Examples
    private static string[] TITLES = {"Song A", "Song B", "Song C", "Song D", "Song E"};
    private static string[] GENRES = {"G1", "G2", "G3", "G4", "G5"};

    private int random_id(){
        return Random.int_range(2, 10001);
    }
    
    private string random_title() {
        return TITLES[Random.int_range(0, TITLES.length)];
    }
    
    private int random_performer_id() {
        return Random.int_range(2, 100);
    }
    
    private string random_path() {
        return "/music/" + random_title() + ".mp3";
    }
    
    private int? random_album_id() {
        return Random.boolean() ? (int?) Random.int_range(1, 500) : null;
    }
    
    private string random_genre() {
        return GENRES[Random.int_range(0, GENRES.length)];
    }
    
    private int random_year() {
        return 1900 + Random.int_range(0, 150);
    }
    
    private int random_track() {
        return Random.int_range(1, 80);
    }

    // --- TESTS ---

    public void test_constructor() throws DomainError {

        int r = random_id();
        int p = random_performer_id();
        
        try {
            new Song(0,"t", p, "/p.mp3");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }
                
        try {
            new Song(-2,"t", p, "/p.mp3");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            var s = new Song(-1, "t", 1, "/p.mp3");
            assert(s.get_id() == -1);
        } catch (Error e) {
            assert_not_reached();
        }
        
        try {
            new Song(r,"", p, "/p.mp3");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        try {
            new Song(r, "t", 0, "/p.mp3");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            new Song(r, "t", -1, "/p.mp3");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            var s = new Song(1, "t", null, "/p.mp3");
            assert(s.get_performer_id() == null);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            new Song(r, "t", p, "");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        int id = random_id();
        string title = random_title();
        int? performer_id = random_performer_id();
        string path = random_path();
        int? album_id = random_album_id();
        string genre = random_genre();
        int year = random_year();
        int track = random_track();

        var song = new Song(id, title, performer_id, path, album_id, genre, year, track);

        assert(song.get_id() == id);
        assert(song.get_title() == title);
        assert(song.get_performer_id() == performer_id);
        assert(song.get_path() == path);
        assert(song.get_album_id() == album_id);
        assert(song.get_genre() == genre);
        assert(song.get_year() == year);
        assert(song.get_track() == track);
    }

    public void test_id() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_id(10);
            assert(song.get_id() == 10);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            song.set_id(-1);
            assert(song.get_id() == -1);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            song.set_id(0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            song.set_id(-2);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int new_id = random_id();
        assert(song.get_id() != new_id);
        song.set_id(new_id);
        assert(song.get_id() == new_id); 
    }

    public void test_title() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_title(""); 
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }
        
        try {
            song.set_title("   ");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        string new_title = random_title();
        song.set_title("   title   ");
        assert(song.get_title() == "title");
        assert(song.get_title() != new_title);
        song.set_title(new_title);
        assert(song.get_title() == new_title);
    }

    public void test_performer_id() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_performer_id(null);
            assert(song.get_performer_id() == null);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            song.set_performer_id(10);
            assert(song.get_performer_id() == 10);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            song.set_performer_id(0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            song.set_performer_id(-1);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int new_performer_id = random_performer_id();
        assert(song.get_performer_id() != new_performer_id);
        song.set_performer_id(new_performer_id);
        assert(song.get_performer_id() == new_performer_id);
    }

    public void test_path() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");
        
        try {
            song.set_path("");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }
        
        try {
            song.set_path("   ");
            assert_not_reached(); 
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        string[] invalid_paths = {"/music/song.txt", "/musIc/photo.JPG", "/music/Archive.zip",
            "/music/no_extension", "/music/fake.mp3.exe",  "/music/mp3_is_here.wav"};
        
        foreach (string path in invalid_paths) {
            try {
                song.set_path(path);
            assert_not_reached(); 
            } catch (DomainError e) {
                assert(e is DomainError.INVALID_DATA);
            }
        }
        
        string new_path = random_path();
        song.set_path("     ~/path/music.mp3   ");
        assert(song.get_path() == "~/path/music.mp3");
        assert(song.get_path() != new_path);
        song.set_path(new_path);
        assert(song.get_path() == new_path);
    }

    public void test_album_id() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_album_id(10);
            assert(song.get_album_id() == 10);
        } catch (Error e) {
            assert_not_reached();
        }

        try {
            song.set_album_id(0);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        try {
            song.set_album_id(-1);
            assert_not_reached();
        } catch (DomainError e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int new_album_id = Random.int_range(1, 100);
        song.set_album_id(null);
        assert(song.get_album_id() == null);
        assert(song.get_album_id() != new_album_id);
        song.set_album_id(new_album_id);
        assert(song.get_album_id() == new_album_id);
        
    }

    public void test_genre() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_genre("");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        try {
            song.set_genre("    ");
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.EMPTY_FIELD);
        }

        string genre = random_genre();
        song.set_genre("     genre    ");
        assert(song.get_genre() == "genre");
        assert(song.get_genre() != genre);
        song.set_genre(genre);
        assert(song.get_genre() == genre);
        song.set_genre(null);
        assert(song.get_genre() == null);
    }

    public void test_year() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_year(-10);
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int year = random_year();
        song.set_year(year);
        assert(song.get_year() == year);
        song.set_year(null);
        assert(song.get_year() == null); 
    }

    public void test_track() throws DomainError {
        var song = new Song(1, "t", 1, "/p.mp3");

        try {
            song.set_track(-1);
            assert_not_reached();
        } catch (Error e) {
            assert(e is DomainError.INVALID_DATA);
        }

        int track = random_track();
        song.set_track(track);
        assert(song.get_track() == track);
        song.set_track(null);
        assert(song.get_track() == null);
    }

    public void test_complete_song() throws DomainError {
        var song = new Song(1,"t", 1, "/p.mp3", 1, "g", 1, 1);

        int id = random_id();
        string title = random_title();
        int performer = random_performer_id();
        string path = random_path();
        int? album = random_album_id();
        string genre = random_genre();
        int year = random_year();
        int track = random_track();

        song.set_id(id);
        song.set_title(title);
        song.set_performer_id(performer);
        song.set_path(path);
        song.set_album_id(album);
        song.set_genre(genre);
        song.set_year(year);
        song.set_track(track);

        assert(song.get_id() == id);
        assert(song.get_title() == title);
        assert(song.get_performer_id() == performer);
        assert(song.get_path() == path);
        assert(song.get_album_id() == album);
        assert(song.get_genre() == genre);
        assert(song.get_year() == year);
        assert(song.get_track() == track);
    }
}

    

