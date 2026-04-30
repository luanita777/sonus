[GtkTemplate (ui = "/sonus/app/main_window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    
    [GtkChild]
    private unowned Gtk.Stack main_stack;
    
    [GtkChild]
    private unowned Gtk.Button list_btn;
    
    [GtkChild]
    private unowned Gtk.Button grid_btn;
    
    [GtkChild]
    private unowned Gtk.Button create_person_btn;
    
    [GtkChild]
    private unowned Gtk.Button create_group_btn;
    
    public MainWindow (Gtk.Application app) {
        Object (application: app);
        
        list_btn.clicked.connect (() => {
                main_stack.visible_child_name = "list";
            });
        
        grid_btn.clicked.connect (() => {
                main_stack.visible_child_name = "grid";
            });
        
        create_person_btn.clicked.connect (() => {

            });
        
        create_group_btn.clicked.connect (() => {

            });
    }
}