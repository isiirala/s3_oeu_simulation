

with Ada.Strings.Unbounded;

with Glib;

with Gtk;
with Gtk.Button;
with Gtk.Check_Button;
with Gtk.Check_Menu_Item;
with Gtk.Window;

with Gtk.Image_Menu_Item;
with Gtk.Menu_Item;
with Gtk.Frame;
with Gtk.Handlers;
with Gtk.Image;
with Gtk.Message_Dialog;
with Gtk.Style;
with Gtk.Widget;

with Ada.Text_IO;

package Wdgt_Common is



    package Widget_Callback_Pkg is new
      Gtk.Handlers.Callback (Gtk.Widget.Gtk_Widget_Record);

    package Window_Callback_Pkg is new
      Gtk.Handlers.Callback (Gtk.Window.Gtk_Window_Record);
 -- This instantiation creates a new package to handle
 -- Gtk_Window_Record.

    package Menu_Item_Callback_Pkg is new
      Gtk.Handlers.Callback (Gtk.Menu_Item.Gtk_Menu_Item_Record);
 -- This instantiation creates a new package to handle
 -- Gtk_Menu_Item_Record.

    package Image_Menu_Item_Callback_Pkg is new
      Gtk.Handlers.Callback (Gtk.Image_Menu_Item.Gtk_Image_Menu_Item_Record);


    package Chk_Button_Callback_Pkg is new
      Gtk.Handlers.User_Callback
        (Widget_Type => Gtk.Check_Button.Gtk_Check_Button_Record,
         User_Type   => Glib.Gint);


--   package Check_Menu_Item_Callback_Pkg is new
--     Gtk.Handlers.Callback (Gtk.Check_Menu_Item.Gtk_Check_Menu_Item_Record);

--    package Button_Cb is new Gtk.Handlers.Callback (
--      Gtk.Button.Gtk_Button_Record);
 -- This instantiation creates a new package to handle
 -- Gtk_Button_Record.



   package Gint_Text_Io is
     new Ada.Text_IO.Integer_IO (Glib.Gint);



   type String_Access is access all String;

   package Button_Handler is new Gtk.Handlers.Callback (Gtk.Button.Gtk_Button_Record);

   package Button_Gint_Handler is new Gtk.Handlers.User_Callback(
     Widget_Type => Gtk.Button.Gtk_Button_Record,
     User_Type   => Glib.Gint);






   type Button_Config is record
      Label      : String_Access;
      Callback   : Button_Handler.Simple_Handler;
      Image      : Gtk.Image.Gtk_Image;
      Tip_Text   : Ada.Strings.Unbounded.Unbounded_String;
   end record;
   type Button_Config_List is array (Positive range <>) of Button_Config;



   package Widget_Handler is new Gtk.Handlers.Callback (Gtk.Widget.Gtk_Widget_Record);


-------------------------------------------------------------------------------
-- Callbaks for Message_Dialog
   type Message_Dialog_Access is access all Gtk.Message_Dialog.Gtk_Message_Dialog;
   package Message_Dialog_Cb is new Gtk.Handlers.User_Callback (
     Gtk.Message_Dialog.Gtk_Message_Dialog_Record, Message_Dialog_Access);

-- Common destroy callback for all message dialogs
   procedure Destroy_Message_Dialog (
     Win : access Gtk.Message_Dialog.Gtk_Message_Dialog_Record'Class;
     Ptr : Message_Dialog_Access);
-------------------------------------------------------------------------------


   Main_Win            : access Gtk.Window.Gtk_Window_Record'Class;
   Win_Style           : Gtk.Style.Gtk_Style;


--   procedure Create_Label_Cell (
--     Frame     : out Gtk.Frame.Gtk_Frame;
--     Text      : in String;
--     H_Padding : in Glib.Guint;
--     V_Padding : in Glib.Guint);


end Wdgt_Common;

