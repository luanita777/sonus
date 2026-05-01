[GtkTemplate (ui = "/sonus/app/groupDialog.ui")]
public class GroupDialog : Adw.Window {
    
    [GtkChild]
    private unowned Gtk.Entry group_name_entry;
    
    [GtkChild]
    private unowned Gtk.MenuButton start_date_btn;
    [GtkChild]
    private unowned Adw.ButtonContent start_date_content;
    [GtkChild]
    private unowned Gtk.Calendar start_date_calendar;
    
    [GtkChild]
    private unowned Gtk.MenuButton end_date_btn;
    [GtkChild]
    private unowned Adw.ButtonContent end_date_content;
    [GtkChild]
    private unowned Gtk.Calendar end_date_calendar;

    [GtkChild]
    private unowned Gtk.Button new_member_btn;
    
    [GtkChild]
    private unowned Gtk.Button cancel_btn;
    
    [GtkChild]
    private unowned Gtk.Button save_btn;
    
    public GroupDialog (Gtk.Window parent) {
        Object(transient_for: parent, modal: true);
        
        start_date_calendar.day_selected.connect (() => {
                var date = start_date_calendar.get_date ();
                start_date_content.label = date.format ("%Y-%m-%d");
                start_date_btn.popover.popdown ();
            });
        
        // Conectar el calendario de la fecha de fin
        end_date_calendar.day_selected.connect (() => {
                var date = end_date_calendar.get_date ();
                end_date_content.label = date.format ("%Y-%m-%d");
                end_date_btn.popover.popdown ();
            });

        new_member_btn.clicked.connect(() => {
               var dialog = new PersonDialog(this);
               dialog.present();
            });
        
        cancel_btn.clicked.connect (() => {
                this.close ();
            });
        
        save_btn.clicked.connect (() => {                    
                this.close ();
            });
        
    }
}
