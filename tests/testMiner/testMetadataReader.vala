using GLib;
using Sonus.Miner;
namespace Sonus.Test.Miner {

    public class TestMetadataReader : Object {

        private MetadataReader reader = new MetadataReader();      

        public void test_extract_full_tag_song() throws Error{
            
            string path = "tests/testMiner/testSongs/fullTagSong.mp3";
            var raw = reader.extract(path);

            assert(raw != null);
            assert(raw.title != null && raw.title == "Title");
            assert(raw.performer != null && raw.performer == "Artist");
            assert(raw.album != null && raw.album == "Album");
            assert(raw.year != null && raw.year == 2026);
            assert(raw.track != null && raw.track == 7);
        }

        public void test_extract_no_tags_song() throws Error{
            
            string path = "tests/testMiner/testSongs/noTagsSong.mp3";
            var raw = reader.extract(path);

            assert(raw != null);
            assert(raw.title != null && raw.title == "noTagsSong");
            assert(raw.performer == null);
            assert(raw.album == null);
            assert(raw.genre == null);
            assert(raw.year == null);
            assert(raw.track == null);
        }


        public void test_extract_invalid_mp3() throws Error{
            string path = "tests/testMiner/testSongs/invalid.mp3";
            var raw = reader.extract(path);
            assert(raw == null);
        }

        public void test_extract_non_existent_mp3() throws Error{
            string path = "tests/testMiner/testSongs/nope.mp3";
            var raw = reader.extract(path);
            assert(raw == null);
        }
        
    }
}