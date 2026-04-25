using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {

    public partial class DAO {

        // PERFORMER WRITERS //        
        public void insert_performer(Performer performer) throws Error {
            var sql = "INSERT INTO performers (id_type, name) VALUES (?, ?)";
            var stmt = prepare(sql);
            performer_to_row(stmt, performer);
            stmt.step();
        }

        public void update_performer(Performer performer) throws Error{
            var sql = "UPDATE performers SET id_type=?, name=? WHERE id_performer = ?";
            var stmt = prepare(sql);
            performer_to_row(stmt, performer);
            stmt.bind_int(3, performer.get_id());
            stmt.step();
        }        
        
        
        
        // PERFORMER CONSULTS //
        public Performer? find_performer_by_id(int id) throws Error {
            var stmt = prepare("SELECT * FROM performers WHERE id_performer = ?");
            stmt.bind_int(1, id);
            if(stmt.step() == Sqlite.ROW)
                return row_to_performer(stmt);
            return null;
        }

        public ArrayList<Performer> find_all_performers() throws Error {
            return fetch_performers(prepare("SELECT * FROM performers"));
        }
        
        public ArrayList<Performer> find_performers_by_type(PerformerType performerType) throws Error {
            var stmt = prepare("SELECT * FROM performers WHERE id_type = ?");
            stmt.bind_int(1, (int)performerType);
            return fetch_performers(stmt);
        }
        
        public ArrayList<Performer> find_performers_by_name(string name) throws Error {
            var stmt = prepare("SELECT * FROM performers WHERE name LIKE ?");
            stmt.bind_text(1, "%" + name + "%");
            return fetch_performers(stmt);
        }
        
        // PERFORMER AUXILIARY METHODS //
        
        private Performer row_to_performer(Statement stmt) throws Error {
            var p = new Performer(stmt.column_int(0), stmt.column_int(1), stmt.column_text(2));
            return p;
        }

        
        private void performer_to_row(Statement stmt, Performer performer) throws Error {
            stmt.bind_int(1, (int)performer.get_performer_type());
            stmt.bind_text(2, performer.get_name());
        }

        private ArrayList<Performer> fetch_performers(Statement stmt) throws Error{
            var list = new ArrayList<Performer>();
            while(stmt.step() == Sqlite.ROW)
                list.add(row_to_performer(stmt));
            return list;
        }
    }
}