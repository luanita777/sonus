using GLib;
using Gee;
using Sonus.Miner;
using Sonus.DAO;
using Sonus.Db;

int main(string[] args) {
    Adw.init ();
    
    var dao = new Sonus.DAO.DAO();
    var db = DatabaseManager.get_DBM();
    try {
        db.open();
        string path = args[1];
            
        var app = new Adw.Application ("sonus.app", 0);
        
        app.activate.connect (() => {
                var window = new MainWindow (app, dao);
                window.present ();
            });
        
        return app.run(args);
    } catch (Error e){
        stderr.printf("An error ocurred,  we are sorry. \nDetails: %s\n", e.message);
        return -1;
    } finally{
        db.close();
    }
    
}