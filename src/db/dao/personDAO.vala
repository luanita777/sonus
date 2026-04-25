using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO{

    public partial class DAO {

         // PERSON WRITERS //        
        public void insert_person(Person person) throws Error{
            var performer = new Performer(person.get_id(), (int)PerformerType.PERSON, person.get_name());
            update_performer(performer);
            
            var sql = "INSERT INTO persons (id_person, stage_name, real_name, birth_date, death_date) VALUES (?, ?, ?, ?, ?)";
            var stmt = prepare(sql);                                 
            person_to_row(stmt, person);
            stmt.step();
        }
        
        public void update_person(Person person) throws Error{                        
            var performer = new Performer(person.get_id(), PerformerType.PERSON, person.get_name());
            update_performer(performer);           

            var sql = "UPDATE persons SET stage_name = ?, real_name = ?, birth_date = ?, death_date = ? WHERE id_person = ?";
            var stmt = prepare(sql);

            stmt.bind_text(1, person.get_name());
            bind_nullable_text(stmt, 2, person.get_real_name());
            bind_nullable_text(stmt, 3, person.get_birth_date());
            bind_nullable_text(stmt, 4, person.get_death_date());
            stmt.bind_int(5, person.get_id());
            stmt.step();         
            
        }
        
        
        // PERSON CONSULTS //
        public Person? find_person_by_id(int id) throws Error {
            var sql = "SELECT p.id_performer, p.name, ps.real_name, ps.birth_date, ps.death_date " +
                       "FROM performers p JOIN persons ps ON p.id_performer = ps.id_person " +
                       "WHERE p.id_performer = ?";
            var stmt = prepare(sql);
            stmt.bind_int(1, id);

            if (stmt.step() == Sqlite.ROW) 
                return row_to_person(stmt);
            return null;
        }

        
        public ArrayList<Person> find_all_persons() throws Error {
            var sql = "SELECT p.id_performer, p.name, ps.real_name, ps.birth_date, ps.death_date " +
                "FROM performers p JOIN persons ps ON p.id_performer = ps.id_person";

            var stmt = prepare(sql);
            var list = new ArrayList<Person>();
            while (stmt.step() == Sqlite.ROW) {
                var person = row_to_person(stmt);
                list.add(person);
            }
            return list;
        }
        
        
        // PERSON AUXILIARY METHODS //
        private void person_to_row(Statement stmt, Person p) throws Error {
            stmt.bind_int(1, p.get_id());
            stmt.bind_text(2, p.get_name());
            stmt.bind_text(3, p.get_real_name());
            bind_nullable_text(stmt, 4, p.get_birth_date());
            bind_nullable_text(stmt, 5, p.get_death_date());
        }
        
        private Person row_to_person(Statement stmt) throws Error {
            return new Person(
                stmt.column_int(0),    
                stmt.column_text(1),   
                stmt.column_text(2),   
                stmt.column_text(3),   
                stmt.column_text(4)    
            );
        }

        
    }
}