namespace Sonus.Test.DAO {

    public abstract class BaseTest : Object {

        protected string test_path = "tests/db/testSonus.db";

        //cleans leftovers from past tests and opens a new dbm connection
        protected void setup(){
            DatabaseManager.reset_DBM();
            File f = File.new_for_path (test_path);
            if (f.query_exists ()) {
                try { f.delete (); } catch (Error e) {}
            }
            
            var dbm = DatabaseManager.get_DBM(test_path);
            try{ dbm.open(); } catch(Error e){
                error("[CRITICAL]: An error ocurred trying to open the DB test file: %s\n", e.message);
            }
        }
        
        //cleans everything of the test who called it and closes the dbm connection
        protected void cleanup(){
            DatabaseManager.get_DBM();
            File file = File.new_for_path(test_path);
            if (file.query_exists()) {
                try { file.delete(); } catch (Error e) {}
            }        
        }

        //opens a connection with the db file
        protected Database open_db() throws Error {
            Database db;
            int rc = Database.open(test_path, out db);
            if (rc != Sqlite.OK) 
                throw new Error("[CRITICAL]: An error ocurred trying to open the DB test file.");
            
            return db;
        }

        
    }

    
}