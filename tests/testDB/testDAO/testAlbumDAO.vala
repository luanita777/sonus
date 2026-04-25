using GLib;
using Sqlite;
using Gee;
using Sonus.Db;

namespace Sonus.Test.DAO {

    public class TestAlbumDAO : BaseTest {

        public TestAlbumDAO() {}

        public void test_insert_album() throws Error {
            setup();            
            var dao = get_dao();

            var path = "/test/duplicated";
            dao.insert_album(new Album(-1, "Original", path, null));
            dao.insert_album(new Album(-1, "Duplicated", path, null));
            var all = dao.find_all_albums();
            assert(all.size == 1);

            
            var album = new Album(-1, "Album test", "path/", null);
            dao.insert_album(album);
            int id = get_id_by_title("Album test");
            assert(id > 0);
            
            var db = open_db();
            Statement stmt;
            string query = "SELECT name, path FROM albums WHERE id_album = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            stmt.bind_int(1, id);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == "Album test");
                assert(stmt.column_text(1) == "path/");                
            } else{
                assert_not_reached();
            }

            cleanup();

            
        }

        public void test_update_album() throws Error{
            setup();

            var dao = get_dao();
            var a = new Album(-1, "Album test", "path/album/", null);
            dao.insert_album(a);

            int id = get_id_by_title("Album test");
            a.set_id(id);
            a.set_name("new Album");
            a.set_path("path/new/Album");
            a.set_year(2020);
            dao.update_album(a);

            var db = open_db();
            Statement stmt;
            string query = "SELECT name, path, year FROM albums WHERE id_album = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            stmt.bind_int(1, id);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == "new Album");
                assert(stmt.column_text(1) == "path/new/Album");
                assert(stmt.column_int(2) == 2020);
            } else {
                assert_not_reached();
            }
            
