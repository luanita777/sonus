using GLib;
using Sqlite;
using Gee;
using Sonus.Db;
using Sonus.DAO;

namespace Sonus.Test.DAO {

    public class TestPerformerDAO : BaseTest {

        public TestPerformerDAO() {}

        public void test_insert_performer() throws Error {
            setup();
            var dao = new DAO();
            var performer = new Performer("Performer 1");
            dao.insert_performer(performer);

            int id = get_id_by_name("Performer 1");
            assert(id > 0);

            var db = open_db();
            
            Statement stmt;
            string query = "SELECT type, name FROM performers WHERE id_performer = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            stmt.bind_int(1, id);
            assert(rc == Sqlite.OK);

            if (stmt.step() == Sqlite.ROW) {
                assert(stmt.column_int(0) == (int)PerformerType.UNKNOWN);
                assert(stmt.column_text(1) == "Performer 1");
            } else {
                Test.fail("Performer did not write on the db.");
            }
            
            cleanup();
        }

        
        public void test_update_performer() throws Error{
            setup();
            
            var dao = new DAO();            
            var p = new Performer("Unknown Artist");
            dao.insert_performer(p);
                       
            int id = get_id_by_name("Unknown Artist");

            p.set_id(id);            
            p.set_type(PerformerType.PERSON);
            p.set_name("Solo Singer");
            dao.update_performer(p);

            var updated = dao.find_performer_by_id(id);
            assert(updated != null);
            assert(updated.get_id() == id);
            assert(updated.get_performer_type() == PerformerType.PERSON);
            assert(updated.get_name() == "Solo Singer");
            
            cleanup();
        }

        
        public void test_find_performer_by_id() throws Error {
            setup();
            
            var dao = new DAO();
            assert(dao.find_performer_by_id(9999) == null);
            assert(dao.find_performer_by_id(-5) == null);

            var p = new Performer("Unknown Artist");
            dao.insert_performer(p);
            int id = get_id_by_name("Unknown Artist");
            
            p.set_id(id);            
            p.set_type(PerformerType.PERSON);
            p.set_name("Solo Singer");
            dao.update_performer(p);

            var db = open_db();

            Statement stmt;
            string query = "SELECT type, name FROM performers WHERE id_performer = ?";
            db.prepare_v2(query, -1, out stmt);
            stmt.bind_int(1, id);
            var performerCheck = dao.find_performer_by_id(id);
            
            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_int(0) == (int)performerCheck.get_performer_type());
                assert(stmt.column_text(1) == performerCheck.get_name());                
            } else {
                Test.fail("Error: Didn't find performer by its id.");
            }

            cleanup();
        }

        
        public void test_find_all_performers() throws Error{
            setup();
            var dao = new DAO();
            assert(dao.find_all_performers().size == 0);
            
            for(int i=0; i < 100; i++)
                dao.insert_performer(new Performer("Performer %d".printf(i)));

            var all_performers = dao.find_all_performers();
            assert(all_performers.size == 100);

            for(int i = 0; i < all_performers.size; i++) {
                var p = all_performers.get(i);                            
                assert(p.get_name() == "Performer %d".printf(i));
                assert(p.get_id() > 0);
            }
            
            cleanup();            
            
        }

        
        public void test_find_performer_by_type() throws Error{
            setup();
            var dao = new DAO();
            
            dao.insert_performer(new Performer(PerformerType.PERSON, "P1"));
            dao.insert_performer(new Performer(PerformerType.PERSON, "P2"));
            dao.insert_performer(new Performer( PerformerType.GROUP, "G1"));

            var persons = dao.find_performers_by_type(PerformerType.PERSON);
            var groups = dao.find_performers_by_type(PerformerType.GROUP);

            assert(persons.size == 2);
            assert(groups.size == 1);
            
            cleanup();
        }

        
        public void test_find_performer_by_stage_name() throws Error {
            setup();
            var dao = new DAO();
            
            dao.insert_performer(new Performer("Performer 1"));
            dao.insert_performer(new Performer("Performer 2"));
            
            var results = dao.find_performers_by_stage_name("Performer 2");
            
            assert(results.size == 1);
            assert(results.get(0).get_name() == "Performer 2");
            
            var no_results = dao.find_performers_by_stage_name("Fake Name");
            
            assert(no_results.size == 0);
            
            cleanup();
        }      

        
        public void test_complete_performerDAO() throws Error{
            setup();
            var dao = new DAO();
            var random = new Random();
            var performerList = new HashMap<int, Performer>();
            int total = 100;
            
            for (int i = 0; i < total; i++) {
                var type = (i % 2 == 0) ? PerformerType.PERSON : PerformerType.GROUP;
                var p = new Performer("Name_%d".printf(i), -1, type) 
                dao.insert_performer(p);

                int id = get_id_by_name("Name_%d".printf(i));
                assert(id > 0);
                p.set_id(id);
                performerList.set(id, p);
            }

            var all_from_db = dao.find_all_performers();
            assert(all_from_db.size == total);

            foreach(var db_performer in all_from_db){
                var expected = performerList.get(db_performer.get_id());
                assert(expected != null);
                assert(db_performer.get_name() == expected.get_name());
                assert(db_performer.get_performer_type() == expected.get_performer_type());
            }

            foreach (var id in performerList.get_keys()){
                if(id % 2 == 0){
                    var p = performerList.get(id);
                    p.set_name("Updated_" + p.get_name());
                    dao.update_performer(p);
                }
            }

            var db = open_db();
            Statement stmt;
            db.prepare_v2("SELECT count(*) FROM performers", -1, out stmt);
            if (stmt.step() == Sqlite.ROW) 
                assert(stmt.column_int(0) == total);
                    
            cleanup();
        }
        
        
        private int get_id_by_name(string name) {
            var db = open_db();
            Statement stmt;
            db.prepare_v2("SELECT id_performer FROM performers WHERE name = ?", -1, out stmt);
            stmt.bind_text(1, name);
            if (stmt.step() == Sqlite.ROW)
                return stmt.column_int(0);
            return -1;
        }
        
          
    }
}