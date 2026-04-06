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
            this._id = value;
        }

        public void set_name(string value) throws DomainError{
            this._name = value.strip();
        }

        public void set_path(string value) throws DomainError{
            this._path = value.strip();
        }

        public void set_year(int? value) throws DomainError {
            this._year = value;
        }


    }

    
}