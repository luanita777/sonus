using GLib;
using Sqlite;
using Gee;
using Sonus;
using Sonus.Db;
using Sonus.DAO;

namespace Sonus.Test.DAO {

    public class TestMembershipDAO : BaseTest {

        public TestMembershipDAO() {}

        public void test_insert_membership() throws Error {
            setup();
            var dao = get_dao();

            int p_id = create_person("Soloist", "Real Name");
            int g_id = create_group("The Band");

            dao.insert_membership(p_id, g_id);

            var db = open_db();
            Statement stmt;
            string sql = "SELECT count(*) FROM in_group WHERE id_person = ? AND id_group = ?";
            db.prepare_v2(sql, -1, out stmt);
            stmt.bind_int(1, p_id);
            stmt.bind_int(2, g_id);
            assert(stmt.step() == Sqlite.ROW);
            assert(stmt.column_int(0) == 1);

            cleanup();
        }

        
        public void test_find_groups_by_person_id() throws Error {
            setup();
            var dao = get_dao();

            int p_id = create_person("Artist", "Real");
            int g1 = create_group("Band A");
            int g2 = create_group("Band B");

            dao.insert_membership(p_id, g1);
            dao.insert_membership(p_id, g2);

            var groups = dao.find_groups_by_person_id(p_id);
            stdout.printf(groups.size.to_string());
            assert(groups.size == 2);
            bool found_g1 = false;
            bool found_g2 = false;
            foreach (var g in groups) {
                if (g.get_id() == g1)
                    found_g1 = true;
                if (g.get_id() == g2)
                    found_g2 = true;
            }
            assert(found_g1 && found_g2);

            cleanup();
        }

        public void test_find_persons_by_group_id() throws Error {
            setup();
            var dao = get_dao();

            int g_id = create_group("Group X");
            int p1 = create_person("P1", "R1");
            int p2 = create_person("P2", "R2");

            dao.insert_membership(p1, g_id);
            dao.insert_membership(p2, g_id);

            var members = dao.find_persons_by_group_id(g_id);

            assert(members.size == 2);
            assert(members.get(0).get_name() == "P1" || members.get(0).get_name() == "P2");

            cleanup();
        }

        public void test_find_all_memberships() throws Error {
            setup();
            var dao = get_dao();

            int p1 = create_person("P1", "R1");
            int g1 = create_group("G1");
            int g2 = create_group("G2");

            dao.insert_membership(p1, g1);
            dao.insert_membership(p1, g2);

            var list = dao.find_all_memberships();
            assert(list.size == 2);

            cleanup();
        }

  
        public void test_complete_membershipDAO() throws Error {
            setup();
            var dao = get_dao();
            
            int num_people = 20;
            int num_groups = 5;
            var person_ids = new ArrayList<int>();
            var group_ids = new ArrayList<int>();

            for(int i=0; i<num_people; i++) person_ids.add(create_person("P%d".printf(i), "R"));
            for(int i=0; i<num_groups; i++) group_ids.add(create_group("G%d".printf(i)));

            foreach(int pid in person_ids) {
                foreach(int gid in group_ids) {
                    dao.insert_membership(pid, gid);
                }
            }

            assert(dao.find_all_memberships().size == (num_people * num_groups));
            assert(dao.find_groups_by_person_id(person_ids.get(0)).size == num_groups);
            assert(dao.find_persons_by_group_id(group_ids.get(0)).size == num_people);

            cleanup();
        }


        //AUXILIAR
        
        private int create_person(string stage_name, string real_name) throws Error {
            var dao = get_dao();
            int id = new_performer(stage_name, PerformerType.PERSON);
            dao.insert_person(new Person(id, stage_name, real_name, "1990-01-01"));
            return id;
        }

        private int create_group(string name)  throws Error{
            var dao = get_dao();
            int id = new_performer(name, PerformerType.GROUP);
            dao.insert_group(new Group(id, name, "2020-01-01"));
            return id;
        }

        private int new_performer(string name, PerformerType type) throws Error{          
            var db = open_db();
            Statement stmt;
            db.prepare_v2("INSERT INTO performers (name, id_type) VALUES (?, ?)", -1, out stmt);
            stmt.bind_text(1, name);
            stmt.bind_int(2, (int)type);
            stmt.step();
            return (int)db.last_insert_rowid();
        }
    }
}