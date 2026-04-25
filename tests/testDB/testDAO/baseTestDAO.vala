using GLib;
using Sqlite;
using Gee;
using Sonus.Db;

namespace Sonus.Test.DAO {

    public errordomain DatabaseError {
        OPEN_FAILED
    }

    public abstract class BaseTest : Object {

        protected string test_path = "tests/db/testSonus.db";

        protected void setup() throws Error{
            var dbm = DatabaseManager.get_DBM(test_path);
            try { 
                dbm.open(); 
            } catch(Error e) {
                error("[CRITICAL]: No se pudo abrir la BD: %s\n", e.message);
            }
            
            var db = open_db();
            
            execute_sql(db, "DELETE FROM rolas;");
            execute_sql(db, "DELETE FROM performers;");
            execute_sql(db, "DELETE FROM groups;");
            execute_sql(db, "DELETE FROM persons;");
            execute_sql(db, "DELETE FROM albums;");
            execute_sql(db, "DELETE FROM in_group;");
    
        }
        
        protected void cleanup() {
            DatabaseManager.get_DBM().close(); 
        }
        
        //opens a connection with the db file
        protected Database open_db() throws Error {
            Database db;
            int rc = Database.open(test_path, out db);
            if (rc != Sqlite.OK) 
                throw new DatabaseError.OPEN_FAILED("An error occurred trying to open the DB test file.");
            
            return db;
        }

        protected Sonus.DAO.DAO get_dao() {
            return new Sonus.DAO.DAO();
        }

        protected void execute_sql(Database db, string sql) {
            Statement stmt;
            int rc = db.prepare_v2(sql, -1, out stmt);
            if (rc != Sqlite.OK) 
                error("Error ejecutando SQL '%s': %s", sql, db.errmsg());            
            stmt.step();
        }
        
        
    }
    
    
}