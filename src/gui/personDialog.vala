[GtkTemplate (ui = "/sonus/app/personDialog.ui")]
    public class PersonDialog : Adw.Window {
        [GtkChild]
        private unowned Gtk.Entry stage_name_entry;
        
        [GtkChild]
        private unowned Gtk.Entry real_name_entry;
        
        [GtkChild]
        private unowned Gtk.MenuButton birth_date_btn;
        [GtkChild]
        private unowned Gtk.Calendar birth_date_calendar;

        [GtkChild]
        private unowned Gtk.MenuButton death_date_btn;
        [GtkChild]
        private unowned Gtk.Calendar death_date_calendar;
        
        [GtkChild]
        private unowned Gtk.Button cancel_btn;
        
        [GtkChild]
        private unowned Gtk.Button save_btn;

        public PersonDialog (Gtk.Window parent) {
            Object (transient_for: parent, modal: true);

            birth_date_calendar.day_selected.connect (() => {
                var date = birth_date_calendar.get_date();
                birth_date_btn.label = date.format ("%Y-%m-%d");
                birth_date_btn.popover.popdown ();
            });

            death_date_calendar.day_selected.connect (() => {
                var date = death_date_calendar.get_date();
                death_date_btn.label = date.format ("%Y-%m-%d");
                death_date_btn.popover.popdown ();
            });

            cancel_btn.clicked.connect (() => {
                this.close ();
            });

            save_btn.clicked.connect (() => {
                    
                this.close ();
            });
        }
    }