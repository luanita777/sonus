namespace Sonus {
    public enum PerformerType {
        PERSON = 0,
        GROUP = 1,
        UNKNOWN = 2;
        
        public static PerformerType map_int(int val) {
            switch (val) {
                case 0: return PERSON;
                case 1: return GROUP;
            default: return UNKNOWN;
            }
        }
    }
}