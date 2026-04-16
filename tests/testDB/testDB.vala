using GLib;

static TestDataBaseManager dbm_tests;

public void add_db_tests() {
    dbm_tests = new TestDataBaseManager();

    Test.add_func("/db/connection", () => {
            try {
                dbm_tests.test_connection();
            } catch (Error e) {
                error(e.message);
            }
        });
    
    Test.add_func("/db/singleton_consistency", () => {
            dbm_tests.test_singleton_consistency();
        });


    Test.add_func("/db/schema", () => {
            try {
                dbm_tests.test_schema();
            } catch (Error e) {
                error(e.message);
            }
        });
    
}