-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Buttons
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Special box with one or more columns of buttons
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  19/03/2014 : Initial version
-- ****************************************************************************


with Glib;

with Gdk.RGBA;

with Gtk.Box;  
with Gtk.Frame; 
with Gtk.Button_Box;
with Gtk.Button;
with Gtk.Handlers;
with Gtk.Enums;

with Wdgt_Common;

package Wdgt_Buttons is

   
   
   type Widget_Config is record
--      Title      : String_Access;
      Callback   : Wdgt_Common.Button_Handler.Simple_Handler;
      Button     : Gtk.Button.Gtk_Button;
   end record;
   type Widget_Config_List is array (Positive range <>) of Widget_Config;   
   type Widget_Config_List_Access is access Widget_Config_List;
   

   type Frame_Buttons_Record is new Gtk.Frame.Gtk_Frame_Record with
      record
        Button_Box      : Gtk.Button_Box.Gtk_Button_Box;
        Widget_Config   : Widget_Config_List_Access;

      end record;
   type Frame_Buttons is access all Frame_Buttons_Record'Class;

   procedure Gtk_New (
     Buttons             : out Frame_Buttons;

     Horizontal          : in Boolean;
     Config              : in Wdgt_Common.Button_Config_List;
          
     Border_Width        : in Glib.Guint := 0;  
     Spacing             : in Glib.Gint := 0;
     Child_W             : in Glib.Gint := 2;
     Child_H             : in Glib.Gint := 2;
     Layout              : in Gtk.Enums.Gtk_Button_Box_Style := Gtk.Enums.Buttonbox_Center;
     Back_Buttons_Color  : in Gdk.RGBA.Gdk_RGBA := Gdk.RGBA.Null_RGBA;
     
     Frame_Label         : in Glib.UTF8_String := "";
     Frame_Shadow        : in Gtk.Enums.Gtk_Shadow_Type := Gtk.Enums.Shadow_None;
     Frame_Border_Width  : in Glib.Guint := 0

   );
   
   
   procedure Initialize (
     Buttons             : access Frame_Buttons_Record'Class; 

     Horizontal          : in Boolean;
     Config              : in Wdgt_Common.Button_Config_List;
       
     Border_Width        : in Glib.Guint := 0;
     Spacing             : in Glib.Gint := 0;
     Child_W             : in Glib.Gint := 2;
     Child_H             : in Glib.Gint := 2;
     Layout              : in Gtk.Enums.Gtk_Button_Box_Style := Gtk.Enums.Buttonbox_Center;
     Back_Buttons_Color  : in Gdk.RGBA.Gdk_RGBA := Gdk.RGBA.Null_RGBA;

     Frame_Label         : in Glib.UTF8_String := "";
     Frame_Shadow        : in Gtk.Enums.Gtk_Shadow_Type := Gtk.Enums.Shadow_None;
     Frame_Border_Width  : in Glib.Guint := 0

   );


--   procedure Change_Button_Title (
--     Buttons             : access Frame_Buttons_Record'Class; 
--     Current_Title       : in Glib.UTF8_String;
--     New_Title           : in String_Access);

end Wdgt_Buttons;

