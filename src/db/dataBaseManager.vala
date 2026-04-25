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

        //it's a method for helping us while doing test's, is mainly for shutdown
        //and create a completely new instance of the DBM so when we run the different
        //test's there are no leftovers of the test's before
        public static void reset_DBM(){
             if (DBM != null) {
                DBM.close();
                DBM = null;
            }
        }
        

        //opens the connection with the .db file we are gonna use
        public void open() throws Error {
            if (connection != null)
                return;
            
            //we make sure the file and directory we will use does exist
            File file = File.new_for_path(db_path);
            File parent = file.get_parent();
            if (parent != null && !parent.query_exists()) 
                parent.make_directory_with_parents();
            
            bool exists = file.query_exists();

            //opening the connection, this creates the file if it didn´t exist
            int rc = Sqlite.Database.open(db_path, out connection);
            if (rc != Sqlite.OK) 
                throw new DatabaseError.FAILED("Error: Couldn´t open the connection: %s".printf(connection.errmsg()));

            //if the file didn´t exist, we write the schema on it
            if (!exists) 
                write_schema();
        }
        
        
        //checks if the connection is open
        public bool is_open () {
            return connection != null;
        }

        
        //closes the connection with .db file we are gonna use
        public void close() {
            connection = null;
        }

        //getter for the connection, it's unowned cuz if another method get's the reference
        //to the connection, when the method ends they could try to close it by themselves
        //(has somemthing to do with C and sqlite3 connection), and we cannot let that
        //happen, the only one that should close it is the DBM
        public unowned Database get_connection() throws Error {
            if (connection == null)
                throw new DatabaseError.FAILED("Error: DB it's closed. Please open it for establishing a connection.");
            return connection;
        }


        
        // === AUXILIAR METHODS === //
        
        //auxiliary method that writes the schema on the .db file to create the tables and so
        private void write_schema() throws Error {
            string? schema_path = Environment.get_variable("SCHEMA_PATH");
            if (schema_path == null) throw new DatabaseError.FAILED("SCHEMA_PATH is not defined.");

            File schema_file = File.new_for_path(schema_path);
            uint8[] contents;
            schema_file.load_contents(null, out contents, null);
            
            string sql = (string)contents;
            int rc = connection.exec(sql);
            if (rc != Sqlite.OK) 
                throw new DatabaseError.FAILED("Error: Schema sintax error. %s".printf(connection.errmsg()));
          
        }

        

    }
}