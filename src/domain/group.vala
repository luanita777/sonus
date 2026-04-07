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
            this._start_date = value;
        }

        public void set_end_date(string? value) throws DomainError{;
            this._end_date = value;
        }

    }
}
