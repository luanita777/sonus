using GLib;

namespace Sonus {

    public class Song : Object {
        
        private int     _id;
        private string  _title;
        private int     _performer_id;
        private string  _path;
        private int?    _album_id;
        private string? _genre;
        private int?    _year;
        private int?    _track;
    

        //Constructor
        public Song(int id, string title, int performer_id, string path, 
                    int? album_id = null, string? genre = null, 
                    int? year = null, int? track = null) throws DomainError {
            
            this.set_id(id);
            this.set_title(title);
            this.set_performer_id(performer_id); 
            this.set_path(path);
            this.set_album_id(album_id);         
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
        
        public int get_performer_id() {
            return this._performer_id;
        }
        
        public string get_path() {
            return this._path;
        }
        
        public int? get_album_id() {
            return this._album_id;
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
                throw new DomainError.INVALID_DATA("Song ID must be greater than 0.");
            this._id = value;
        }
        
        public void set_title(string value) throws DomainError {
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("Song title can not be empty.");
            this._title = value.strip();
        }
        
        public void set_performer_id(int value) throws DomainError {
            if (value <= 0) {
                throw new DomainError.INVALID_DATA("Performer ID must be greater than 0.");
            }
            this._performer_id = value;
        }
        
        public void set_path(string value) throws DomainError {
            if (value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("Path can not be empty.");

            if(!value.strip().down().has_suffix(".mp3")){
                throw new DomainError.INVALID_DATA("Path needs to have '.mp3' extension.");
            }
            
            this._path = value.strip();
        }
        
        public void set_album_id(int? value) throws DomainError {
            if (value != null && value <= 0) {
                throw new DomainError.INVALID_DATA("Album ID must be greater than 0.");
            }
            this._album_id = value;
        }
        
        public void set_genre(string? value) throws DomainError {
            if (value != null && value.strip().length == 0)
                throw new DomainError.EMPTY_FIELD("Genre can not be empty.");
            if(value != null)
                this._genre = value.strip();
            else
                this._genre = null;
        }
        
        public void set_year(int? value) throws DomainError {
            if (value != null && value < 0)
                throw new DomainError.INVALID_DATA("Year must be greater the 0.");
            this._year = value;
        }
        
        public void set_track(int? value) throws DomainError {
            if (value != null && value <= 0)
                throw new DomainError.INVALID_DATA("Track number must be greater the 0.");
            this._track = value;
        }
        
    }
}

