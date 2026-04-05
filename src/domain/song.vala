using GLib;

namespace Sonus {

    public class Song : Object {
        
        private int     _id;
        private string  _title;
        private string  _performer;
        private string  _path;
        private string? _album;
        private string? _genre;
        private int?    _year;
        private int?    _track;
    

        //Constructor
        public Song(int id, string title, string performer, string path, string? album = null,
                    string? genre = null, int? year = null, int? track = null) throws DomainError {
            this.set_id(id);
            this.set_title(title);
            this.set_performer(performer);
            this.set_path(path);
            this.set_album(album);
            this.set_genre(genre);
            this.set_year(year);
            this.set_track(track);
        }
        
        //GETTERS
        public int get_id(){
            return this._id;
        }
        
        public string get_title() {
            return this._title;
        }
        
        public string get_performer() {
            return this._performer;
        }
        
        public string get_path() {
            return this._path;
        }
        
        public string? get_album() {
            return this._album;
        }
        
        public string? get_genre() {
            return this._genre;
        }
        
        public int? get_year() {
            return this._year;
        }
        
        public int? get_track() {
            return this._track;
        }
        
        
        // SETTERS
        public void set_id(int value) throws DomainError{
            if(value <= 0)
                throw new DomainError.INVALID_DATA("invalid id-song");
            this._id = value;
        }
        
        public void set_title(string value) throws DomainError {
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("title can not be empty");
            this._title = value.strip();
        }
        
        public void set_performer(string value) throws DomainError {
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("performer can not be empty");
            this._performer = value.strip();
        }
        
        public void set_path(string value) throws DomainError {
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("path can not be empty");

            if(!value.strip().down().has_suffix(".mp3")){
                throw new DomainError.INVALID_DATA("path should have '.mp3' extension");
            }
            
            this._path = value.strip();
        }
        
        public void set_album(string? value) throws DomainError {
            if (value != null && value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("album can not be empty");
            this._album = value.strip();
        }
        
        public void set_genre(string? value) throws DomainError {
            if (value != null && value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("genre can not be empty");
            this._genre = value.strip();
        }
        
        public void set_year(int? value) throws DomainError {
            if (value != null && value < 0)
                throw new DomainError.INVALID_DATA("year can not be negative");
            this._year = value;
        }
        
        public void set_track(int? value) throws DomainError {
            if (value != null && value <= 0)
                throw new DomainError.INVALID_DATA("track can not be negative");
            this._track = value;
        }
        
    }
}

