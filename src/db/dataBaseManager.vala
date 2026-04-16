using GLib;
using Sqlite;

namespace Sonus.Db {

    public errordomain DatabaseError { FAILED }

    public class DatabaseManager : Object {

        // VARIABLES //
        private static DatabaseManager? DBM = null;
        private Database? connection = null;
        private string db_path;

        // CONSTRUCTOR //
        private DatabaseManager(string path) {
            this.db_path = path;
        }

        // === METHODS === //
        
        //DBM instance should be unique (singleton)
        public static DatabaseManager get_DBM(string path = "data/sonus.db") {
            if (DBM == null) 
                DBM = new DatabaseManager(path);
            return DBM;
        }

        //opens the connection with the .db file we are gonna use
        public void open() throws GLib.Error {
            
        }

        //checks if the connection is open
        public bool is_open () {
            return false;
        }

        
        //closes the connection with .db file we are gonna use
        public void close() {

        }

        //getter for the connection, it's unowned cuz if another method get's the reference
        //to the connection, when the method ends they could try to close it by themselves
        //(has somemthing to do with C and sqlite3 connection), and we cannot let that
        //happen, the only one that should close it is the DBM
        public unowned Database get_connection() throws Error {
                throw new DatabaseError.FAILED("NOT IMPLEMENTED");
        }


        
        // === AUXILIAR METHODS === //
        
        //auxiliary method that writes the schema on the .db file to create the tables and so
        private void write_schema() throws Error {
            
        }

        

    }
}