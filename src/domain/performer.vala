using GLib;

namespace Sonus {

    public class Performer : Object {
        
        
        private int _id;
        private PerformerType _type;
        private string _name;
        
        //cosntructor
        public Performer(int id = -1, PerformerType type, string name) throws DomainError{
            this.set_id(id);
            this.set_type(type);
            this.set_name(name);
        }
        

        //Getters
        public int get_id(){
            return this._id;
        }
        
        public PerformerType get_performer_type(){
            return this._type;
        }
            
            public string get_name(){
            return this._name;
        }
        
        
        //Setters
        public void set_id(int value) throws DomainError {
            if (value == -1) {
                this._id = value;
                return;
            }
            
            if(value <= 0)
                throw new DomainError.INVALID_DATA("invalid id-performer");
            this._id = value;
            
        }
        
        public void set_type(PerformerType value)  throws DomainError{
            this._type = value;
        }

        public void set_name(string value) throws DomainError{
            string cleanedName = value.strip();
            if(cleanedName == ""){
                throw new DomainError.EMPTY_FIELD("Performer name can´t be empty.");
            }
            this._name = cleanedName;
        }
    }
}