using GLib;
using Sonus.Test.DAO;

static TestDataBaseManager dbm_tests;
static TestSongDAO song_dao;
static TestPerformerDAO performer_dao;
static TestAlbumDAO album_dao;
static TestPersonDAO person_dao;
static TestGroupDAO group_dao;
static TestMembershipDAO membership_dao;

public void add_db_tests() {
    dbm_tests = new TestDataBaseManager();

    Test.add_func("/db/connection", () => {
        try { dbm_tests.test_connection(); }
        catch (Error e) { error(e.message); }
    });
    
    Test.add_func("/db/singleton_consistency", () => { 
        dbm_tests.test_singleton_consistency(); 
    });

    Test.add_func("/db/schema", () => {
        try { dbm_tests.test_schema(); }
        catch (Error e) { error(e.message); }
    });    
}

public void add_dao_tests() {
    song_dao = new TestSongDAO();
    performer_dao = new TestPerformerDAO();
    album_dao = new TestAlbumDAO();
    person_dao = new TestPersonDAO();
    group_dao = new TestGroupDAO();
    membership_dao = new TestMembershipDAO();
    
    add_song_dao_tests();
    add_performer_dao_tests();
    add_album_dao_tests();
    add_person_dao_tests();
    add_group_dao_tests();
    add_membership_dao_tests();
}

