using GLib;

namespace Sonus {

    public class GroupMembership : Object {
        private int _person_id;
        private int _group_id;

        //constructor
        public GroupMembership(int person_id, int group_id) throws DomainError {
            set_person_id(person_id);
            set_group_id(group_id);
        }

        //GETTERS
        public int get_person_id() {
            return this._person_id;
        }
        
        public int get_group_id() {
            return this._group_id;
        }


        //SETTERS
        public void set_person_id(int value) throws DomainError {
            if (value <= 0)
                throw new DomainError.INVALID_DATA("Invalid Person ID.");
            this._person_id = value;
        }

        public void set_group_id(int value) throws DomainError {
            if (value <= 0)
                throw new DomainError.INVALID_DATA("Invalid Group ID.");
            this._group_id = value;
        }
        
    }
}