


with Ada.Strings.Unbounded;

with Gdk.Color;          

with Gtk.Alignment;      
with Gtk.Event_Box;      
with Gtk.Style;         
with Gtk.Hbutton_Box;
with Gtk.Vbutton_Box;
with Pango.Font;     


package body Wdgt_Buttons is


-- Private subprograms declaration
   function User_Config_To_Widget_Config (User_Config : Wdgt_Common.Button_Config_List) 
     return Widget_Config_List_Access;


  

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
     ) is
   begin
      Buttons := new Frame_Buttons_Record;
      Initialize (
        Buttons, Horizontal, Config, Border_Width, Spacing, Child_W, Child_H, Layout,
        Back_Buttons_Color, Frame_Label, Frame_Shadow, Frame_Border_Width);
   end Gtk_New;


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
   ) is
          
   begin

      Buttons.Widget_Config := User_Config_To_Widget_Config(Config); --new Title_And_Callback_List'(Config);

-- Initialize current composition widget. It is built in the previous Gtk_New procedure
      Gtk.Frame.Initialize (Buttons, Frame_Label);



-- The Border Width of the frame is the space arround the border that separate this 
-- widget with the rest of window.
-- The border and shadow are configured calling inherited functions from Gtk.Frame
      Set_Border_Width (Buttons, Frame_Border_Width);
      Set_Shadow_Type (Buttons, Frame_Shadow);

      if Horizontal then
         declare
            B : Gtk.Hbutton_Box.Gtk_Hbutton_Box;
         begin
            Gtk.Hbutton_Box.Gtk_New (B);
            Buttons.Button_Box := Gtk.Button_Box.Gtk_Button_Box (B);
         end;
      else
         declare
            B : Gtk.Vbutton_Box.Gtk_Vbutton_Box;
         begin
            Gtk.Vbutton_Box.Gtk_New (B);
            Buttons.Button_Box := Gtk.Button_Box.Gtk_Button_Box (B);
         end;
      end if;      

      Gtk.Button_Box.Set_Border_Width (Buttons.Button_Box, Border_Width => Border_Width);
      Add (Buttons, Buttons.Button_Box);

      Gtk.Button_Box.Set_Layout (Buttons.Button_Box, Layout);
      Gtk.Button_Box.Set_Spacing (Buttons.Button_Box, Spacing);
--      Gtk.Button_Box.Set_Child_Size (Buttons.Button_Box, Child_W, Child_H);

      for I in Buttons.Widget_Config'Range loop

         Gtk.Button.Gtk_New 
           (Button => Buttons.Widget_Config(I).Button, 
            Label => Config(I).Label.All);
         
         Gtk.Button.Set_Image 
           (Button => Buttons.Widget_Config(I).Button,
            Image  => Config(I).Image);
         Gtk.Button.Set_Always_Show_Image
           (Button      => Buttons.Widget_Config(I).Button,
            Always_Show => True);
         Gtk.Button.Set_Image_Position
           (Button   => Buttons.Widget_Config(I).Button,
            Position => Gtk.Enums.Pos_Left);
         if Ada.Strings.Unbounded.Length (Config (I).Tip_Text) > 0 then
            Buttons.Widget_Config(I).Button.Set_Tooltip_Text 
              (Ada.Strings.Unbounded.To_String (Config (I).Tip_Text));
         end if;      
         
         Gtk.Button.Set_Relief
           (Buttons.Widget_Config(I).Button, 
            Relief => Gtk.Enums.Relief_Half); --Gtk.Enums.Relief_Normal, Relief_Half, None)
         Gtk.Button_Box.Add (Buttons.Button_Box, Buttons.Widget_Config(I).Button);
         
         Gtk.Button.Override_Background_Color(
           Widget => Buttons.Widget_Config(I).Button,
           State  => Gtk.Enums.Gtk_State_Flag_Normal,
           Color  => Back_Buttons_Color); 

         
         Wdgt_Common.Button_Handler.Object_Connect
           (Buttons.Widget_Config(I).Button, "clicked", 
            Buttons.Widget_Config(I).Callback,
            Buttons.Widget_Config(I).Button);
      end loop;


   end Initialize;




--   procedure Change_Button_Title (
--     Buttons             : access Frame_Buttons_Record'Class; 
--     Current_Title       : in Glib.UTF8_String;
--     New_Title           : in String_Access) is
          
--   begin
   
--      for I in 1 .. Buttons.Widget_Config'Length loop

--         if(Gtk.Button.Get_Label(Buttons.Widget_Config(I).Button) = Current_Title) then
--            Buttons.Widget_Config(I).Title := New_Title;
--            Gtk.Button.Set_Label(Buttons.Widget_Config(I).Button, Label => Buttons.Widget_Config(I).Title.All);
--         end if;
--      end loop;
   
   
--   end Change_Button_Title;





-- -----------------------------------------------------------------------------
-- %Private Subprograms%
-- -----------------------------------------------------------------------------

   function User_Config_To_Widget_Config (User_Config : Wdgt_Common.Button_Config_List) 
     return Widget_Config_List_Access is
      Num_Buttons_C  : Positive := User_Config'Length;
      Widget_List : Widget_Config_List(1 .. Num_Buttons_C);
   begin

      for I in 1 .. Num_Buttons_C loop
--         Widget_List(I).Title     := User_Config(I).Title; --new String'(User_Config(I).Title.All);
         Widget_List(I).Callback  := User_Config(I).Callback;
         Widget_List(I).Button    := null;
      end loop;

      return new Widget_Config_List'(Widget_List);
   end User_Config_To_Widget_Config;


end Wdgt_Buttons;


