using GLib;
using Sonus;
using Sonus.DAO;

[GtkTemplate (ui = "/sonus/app/editPersonDialog.ui")]
public class EditPersonDialog : Adw.Window {
    
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
    
    private string? birth_date_str = null;
    private string? death_date_str = null;
    
    private unowned Sonus.DAO.DAO dao;
    private int person_id;

    public signal void person_saved();

    public EditPersonDialog (Gtk.Window parent, Sonus.DAO.DAO dao, int id) {
        Object (transient_for: parent, modal: true);
        this.dao = dao;
        this.person_id = id;

        load_person_data(id);
        save_btn.set_sensitive(false);

        stage_name_entry.notify["text"].connect(validate_forms);
        real_name_entry.notify["text"].connect(validate_forms);

        birth_date_calendar.day_selected.connect (() => {
            var date = birth_date_calendar.get_date();
            birth_date_str = date.format("%Y-%m-%d");
            birth_date_btn.label = birth_date_str;
            birth_date_btn.popover.popdown();
            validate_forms();
        });

        death_date_calendar.day_selected.connect (() => {
            var date = death_date_calendar.get_date();
            death_date_str = date.format("%Y-%m-%d");
            death_date_btn.label = death_date_str;
            death_date_btn.popover.popdown();
            validate_forms();
        });

        cancel_btn.clicked.connect (() => {
            this.close();
        });

        save_btn.clicked.connect (() => {
            save_person(id);
        });
        
        validate_forms();
    }

    private void load_person_data(int id) {
        try{
            var person = dao.find_person_by_id(id);
            if (person != null) {
                stage_name_entry.text = person.get_name();
                
                var real_name = person.get_real_name();
                if (real_name != null) {
                    real_name_entry.text = real_name;
                }
                
                var birth_date = person.get_birth_date();
                if (birth_date != null) {
                    birth_date_str = birth_date;
                    birth_date_btn.label = birth_date_str;
                }
                
                var death_date = person.get_death_date();
                if (death_date != null) {
                    death_date_str = death_date;
                    death_date_btn.label = death_date_str;
                }
            }
        } catch(Error e){
            show_error("An error ocurred trying to load person data. " + e.message);
        }
    }

    private void validate_forms() {
        try {
            var stage_name = stage_name_entry.get_text().strip();
            if (stage_name == "") {
                save_btn.set_sensitive(false);
                return;
            }

            var p = new Person(person_id, stage_name);
            var real_name = real_name_entry.get_text().strip();
            
            if (real_name == "") {
                p.set_real_name(null);
            } else {
                p.set_real_name(real_name);
            }

            p.set_birth_date(birth_date_str);
            p.set_death_date(death_date_str);

            
            if (birth_date_str != null && death_date_str != null) {
                if (birth_date_str > death_date_str) {
                    save_btn.set_sensitive(false);
                    return;
                }
            }

            save_btn.set_sensitive(true);
        } catch (DomainError e) {
            save_btn.set_sensitive(false);
        }
    }

    private void save_person(int id) {
        try {
            var person = dao.find_person_by_id(id);
            if (person != null) {
                person.set_name(stage_name_entry.text.strip());

                var real_name = real_name_entry.get_text().strip();
                if (real_name != "") {
                    person.set_real_name(real_name);
                } else {
                    person.set_real_name(null);
                }

                person.set_birth_date(birth_date_str);
                person.set_death_date(death_date_str);

                dao.update_person(person);                
            } else {
                person = new Person(id, name);
                dao.insert_person(person);
            }
            person_saved();            
            this.close();
            
        } catch (DAOError e) {
            show_error("Error updating person: " + e.message);
        } catch (DomainError e) {
            show_error("Error with the person data validation: " + e.message);
        } catch (Error e){
            show_error("An error ocurred. We are sorry. " + e.message);
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