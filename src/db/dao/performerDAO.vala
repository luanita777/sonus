using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public class DAO {

        // PERFORMER WRITERS //        
        public void save_performer(Performer performer) throws Error {
            
        }
        
        public void delete_performer(int id) throws Error {
            
        }
        
        
        // PERFORMER CONSULTS //
        public Performer? find_performer_by_id(int id) throws Error {
            return null;
        }

        public ArrayList<Performer> find_all_performers() throws Error {
            return new ArrayList<Performer>();
        }
        
        public ArrayList<Performer> find_performers_by_type(PerformerType performerType) throws Error {
            return new ArrayList<Performer>();
        }
        
        public ArrayList<Performer> find_performers_by_stage_name(string name) throws Error {
            return new ArrayList<Performer>();
        }
        
        // PERFORMER AUXILIARY METHODS //
        private void insert_performer(Performer performer) throws Error {
            
        }
        
        private void update_performer(Performer performer) throws Error {
            
        }
        
        private Performer row_to_performer(Statement stmt) {
            return null;
        }

        
        private void performer_to_row(Statement stmt, Performer performer) throws Error {
            
        }
    }
}