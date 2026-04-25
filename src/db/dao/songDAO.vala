using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public partial class DAO {
                
        // SONG WRITERS //        
        public void insert_song(Song song) throws Error {            
            var existing = this.find_song_by_path(song.get_path());    
            if (existing != null) 
                return;            
            
            var sql = "INSERT INTO rolas (title, id_performer, id_album, path, track, year, genre) VALUES (?, ?, ?, ?, ?, ?, ?)";
            var stmt = prepare(sql);
            song_to_row(stmt, song);
            stmt.step();
        }

        public void update_song(Song song) throws Error{
            var sql = "UPDATE rolas SET title=?, id_performer=?, id_album=?, path=?, track=?, year=?, genre=? WHERE id_rola = ?";
            var stmt = prepare(sql);           
            song_to_row(stmt, song);             
            stmt.bind_int(8, song.get_id());             
            stmt.step();
        }

        
        // SONG CONSULTS //
        public Song? find_song_by_id(int id) throws Error {
            var stmt = prepare("SELECT * FROM rolas WHERE id_rola = ?");
            stmt.bind_int(1, id);
            if(stmt.step() == Sqlite.ROW)
                return row_to_song(stmt);
            return null;
        }

        public Song? find_song_by_path(string path) throws Error {
            var stmt = prepare("SELECT * FROM rolas WHERE path = ?");
            stmt.bind_text(1, path);
            if(stmt.step() == Sqlite.ROW)
                return row_to_song(stmt);
            return null;
        }

        public ArrayList<Song> find_all_songs() throws Error {
            return fetch_songs(prepare("SELECT * FROM rolas"));
        }

        public ArrayList<Song> find_songs_by_performer_id(int performer_id) throws Error {
            var stmt = prepare("SELECT * FROM rolas WHERE id_performer = ?");
            stmt.bind_int(1, performer_id);
            return fetch_songs(stmt);
        }

        public ArrayList<Song> find_songs_by_album_id(int album_id) throws Error {
            var stmt = prepare("SELECT * FROM rolas WHERE id_album = ?");
            stmt.bind_int(1, album_id);
            return fetch_songs(stmt);
        }

        public ArrayList<Song> find_songs_by_genre(string genre) throws Error {
            var stmt = prepare("SELECT * FROM rolas WHERE genre LIKE ?");
            stmt.bind_text(1, "%" + genre + "%");
            return fetch_songs(stmt);
        }

        public ArrayList<Song> find_songs_by_title(string title) throws Error {
            var stmt = prepare("SELECT * FROM rolas WHERE title LIKE ?");
            stmt.bind_text(1,  "%" + title + "%");
            return fetch_songs(stmt);
        }

        public ArrayList<Song> find_songs_with_query(string clause) throws Error {
            return new ArrayList<Song>();
        }


        // SONG AUXILIARY METHODS //
        
        private Song row_to_song(Statement stmt) throws Error {
            int? performer_id = get_nullable_int(stmt, 1);
            int? album_id = get_nullable_int(stmt, 2);
            int? track = get_nullable_int(stmt, 5);
            int? year = get_nullable_int(stmt, 6);
            
            var s = new Song(
                             stmt.column_int(0),     
                             stmt.column_text(4),    
                             performer_id,           
                             stmt.column_text(3)     
                             );
            
            s.set_album_id(album_id);
            s.set_track(track);
            s.set_year(year);
            s.set_genre(stmt.column_text(7));
            
            return s;
        }
        
        private void song_to_row(Statement stmt, Song song) throws Error {
            stmt.bind_text(1, song.get_title());  
            bind_nullable_int(stmt, 2, song.get_performer_id());
            bind_nullable_int(stmt, 3, song.get_album_id());            
            stmt.bind_text(4, song.get_path());   
            bind_nullable_int(stmt, 5, song.get_track());
            bind_nullable_int(stmt, 6, song.get_year());
            bind_nullable_text(stmt, 7, song.get_genre());          
        }
       
        private ArrayList<Song> fetch_songs(Statement stmt) throws Error{
            var list = new ArrayList<Song>();
            while(stmt.step() == Sqlite.ROW)
                list.add(row_to_song(stmt));
            return list;
        }

    }
}