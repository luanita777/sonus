using GLib;
using Sqlite;
using Gee;

namespace Sonus.DAO{

    public class DAO {

         // PERSON WRITERS //        
        public void save_person(Person person) throws Error {
            
        }
        
        public void delete_person(int id) throws Error {
            
        }
        
        
        // PERSON CONSULTS //
        public Person? find_person_by_id(int id) throws Error {
            return null;
        }

        public ArrayList<Person> find_all_persons() throws Error {
            return new ArrayList<Person>();
        }
        
        public ArrayList<Person> find_person_by_name(string name) throws Error {
            return new ArrayList<Person>();
        }
        
        // PERSON AUXILIARY METHODS //
        private void insert_person(Person person) throws Error {
            
        }
        
        private void update_person(Person person) throws Error {
            
        }
        
        private Person row_to_person(Statement stmt) {
            return null;
        }
        
        private void person_to_row(Statement stmt, Person person) throws Error {
            
        }
    }
}