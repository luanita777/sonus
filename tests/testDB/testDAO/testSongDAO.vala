using GLib;
using Sqlite;
using Gee;
using Sonus.Db;
using Sonus.DAO;

namespace Sonus.Test.DAO {
    
    public class TestSongDAO : BaseTest {
        
        public TestSongDAO() {}
        
        // == TEST METHODS == //
        
        public void test_insert_song() throws Error {
            setup();
            var dao = new DAO();
            var song = new Song(-1, "Test Song", "/path/1.mp3"); 
            song.set_track(7);            
            dao.insert_song(song);
            
            var db_check = open_db();            
            Statement stmt;
            string query = "SELECT title, track, path FROM rolas WHERE title = 'Test Song'";
            var rc = db_check.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            
            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == "Test Song");
                assert(stmt.column_int(1) == 7);
                assert(stmt.column_text(2) == "/path/1.mp3");
            } else {
                Test.fail("Song did not write on the db.");
            }
            cleanup();
        }
        
        public void test_update_song() throws Error {
            setup();
            
            var dao = new DAO();
            var song = new Song(-1, "Original", 1, "/path.mp3");
            dao.insert_song(song);

            int id = dao.find_song_by_path("/path.mp3").get_id();

            song.set_title("New Title");
            song.set_track(99);
            song.set_genre("Genre");
            dao.insert_song(song);

            var updated = dao.find_song_by_id(original_id);
            assert(updated != null);
            assert(updated.get_id() == id);
            assert(updated.get_title() == "New Title");
            assert(updated.get_track() == 99);
            
            cleanup();
        }

        public void test_find_by_id() throws Error {    
            setup();
            
            var dao = new DAO();
            assert(dao.find_song_by_id(9999) == null);
            assert(dao.find_by_id(-5) == null);

            var song = new Song(-1, "Test Song", 3, "/path.mp3");
            dao.insert_performer(song);
            int id = get_id_by_name("Test Song");
            
            var db_check = open_db();
            
            Statement stmt;
            string query = "SELECT title, id_performer, path FROM rolas WHERE id_rola = 5";
            db_check.prepare_v2(query, -1, out stmt);
            var songCheck = dao.find_song_by_id(id);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == songCheck.get_title());
                assert(stmt.column_int(1) == songCheck.get_performer_id());
                assert(stmt.column_text(2) == songCheck.get_path());
            } else {
                Test.fail("Error: Didn't find song by its id.");
            }
            cleanup();
        }

        public void test_find_by_path() throws Error {
            setup();
            
            var dao = new SongDAO();
            string path = "/music/album/song.mp3";
            dao.insert_song(new Song(-1, "Song", 1, path));

            var found = dao.find_by_path(path);
            assert(found != null);
            assert(found.get_path() == path);
            assert(dao.find_song_by_path("/other/path.mp3") == null);

            var db_check = open_db();
            
            Statement stmt;
            string query = "SELECT id_rola, title, id_performer FROM rolas WHERE path = '/music/album/song.mp3'";
            db_check.prepare_v2(query, -1, out stmt);
            var songCheck = dao.find_by_path(path);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_int(0) == songCheck.get_id());
                assert(stmt.column_text(1) == songCheck.get_title());
                assert(stmt.column_int(2) == songCheck.get_performer_id());
            } else {
                Test.fail("Error: Didn't find song by path in DB.");
            }
            cleanup();
        }

        public void test_find_all_songs() throws Error {
            setup();           
            var dao = new SongDAO();
            assert(dao.find_all_songs().size == 0);
            
            for (int i = 0; i < 100; i++) 
                dao.insert_song(new Song("Song %d".printf(i), 1, "p%d.mp3".printf(i)));
            var all_songs = dao.find_all_songs();
            assert(all_songs.size == 100);

            for(int i = 0;  i < all_songs.size; i++){
                var s = all_songs.get(i);
                assert(s.get_title() == "Song %d".printf(i));
                assert(s.get_id() > 0);
                assert(s.get_path == "p%d.mp3".printf(i));
            }            
            
            cleanup();
        }

        public void test_find_by_performer() throws Error {
            setup();
            
            var dao = new DAO();
            var expected_songs = new ArrayList<Song>();
            
            int target_performer_id = Random.int_range(1, 10);
            int other_performer_id = Random.int_range(11, 20);
            
            for (int i = 0; i < 10; i++) {
                int p_id = (i % 2 == 0) ? target_performer_id : other_performer_id;
                var s = new Song(-1, "Song %d".printf(i), p_id, "/path/%d.mp3".printf(i));
                dao.insert_song(s);
                
                if (p_id == target_performer_id) 
                    expected_songs.add(s);            
            }
                
            var result_songs = dao.find_by_performer_id(target_performer_id);      
            assert(result_songs.size == expected_songs.size);        
            for (int i = 0; i < result_songs.size; i++) {
                var actual = result_songs.get(i);
                var expected = expected_songs.get(i);
                
                assert(actual.get_id() == expected.get_id());
                assert(actual.get_title() == expected.get_title());
                assert(actual.get_performer_id() == target_performer_id);
                assert(actual.get_path() == expected.get_path());
            }            
            assert(dao.find_by_performer_id(999).size == 0);
            
            cleanup();
        }

        public void test_find_by_album() throws Error {
            setup();
            
            var dao = new DAO();
            var expected_album_songs = new ArrayList<Song>();
            int target_album_id = Random.int_range(1, 10);

            for (int i = 0; i < 3; i++) {
                var s = new Song(-1, "In Album %d".printf(i), 1, "album_%d.mp3".printf(i), target_album_id);
                dao.insert_song(s);
                expected_album_songs.add(s);
            }
            
            dao.insert_song(new Song(-1, "Single 1", 1, "single1.mp3", null));
            dao.insert_song(new Song(-1, "Single 2", 1, "single2.mp3", null));
            dao.insert_song(new Song(-1, "Other Album", 1, "other.mp3", 99));
            
            var result = dao.find_by_album_id(target_album_id);
            assert(result.size == expected_album_songs.size);
            
            foreach (var song in result) {
                assert(song.get_album_id() == target_album_id);
                bool found = false;
                foreach (var exp in expected_album_songs) {
                    if (exp.get_id() == song.get_id()) found = true;
                }
                assert(found);
            }
            cleanup();
        }

        public void test_complete_songDAO() throws Error {
            setup();
            
            var dao = new DAO();
            var random = new Random();
            var songList = new HashMap<int, Song>();

            for (int i = 0; i < 100; i++) {
                int p_id = random.next_int(1, 10); 
                int? a_id = (i % 5 == 0) ? null : random.next_int(1, 5);
                
                var s = new Song(-1, "Song Test %d".printf(i), p_id, "/path/song_%d.mp3".printf(i), a_id);
                if (i % 2 == 0)
                    s.set_year(1990 + (i % 30));
                
                dao.insert_song(s);
                int id = get_id_by_name("Song Test %d".printf(i));
                assert(id > 0);
                s.set_id(id);
                songList.set(id, s);
            }

            var all_from_db = dao.find_all_songs();
            assert(all_from_db.size == 100);
            
            foreach (var db_song in all_from_db) {
                var expected = songList.get(db_song.get_id());
                assert(expected != null);
                assert(db_song.get_title() == expected.get_title());
                assert(db_song.get_path() == expected.get_path());
            }

            foreach (var id in songList.get_keys()) {
                if (id % 2 == 0) {
                    var s = songList.get(id); 
                    s.set_title("Updated_" + s.get_title());
                    dao.update_song(s);
                }
            }

            var performer3_db = dao.find_by_performer_id(3);
            int expected_count_p3 = 0;
            foreach (var s in songList.get_values()) {
                if (s.get_performer_id() == 3)
                    expected_count_p3++;
            }
            assert(performer3_db.size == expected_count_p3);
            
            var db_check = open_db();
            
            Statement stmt;
            db_check.prepare_v2("SELECT count(*) FROM rolas", -1, out stmt);
            if (stmt.step() == Sqlite.ROW) 
                assert(stmt.column_int(0) == songList.size);
                    
            cleanup();
        }


         private int get_id_by_name(string name) {
            var db = open_db();
            Statement stmt;
            db.prepare_v2("SELECT id_rola FROM rolas WHERE name = ?", -1, out stmt);
            stmt.bind_text(1, name);
            if (stmt.step() == Sqlite.ROW)
                return stmt.column_int(0);
            return -1;
        }
        
    }
    
}