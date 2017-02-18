
with Glib;
with Gtk.Notebook;

with Basic_Types_I;
with Basic_Types_1553;
with Test_Params_I;

package Uif_Tc_Tm_1 is


   procedure Create_Sub_Srv_Pages
     (Sub_Srv_Notebook : not null access Gtk.Notebook.Gtk_Notebook_Record'Class);

   procedure Get_Message_Id_From_Index_Page
     (Sub_Page_Index   : in Glib.Gint;
      Tm_Id            : out Basic_Types_1553.Tc_Tm_Id_T);


   procedure Update_Tm_Params
     (Params     : in Test_Params_I.Array_Params_T;
      Params_Len : in Basic_Types_I.Data_32_Len_T);


end Uif_Tc_Tm_1;
