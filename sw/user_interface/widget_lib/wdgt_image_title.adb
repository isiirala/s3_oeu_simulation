




with Gtk.Alignment; 
with Gdk.Color;     
with Gtk.Event_Box;   
with Gtk.Misc;      
with Gtk.Style;


with Wdgt_Common;
with Wdgt_Fonts;

package body Wdgt_Image_Title is

 
   procedure Gtk_New  
     (Image_Title         : out Frame_Image_Title; 
      Image               : in Gtk.Image.Gtk_Image; 
      Title               : in Glib.UTF8_String;
      Title_Pos           : in Gtk.Enums.Gtk_Position_Type;
      Title_Color         : in Wdgt_Colors.Color_T;
      Frame_Label         : in Glib.UTF8_String := "";
      Frame_Shadow        : in Gtk.Enums.Gtk_Shadow_Type := Gtk.Enums.Shadow_None;
      Frame_Border_Width  : in Glib.Guint := 5;
      Title_Padding       : in Glib.Guint := 4) 
   is
   begin
      Image_Title := new Frame_Image_Title_Record;
      Initialize 
        (Image_Title, Image, Title, Title_Pos, Title_Color, Frame_Label, Frame_Shadow, 
         Frame_Border_Width,
         Title_Padding);
   end Gtk_New;

   procedure Initialize 
     (Image_Title         : access Frame_Image_Title_Record'Class; 
      Image               : in Gtk.Image.Gtk_Image; 
      Title               : in Glib.UTF8_String;
      Title_Pos           : in Gtk.Enums.Gtk_Position_Type;
      Title_Color         : in Wdgt_Colors.Color_T;
      Frame_Label         : in Glib.UTF8_String := "";
      Frame_Shadow        : in Gtk.Enums.Gtk_Shadow_Type := Gtk.Enums.Shadow_None;
      Frame_Border_Width  : in Glib.Guint := 5;
      Title_Padding       : in Glib.Guint := 4) 
   is
      use type Gtk.Enums.Gtk_Position_Type;
   begin

-- Initialize current composition widget. It is built in the previous Gtk_New procedure
      Gtk.Frame.Initialize (Image_Title, Frame_Label);
      
-- The Border Width of the frame is the space arround the border that separate this 
-- widget with the rest of window.
-- The border and shadow are configured calling inherited functions from Gtk.Frame
      Set_Border_Width (Image_Title, Frame_Border_Width);
      Set_Shadow_Type (Image_Title, Frame_Shadow);
     
-- Create a H box to place the image and then the title, the Spacing parameter 
-- will be the separation space between image and title

--      Gtk.Image.Gtk_New (Image_Title.Image, File_Image);
      Image_Title.Image := Image;

      Gtk.Label.Gtk_New (Image_Title.Label, Title);
      
      Image_Title.Label.Set_Attributes 
        (Attrs => Wdgt_Fonts.Get_Attributes (Wdgt_Fonts.F_Title2, Title_Color));

      Gtk.Box.Gtk_New_VBox 
        (Box         => Image_Title.V_Box, 
         Homogeneous => False, 
         Spacing     => 0);
         
      Add (Image_Title, Image_Title.V_Box);

      if Title_Pos = Gtk.Enums.Pos_Top then

         Gtk.Box.Pack_Start 
           (In_Box  => Image_Title.V_Box, 
            Child   => Image_Title.Label, 
            Expand  => False, 
            Fill    => False, 
            Padding => Title_Padding);

         Gtk.Box.Pack_Start 
           (In_Box  => Image_Title.V_Box, 
            Child   => Image_Title.Image, 
            Expand  => False, 
            Fill    => False, 
            Padding => 0);       
            
      elsif Title_Pos = Gtk.Enums.Pos_Right then

         Gtk.Box.Gtk_New_Hbox 
           (Box         => Image_Title.H_Box, 
            Homogeneous => False, 
            Spacing     => 0);

         Gtk.Box.Pack_Start 
           (In_Box  => Image_Title.V_Box, 
            Child   => Image_Title.H_Box, 
            Expand  => False, 
            Fill    => False, 
            Padding => 0);
                        
         Gtk.Box.Pack_Start 
           (In_Box  => Image_Title.H_Box, 
            Child   => Image_Title.Image, 
            Expand  => False, 
            Fill    => False, 
            Padding => 0);   

         Gtk.Box.Gtk_New_VBox 
           (Box         => Image_Title.V2_Box, 
            Homogeneous => False, 
            Spacing     => 0);

         Gtk.Box.Pack_Start 
           (In_Box  => Image_Title.H_Box, 
            Child   => Image_Title.V2_Box, 
            Expand  => False, 
            Fill    => False, 
            Padding => 0);       
            
         Gtk.Box.Pack_Start 
           (In_Box  => Image_Title.V2_Box, 
            Child   => Image_Title.Label, 
            Expand  => False, 
            Fill    => False, 
            Padding => Title_Padding);
      end if;

   end Initialize;


end Wdgt_Image_Title;


