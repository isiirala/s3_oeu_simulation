
with Gtk.Enums;
with Gtk.Alignment;  --use Gtk.Alignment;
with Gtk.Label;      --use Gtk.Label;
with Gtk.Container;  --use Gtk.Container;


package body Wdgt_Common is




   procedure Destroy_Message_Dialog (
     Win : access Gtk.Message_Dialog.Gtk_Message_Dialog_Record'Class;
     Ptr : Message_Dialog_Access) is
      pragma Warnings (Off, Win);
   begin

      Ptr.all := null;
   end Destroy_Message_Dialog;



--   procedure Create_Label_Cell (
--     Frame     : out Gtk.Frame.Gtk_Frame;
--     Text      : in String;
--     H_Padding : in Glib.Guint;
--     V_Padding : in Glib.Guint) is

--      New_Align         : Gtk.Alignment.Gtk_Alignment;
--      New_Label         : Gtk.Label.Gtk_Label;
--   begin

--      Gtk.Frame.Gtk_New (Frame, "");
--      Gtk.Frame.Set_Shadow_Type (Frame, Gtk.Enums.Shadow_Etched_Out);

--      Gtk.Label.Gtk_New (New_Label, Text);

--      Gtk.Alignment.Gtk_New (
--        Alignment => New_Align,
--        Xalign	   => 0.0,
--        Yalign	   => 0.0,
--        Xscale	   => 0.0,
--        Yscale    => 0.0);

--      Gtk.Alignment.Set_Padding (
--        Alignment      => New_Align,
--        Padding_Top	  => V_Padding,
--        Padding_Bottom => V_Padding,
--        Padding_Left	  => H_Padding,
--        Padding_Right  => H_Padding);

--      Add (New_Align, New_Label);
--      Add (Frame, New_Align);
--   end Create_Label_Cell;



end Wdgt_Common;
