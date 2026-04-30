[GtkTemplate (ui = "/sonus/app/main_window.ui")]
public class MainWindow : Adw.ApplicationWindow {
    [GtkChild]
    private unowned Gtk.Stack main_stack;
    
    // Añadimos los botones como hijos para enlazarlos con el .blp
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
        
        // Cambiar a la vista de lista al hacer clic
        list_btn.clicked.connect (() => {
                main_stack.visible_child_name = "list";
            });
        
        // Cambiar a la vista de cuadrícula al hacer clic
        grid_btn.clicked.connect (() => {
                main_stack.visible_child_name = "grid";
            });
        
        // Conectar botones superiores
        create_person_btn.clicked.connect (() => {
                // Aquí irá tu lógica para abrir el diálogo de persona
            });
        
        create_group_btn.clicked.connect (() => {
                // Aquí irá tu lógica para abrir el diálogo de grupo
            });
    }
}