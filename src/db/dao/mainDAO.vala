using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public class DAO : Object {

        private unowned Database db;

        private Database get_db() {
             return DatabaseManager.get_DBM().get_connection();
        }
        
        private void execute_query(string sql, string[] params) throws Error{
            
        }

        private void log_error(string context, Error e) {
            stderr.printf("Error in %s: %s\n", context, e.message);
        }
        
    }
    
}