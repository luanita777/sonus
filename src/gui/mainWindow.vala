using GLib;
using Sonus;
using Sonus.DAO;
using Sonus.Miner;

[GtkTemplate (ui = "/sonus/app/mainWindow.ui")]
public class MainWindow : Adw.ApplicationWindow {
    
    [GtkChild]
    private unowned Gtk.Stack main_stack;
    
    [GtkChild]
    private unowned Gtk.Button list_btn;
    [GtkChild]
    private unowned Gtk.ListBox list_box;

    [GtkChild]
    private unowned Gtk.Button mine_songs_btn;
    
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

    private unowned Sonus.DAO.DAO dao;

    private unowned string path;
    
    public MainWindow (Gtk.Application app, Sonus.DAO.DAO _dao, string _path) {
        Object (application: app);
        this.dao = _dao;
        this.path = _path;
        
        list_btn.clicked.connect (() => {
                main_stack.visible_child_name = "list";
            });       

        mine_songs_btn.clicked.connect(() => {
                var miner = new Sonus.Miner.Miner(dao);
                miner.mine(path);
                load_songs(dao);
            });
        
        create_person_btn.clicked.connect (() => {
                var dialog = new PersonDialog(this, dao);
                dialog.set_transient_for(this);
                dialog.set_modal(true);
                dialog.present();
            });
        
        create_group_btn.clicked.connect (() => {
                var dialog = new GroupDialog(this, dao);
                dialog.set_transient_for(this);
                dialog.set_modal(true);
                dialog.present();
            });

        setup_button_actions();
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
  

    private void load_songs(Sonus.DAO.DAO dao) {
        try {
            var current_songs= dao.find_all_songs();
            
            var list_row = list_box.get_row_at_index(0);
            while (list_row != null) {
                list_box.remove(list_row);
                list_row = list_box.get_row_at_index(0);
            }
            
            foreach (var song in current_songs) {
                if (song == null) 
                    continue;                            
            
                string performer_name = "Unknown";
                string album_name = "Unknown";
                string genre_name = "Unknown";
            
                if (dao != null) {
                    try {
                        int? performer_id = song.get_performer_id();
                        var performer = performer_id == null ? null : dao.find_performer_by_id(performer_id);

                        int? album_id = song.get_album_id();
                        var album = album_id == null ? null : dao.find_album_by_id(album_id);
                    
                        if (performer != null) 
                            performer_name = performer.get_name();
                        
                        if (album != null) 
                            album_name = album.get_name();

                        if(song.get_genre() != null)
                            genre_name = song.get_genre();
                        
                    } catch (Error e) {
                        show_error("There was an error while trying to find performer or album: " + e.message);
                    }
                } else {
                    show_error("[CRITICAL]: DAO IS NULL");
                }
            
                var list_btn = new Gtk.Button();
                list_btn.add_css_class("flat");
            
                var list_box_row = new Gtk.ListBoxRow();
                var list_box_content = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 12);
            
                list_box_content.margin_start = 12;
                list_box_content.margin_end = 12;
                list_box_content.margin_top = 8;
                list_box_content.margin_bottom = 8;
                list_box_content.valign = Gtk.Align.CENTER;
            
                var list_icon = new Gtk.Image.from_icon_name("audio-x-generic");
                list_icon.pixel_size = 42;
                list_box_content.append(list_icon);
            
                var texts_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
                texts_box.hexpand = true;
                texts_box.valign = Gtk.Align.CENTER;
            
                var title_label = new Gtk.Label(null);
                title_label.set_markup("<b> %s </b>".printf(Markup.escape_text(song.get_title())));
                title_label.halign = Gtk.Align.START;
            
                var artist_n_genre_label = new Gtk.Label(null);
                artist_n_genre_label.set_text("%s   •   %s".printf(performer_name, genre_name)); 
                artist_n_genre_label.halign = Gtk.Align.START;
            
                texts_box.append(title_label);
                texts_box.append(artist_n_genre_label);
                list_box_content.append(texts_box);
            
                var album_label = new Gtk.Label(album_name);
                album_label.halign = Gtk.Align.END;
                album_label.margin_end = 12;
                album_label.add_css_class("dim-label"); 
                list_box_content.append(album_label);
            
                list_btn.set_child(list_box_content);
            
                list_btn.clicked.connect(() => {
                        var dialog = new EditSongDialog(this, dao, song.get_id());
                        dialog.set_transient_for(this);
                        dialog.set_modal(true);
                        dialog.song_saved.connect (() => {                                
                                load_songs(dao);
                            });
                        dialog.present();
                    });
            
                list_box_row.set_child(list_btn);
                list_box.append(list_box_row);
            }
            
            main_stack.visible_child_name = "list";
            
        } catch (Error e) {           
            show_error("There was an error trying to upload the songs from the DB.");
        }
    }
    
    private void show_error(string message){
        string title = "Error";
        var error_dialog = new Adw.MessageDialog(this, title, message);
        error_dialog.add_response("ok", "Accept");
        error_dialog.set_default_response("ok");
        error_dialog.present();
    }
        
}