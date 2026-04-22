using GLib;
using Sqlite;
using Gee;
using Sonus.Db;

namespace Sonus.Test.DAO {

    public class TestAlbumDAO : BaseTest {

        public TestAlbumDAO() {}

        public void test_insert_album() throws Error {
            setup();
            
            var dao = new DAO();
            var album = new Album("Album test", "path/");
            dao.insert_album(album);

            int id = get_id_by_title("Album test");
            assert(id > 0);

            var db = open_db();

            Statement stmt;
            string query = "SELECT name, path FROM albums WHERE id_album = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            stmt.bind_int(1, id);
            assert(rc == Sqlite.OK);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == "Album test");
                assert(stmt.column_text(1) == "path/");                
            } else{
                Test.fail("Album did not write on the db.");
            }

            cleanup();

            
        }

        public void test_update_album() throws Error{
            setup();

            var dao = new DAO();
            var a = new Album("Album test", "path/album/");
            dao.insert_album(a);

            int id = get_id_by_title("Album test");
            a.set_id(id);
            a.set_name("new Album");
            a.set_path("path/new/Album");
            a.set_year(2020);
            dao.update_album(a);

            var updated = dao.find_album_by_id(id);
            assert(updated != null);
            assert(updated.get_id() == id);
            assert(updated.get_name() == "new Album");
            assert(updated.get_path() == "path/new/Album");
            assert(updated.get_year() == 2020);
            
            cleanup();
        }

        public void test_find_album_by_id() throws Error {
            setup();

            var dao = new DAO();
            assert(dao.find_album_by_id(9999) == null);
            assert(dao.find_album_by_id(-5) == null);

            var a = new Album("Album test", "path/album/");
            dao.insert_album(a);
            int id = get_id_by_title("Album test");

            a.set_id(id);
            a.set_name("new Album");
            a.set_path("path/new/Album");
            a.set_year(2020);
            dao.update_album(a);

            var updated = dao.find_album_by_id(id);
            assert(updated != null);            
            
            var db = open_db();

            Statement stmt;
            string query = "SELECT name, path, year FROM albums WHERE id_album = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            stmt.bind_int(1, id);
            assert(rc == Sqlite.OK);
            var albumCheck = dao.find_album_by_id(id);

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_text(0) == albumCheck.get_name());
                assert(stmt.column_text(1) == albumCheck.get_path());
                assert(stmt.column_int(2) == albumCheck.get_year());
            } else {
                Test.fail("Error: Didn´t find album by it's id.");
            }
            
            cleanup();            
        }

        public void test_find_all_albums() throws Error{
            setup();

            var dao = new DAO();
            assert(dao.find_all_albums().size == 0);

            for(int i=0; i < 100; i++)
                dao.insert_album(new Album("Album %d".printf(i), "/path/album%d".printf(i)));

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
            var dao = new DAO();
            
            dao.insert_album(new Album("Album A", 2020));
            dao.insert_album(new Album("Album B", 2020));
            dao.insert_album(new Album("Album C", 2021));
            var albums_2020 = dao.find_albums_by_year(2020);
            assert(albums_2020.size == 2);

            var album_2021 = dao.find_albums_by_year(2021);
            assert(album_2021.size == 1);
            assert(album_2021.get(0).get_title() == "Album C");

            var no_results = dao.find_albums_by_year(1990);
            assert(no_results.size == 0);
    
            cleanup();
                
        }

        public void test_find_albums_by_name() throws Error{
            setup();
            var dao = new DAO();

            dao.insert_album(new Album("Album 1", "/path/1"));
            dao.insert_album(new Album("Album 2", "/path/2"));

            var results = dao.find_albums_by_name("Album 2");
            assert(results.size == 1);
            assert(results.get(0).get_name() == "Album 2");
            assert(results.get(0).get_path() == "/path/2");

            var no_results = dao.find_albums_by_name("NotAlbum");
            assert(no_results.size == 0);
            cleanup();
        }

        public void test_complete_albumDAO() throws Error {
            setup();
            var dao = new AlbumDAO();
            var albumList = new HashMap<int, Album>();
            int total = 100; 

            for (int i = 0; i < total; i++) {
                int year = 2000 + (i % 20); 
                var album = new Album("Album_%d".printf(i), year);
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
                assert(db_album.get_title() == expected.get_title());
                assert(db_album.get_year() == expected.get_year());
            }
            
            foreach (var id in albumList.get_keys()) {
                if (id % 2 == 0) {
                    var a = albumList.get(id);
                    a.set_title("Updated_" + a.get_title());
                    a.set_year(2026); 
                    dao.update_album(a);
                }
            }
            
            var db = open_db();
            Statement stmt;
            db.prepare_v2("SELECT count(*) FROM albums", -1, out stmt);
            if (stmt.step() == Sqlite.ROW) 
                assert(stmt.column_int(0) == total);
                                  
            cleanup();
        }

        
        private int get_id_by_title(string title) {
            var db = open_db();
            Statement stmt;
            db.prepare_v2("SELECT id_album FROM albums WHERE title = ?", -1, out stmt);
            stmt.bind_text(1, title);
            if (stmt.step() == Sqlite.ROW)
                return stmt.column_int(0);
            return -1;
        }

        
          
    }
}