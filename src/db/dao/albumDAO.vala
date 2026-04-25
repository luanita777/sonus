using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public partial class DAO {
        
        // ALBUM WRITERS //        
        public void insert_album(Album album) throws Error {
            var existing = this.find_album_by_path(album.get_path());
            if(existing != null)
                return;

            var sql = "INSERT INTO albums (path, name, year) VALUES (?, ?, ?)";
            var stmt = prepare(sql);
            album_to_row(stmt, album);
            stmt.step();
        }

        public void update_album(Album album) throws Error {
            var sql = "UPDATE albums SET path=?, name=?, year=? WHERE id_album = ?";
            var stmt = prepare(sql);
            album_to_row(stmt, album);
            stmt.bind_int(4, album.get_id());
            stmt.step();
        }        
        
        
        // ALBUM CONSULTS //
        public Album? find_album_by_id(int id) throws Error {
            var stmt = prepare("SELECT * FROM albums WHERE id_album = ?");
            stmt.bind_int(1, id);
            if(stmt.step() == Sqlite.ROW)
                return row_to_album(stmt);
            return null;
        }

        public Album? find_album_by_path(string path) throws Error{
            var stmt = prepare("SELECT * FROM albums WHERE path = ?");
            stmt.bind_text(1, path);
            if(stmt.step() == Sqlite.ROW)
                return row_to_album(stmt);
            return null;
        }
        
        public ArrayList<Album> find_all_albums() throws Error {
            return fetch_albums(prepare("SELECT * FROM albums"));            
        }
        
        public ArrayList<Album> find_albums_by_year(int year) throws Error {
            var stmt = prepare("SELECT * FROM albums WHERE year = ?");
            stmt.bind_int(1, year);
            return fetch_albums(stmt);
        }
        
        public ArrayList<Album> find_albums_by_name(string name) throws Error {
            var stmt = prepare("SELECT * FROM albums WHERE name LIKE ?");
            stmt.bind_text(1, "%" + name + "%");
            return fetch_albums(stmt);
        }
        
        // ALBUM AUXILIARY METHODS //        
        private Album row_to_album(Statement stmt) throws Error{
            int? year = get_nullable_int(stmt, 3);
            
            var a = new Album(
                stmt.column_int(0),
                stmt.column_text(2),
                stmt.column_text(1),
                year
                );

            return a;
        }
        
        private void album_to_row(Statement stmt, Album album) throws Error {
            stmt.bind_text(1, album.get_path());
            stmt.bind_text(2, album.get_name());
            bind_nullable_int(stmt, 3, album.get_year());            
        }

        private ArrayList<Album> fetch_albums(Statement stmt) throws Error{
            var list = new ArrayList<Album>();
            while(stmt.step() == Sqlite.ROW)
                list.add(row_to_album(stmt));
            return list;
        }
        
    }
}