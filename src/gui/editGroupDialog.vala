using GLib;
using Sonus.DAO;
using Sonus;

[GtkTemplate (ui = "/sonus/app/editGroupDialog.ui")]
public class EditGroupDialog : Adw.Window {
    
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

    [GtkChild]
    private unowned Gtk.ListBox members_listbox;

    private string? start_date_str = null;
    private string? end_date_str = null;
    
    private Sonus.DAO.DAO dao;
    private int group_id;

    public signal void group_saved();
    
    public EditGroupDialog (Gtk.Window parent, Sonus.DAO.DAO _dao, int group_id = -1) {
        Object(transient_for: parent, modal: true);
        this.dao = _dao;
        this.group_id = group_id;

        save_btn.set_sensitive(false);

        group_name_entry.notify["text"].connect(validate_forms);
        
        // Load data if editing an existing group
        if (group_id > 0) {
            load_group_data(group_id);
        }

        start_date_calendar.day_selected.connect (() => {
            var date = start_date_calendar.get_date();
            start_date_str = date.format("%Y-%m-%d");
            start_date_content.label = start_date_str;
            start_date_btn.popover.popdown();
            validate_forms();
        });

        end_date_calendar.day_selected.connect (() => {
            var date = end_date_calendar.get_date();
            end_date_str = date.format("%Y-%m-%d");
            end_date_content.label = end_date_str;
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

    private void load_group_data(int id) {
        try {
            var group = dao.find_group_by_id(id);
            if (group != null) {
                this.title = "Edit Group";
                group_name_entry.text = group.get_name();
                
                var save_box = save_btn.get_child() as Gtk.Box;
                var save_label = save_box != null ? save_box.get_last_child() as Gtk.Label : null;
                if (save_label != null) {
                    save_label.label = "<b>Save Changes</b>";
                }

                start_date_str = group.get_start_date();
                end_date_str = group.get_end_date();

                if (start_date_str != null) {
                    start_date_content.label = start_date_str;
                }
                if (end_date_str != null) {
                    end_date_content.label = end_date_str;
                }
            } else {
                this.title = "Edit Group";
                var performers = dao.find_all_performers();
                foreach (var p in performers) {
                    if (p.get_id() == id) {
                        group_name_entry.text = p.get_name();
                        break;
                    }
                }
            }
        } catch (Error e) {
            show_error("Error loading group: " + e.message);
        }
    }

    private void load_available_members() {
        var child = members_listbox.get_first_child();
        while(child != null){
            var next = child.get_next_sibling();
            members_listbox.remove(child);
            child = next;
        }
        
        try {
            var performers = dao.find_all_performers();
            Gee.ArrayList<Person> current_members = null;
            if (group_id > 0) {
                try {
                    current_members = dao.find_persons_by_group_id(group_id);
                } catch (Error e) {
                    current_members = null; 
                }
            }
        
            foreach (var p in performers) {
                if (p.get_performer_type() == PerformerType.PERSON) {
                    var row = new Gtk.ListBoxRow();
                    var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 6);
                    box.margin_start = 6;
                    box.margin_end = 6;
                    box.margin_top = 4;
                    box.margin_bottom = 4;
                    
                    var check = new Gtk.CheckButton();
                    check.name = p.get_id().to_string();

                    if (current_members != null) {
                        foreach (var member in current_members) {
                            if (member.get_id() == p.get_id()) {
                                check.active = true;
                                break;
                            }
                        }
                    }
                    
                    var label = new Gtk.Label(p.get_name());
                    
                    box.append(check);
                    box.append(label);
                    row.set_child(box);
                    members_listbox.append(row);
                }
            }
            
        } catch(Error e) {
            show_error("Error loading performers: " + e.message);
        }
    }
    
    private void validate_forms() {
        try {
            var group_name = group_name_entry.get_text().strip();
            if (group_name == "") {
                save_btn.set_sensitive(false);
                return;
            }
            
            var g = new Group(-1, group_name);
            g.set_start_date(start_date_str);
            g.set_end_date(end_date_str);
            
            save_btn.set_sensitive(true);
        } catch(DomainError e) {
            save_btn.set_sensitive(false);
        }
    }
    
    private void save_group() {
        try {
            var name = group_name_entry.get_text();
            Group group;
            
            group = dao.find_group_by_id(group_id);
            
            if (group != null) {

                group.set_name(name);
                group.set_start_date(start_date_str);
                group.set_end_date(end_date_str);
                dao.update_group(group);
                
            } else {

                group = new Group(group_id, name, start_date_str, end_date_str);
                dao.insert_group(group);
            }
            
            var actual_group_id = group.get_id();
            
            var child = members_listbox.get_first_child();
            while (child != null) {
                var row = child as Gtk.ListBoxRow;
                if (row != null) {
                    var box = row.get_child() as Gtk.Box;
                    var check = box.get_first_child() as Gtk.CheckButton;
                    if (check != null && check.active) {
                        int person_id = int.parse(check.name);
                        dao.insert_membership(person_id, actual_group_id);
                    }
                }
                child = child.get_next_sibling();
            }
            
            group_saved();
            this.close();
            print("Success saving group: %s\n", group.get_name());
            
        } catch (DAOError e) {
            show_error("Error saving group: " + e.message);
        } catch (DomainError e) {
            show_error("Error with the new group data validation. " + e.message);         
        } catch (Error e) {
            show_error("Sorry, an error occurred: " + e.message);
        }
    }
    
    private void show_error(string message) {
        string title = "Error";
        var error_dialog = new Adw.MessageDialog(this, title, message);
        error_dialog.add_response("ok", "Accept");
        error_dialog.set_default_response("ok");
        error_dialog.present();
    }
}