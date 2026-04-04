using GLib;


static TestSong song_tests;
static TestPerformerType performer_type_tests;

int main(string[] args) {
    
    Test.init(ref args);
    song_tests = new TestSong();
    performer_type_tests = new TestPerformerType();

    add_tests_song();
    add_tests_performer_type();

    return Test.run();
}

//register of song tests
void add_tests_song() {
    
    //delegates
    Test.add_func("/song/id", () => {
        try { song_tests.test_id(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/constructor", () => {
        try { song_tests.test_constructor(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/title", () => {
        try { song_tests.test_title(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/performer", () => {
        try { song_tests.test_performer(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/path", () => {
        try { song_tests.test_path(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/album", () => {
        try { song_tests.test_album(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/genre", () => {
        try { song_tests.test_genre(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/year", () => {
        try { song_tests.test_year(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/track", () => {
        try { song_tests.test_track(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/full", () => {
        try { song_tests.test_song(); } catch (Error e) { error(e.message); }
    });
}

//register of type-performer tests
void add_tests_performer_type() {
    Test.add_func("/performer_type/map", () => {
        performer_type_tests.test_map_int();
    });
}


