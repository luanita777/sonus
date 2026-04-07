using GLib;

namespace Sonus{

    public class Person : Performer {
        private string? _real_name;
        private string? _birth_date;
        private string? _death_date;

        //constructor
        public Person(int id, string stage_name, string? real_name = null, 
                      string? birth_date = null, string? death_date = null) throws DomainError {
            
            base(id, PerformerType.PERSON, stage_name);
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
            return this._death_date;
        }


        //SETTERS
        public void set_real_name(string? value) throws DomainError{
            if (value == null) {
                this._real_name = null;
                return;
            }
            
            if (value.strip().length == 0) 
                throw new DomainError.EMPTY_FIELD("Real name can not be empty.");
            
            this._real_name = value.strip();
        }

        public void set_birth_date(string? value) throws DomainError{
            string? potential = validate_date_format(value);
            validate_chronology(potential, this._death_date);
            this._birth_date = potential;
        }

        public void set_death_date(string? value) throws DomainError{
            string? potential = validate_date_format(value);
            validate_chronology(this._birth_date, potential);
            this._death_date = potential;
        }

        private static string? validate_date_format(string? date) throws DomainError {
            if (date == null)
                return null;

            string cleaned = date.strip();
            if (!Regex.match_simple("^\\d{4}-\\d{2}-\\d{2}$", cleaned)) 
                throw new DomainError.INVALID_DATA("Invalid date format. Use YYYY-MM-DD");
           
            // we use GLib.Date 
            string[] parts = cleaned.split("-");
            int year = int.parse(parts[0]);
            int month = int.parse(parts[1]);
            int day = int.parse(parts[2]);

            Date gDate = Date();
            gDate.set_dmy((DateDay)day, (DateMonth)month, (DateYear)year);

            if (!gDate.valid()) {
                throw new DomainError.INVALID_DATA("Date does not exist in calendar");
            }

            return cleaned;
        }

        
        private static void validate_chronology(string? birth, string? death) throws DomainError {
            if (birth == null || death == null)
                return;

            if (birth > death) {
                throw new DomainError.INVALID_DATA("Chronology error: Birth date is after death date");
            }
        }

        
    }
}


