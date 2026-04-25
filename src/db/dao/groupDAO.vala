using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO {
    
    public partial class DAO {
        
        // GROUP WRITERS //        
        public void insert_group(Group group) throws Error {
            var performer = new Performer(group.get_id(), (int)PerformerType.GROUP, group.get_name());
            update_performer(performer);

            var sql = "INSERT INTO groups (id_group, name, start_date, end_date) VALUES (?, ?, ?, ?)";
            var stmt  = prepare(sql);
            group_to_row(stmt, group);
            stmt.step();
        }

        public void update_group(Group group) throws Error {
            var performer = new Performer(group.get_id(), PerformerType.GROUP, group.get_name());
            update_performer(performer);

            var sql = "UPDATE groups SET name = ?, start_date = ?, end_date = ? WHERE id_group = ?";
            var stmt = prepare(sql);
            stmt.bind_text(1, group.get_name());
            bind_nullable_text(stmt, 2, group.get_start_date());
            bind_nullable_text(stmt, 3, group.get_end_date());
            stmt.bind_int(4, group.get_id());
            stmt.step();
        }
        
        
        
        // GROUP CONSULTS //
        public Group? find_group_by_id(int id) throws Error {
            var sql = "SELECT p.id_performer, p.name, g.start_date, g.end_date " +
                "FROM performers p JOIN groups g ON p.id_performer = g.id_group " +
                "WHERE p.id_performer = ?";
            var stmt = prepare(sql);
            stmt.bind_int(1, id);

            if(stmt.step() == Sqlite.ROW)
                return row_to_group(stmt);
            return null;
        }
        
        public ArrayList<Group> find_all_groups() throws Error {
            var sql = "SELECT p.id_performer, p.name, g.start_date, g.end_date " +
                "FROM performers p JOIN groups g ON p.id_performer = g.id_group";

            var stmt = prepare(sql);
            var list = new ArrayList<Group>();
            while(stmt.step() == Sqlite.ROW){
                var group = row_to_group(stmt);
                list.add(group);
            }
            return list;                
        }

        
        // GROUP AUXILIARY METHODS //
        
        private Group row_to_group(Statement stmt) throws Error{
            return new Group(
                             stmt.column_int(0),
                             stmt.column_text(1),
                             stmt.column_text(2),
                             stmt.column_text(3)
                             );
        }
        
        private void group_to_row(Statement stmt, Group g) throws Error {
            stmt.bind_int(1, g.get_id());
            stmt.bind_text(2, g.get_name());
            bind_nullable_text(stmt, 3, g.get_start_date());
            bind_nullable_text(stmt, 4, g.get_end_date());
        }
    }
}