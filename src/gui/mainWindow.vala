[GtkTemplate (ui = "/sonus/app/mainWindow.ui")]
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

    [GtkChild]
    private unowned Gtk.Button btn_song;
    [GtkChild]
    private unowned Gtk.Button btn_artist;
    [GtkChild]
    private unowned Gtk.Button btn_genre;
    [GtkChild]
    private unowned Gtk.Button btn_album;
    [GtkChild]
    private unowned Gtk.Button btn_and;
    [GtkChild]
    private unowned Gtk.Button btn_or;
    [GtkChild]
    private unowned Gtk.Button btn_not;
    [GtkChild]
    private unowned Gtk.Button btn_parenthesis;
    [GtkChild]
    private unowned Gtk.Button btn_comma;

    [GtkChild]
    private unowned Gtk.SearchEntry search_entry;
    
    public MainWindow (Gtk.Application app) {
        Object (application: app);
        
        list_btn.clicked.connect (() => {
                main_stack.visible_child_name = "list";
            });
        
        grid_btn.clicked.connect (() => {
                main_stack.visible_child_name = "grid";
            });
        
        create_person_btn.clicked.connect (() => {
                var dialog = new PersonDialog(this);
                dialog.set_transient_for(this);
                dialog.set_modal(true);
                dialog.present();
            });
        
        create_group_btn.clicked.connect (() => {
                var dialog = new GroupDialog(this);
                dialog.set_transient_for(this);
                dialog.set_modal(true);
                dialog.present();
            });

        setup_button_actions ();
    }

    private void setup_button_actions () {
        connect_look_button(btn_song);
        connect_look_button(btn_artist);
        connect_look_button(btn_genre);
        connect_look_button(btn_album);
        connect_logic_button(btn_and);
        connect_logic_button(btn_or);
        connect_logic_button(btn_not);
        connect_pths_button(btn_parenthesis);
        connect_comma_button(btn_comma);
    }

    private void connect_look_button (Gtk.Button btn) {
        btn.clicked.connect (() => {
                int position = search_entry.get_position();
                var text_to_insert = btn.label.down () + ": ";
        
                ((Gtk.Editable) search_entry).insert_text(text_to_insert, -1, ref position);
                search_entry.set_position(position);
                search_entry.grab_focus();
            });
    }
    
    private void connect_logic_button (Gtk.Button btn){
        btn.clicked.connect (() => {
                int position = search_entry.get_position();
                var text_to_insert = " " + btn.label + " ";
                
                ((Gtk.Editable) search_entry).insert_text(text_to_insert, -1, ref position);
                search_entry.set_position(position);
                search_entry.grab_focus();
            });
    }
    
    private void connect_comma_button (Gtk.Button btn){
        btn.clicked.connect (() => {
                int position = search_entry.get_position();
                var text_to_insert = btn.label + " ";
        
                ((Gtk.Editable) search_entry).insert_text(text_to_insert, -1, ref position);
                search_entry.set_position(position);
                search_entry.grab_focus();
            });
    }
    
    private void connect_pths_button (Gtk.Button btn){
        btn.clicked.connect (() => {
                int position = search_entry.get_position();
                var text_to_insert = btn.label; 
        
                ((Gtk.Editable) search_entry).insert_text(text_to_insert, -1, ref position);
                search_entry.set_position(position - 1);
                search_entry.grab_focus();
            });
    }
        
}