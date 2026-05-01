using GLib;
using Gee;
using Sonus.Miner;
using Sonus.DAO;
using Sonus.Db;

int main(string[] args) {
    Adw.init();

    var app = new Adw.Application("sonus.app", GLib.ApplicationFlags.HANDLES_COMMAND_LINE);
    
    string path = "";

    app.command_line.connect((app, command_line) => {
        var cmd_args = command_line.get_arguments();
        
        if (cmd_args.length < 2) {
            stderr.printf("Error: Missing argument. Usage: sonus <path/of/the/songs/for/the/app>\n");
            return -1;
        }
        
        path = cmd_args[1];

        app.activate();
        return 0;
    });

    var dao = new Sonus.DAO.DAO();
    var db = DatabaseManager.get_DBM();

    app.activate.connect(() => {
        try {
            db.open();
            var window = new MainWindow(app, dao, path);
            window.present();
        } catch (Error e) {
            stderr.printf("An error occurred, we are sorry. \nDetails: %s\n", e.message);
        }
    });

    int status = app.run(args);

    try {
        db.close();
    } catch (Error e) {
        stderr.printf("Error closing database: %s\n", e.message);
    }

    return status;
}