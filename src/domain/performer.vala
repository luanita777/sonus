using GLib;

public class Performer : Object {

    
    private int _id;
    private PerformerType _type;
    private string _name;

    //cosntructor
    public Performer(int id, Performertype type, string name){
        this.set_id(id);
        this.set_type(type);
        this.set_name(name);
    }


    //Getters
    public int get_id(){
        return this._id;
    }

    public PerformerType get_type(){
        return this._type;
    }

    public string get_name(){
        return this._name;
    }


    //Setters
    public void set_id(int value) throws Sonus.DomainError {
        this._id = value;
    }

    public void set_type(PerformerType value)  throws Sonus.DomainError{
        this._type = value;
    }

    public void set_name(string value) throws Sonus.DomainError{
        this._name = value;
    }
}