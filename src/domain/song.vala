public class Song : Object {

    private string  _title;
    private string  _performer;
    private string  _path;
    private string? _album;
    private string? _genre;
    private int?    _year;
    private int?    _track;

    public Song(string title, string performer, string path, string? album = null,
                string? genre = null, int? year = null, int? track = null) {
        
        this.title = title;
        this.performer = performer;
        this.path = path;
        this.album = album;
        this.genre = genre;
        this.year = year;
        this.track = track;
    }

    public string title {
        get { return _title; }
        set { _title = value; }
    }

    public string performer {
            get { return _performer; }
            set { _performer = value; }
    }

    public string path {
        get { return _path; }
        set { _path = value; }
    }

    public string? album {
        get { return _album; }
        set { _album = value; }
    }

    public string? genre {
        get { return _genre; }
        set { _genre = value; }
    }

    public int? year {
        get { return _year; }
        set { _year = value; }
    }

    public int? track {
        get { return _track; }
        set { _track = value; }
    }
    

   
}