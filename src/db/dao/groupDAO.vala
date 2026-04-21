using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {
    
    public class DAO {
        
        // GROUP WRITERS //        
        public void save_group(Group group) throws Error {
            
        }
        
        public void delete_group(int id) throws Error {
            
        }
        
        
        // GROUP CONSULTS //
        public Group? find_group_by_id(int id) throws Error {
            return null;
        }
        
        public ArrayList<Group> find_all_groups() throws Error {
            return new ArrayList<Group>();
        }

        
        // GROUP AUXILIARY METHODS //
        private void insert_group(Group group) throws Error {
            
        }
        
        private void update_group(Group group) throws Error {
            
        }
        
        private Group row_to_group(Statement stmt) {
            return null;
        }
        
        private void group_to_row(Statement stmt, Group group) throws Error {
            
        }
    }
}