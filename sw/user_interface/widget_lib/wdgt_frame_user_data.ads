


with Glib;


with Gtk.Frame;


package Wdgt_Frame_User_Data is

   type Frame_User_Data_Record is new Gtk.Frame.Gtk_Frame_Record with
      record
        User_Data_Int1   : Glib.Gint;
        User_Data_Int2   : Glib.Gint;
        User_Data_Int3   : Glib.Gint;
--        User_Data_Str1   : Glib.UTF8_String (1 .. 50);
--        User_Data_Str2   : Glib.UTF8_String (1 .. 50);
      end record;
   type Frame_User_Data is access all Frame_User_Data_Record'Class;




   procedure Gtk_New
     (Frame_U_Data          : out Frame_User_Data;
      Label                 : in  Glib.UTF8_String := "");

   procedure Initialize
     (Frame_U_Data          : access Frame_User_Data_Record'Class;
      Label                 : in  Glib.UTF8_String := "");




end Wdgt_Frame_User_Data;


