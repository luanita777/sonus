using GLib;
using Sqlite;
using Gee;
using Sonus.Db;

namespace Sonus.Test.DAO {

    public class TestGroupDAO : BaseTest {

        public TestGroupDAO() {}

        public void test_insert_group() throws Error {
            setup();
            var dao = get_dao();
            
            string name = "Group 1";
            int id = new_performer(name);
            assert(id > 0);
            
            var group = new Group(id, name, "1960-01-01","1970-01-01");
            dao.insert_group(group);


            var db = open_db();
            Statement stmt_p;
            Statement stmt_g;

            string query_p = "SELECT name, id_type FROM performers WHERE id_performer = ?";
            var rc_p = db.prepare_v2(query_p, -1, out stmt_p);
            assert(rc_p == Sqlite.OK);
            stmt_p.bind_int(1, id);
            
            string query_g = "SELECT name, start_date, end_date FROM groups WHERE id_group = ?";
            var rc_g = db.prepare_v2(query_g, -1, out stmt_g);
            assert(rc_g == Sqlite.OK);
            stmt_g.bind_int(1, id);

            if(stmt_p.step() == Sqlite.ROW && stmt_g.step() == Sqlite.ROW){
                string name_p = stmt_p.column_text(0);
                string name_g = stmt_g.column_text(0);

                assert(name_p == name);
                assert(name_g == name);
                assert(name_p == name_g);

                assert(stmt_p.column_int(1) == (int)PerformerType.GROUP);
                assert(stmt_g.column_text(1) == "1960-01-01");
                assert(stmt_g.column_text(2) == "1970-01-01");
            } else {
                assert_not_reached();
            }
            
            cleanup();
        }

        public void test_update_group() throws Error{
            setup();
            var dao = get_dao();

            int id = new_performer("Original Name");
            assert(id > 0);
            
            var g = new Group(id, "Original Name", "2000-01-01");
            dao.insert_group(g);

            g.set_name("Updated Name");
            g.set_end_date("2024-01-01");
            dao.update_group(g);

            var db = open_db();
            Statement stmt;

            string query = "SELECT p.id_type, p.name, g.name, g.start_date, g.end_date " +
                "FROM performers p JOIN groups g ON p.id_performer = g.id_group " +
                "WHERE p.id_performer = ?";

            var rc = db.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            stmt.bind_int(1, id);

            if(stmt.step() == Sqlite.ROW){            
                assert(stmt.column_int(0) == (int)PerformerType.GROUP);
                assert(stmt.column_text(1) == "Updated Name");
                assert(stmt.column_text(2) == "Updated Name");             
                assert(stmt.column_text(3) == "2000-01-01"); 
                assert(stmt.column_text(4) == "2024-01-01");
            } else{
                assert_not_reached();
            }
            
            cleanup();               
        }

        public void test_find_group_by_id() throws Error {
            setup();
            var dao = get_dao();

            int id = new_performer("Group");
            assert(id > 0);
            var g = new Group(id, "Group", "1968-01-01", "1980-01-01");
            dao.insert_group(g);

            var db = open_db();
            Statement stmt;
             string query = "SELECT p.id_type, p.name, g.name, g.start_date, g.end_date " +
                "FROM performers p JOIN groups g ON p.id_performer = g.id_group " +
                "WHERE p.id_performer = ?";

            var rc = db.prepare_v2(query, -1, out stmt);
            assert(rc == Sqlite.OK);
            stmt.bind_int(1, id);
            
            var groupCheck= dao.find_group_by_id(id);
            assert(groupCheck != null);
            

            if(stmt.step() == Sqlite.ROW){
                assert(stmt.column_int(0) == groupCheck.get_performer_type());
                assert(stmt.column_text(1) == groupCheck.get_name());
                assert(stmt.column_text(2) == groupCheck.get_name());
                assert(stmt.column_text(3) == groupCheck.get_start_date());
                assert(stmt.column_text(4) == groupCheck.get_end_date());
            } else {
                assert_not_reached();
            }
            
            cleanup();
        }

        public void test_find_all_groups() throws Error{
            setup();
            var dao = get_dao();
            int total = 100;
            
            assert(dao.find_all_groups().size == 0);

            for(int i=0; i < total; i++){
                int id = new_performer("G_%d".printf(i));
                dao.insert_group(new Group(id, "G_%d".printf(i), "2000-01-01", null));
            }

            var all_groups = dao.find_all_groups();
            assert(all_groups.size == 100);

            foreach(var g in all_groups) {
                assert(g.get_performer_type() == (int)PerformerType.GROUP);
                assert(g.get_name().contains("G_"));
                assert(g.get_start_date() == "2000-01-01");
                assert(g.get_end_date() == null);                
                assert(g.get_id() > 0);
            }
            
            cleanup();
            
        }

        public void test_complete_groupDAO() throws Error{
            setup();
            var dao = get_dao();
            var db = open_db();
            int total = 100;
            var ids = new ArrayList<int>();

            for(int i=0; i < total; i++){
                string name = "Original_%d".printf(i);
                int id = new_performer(name);
                var g = new Group(id, "Original_%d".printf(i), "2000-01-01", "2020-01-01");
                dao.insert_group(g);
                ids.add(id);     
            }

            var all_from_db = dao.find_all_groups();
            assert(all_from_db.size == total);           

            foreach (int id in ids) {
                if(id % 2 == 0) {
                    var g = dao.find_group_by_id(id);
                    g.set_start_date("2005-05-05"); 
                    g.set_name("Updated_%d".printf(id));
                    dao.update_group(g);
                }                
            }

            Statement stmt;

            var rc_p = db.prepare_v2("SELECT count(*) FROM performers", -1, out stmt);
            assert(rc_p == Sqlite.OK);
            if(stmt.step() == Sqlite.ROW)
                assert(stmt.column_int(0) == total);

            var rc_g = db.prepare_v2("SELECT count(*) FROM groups", -1, out stmt);
            assert(rc_g == Sqlite.OK);
            if (stmt.step() == Sqlite.ROW)
                assert(stmt.column_int(0) == total);

            foreach (int id in ids) {
                Statement stmt2;
                var query= "SELECT p.name, g.name FROM performers p JOIN groups g " +
                    "ON p.id_performer = g.id_group WHERE p.id_performer = ?";
                var rc = db.prepare_v2(query, -1, out stmt2);
                stmt2.bind_int(1, id);
                assert(rc == Sqlite.OK);
                
                if (stmt2.step() == Sqlite.ROW) {
                    string p_name = stmt2.column_text(0);
                    string g_name = stmt2.column_text(1);
                    assert((p_name == g_name));
                    
                    if (id % 2 == 0)                         
                        assert(p_name.contains("Updated_") && g_name.contains("Updated_"));
                    else                      
                        assert(p_name.contains("Original_") && g_name.contains("Original_"));

                    
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