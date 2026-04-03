using GLib;

public errordomain SongError {
    EMPTY_FIELD,
    INVALID_DATA
}

public class Song : Object {

    private string  _title;
    private string  _performer;
    private string  _path;
    private string? _album;
    private string? _genre;
    private int?    _year;
    private int?    _track;


    //Constructor
    public Song(string title, string performer, string path, string? album = null,
                string? genre = null, int? year = null, int? track = null) throws SongError {
        this.set_title(title);
        this.set_performer(performer);
        this.set_path(path);
        this.set_album(album);
        this.set_genre(genre);
        this.set_year(year);
        this.set_track(track);
    }

    //GETTERS
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
    public void set_title(string value) throws SongError {
        this._title = value;
    }
    
    public void set_performer(string value) throws SongError {
        this._performer = value;
    }
    
    public void set_path(string value) throws SongError {
        this._path = value;
    }
    
    public void set_album(string? value) throws SongError {
        this._album = value;
    }
    
    public void set_genre(string? value) throws SongError {
        this._genre = value;
    }
    
    public void set_year(int? value) throws SongError {
        this._year = value;
    }
    
    public void set_track(int? value) throws SongError {
        this._track = value;
    }
}


