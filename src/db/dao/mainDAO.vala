using GLib;
using Sqlite;
using Gee;
using Sonus.Db;

namespace Sonus.DAO {

    public partial class DAO : Object {

        public unowned Database get_db() throws Error {
            return DatabaseManager.get_DBM().get_connection();
        }
        
        private Statement prepare(string sql) throws Error{
            Statement stmt;
            get_db().prepare_v2(sql, -1, out stmt);
            return stmt;
        }
        
        private int? get_nullable_int(Statement stmt, int index) {
            if (stmt.column_type(index) == Sqlite.NULL) 
                return null;            
            return stmt.column_int(index);
        }
        
        private void bind_nullable_int(Statement stmt, int index, int? value) {
            if (value != null)
                stmt.bind_int(index, value);
            else
                stmt.bind_null(index);
        }

        private void bind_nullable_text(Statement stmt, int index, string? value) {
            if (value != null)
                stmt.bind_text(index, value);
            else
                stmt.bind_null(index);
        }
        
        
    }
    
}