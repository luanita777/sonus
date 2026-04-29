using GLib;
using Gee;

namespace Sonus.Miner {

    public class FileReader : Object {

        private string _extension;
        private int _files_found_count = 0;

        public FileReader(string extension = ".mp3"){
            
        }

        public int get_files_found_count() {
            return 0;
        }
        

        public ArrayList<string> read(string path) throws Error{
           
        }        
        
    }
}