using GLib;


static TestSong song_tests;
static TestPerformerType performer_type_tests;
static TestPerformer performer_tests;
static TestAlbum album_tests;
static TestPerson person_tests;
static TestGroup group_tests;
static TestGroupMembership groupMembership_tests;

int main(string[] args) {
    
    Test.init(ref args);
    
    song_tests = new TestSong();
    performer_type_tests = new TestPerformerType();
    performer_tests = new TestPerformer();
    album_tests = new TestAlbum();
    person_tests = new TestPerson();
    group_tests = new TestGroup();
    groupMembership_tests = new TestGroupMembership();

    add_tests_song();
    add_tests_performer_type();
    add_tests_performer();
    add_tests_album();
    add_tests_person();
    add_tests_group();
    add_tests_groupMembership();

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
        try { song_tests.test_performer_id(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/path", () => {
        try { song_tests.test_path(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/song/album", () => {
        try { song_tests.test_album_id(); } catch (Error e) { error(e.message); }
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

    Test.add_func("/song/complete_song", () => {
        try { song_tests.test_complete_song(); } catch (Error e) { error(e.message); }
    });

    
}

//register of type-performer tests
void add_tests_performer_type() {
    Test.add_func("/performer_type/map", () => {
        performer_type_tests.test_map_int();
    });
}

void add_tests_performer(){

    Test.add_func("/performer/constructor", () => {
            try { performer_tests.test_constructor(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/performer/id", () => {
            try { performer_tests.test_id(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/performer/name", () => {
            try { performer_tests.test_name(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/performer/type", () => {
            try { performer_tests.test_type(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/performer/complete_performer", () => {
            try { performer_tests.test_complete_performer(); } catch (Error e) { error(e.message); }
        });
}

void add_tests_album(){
    Test.add_func("/album/constructor", () => {
            try { album_tests.test_constructor(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/album/id", () => {
            try { album_tests.test_id(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/album/name", () => {
            try { album_tests.test_name(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/album/path", () => {
            try { album_tests.test_path(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/album/year", () => {
        try { album_tests.test_year(); } catch (Error e) { error(e.message); }
    });

    Test.add_func("/album/complete_album", () => {
        try { album_tests.test_complete_album(); } catch (Error e) { error(e.message); }
    });
}

void add_tests_person(){
    
    Test.add_func("/person/constructor", () => {
            try { person_tests.test_constructor(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/person/real_name", () => {
            try { person_tests.test_real_name(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/person/dates(birth & death)", () => {
            try { person_tests.test_dates(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/person/correct_chronology_in_dates", () => {
            try { person_tests.test_chronology_error(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/person/no_update_if_error_with_dates", () => {
            try { person_tests.test_no_update_if_error_with_dates(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/person/same_birth_death_day", () => {
            try { person_tests.test_same_day_birth_death(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/person/complete_person", () => {
            try { person_tests.test_complete_person(); } catch (Error e) { error(e.message); }
        });

    
}

void add_tests_group(){
    Test.add_func("/group/constructor", () => {
            try { group_tests.test_constructor(); } catch (Error e) { error(e.message); }
        });

     Test.add_func("/group/dates(start & end)", () => {
            try { group_tests.test_dates(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/group/correct_chronology_in_dates", () => {
            try { group_tests.test_chronology_error(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/group/no_update_if_error_with_dates", () => {
            try { group_tests.test_no_update_if_error_with_dates(); } catch (Error e) { error(e.message); }
        });

    Test.add_func("/group/same_start_end_day", () => {
            try { group_tests.test_same_day_start_end(); } catch (Error e) { error(e.message); }
        });
    
    Test.add_func("/group/complete_group", () => {
            try { group_tests.test_complete_group(); } catch (Error e) { error(e.message); }
        });
}


void add_tests_groupMembership(){
    Test.add_func("/groupMembership/constructor", () => {
            try { groupMembership_tests.test_constructor(); } catch (Error e) { error(e.message); }
        });

     Test.add_func("/groupMembership/invalid_ids", () => {
            try { groupMembership_tests.test_invalid_ids(); } catch (Error e) { error(e.message); }
        });

     Test.add_func("/groupMembership/setters", () => {
            try { groupMembership_tests.test_setters(); } catch (Error e) { error(e.message); }
        });
}


