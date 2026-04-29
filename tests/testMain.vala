using GLib;

int main(string[] args) {
    
    Test.init(ref args);

    add_domain_tests();
    add_db_tests();
    add_dao_tests();
    add_miner_tests();

    return Test.run();
}