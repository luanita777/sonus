using GLib;
using Gee;
using Sonus.Miner;
using Sonus.DAO;
using Sonus.Db;

int main(string[] args) {
    var db = DatabaseManager.get_DBM();
    
    try {
        db.open();
        
        string path = args[1];
        var miner = new Miner();   

        miner.mine(path);
        return 0;
        
    } catch (Error e){
        stderr.printf("An error ocurred,  we are sorry. \nDetails: %s\n", e.message);
        return -1;
    } finally{
        db.close();
    }
    
}