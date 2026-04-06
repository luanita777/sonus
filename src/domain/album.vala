using GLib;

namespace Sonus {

    public class Album : Object {

        private int    _id;
        private string _name;
        private string _path;
        private int?   _year;

        //constructor
        public Album(int id, string name, string path,  int? year = null) throws DomainError {
            this.set_id(id);
            this.set_name(name);
            this.set_path(path);
            this.set_year(year);
        }


        //GETTERS
        public int get_id(){
            return this._id;
        }

        public string get_name(){
            return this._name;
        }

        public string get_path() {
            return this._path;
        }

        public int? get_year() {
            return this._year;
        }



        //SETTERS
        public void set_id(int value) throws DomainError{
            if(value <= 0)
                throw new DomainError.INVALID_DATA("invalid id-song");
            this._id = value;
        }

        public void set_name(string value) throws DomainError{
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("album name can not be empty");
            this._name = value.strip();
        }

        public void set_path(string value) throws DomainError{
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("path can not be empty");
            
            if(value.strip().down().has_suffix(".mp3")){
                throw new DomainError.INVALID_DATA("path shouldn´t have '.mp3' extension or any extension at all");
            }
            
            this._path = value.strip();
        }

        public void set_year(int? value) throws DomainError {
            if (value != null && value < 0)
                throw new DomainError.INVALID_DATA("year can not be negative");
            this._year = value;
        }


    }

    
}