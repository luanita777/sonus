using GLib;
using Gee;
using TagLib;

namespace Sonus.Miner {
    public class MetadataReader : Object {

        public struct RawSong{
            public string title;
            public string? performer;
            public string? album;
            public string? genre;
            public int? year;
            public int? track;         
        }
        
        public RawSong? extract(string path) throws Error {
            if (!is_valid_mp3(path))
                return null;

            var file = new TagLib.File(path);
            if (file == null || !file.is_valid())
                return null;
            
            if (file.audioproperties == null || file.audioproperties.length == 0) 
                return null;
            
            
            var raw = RawSong();
            var _title = file.tag.title;
            var _performer = file.tag.artist;
            var _album = file.tag.album;
            var _genre = file.tag.genre;
            var _year = (int)file.tag.year;
            var _track = (int)file.tag.track;
                
            raw.title     = (_title != null && _title.strip() != "") ? _title : get_filename_no_extension(path);
            raw.performer = (_performer != null && _performer.strip() != "") ? _performer : null;
            raw.album     = (_album != null && _album.strip() != "") ? _album : null;
            raw.genre     = (_genre != null && _genre.strip() != "") ? _genre : null;
            raw.year      = (_year > 0) ? (int?)_year : null;
            raw.track     = (_track > 0) ? (int?)_track : null;               
            
            return raw;
            
        }
        
        
        private string get_filename_no_extension(string path) {
            return GLib.File.new_for_path(path).get_basename().split(".")[0];
        }

        private bool is_valid_mp3(string path) throws Error {
            if(!path.down().has_suffix(".mp3"))
                return false;
            
            try {                
                var file = GLib.File.new_for_path(path);
                var info = file.query_info(GLib.FileAttribute.STANDARD_CONTENT_TYPE, 0);
                var type = info.get_content_type();
                if (type.contains("audio/mpeg") || type.contains("audio/x-mpeg")) 
                    return true;
                else                     
                    return false;                
            } catch{
                return false;
            }
        } 
        
    }
    
}