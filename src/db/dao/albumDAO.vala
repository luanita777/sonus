using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public class DAO {
        
        // ALBUM WRITERS //        
        public void insert_album(Album album) throws Error {
            
        }

        public void update_album(Album album) throws Error {
            
        }        
        
        
        // ALBUM CONSULTS //
        public Album? find_album_by_id(int id) throws Error {
            return null;
        }
        
        public ArrayList<Album> find_all_albums() throws Error {
            return new ArrayList<Album>();
        }
        
        public ArrayList<Album> find_albums_by_year(int year) throws Error {
            return new ArrayList<Album>();
        }
        
        public ArrayList<Album> find_albums_by_name(string name) throws Error {
            return new ArrayList<Album>();
        }
        
        // ALBUM AUXILIARY METHODS //
        private void insert_album(Album album) throws Error {
            
        }
        
        private void update_album(Album album) throws Error {
            
        }
        
        private Album row_to_album(Statement stmt) {
            return null;
        }
        
        private void album_to_row(Statement stmt, Album album) throws Error {
            
        }
    }
}