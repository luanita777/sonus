using GLib;
using Sonus.DAO;
using Sonus;

[GtkTemplate (ui = "/sonus/app/groupDialog.ui")]
public class GroupDialog : Adw.Window {
    
    [GtkChild]
    private unowned Gtk.Entry group_name_entry;
    
    [GtkChild]
    private unowned Gtk.MenuButton start_date_btn;
    [GtkChild]
    private unowned Gtk.Calendar start_date_calendar;
    
    [GtkChild]
    private unowned Gtk.MenuButton end_date_btn;
    [GtkChild]
    private unowned Gtk.Calendar end_date_calendar;

    [GtkChild]
    private unowned Gtk.Button new_member_btn;
    
    [GtkChild]
    private unowned Gtk.Button cancel_btn;
    
    [GtkChild]
    private unowned Gtk.Button save_btn;

    [GtkChild]
    private unowned Gtk.ListBox members_listbox;

    private string? start_date_str = null;
    private string? end_date_str = null;
    
    private Sonus.DAO.DAO dao;
    
    public GroupDialog (Gtk.Window parent, Sonus.DAO.DAO _dao) {
        Object(transient_for: parent, modal: true);
        this.dao = _dao;

        save_btn.set_sensitive(false);

        group_name_entry.notify["text"].connect(validate_forms);
        
        start_date_calendar.day_selected.connect (() => {
                var date = start_date_calendar.get_date();
                start_date_str = date.format("%Y-%m-%d");
                start_date_btn.label = start_date_str;
                start_date_btn.popover.popdown();
                validate_forms();
            });
        

        end_date_calendar.day_selected.connect (() => {
                var date = end_date_calendar.get_date();
                end_date_str = date.format("%Y-%m-%d");
                end_date_btn.label = start_date_str;
                end_date_btn.popover.popdown();
                validate_forms();
            });

        new_member_btn.clicked.connect(() => {
                var dialog = new PersonDialog(this, dao);
                dialog.present();
    
                ((Gtk.Widget) dialog).destroy.connect(() => {
                        load_available_members();
                    });
            });
        
        cancel_btn.clicked.connect (() => {
                this.close ();
            });
        
        save_btn.clicked.connect (() => {                    
                save_group();
            });

        load_available_members();
        
    }

    private void load_available_members(){
        var child = members_listbox.get_first_child();
        while(child != null){
            var next = child.get_next_sibling();
            members_listbox.remove(child);
            child = next;
        }
        
        try{
            var performers = dao.find_all_performers();
         
            foreach(var p in performers){

                if(p.get_performer_type() == PerformerType.PERSON){
                    
                
                    var row = new Gtk.ListBoxRow();
                    var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
                    box.margin_start = 6;
                    box.margin_end = 6;
                    box.margin_top = 4;
                    box.margin_bottom = 4;
                    
                    var check = new Gtk.CheckButton();
                    check.name = p.get_id().to_string();
                    
                    var label = new Gtk.Label(p.get_name());
                
                    box.append(check);
                    box.append(label);
                    row.set_child(box);
                    members_listbox.append(row);
                }
            }
            
        }catch(Error e){
            show_error("Error loadings performers: " + e.message);
        }
        
    }
    
    private void validate_forms(){
        try{
            var group_name = group_name_entry.get_text().strip();
            if(group_name == ""){
                save_btn.set_sensitive(false);
                return;
            }
            
            var g = new Group(-1, group_name);

            g.set_start_date(start_date_str);
            g.set_end_date(end_date_str);
            save_btn.set_sensitive(true);
            
        }catch(DomainError e){
            save_btn.set_sensitive(false);
        }
    }
    
    private void save_group(){
        try{
            var name = group_name_entry.get_text();
            var group = new Group(-1, name, start_date_str, end_date_str);
            dao.insert_group(group);
            
            var child = members_listbox.get_first_child();
            while (child != null) {
                var row = child as Gtk.ListBoxRow;
                if (row != null) {
                    var box = row.get_child() as Gtk.Box;
                    var check = box.get_first_child() as Gtk.CheckButton;
                    if (check != null && check.active) {
                        int person_id = int.parse(check.name);
                        dao.insert_membership(person_id, group.get_id());                
                    }
                    child = child.get_next_sibling();
                }                
                this.close();                
                print("Success creating new group: %s\n", group.get_name());
            }
        }catch(DAOError e){
            show_error("Error saving group: " + e.message);
        }catch(DomainError e){
            show_error("Error with the new group data validation. " + e.message);            
        }catch(Error e){
            show_error("Sorry, an error ocurred: " + e.message);
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
