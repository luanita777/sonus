using GLib;
using Sonus.Db;
using Sqlite;

public class TestDataBaseManager : Object {
    
    private string test_path;
    
    // CONSTRUCTOR //
    
    //we do this cuz Vala does not allow doing:
    // private string test_path = File.new_for_path("tests/db/test_sonus.db").get_path();
    public TestDataBaseManager () {
        this.test_path = File.new_for_path("tests/db/testSonus.db").get_path();
    }


    // == TEST METHODS == //
    
    //tests the connection does open and does close on call
    public void test_connection() throws Error {
        reset_DBM_for_tests();
        var manager = DatabaseManager.get_DBM(test_path);
        manager.open();
        assert(manager.is_open());
        manager.close();
        assert(!manager.is_open());
        reset_DBM_for_tests();
    }
        

    //tests there's only one DBM instance 
    public void test_singleton_consistency() {
        reset_DBM_for_tests();
        var db1 = DatabaseManager.get_DBM (test_path);
        var db2 = DatabaseManager.get_DBM ("otra/ruta.db");
        assert (db1 == db2);
        reset_DBM_for_tests();
    }
    
    
    //tests the schema did wrote on the testSonus.db doing some sql consults
    public void test_schema() throws Error {
        reset_DBM_for_tests();
        
        var manager = DatabaseManager.get_DBM (test_path);
        manager.open();
        unowned Database db = manager.get_connection();

        // == Consults for known existing data == //
        Statement stmt_types;
        string sql_types = "SELECT id_type, description FROM types ORDER BY id_type ASC;";
        
        int rc = db.prepare_v2 (sql_types, -1, out stmt_types);
        assert (rc == Sqlite.OK);
        
        // verify first value (0, 'Person')
        assert (stmt_types.step () == Sqlite.ROW);
        assert (stmt_types.column_int (0) == 0);
        assert (stmt_types.column_text (1) == "Person");
        
        // verify second value (1, 'Group')
        assert (stmt_types.step () == Sqlite.ROW);
        assert (stmt_types.column_int (0) == 1);
        assert (stmt_types.column_text (1) == "Group");
        
        // verify third value (2, 'Unknown')
        assert (stmt_types.step () == Sqlite.ROW);
        assert (stmt_types.column_int (0) == 2);
        assert (stmt_types.column_text (1) == "Unknown");
        

        // == Check if all tables exist and are empty (we do not check types table) == //
        string[] tables_to_check = { "performers", "persons", "groups", "in_group", "albums", "rolas" };
        
        foreach (string table_name in tables_to_check) {
            
            Statement stmt_table;
            string sql_consult1 = "SELECT name FROM sqlite_master WHERE type='table' AND name='%s';".printf(table_name);
            int rc1 = db.prepare_v2 (sql_consult1, -1, out stmt_table);
            assert (rc1 == Sqlite.OK);
            if (!(stmt_table.step() == Sqlite.ROW))
                error ("[CRITICAL]: %s was not created by the schema.", table_name);

            
            Statement stmt_table_row;
            string sql_consult2 = "SELECT * FROM '%s';".printf(table_name);
            int rc2 = db.prepare_v2 (sql_consult2, -1, out stmt_table_row);
            assert (rc2 == Sqlite.OK);
            assert (stmt_table_row.step() == Sqlite.DONE); 
            
        }

        reset_DBM_for_tests();
    }


    // == AUXILIAR METHODS == //
    
    //makes sure to clean leftovers from test to test in order to assure the code works
    //the way it's supposed to (deletes the actual DBM and the test file it created)
    private void reset_DBM_for_tests() {
        DatabaseManager.reset_DBM();
        delete_test_file();
    }

    //deletes the test file
    private void delete_test_file () {
        File f = File.new_for_path (test_path);
        if (f.query_exists ()) {
            try {
                f.delete ();
            } catch {}
        }
    }

    
}