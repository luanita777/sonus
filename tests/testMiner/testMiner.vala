using GLib;
using Sonus.Test.Miner;

static TestFileReader fr_miner;
static TestMetadataReader mr_miner;

public void add_miner_tests(){
    fr_miner = new TestFileReader();
    mr_miner = new TestMetadataReader();
    
    add_fr_miner_tests();
    add_mr_miner_tests();
}


private void add_fr_miner_tests(){
    
    Test.add_func("/miner/file_reader/read", () => {
            try { fr_miner.test_read(); }
            catch (Error e) { error("Read test failed: " + e.message); }
        });
        
    Test.add_func("/miner/file_reader/non existent directory", () => {
            try { fr_miner.test_non_existent_directory(); }
            catch (Error e) { error("Non existent directory test failed: " + e.message); }
        });
    
}


private void add_mr_miner_tests(){
    Test.add_func("/miner/metadata_reader/extract full tag song", () => {
            try { mr_miner.test_extract_full_tag_song(); }
            catch (Error e) { error("Extract full tag song test failed: " + e.message); }
        });

    Test.add_func("/miner/metadata_reader/extract no tags song", () => {
            try { mr_miner.test_extract_no_tags_song(); }
            catch (Error e) { error("Extract no tags song test failed: " + e.message); }
        });


        Test.add_func("/miner/metadata_reader/extract invalid song (.mp3)", () => {
            try { mr_miner.test_extract_invalid_mp3(); }
            catch (Error e) { error("Extract invalid song (.mp3) test failed: " + e.message); }
        });

        Test.add_func("/miner/metadata_reader/extract non existent song (.mp3)", () => {
            try { mr_miner. test_extract_non_existent_mp3(); }
            catch (Error e) { error("Extract non existent song (.mp3) test failed: " + e.message); }
        });

    
}

