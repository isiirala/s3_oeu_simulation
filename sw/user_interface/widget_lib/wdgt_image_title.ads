-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Image_Title
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Composited widget inherited from Gtk.Frame with an 
--    image and a label title
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************


with Glib;         
with Gtk.Box;   
with Gtk.Enums;
with Gtk.Image;   
with Gtk.Label;   
with Gtk.Frame; 

with Wdgt_Colors;

package Wdgt_Image_Title is

   type Frame_Image_Title_Record is new Gtk.Frame.Gtk_Frame_Record with 
      record
        V_Box    : Gtk.Box.Gtk_Box;
        H_Box    : Gtk.Box.Gtk_Box;
        V2_Box   : Gtk.Box.Gtk_Box;
        Image    : Gtk.Image.Gtk_Image;
        Label    : Gtk.Label.Gtk_Label;
      end record;
   type Frame_Image_Title is access all Frame_Image_Title_Record'Class;


--   type Gtk_Position_Type is (
--      Pos_Left,
--      Pos_Right,
--      Pos_Top,
--      Pos_Bottom);



   procedure Gtk_New 
     (Image_Title         : out Frame_Image_Title;
      Image               : in Gtk.Image.Gtk_Image; 
      Title               : in Glib.UTF8_String;
      Title_Pos           : in Gtk.Enums.Gtk_Position_Type;
      Title_Color         : in Wdgt_Colors.Color_T;
      Frame_Label         : in Glib.UTF8_String := "";
      Frame_Shadow        : in Gtk.Enums.Gtk_Shadow_Type := Gtk.Enums.Shadow_None;
      Frame_Border_Width  : in Glib.Guint := 5;
      Title_Padding       : in Glib.Guint := 4);
   
   procedure Initialize 
     (Image_Title         : access Frame_Image_Title_Record'Class; 
      Image               : in Gtk.Image.Gtk_Image; 
      Title               : in Glib.UTF8_String;
      Title_Pos           : in Gtk.Enums.Gtk_Position_Type;
      Title_Color         : in Wdgt_Colors.Color_T;
      Frame_Label         : in Glib.UTF8_String := "";
      Frame_Shadow        : in Gtk.Enums.Gtk_Shadow_Type := Gtk.Enums.Shadow_None;
      Frame_Border_Width  : in Glib.Guint := 5;
      Title_Padding       : in Glib.Guint := 4);
   
end Wdgt_Image_Title;

