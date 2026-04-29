using GLib;
using Gee;

namespace Sonus.Miner {

    public class FileReader : Object {

        private string _extension;
        private int _files_found_count = 0;

        public FileReader(string extension = ".mp3"){
            this._extension = extension.down();
        }

        public int get_files_found_count() {
            return this._files_found_count;
        }
        

        public ArrayList<string> read(string path) throws Error{
            var file_list = new ArrayList<string>();
            var directory = File.new_for_path(path);

            if(!directory.query_exists()){
                throw new MinerError.DIRECTORY_DOES_NOT_EXIST("The given directory doesn´t exist.");
            }

            var enumerator = directory.enumerate_children(FileAttribute.STANDARD_NAME + "," + FileAttribute.STANDARD_TYPE,
                                                          FileQueryInfoFlags.NONE);

            FileInfo info;

            while((info = enumerator.next_file()) != null){
                var child = directory.get_child(info.get_name());
                var child_path = child.get_path();
                
                if(info.get_file_type() == FileType.DIRECTORY){
                    try {
                        file_list.add_all(read(child_path));
                    } catch (Error e) {                       
                        stderr.printf("[ERROR] Couldn´t acces to %s: %s\n", child_path, e.message);
                    }
                    
                } else if(info.get_file_type() == FileType.REGULAR){
                    if(info.get_name().down().has_suffix(_extension)){
                        file_list.add(child_path);
                        _files_found_count++;
                    }
                }                     
            }

            return file_list;
        }

        
        
    }
}