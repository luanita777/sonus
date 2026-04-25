using GLib;
using Sqlite;
using Gee;
using Sonus;
using Sonus.Db;

namespace Sonus.Test.DAO {

    public class TestPersonDAO : BaseTest {

        public TestPersonDAO() {}

        public void test_insert_person() throws Error {
            setup();
            var dao = get_dao();
            
            string stage_name = "stage name";
            int id = new_performer(stage_name);
            assert(id > 0);
            
            string real_name = "real name";
            var p = new Person(id, stage_name, real_name, "1947-01-08", "2016-01-10");            
            dao.insert_person(p);

            var db = open_db();
            Statement stmt_p;
            Statement stmt_pers;

            string query_p = "SELECT name, id_type FROM performers WHERE id_performer = ?";
            var rc_p = db.prepare_v2(query_p, -1, out stmt_p);
            assert(rc_p == Sqlite.OK);
            stmt_p.bind_int(1, id);

            string query_pers = "SELECT stage_name, real_name, birth_date, death_date FROM persons WHERE id_person = ?";
            var rc_pers = db.prepare_v2(query_pers, -1, out stmt_pers);
            assert(rc_pers == Sqlite.OK);
            stmt_pers.bind_int(1, id);

            if (stmt_p.step() == Sqlite.ROW && stmt_pers.step() == Sqlite.ROW) {
                assert(stmt_p.column_text(0) == stage_name);
                assert(stmt_p.column_int(1) == (int)PerformerType.PERSON); 

                assert(stmt_pers.column_text(0) == stage_name);
                assert(stmt_pers.column_text(1) == real_name);
                assert(stmt_pers.column_text(2) == "1947-01-08");
                assert(stmt_pers.column_text(3) == "2016-01-10");
            } else {
                assert_not_reached();
            }
            
            cleanup();
        }

        public void test_update_person() throws Error {
            setup();
            var dao = get_dao();
            
            int id = new_performer("Stage name");
            assert(id > 0);
            
            var p = new Person(id, "Stage name", "Real name", "1980-01-01");
            dao.insert_person(p);

            p.set_name("New Stage Name");
            p.set_real_name("New Real Name");
            p.set_death_date("2020-12-31");
            dao.update_person(p);

            var db = open_db();
            Statement stmt;
            
            string query = "SELECT p.id_type, p.name, ps.stage_name, ps.real_name, ps.birth_date, ps.death_date " +
                "FROM performers p JOIN persons ps ON p.id_performer = ps.id_person " +
                "WHERE p.id_performer = ?";               
                
            var rc = db.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            stmt.bind_int(1, id);
            
            if (stmt.step() == Sqlite.ROW) {
                assert(stmt.column_int(0) == (int)PerformerType.PERSON);
                assert(stmt.column_text(1) == "New Stage Name");
                assert(stmt.column_text(2) == "New Stage Name");
                assert(stmt.column_text(3) == "New Real Name");
                assert(stmt.column_text(4) == "1980-01-01"); 
                assert(stmt.column_text(5) == "2020-12-31");
            } else {
                assert_not_reached(); 
            }
            
            cleanup();
        }

        public void test_find_person_by_id() throws Error {
            setup();
            var dao = get_dao();

            int id = new_performer("Stage name");
            var p = new Person(id, "Stage name", "Real name", "1995-05-05");
            dao.insert_person(p);

            var db = open_db();
            Statement stmt;

            string query = "SELECT p.id_type, p.name, ps.stage_name, ps.real_name FROM performers p " +
                "JOIN persons ps ON p.id_performer = ps.id_person " +
                "WHERE p.id_performer = ?";
            var rc = db.prepare_v2(query, -1, out stmt);
            stmt.bind_int(1, id);
            assert(rc == Sqlite.OK);

            var personCheck = dao.find_person_by_id(id);
            assert(personCheck != null);

            if (stmt.step() == Sqlite.ROW) {
                assert(stmt.column_int(0) == personCheck.get_performer_type());
                assert(stmt.column_text(1) == personCheck.get_name());
                assert(stmt.column_text(2) == personCheck.get_name());
                assert(stmt.column_text(3) == personCheck.get_real_name());
            } else {
                assert_not_reached();
            }
            
            cleanup();
        }

        public void test_find_all_persons() throws Error {
            setup();
            var dao = get_dao();
            int total = 100;
            
            assert(dao.find_all_persons().size == 0);

            for (int i = 0; i < total; i++) {
                int id = new_performer("S_%d".printf(i));
                dao.insert_person(new Person(id, "S_%d".printf(i), "R_%d".printf(i), "1900-01-01"));
            }

            var all = dao.find_all_persons();
            assert(all.size == total);

            foreach (var p in all) {
                assert(p.get_performer_type() == (int)PerformerType.PERSON);
                assert(p.get_name().contains("S_"));
                assert(p.get_real_name().contains("R_"));
                assert(p.get_birth_date() == "1900-01-01");
                assert(p.get_death_date() == null);
                assert(p.get_id() > 0);
            }
            
            cleanup();
        }

        public void test_complete_personDAO() throws Error {
            setup();
            var dao = get_dao();
            var db = open_db(); 
            int total = 100;
            var ids = new ArrayList<int>();

            for (int i = 0; i < total; i++) {
                string name = "Original_%d".printf(i);
                int id = new_performer(name);
                var p = new Person(id, name, "RealName", "2000-01-01");
                dao.insert_person(p);
                ids.add(id);
            }

            var all_from_db = dao.find_all_persons();                        
            assert(all_from_db.size == total);
           
            
            foreach (int id in ids) {
                if (id % 2 == 0) {
                    var p = dao.find_person_by_id(id);
                    p.set_name("Updated_%d".printf(id));
                    dao.update_person(p);
                }
            }

            Statement stmt;

            var rc_p = db.prepare_v2("SELECT count(*) FROM performers", -1, out stmt);
            assert(rc_p == Sqlite.OK);
            if(stmt.step() == Sqlite.ROW)
                assert(stmt.column_int(0) == total);

            var rc_g = db.prepare_v2("SELECT count(*) FROM persons", -1, out stmt);
            assert(rc_g == Sqlite.OK);
            if (stmt.step() == Sqlite.ROW)
                assert(stmt.column_int(0) == total);
            
            foreach (int id in ids) {
                Statement stmt2;
                var query = "SELECT p.name, ps.stage_name FROM performers p JOIN persons ps " +
                    "ON p.id_performer = ps.id_person WHERE p.id_performer = ?";
                var rc = db.prepare_v2(query, -1, out stmt2);
                stmt2.bind_int(1, id);
                assert(rc == Sqlite.OK);
                
                if (stmt2.step() == Sqlite.ROW) {
                    string p_name = stmt2.column_text(0);
                    string ps_name = stmt2.column_text(1);
                    assert((p_name == ps_name));
                    
                    if (id % 2 == 0)                         
                        assert(p_name.contains("Updated_") && ps_name.contains("Updated_"));
                    else                      
                        assert(p_name.contains("Original_") && ps_name.contains("Original_"));
                    
                } else {
                    assert_not_reached();
                }
                
            }
            
            cleanup();

        }
        
        private int new_performer(string name)  throws Error{            
            var db = open_db();
            Statement stmt;
            db.prepare_v2("INSERT INTO performers (name, id_type) VALUES (?, ?)", -1, out stmt);
            stmt.bind_text(1, name);
            stmt.bind_int(2, (int)PerformerType.UNKNOWN);
            stmt.step();
            return (int)db.last_insert_rowid();
        }
         
    }
}