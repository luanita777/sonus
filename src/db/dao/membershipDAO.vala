using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public class DAO {

         // MEMBERSHIP WRITERS //        
        public void save_membership(int person_id, int group_id) throws Error {
            
        }
        
        public void delete_membership(int person_id, int group_id) throws Error {
            
        }
        
        
        // MEMBERSHIP CONSULTS //
        public ArrayList<GroupMembership> find_membership_by_person_id(int person_id) throws Error {
            return null;
        }

        public ArrayList<GroupMembership> find_membership_by_group_id(int group_id) throws Error {
            return null;
        }

        public ArrayList<GroupMembership> find_all_memberships() throws Error {
            return null;
        }

        
        // MEMBERSHIP AUXILIARY METHODS //
        private void insert_membership(int person_id, int group_id) throws Error {
            
        }
        
        private void update_membership(int person_id, int group_id) throws Error {
            
        }
        
        private GroupMembership row_to_groupMembership(Statement stmt) {
            return null;
        }
        
        private void groupMembership_to_row(Statement stmt, GroupMembership groupMembership) throws Error {
            
        }
    }
}