
with Glib;
with Gtk.Notebook;

with Basic_Types_1553;


package Uif_Tc_Tm_129 is

   procedure Create_Sub_Srv_Pages
     (Sub_Srv_Notebook : not null access Gtk.Notebook.Gtk_Notebook_Record'Class);

   procedure Get_Message_Id_From_Index_Page
     (Sub_Page_Index   : in Glib.Gint;
      Tc_Id            : out Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Id            : out Basic_Types_1553.Tc_Tm_Id_T);

end Uif_Tc_Tm_129;