private void add_song_dao_tests() {

    Test.add_func("/dao/song/insert", () => {
        try { song_dao.test_insert_song(); }
        catch (Error e) { error("Insert song failed: " + e.message); }
    });

    Test.add_func("/dao/song/update", () => {
        try { song_dao.test_update_song(); }
        catch (Error e) { error("Update song failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_by_id", () => {
        try { song_dao.test_find_by_id(); }
        catch (Error e) { error("Find song by ID failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_by_path", () => {
        try { song_dao.test_find_by_path(); }
        catch (Error e) { error("Find song by path failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_all", () => {
        try { song_dao.test_find_all_songs(); }
        catch (Error e) { error("Find all songs failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_by_performer", () => {
        try { song_dao.test_find_by_performer(); }
        catch (Error e) { error("Find songs by performer failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_by_album", () => {
        try { song_dao.test_find_by_album(); }
        catch (Error e) { error("Find songs by album failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_by_genre", () => {
        try { song_dao.test_find_by_genre(); }
        catch (Error e) { error("Find songs by genre failed: " + e.message); }
    });

    Test.add_func("/dao/song/find_by_title", () => {
        try { song_dao.test_find_by_title(); }
        catch (Error e) { error("Find songs by title failed: " + e.message); }
    });
    
    Test.add_func("/dao/song/complete", () => {
        try { song_dao.test_complete_songDAO(); }
        catch (Error e) { error("Complete song test failed: " + e.message); }
    });
}

private void add_performer_dao_tests(){
    
    Test.add_func("/dao/performer/insert", () => {
        try { performer_dao.test_insert_performer(); }
        catch (Error e) { error("Insert performer failed: " + e.message); }
    });

    Test.add_func("/dao/performer/update", () => {
            try { performer_dao.test_update_performer(); }
            catch (Error e) { error("Update performer failed: " + e.message); }
        });

    Test.add_func("/dao/performer/find by id", () => {
            try { performer_dao.test_find_performer_by_id(); }
            catch (Error e) { error("Finding performer by id failed: " + e.message); }
        });

    Test.add_func("/dao/performer/find by type", () => {
            try { performer_dao.test_find_performers_by_type(); }
            catch (Error e) { error("Finding performers by type failed: " + e.message); }
        });

    Test.add_func("/dao/performer/find by name", () => {
            try { performer_dao.test_find_performers_by_name(); }
            catch (Error e) { error("Finding performers by name failed: " + e.message); }
        });

    Test.add_func("/dao/performer/find all", () => {
            try { performer_dao.test_find_all_performers(); }
            catch (Error e) { error("Finding all performers failed: " + e.message); }
        }); 


    Test.add_func("/dao/performer/complete", () => {
            try { performer_dao.test_complete_performerDAO(); }
            catch (Error e) { error("Complete performer test failed: " + e.message); }
        });
}

private void add_album_dao_tests(){
    Test.add_func("/dao/album/insert", () => {
        try { album_dao.test_insert_album(); }
        catch (Error e) { error("Insert album failed: " + e.message); }
    });

    Test.add_func("/dao/album/update", () => {
            try { album_dao.test_update_album(); }
            catch (Error e) { error("Update album failed: " + e.message); }
        });

    Test.add_func("/dao/album/find by id", () => {
            try { album_dao.test_find_album_by_id(); }
            catch (Error e) { error("Finding album by id failed: " + e.message); }
        });

    Test.add_func("/dao/album/find by year", () => {
            try { album_dao.test_find_album_by_year(); }
            catch (Error e) { error("Finding albums by year failed: " + e.message); }
        });

    Test.add_func("/dao/album/find by name", () => {
            try { album_dao.test_find_albums_by_name(); }
            catch (Error e) { error("Finding albums by name failed: " + e.message); }
        });

    Test.add_func("/dao/album/find by path", () => {
            try { album_dao.test_find_album_by_path(); }
            catch (Error e) { error("Finding album by path failed: " + e.message); }
        });

    Test.add_func("/dao/album/find all", () => {
            try { album_dao.test_find_all_albums(); }
            catch (Error e) { error("Finding all albums failed: " + e.message); }
        });

    Test.add_func("/dao/album/complete", () => {
            try { album_dao.test_complete_albumDAO(); }
            catch (Error e) { error("Complete album DAO test failed: " + e.message); }
        });
}


private void add_person_dao_tests(){
    Test.add_func("/dao/person/insert", () => {
        try { person_dao.test_insert_person(); }
        catch (Error e) { error("Insert person failed: " + e.message); }
    });

    Test.add_func("/dao/person/update", () => {
        try { person_dao.test_update_person(); }
        catch (Error e) { error("Update person failed: " + e.message); }
    });

    Test.add_func("/dao/person/find by id", () => {
        try { person_dao.test_find_person_by_id(); }
        catch (Error e) { error("Finding person by id failed: " + e.message); }
    });

    Test.add_func("/dao/person/find all", () => {
        try { person_dao.test_find_all_persons(); }
        catch (Error e) { error("Finding all persons failed: " + e.message); }
    });

    Test.add_func("/dao/person/complete", () => {
        try { person_dao.test_complete_personDAO(); }
        catch (Error e) { error("Complete person DAO failed: " + e.message); }
    });

}


private void add_group_dao_tests(){
    Test.add_func("/dao/group/insert", () => {
        try { group_dao.test_insert_group(); }
        catch (Error e) { error("Insert group failed: " + e.message); }
    });

    Test.add_func("/dao/group/update", () => {
        try { group_dao.test_update_group(); }
        catch (Error e) { error("Update group failed: " + e.message); }
    });

    Test.add_func("/dao/group/find by id", () => {
        try { group_dao.test_find_group_by_id(); }
        catch (Error e) { error("Finding group by id failed: " + e.message); }
        });

    Test.add_func("/dao/group/find all", () => {
        try { group_dao.test_find_all_groups(); }
        catch (Error e) { error("Finding all groups failed: " + e.message); }
    });

    Test.add_func("/dao/group/complete", () => {
        try { group_dao.test_complete_groupDAO(); }
        catch (Error e) { error("Complete group DAO failed: " + e.message); }
    });

}


private void add_membership_dao_tests(){
    Test.add_func("/dao/membership/insert", () => {
        try { membership_dao.test_insert_membership(); }
        catch (Error e) { error("Insert membership failed: " + e.message); }
    });

    Test.add_func("/dao/membership/find groups by person id", () => {
        try { membership_dao.test_find_groups_by_person_id(); }
        catch (Error e) { error("Finding groups by person id failed: " + e.message); }
    });

    Test.add_func("/dao/membership/find persons by group id", () => {
        try { membership_dao. test_find_persons_by_group_id(); }
        catch (Error e) { error("Finding persons by group id failed: " + e.message); }
    });

    Test.add_func("/dao/membership/find all memberships", () => {
        try { membership_dao. test_find_all_memberships(); }
        catch (Error e) { error("Finding all memberships failed: " + e.message); }
    });

    Test.add_func("/dao/membership/complete", () => {
        try { membership_dao. test_complete_membershipDAO(); }
        catch (Error e) { error("Complete membership DAO test failed:  " + e.message); }
    });
}