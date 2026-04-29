using GLib;
using Gee;
using Sonus.Miner;

namespace Sonus.Test.Miner{

    public class TestFileReader : Object {
    
        private static string temp_test_dir;
        
        public void test_read() throws Error {
            setup_files();
            
            try {
                var reader = new FileReader(".mp3");
                var result = reader.read(temp_test_dir);
                
                assert(result.size == 100);
                assert(reader.get_files_found_count() == 100);
                
                foreach (var path in result) {
                    assert(path.down().has_suffix(".mp3"));
                }           
                
            } catch (Error e) {
                assert_not_reached();
            } finally {
                DirUtils.remove(temp_test_dir);
            }
        }
        
        public void test_non_existent_directory() throws Error {
            var reader = new FileReader();
            try {
                reader.read("/tests/testMiner/tmp/thisDirectoryDoesNotExist12345");
                assert_not_reached(); 
            } catch (MinerError.DIRECTORY_DOES_NOT_EXIST e) {
                assert(true);
                return;
            } catch (Error e) {
                assert_not_reached();
            }
        }
        
        
        private void setup_files() throws Error {
            
            temp_test_dir = DirUtils.make_tmp("sonus-miner-test-XXXXXX");
            
            for (int i = 0; i < 5; i++) {
                string subdir = Path.build_filename(temp_test_dir, "subdir_%d".printf(i));
                DirUtils.create(subdir, 0755);
                
                for (int j = 0; j < 20; j++) {
                    FileUtils.set_contents(Path.build_filename(subdir, "song_%d.mp3".printf(j)), "test_song");
                    FileUtils.set_contents(Path.build_filename(subdir, "trash_%d.txt".printf(j)), "not_a_song");
                }
            }
        }
        
    }
    
}