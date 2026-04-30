[GtkTemplate (ui = "/sonus/app/main_window.ui")]
public class SonusMainWindow : Adw.ApplicationWindow {
    
    public SonusMainWindow (Gtk.Application app) {
        Object (application: app);
    }
}