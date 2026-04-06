using GLib;

namespace Sonus{

    public class Person : Performer {
        private string? _real_name;
        private string? _birth_date;
        private string? _death_date;

        //constructor
        public Person(int id, string stage_name, string? real_name = null, 
                      string? birth_date = null, string? death_date = null) throws DomainError {
            
            base(id, stage_name, PerformerType.PERSON);
            this._real_name = real_name;
            this._birth_date = birth_date;
            this._death_date = death_date;
        }

        //GETTERS
        public string? get_real_name(){
            return this._real_name;
        }

        public string? get_birth_date(){
            return this._birth_date;
        }

        public string? get_death_date(){
            return this.death_date;
        }


        //SETTERS
        public void set_real_name(string? value) throws DomainError{
            this._real_name = value;
        }

        public void set_birth_date(string? value) throws DomainError{
            this._birth_date = value;
        }

        public void set_death_date(string? value) throws DomainError{
            this._death_date = value;
        }

    }
}