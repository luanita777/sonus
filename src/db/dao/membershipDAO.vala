/*using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public partial class DAO {

         // MEMBERSHIP WRITERS //        
        public void insert_membership(int person_id, int group_id) throws Error {
            
        }      
        
        
        // MEMBERSHIP CONSULTS //
        public ArrayList<Group> find_groups_by_person_id(int person_id) throws Error {
            return null;
        }

        public ArrayList<Person> find_persons_by_group_id(int group_id) throws Error {
            return null;
        }

        public ArrayList<GroupMembership> find_all_memberships() throws Error {
            return null;
        }

        
        // MEMBERSHIP AUXILIARY METHODS //
        
        private GroupMembership row_to_groupMembership(Statement stmt) {
            return null;
        }
        
        private void groupMembership_to_row(Statement stmt, GroupMembership groupMembership) throws Error {
            
        }
    }
}*/

using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public partial class DAO {

        // MEMBERSHIP WRITERS //        
        public void insert_membership(int person_id, int group_id) throws Error {
            var sql = "INSERT INTO in_group (id_person, id_group) VALUES (?, ?)";
            var stmt = prepare(sql);
            stmt.bind_int(1, person_id);
            stmt.bind_int(2, group_id);
            stmt.step();
        }     
        
        
        // MEMBERSHIP CONSULTS //
        public ArrayList<Group> find_groups_by_person_id(int person_id) throws Error {
            var sql = "SELECT p.id_performer, p.name, g.start_date " +
                      "FROM performers p " +
                      "JOIN groups g ON p.id_performer = g.id_group " +
                      "JOIN in_group ig ON p.id_performer = ig.id_group " +
                      "WHERE ig.id_person = ?";
            
            var stmt = prepare(sql);
            stmt.bind_int(1, person_id);
            
            var list = new ArrayList<Group>();
            while (stmt.step() == Sqlite.ROW) 
                list.add(new Group(stmt.column_int(0), stmt.column_text(1), stmt.column_text(2)));          
            return list;
        }

        public ArrayList<Person> find_persons_by_group_id(int group_id) throws Error {
            var sql = "SELECT p.id_performer, p.name, ps.real_name, ps.birth_date, ps.death_date " +
                      "FROM performers p " +
                      "JOIN persons ps ON p.id_performer = ps.id_person " +
                      "JOIN in_group ig ON p.id_performer = ig.id_person " +
                      "WHERE ig.id_group = ?";
            
            var stmt = prepare(sql);
            stmt.bind_int(1, group_id);
            
            var list = new ArrayList<Person>();
            while (stmt.step() == Sqlite.ROW) 
                list.add(row_to_person(stmt));           
            return list;
        }

        public ArrayList<GroupMembership> find_all_memberships() throws Error {
            var sql = "SELECT id_person, id_group FROM in_group";
            var stmt = prepare(sql);
            
            var list = new ArrayList<GroupMembership>();
            while (stmt.step() == Sqlite.ROW) {
                list.add(row_to_groupMembership(stmt));
            }
            return list;
        }

        
        // MEMBERSHIP AUXILIARY METHODS //
        
        private GroupMembership row_to_groupMembership(Statement stmt) throws Error {
            return new GroupMembership(stmt.column_int(0), stmt.column_int(1));
        }
        
    }
}