            cleanup();
        }

        public void test_find_album_by_id() throws Error {
            setup();

            var dao = get_dao();
            assert(dao.find_album_by_id(9999) == null);
            assert(dao.find_album_by_id(-5) == null);

            var a = new Album(-1,"Album test", "path/album/", null);
            dao.insert_album(a);
            int id = get_id_by_title("Album test");

            a.set_id(id);
            a.set_name("new Album");
            a.set_path("path/new/Album");
            a.set_year(2020);
            dao.update_album(a);                       
            
            var db = open_db();

            Statement stmt;
            string query = "SELECT name, path, year FROM albums WHERE id_album = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            stmt.bind_int(1, id);
            var albumCheck = dao.find_album_by_id(id);
            assert(albumCheck != null);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == albumCheck.get_name());
                assert(stmt.column_text(1) == albumCheck.get_path());
                assert(stmt.column_int(2) == albumCheck.get_year());
            } else {
                assert_not_reached();
            }
            
            cleanup();            
        }

        public void test_find_all_albums() throws Error{
            setup();

            var dao = get_dao();
            assert(dao.find_all_albums().size == 0);

            for(int i=0; i < 100; i++)
                dao.insert_album(new Album(-1, "Album %d".printf(i), "/path/album%d".printf(i), null));

            var all_albums = dao.find_all_albums();
            assert(all_albums.size == 100);

            for(int i = 0; i < all_albums.size; i++){
                var a = all_albums.get(i);
                assert(a.get_name() == "Album %d".printf(i));
                assert(a.get_path() ==  "/path/album%d".printf(i));
                assert(a.get_id() > 0);
            }
            
            cleanup();
        }

        public void test_find_album_by_year() throws Error{
            setup();       
            var dao = get_dao();
            
            dao.insert_album(new Album(-1, "Album A", "path/AlbumA", 2020));
            dao.insert_album(new Album(-1, "Album B", "path/AlbumB", 2020));
            dao.insert_album(new Album(-1, "Album C", "path/AlbumC", 2021));
            var albums_2020 = dao.find_albums_by_year(2020);
            assert(albums_2020.size == 2);

            var album_2021 = dao.find_albums_by_year(2021);
            assert(album_2021.size == 1);
            assert(album_2021.get(0).get_name() == "Album C");

            var no_results = dao.find_albums_by_year(1990);
            assert(no_results.size == 0);
    
            cleanup();
                
        }

        public void test_find_albums_by_name() throws Error {
            setup();
            var dao = get_dao();
                   
            dao.insert_album(new Album(-1, "Classic Rock Album", "/path/1", null));
            dao.insert_album(new Album(-1, "Jazz Rock Mix", "/path/2", null));
            dao.insert_album(new Album(-1, "Pop Hits", "/path/3", null));
            
            var results = dao.find_albums_by_name("Rock");
            assert(results.size == 2);
            
            var exact_result = dao.find_albums_by_name("Classic Rock Album");
            assert(exact_result.size == 1);
            assert(exact_result.get(0).get_name() == "Classic Rock Album");
           
            var no_results = dao.find_albums_by_name("Heavy Metal");
            assert(no_results.size == 0);
            
            cleanup();
        }
        

        public void test_find_album_by_path() throws Error {
            setup();
            
            var dao = get_dao();
            string path = "/music/album/";
            dao.insert_album(new Album(-1, "Album", path, 2026));

            var found = dao.find_album_by_path(path);
            assert(found != null);
            assert(found.get_path() == path);
            assert(dao.find_album_by_path("/other/path/") == null);
            
            var db_check = open_db();
            
            Statement stmt;
            string query = "SELECT id_album, name, year FROM albums WHERE path = ?";
            db_check.prepare_v2(query, -1, out stmt);
            stmt.bind_text(1, path);
            
            var albumCheck = dao.find_album_by_path(path);
            
            if(stmt.step() == Sqlite.ROW) {
                assert(stmt.column_int(0) == albumCheck.get_id());
                assert(stmt.column_text(1) == albumCheck.get_name());
                assert(stmt.column_int(2) == albumCheck.get_year());
            } else {
                assert_not_reached();
            }
            cleanup();
        }
        

        public void test_complete_albumDAO() throws Error {
            setup();
            var dao = get_dao();
            var albumList = new HashMap<int, Album>();
            int total = 100; 

            for (int i = 0; i < total; i++) {
                int year = 2000 + (i % 20); 
                var album = new Album(-1, "Album_%d".printf(i), "path/%d".printf(i), year);
                dao.insert_album(album);
                
                int id = get_id_by_title("Album_%d".printf(i));
                assert(id > 0);                
                album.set_id(id);
                albumList.set(id, album);
            }
            
            var all_from_db = dao.find_all_albums();
            assert(all_from_db.size == total);
            
            foreach (var db_album in all_from_db) {
                var expected = albumList.get(db_album.get_id());
                assert(expected != null);
                assert(db_album.get_name() == expected.get_name());
                assert(db_album.get_year() == expected.get_year());
            }
            
            foreach (var id in albumList.keys) {
                if (id % 2 == 0) {
                    var a = albumList.get(id);
                    a.set_name("Updated_" + a.get_name());
                    a.set_year(2026); 
                    dao.update_album(a);
                }
            }
            
            var db = open_db();
            Statement stmt;
            var rc = db.prepare_v2("SELECT count(*) FROM albums", -1, out stmt);
            assert(rc == Sqlite.OK);
            if (stmt.step() == Sqlite.ROW) 
                assert(stmt.column_int(0) == total);
                                  
            cleanup();
        }

        
        private int get_id_by_title(string title)  throws Error{
            var db = open_db();
            Statement stmt;
            db.prepare_v2("SELECT id_album FROM albums WHERE name = ?", -1, out stmt);
            stmt.bind_text(1, title);
            if (stmt.step() == Sqlite.ROW)
                return stmt.column_int(0);
            return -1;
        }

        
          
    }
}