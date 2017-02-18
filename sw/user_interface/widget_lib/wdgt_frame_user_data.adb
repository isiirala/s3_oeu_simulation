


package body Wdgt_Frame_User_Data is

   procedure Gtk_New
     (Frame_U_Data          : out Frame_User_Data;
      Label                 : in  Glib.UTF8_String := "")
   is
   begin

      Frame_U_Data := new Frame_User_Data_Record;
      Initialize (Frame_U_Data, Label);
   end Gtk_New;

   procedure Initialize
     (Frame_U_Data          : access Frame_User_Data_Record'Class;
      Label                 : in  Glib.UTF8_String := "")
   is
   begin
      Frame_U_Data.User_Data_Int1 := 0;
      Frame_U_Data.User_Data_Int2 := 0;
      Gtk.Frame.Initialize
        (Frame => Frame_U_Data,
         Label => Label);
   end Initialize;



end Wdgt_Frame_User_Data;

