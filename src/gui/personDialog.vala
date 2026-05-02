using GLib;
using Sonus.DAO;
using Sonus;

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
    
    private string? birth_date_str = null;
    private string? death_date_str = null;
    
    private Sonus.DAO.DAO dao;

    public PersonDialog (Gtk.Window parent, Sonus.DAO.DAO dao) {
        Object (transient_for: parent, modal: true);
        this.dao = dao;
        
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
                this.close ();
            });
        
        save_btn.clicked.connect (() => {
                save_person();
            });
    }
    
    
    private void validate_forms(){
        try{
            var stage_name = stage_name_entry.get_text().strip(); 
            if(stage_name == ""){
                save_btn.set_sensitive(false);
                return;
            }
            
            var p = new Person(-1, stage_name);
            var real_name = real_name_entry.get_text().strip ();
            if (real_name == "")
                p.set_real_name (null);
            else
                p.set_real_name (real_name);
            
            p.set_birth_date(birth_date_str);
            p.set_death_date(death_date_str);
            save_btn.set_sensitive(true);                                           
        } catch (DomainError e){
            save_btn.set_sensitive(false);
        }
    }
    
    
    private void save_person(){
        try{
            var stage_name = stage_name_entry.get_text().strip ();
            var p = new Person(-1, stage_name);
            
            var real_name = real_name_entry.get_text().strip ();
                if (real_name != "") 
                    p.set_real_name(real_name);
                
                
                p.set_birth_date (birth_date_str);
                p.set_death_date (death_date_str);
                
                dao.insert_person(p);
                
                this.close();
                
                print("Success creating and validating new person: %s\n", p.get_name());
        } catch(DAOError e){
            show_error("Error saving new person. " + e.message);          
        } catch(DomainError e){
            show_error("Error with the new person data validation. " + e.message);
        } catch(Error e){
            show_error("An error ocurred. We are sorry. " + e.message);
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