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
            
        }                       
        
    }
    
}