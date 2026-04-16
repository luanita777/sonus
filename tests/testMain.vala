using GLib;

int main(string[] args) {
    
    Test.init(ref args);

    add_domain_tests();
    add_db_tests();

    return Test.run();
}