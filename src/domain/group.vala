using GLib;

namespace Sonus{

    public class Group : Performer {
        
        private string? _start_date;
        private string? _end_date;

        //constructor
        public Group(int id, string stage_name, string? start_date = null, string? end_date = null) throws DomainError{
            base(id, PerformerType.GROUP, stage_name);
            this._start_date = start_date;
            this._end_date = end_date;
        }

        //GETTERS
        public string? get_start_date(){
            return this._start_date;
        }

        public string? get_end_date(){
            return this._end_date;
        }


        //SETTERS
        public void set_start_date(string? value) throws DomainError{
            string? potential = validate_date_format(value);
            validate_chronology(potential, this._end_date);
            this._start_date = potential;
        }


        public void set_end_date(string? value) throws DomainError{
            string? potential = validate_date_format(value);
            validate_chronology(this._start_date, potential);
            this._end_date = potential;
        }


        //auxiliary methods
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

            if (!gDate.valid()) 
                throw new DomainError.INVALID_DATA("Date does not exist in calendar");

            return cleaned;
        }

        
        private static void validate_chronology(string? start, string? end) throws DomainError {
            if (start == null || end == null)
                return;

            if (start > end) 
                throw new DomainError.INVALID_DATA("Chronology error: Start date is after end date");
        }

    }
}
