

with Glib;

with Gtk.Builder;

with Basic_Types_I;

package Wdgt_Ui_Def is


   type Ui_Def_T is
     (Main_Menu, Logs_Config, Tc_Tm_Test
      );


   procedure Init (Debug_Routine : Basic_Types_I.Debug_Proc_T);


   function Get_Builder
--     (Builder : not null access Gtk.Builder.Gtk_Builder_Record;
      (Ui_Def  : in Ui_Def_T) return Gtk.Builder.Gtk_Builder;





end Wdgt_Ui_Def;

