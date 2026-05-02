using GLib;
using Sonus;
using Sonus.DAO;

[GtkTemplate (ui = "/sonus/app/editSongDialog.ui")]
public class EditSongDialog : Adw.Window {
    
    [GtkChild]
    private unowned Gtk.Entry title_entry;
    
    [GtkChild]
    private unowned Gtk.DropDown performers_dropdown;
    
    [GtkChild]
    private unowned Gtk.Button create_person_btn;
    
    [GtkChild]
    private unowned Gtk.Button create_group_btn;
    
    [GtkChild]
    private unowned Gtk.Button edit_artist_btn;
    
    [GtkChild]
    private unowned Gtk.Entry genre_entry;      
      
    [GtkChild]
    private unowned Gtk.Button cancel_btn;
      
    [GtkChild]
    private unowned Gtk.Button save_btn;

    public signal void song_saved();

    private unowned Sonus.DAO.DAO dao;
    private int song_id;
    
    private Gee.ArrayList<Performer> performers_list;
    
    public EditSongDialog (Gtk.Window parent, Sonus.DAO.DAO dao, int id) {
        Object (transient_for: parent, modal: true);
        this.dao = dao;
        this.song_id = id;    
      
        load_performers_dropdown();        
        load_song_data(id);
      
        title_entry.notify["text"].connect(validate_forms);
      
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
 
        edit_artist_btn.clicked.connect (() => {
            edit_selected_artist();
        });
 
        cancel_btn.clicked.connect (() => {
            this.close();
        });
 
        save_btn.clicked.connect (() => {
            save_song(id);
        });
    }

    private void load_performers_dropdown() {
        try{
            performers_list = dao.find_all_performers();
            
            var string_list = new Gtk.StringList (null);
            
            foreach (var performer in performers_list) {
                string_list.append (performer.get_name()); 
            }
            
            performers_dropdown.model = string_list;
        }catch(Error e){
            show_error("There was an error loading performers. " + e.message);
        }
    }
    
    private void load_song_data(int id) {
        try{
            var song = dao.find_song_by_id(id); 
            
            if (song != null) {
                title_entry.text = song.get_title();
                genre_entry.text = song.get_genre();
                
                for (int i = 0; i < performers_list.size; i++) {
                    var performer = performers_list.get(i);
                    if (performer.get_id() == song.get_performer_id()) {
                        performers_dropdown.selected = (uint)i;
                        break;
                    }
                }
            }
        }catch(Error e){
            show_error("There was an error loading the song data. " + e.message);
        }
    }

    private void edit_selected_artist() {
        int selected_index = (int)performers_dropdown.selected;
        if (selected_index < performers_list.size) {
            var performer = performers_list.get(selected_index);
            var performer_type = performer.get_performer_type();
        
            if (performer_type == PerformerType.GROUP) { 
                var dialog = new EditGroupDialog(this, dao, performer.get_id());
                dialog.set_transient_for(this);
                dialog.set_modal(true);
                
                dialog.group_saved.connect (() => {
                    load_performers_dropdown();
                });
        
                dialog.present();
            } else if (performer_type == PerformerType.PERSON) {
                var dialog = new EditPersonDialog(this, dao, performer.get_id());
                dialog.set_transient_for(this);
                dialog.set_modal(true);
                
                dialog.person_saved.connect (() => {
                    load_performers_dropdown();
                });
                
                dialog.present();
            } else if (performer_type == PerformerType.UNKNOWN) {

                var type_dialog = new Adw.MessageDialog(
                    this,
                    "Select Artist Type",
                    "This artist has no type assigned. Please choose if the artist is a Person or a Group:"
                );
                
                type_dialog.add_response("cancel", "Cancel");
                type_dialog.add_response("person", "Person");
                type_dialog.add_response("group", "Group");
                type_dialog.set_close_response("cancel");
                
                type_dialog.response.connect((_dialog, response_id) => {
                    if (response_id == "person") {
                        var dialog = new EditPersonDialog(this, dao, performer.get_id());
                        dialog.set_transient_for(this);
                        dialog.set_modal(true);
                        
                        dialog.person_saved.connect (() => {
                            load_performers_dropdown();
                        });
                        
                        dialog.present();
                    } else if (response_id == "group") {
                        var dialog = new EditGroupDialog(this, dao, performer.get_id());
                        dialog.set_transient_for(this);
                        dialog.set_modal(true);
                        
                        dialog.group_saved.connect (() => {
                            load_performers_dropdown();
                        });
                        
                        dialog.present();
                    }
                });
                
                type_dialog.present();
            }
        }      
    }

    private void save_song (int id) {
        try{
            var song = dao.find_song_by_id(id);
            var new_title = title_entry.text;
            var new_genre = genre_entry.text;
            
            uint selected_index = performers_dropdown.selected;
            var performer = performers_list.get((int)selected_index);
            
            int new_performer = dao.find_performer_by_exact_name(performer.get_name());
            
            song.set_title(new_title);
            song.set_genre(new_genre);
            song.set_performer_id(new_performer);
            
            dao.update_song(song);
            
            song_saved();
            
            this.close ();
        }catch(Error e){
            show_error("There was an error trying to update the song. " + e.message);
        }
            
    }

    private void validate_forms() {
        var song_name = title_entry.get_text().strip();
        if(song_name == "") {
            save_btn.set_sensitive(false);
            return;
        }
        save_btn.set_sensitive(true);                                        
    }

    private void show_error(string message) {
        string title = "Error";
        var error_dialog = new Adw.MessageDialog(this, title, message);
        error_dialog.add_response("ok", "Accept");
        error_dialog.set_default_response("ok");
        error_dialog.present();
    }
}