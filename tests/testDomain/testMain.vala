using GLib;

static TestSong tests;

int main(string[] args) {
    Test.init(ref args);

    tests = new TestSong();

    Test.add_func("/song/id", () => {
            try {
                tests.test_id();
            } catch (Error e) {
                error("Error en ID: %s", e.message);
            }
        });
    
    Test.add_func("/song/constructor", () => {
        try {
            tests.test_constructor();
        } catch (Error e) {
            error("Error en constructor: %s\n", e.message);
        }
    });

    Test.add_func("/song/title", () => {
        try {
            tests.test_title();
        } catch (Error e) {
            error("Error en title: %s\n", e.message);
        }
    });

    Test.add_func("/song/performer", () => {
        try {
            tests.test_performer();
        } catch (Error e) {
            error("Error en performer: %s\n", e.message);
        }
    });

    Test.add_func("/song/path", () => {
        try {
            tests.test_path();
        } catch (Error e) {
            error("Error en path: %s\n", e.message);
        }
    });

    Test.add_func("/song/album", () => {
        try {
            tests.test_album();
        } catch (Error e) {
            error("Error en album: %s\n", e.message);
        }
    });

    Test.add_func("/song/genre", () => {
        try {
            tests.test_genre();
        } catch (Error e) {
            error("Error en genre: %s\n", e.message);
        }
    });

    Test.add_func("/song/year", () => {
        try {
            tests.test_year();
        } catch (Error e) {
            error("Error en year: %s\n", e.message);
        }
    });

    Test.add_func("/song/track", () => {
        try {
            tests.test_track();
        } catch (Error e) {
            error("Error en track: %s\n", e.message);
        }
    });

    Test.add_func("/song/full", () => {
        try {
            tests.test_song();
        } catch (Error e) {
            error("Error en full test: %s\n", e.message);
        }
    });

    return Test.run();
}


