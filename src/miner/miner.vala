using GLib;
using Gee;
using Sonus.Miner;
using Sonus.DAO;

namespace Sonus.Miner {

    public class Miner : Object {
        
        private FileReader _reader;
        private MetadataReader _mdr;
        private Sonus.DAO.DAO _dao;
        private ArrayList<string> _found_files;

        public Miner(Sonus.DAO.DAO dao) {
            this._reader = new FileReader();
            this._mdr = new MetadataReader();
            this._dao = dao;
            this._found_files = new Gee.ArrayList<string>();
        }

        
        public void mine(string path) {
            try {
                print("Mining in: %s...\n", path);
                
                this._found_files = _reader.read(path);
                
                print("Mining done. We found %d files.\n", _found_files.size);

                print("Now starting to read file metadata from each file found and insert in DataBase:\n\n");
                
                process_files();

                
                print("\nAll done. You are ready to go:)");
                
            } catch (Error e) {
                stderr.printf("[CRITICAL] :( Something went wrong while trying to mine: %s\n", e.message);
            }
        }

        private void process_files() throws Error {
            foreach(string path in _found_files) {
                try {
                    if(_dao.find_song_by_path(path) != null)
                        continue;                    
                    
                    var raw = _mdr.extract(path);                  
                    if(raw == null)
                        continue;
                    
                    string album_path = Path.get_dirname(path);
                    int? performer_id = null;
                    int? album_id = null;
            
                    if(raw.performer != null){
                        string performer_name = raw.performer.strip().replace("\u00A0", " ");
                        
                        if (performer_name != "") {
                            performer_id = _dao.find_performer_by_exact_name(performer_name);                                        
                            if (performer_id == null || performer_id <= 0) {
                                _dao.insert_performer(new Performer(-1, PerformerType.UNKNOWN, performer_name));
                                performer_id = _dao.find_performer_by_exact_name(performer_name);
                            }
                        }
                    } 
                    
                    if (raw.album != null) {                     
                        string album_name = raw.album.strip().replace("\u00A0", " ");
                        
                        if (album_name != "" && album_name.down() != "unknown") {  
                            var existing_album = _dao.find_album_by_path(album_path);                            
                            if (existing_album != null) {
                                album_id = existing_album.get_id();
                            } else {
                                var new_album = new Album(-1, album_name, album_path, null);
                                _dao.insert_album(new_album);
                                album_id = new_album.get_id();                       
                            }
                        } else {
                            album_id = null;
                        }
                    }              
                    
                    var s = new Song(-1, raw.title, performer_id, path, album_id, raw.genre, raw.year, raw.track);
                    _dao.insert_song(s);
                    
                    var s_obj = _dao.find_song_by_path(path);
                    if (s_obj != null) {
                        int s_id = s_obj.get_id();                  
                
                        // DEBUG
                        print("\n-------------------------------------------------------------------------------------\n");
                        print("New Song inserted successfully:\n");
                        print(" [ID Song]:     %d\n", s_id);
                        print(" [Title]:       %s\n", raw.title ?? "Unknown");
                        print(" [Performer]:   %s (ID: %d)\n", raw.performer ?? "Unknown", performer_id ?? -1);
                        print(" [Album]:       %s (ID: %d)\n", raw.album ?? "Unknown", album_id ?? -1);
                        print(" [Genre]:       %s\n", raw.genre ?? "N/A");
                        print(" [Year]:        %d\n", raw.year ?? -1);
                        print(" [Track]:       %d\n", raw.track ?? -1);
                        print(" [Path]:        %s\n", path);
                        print("-------------------------------------------------------------------------------------\n");
                    }
                    
                } catch (Error e) {
                    stderr.printf("[ERROR] Failed to process file: %s : %s \n", path, e.message); 
                }                         
            }
        }
        
        
    }    
    
}






