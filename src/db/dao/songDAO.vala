using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public class DAO {
                
        // SONG WRITERS //        
        public void save_song(Song song) throws Error {
            
        }

        public void delete_song(int id) throws Error {
            
        }

        
        // SONG CONSULTS //
        public Song? find_song_by_id(int id) throws Error {
            return null;
        }

        public Song? find_song_by_path(string path) throws Error {
            return null;
        }

        public ArrayList<Song> find_all_songs() throws Error {
            return new ArrayList<Song>();
        }

        public ArrayList<Song> find_songs_by_performer_id(int performer_id) throws Error {
            return new ArrayList<Song>();
        }

        public ArrayList<Song> find_songs_by_album_id(int album_id) throws Error {
            return new ArrayList<Song>();
        }

        public ArrayList<Song> find_songs_by_genre_id(int genre_id) throws Error {
            return new ArrayList<Song>();
        }

        public ArrayList<Song> find_songs_with_query(string clause) throws Error {
            return new ArrayList<Song>();
        }


        // SONG AUXILIARY METHODS //
        private void insert_song(Song song) throws Error {
            
        }

        private void update_song(Song song) throws Error {
            
        }
        
        private Song row_to_song(Statement stmt) {
            return null;
        }
        
                
        private void song_to_row(Statement stmt, Song song) throws Error {
            
        }

    }
}