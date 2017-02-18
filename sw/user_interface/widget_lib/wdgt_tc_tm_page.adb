

with Gtk.Aspect_Frame;
with Gtk.Enums;
with Gtk.Image;
with Gtk.Label;
with Gdk.Pixbuf;
with Gtk.Scrolled_Window;
with Gtk.Separator;


with Wdgt_Colors;
with Wdgt_Fonts;
with Wdgt_Images;



package body Wdgt_Tc_Tm_Page is



-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   procedure Create_One_Main_Title
     (Vbox         : in Gtk.Box.Gtk_Box;
      Srv_Title    : in String;
      Srv_Descript : in String;
      Info_Label   : in String)
   is
      Hbox           : Gtk.Box.Gtk_Hbox                       := null;
      L1             : Gtk.Label.Gtk_Label                    := null;
      Sepa_V         : Gtk.Separator.Gtk_Separator            := null;
      L2             : Gtk.Label.Gtk_Label                    := null;
      Sepa_H         : Gtk.Separator.Gtk_Separator            := null;
      Info_Box       : Gtk.Box.Gtk_Hbox                       := null;
      Info_L         : Gtk.Label.Gtk_Label                    := null;
   begin

      Gtk.Box.Gtk_New_HBox
        (Box         => Hbox,
         Homogeneous => False,
         Spacing     => 2);

      Vbox.Pack_Start
        (Child   => Hbox,
         Expand  => False,
         Fill    => True,
         Padding => 2);

      Gtk.Label.Gtk_New (L1, Srv_Title);
      L1.Set_Attributes
        (Attrs => Wdgt_Fonts.Get_Attributes
          (Wdgt_Fonts.F_Title1, Wdgt_Colors.Orange_2));
--      L1.Set_Margin_Top (20);

      Hbox.Pack_Start
        (Child   => L1,
         Expand  => False,
         Fill    => True,
         Padding =>  4);

      Gtk.Separator.Gtk_New
        (Separator    => Sepa_V,
         Orientation  => Gtk.Enums.Orientation_Vertical);

      Hbox.Pack_Start
        (Child   => Sepa_V,
         Expand  => False,
         Fill    => True,
         Padding =>  2);


      Gtk.Label.Gtk_New (L2, Srv_Descript);
      L2.Set_Attributes
        (Attrs => Wdgt_Fonts.Get_Attributes
          (Wdgt_Fonts.F_Text2_Sans, Wdgt_Colors.Black));
      L2.Set_Lines (3);
      Hbox.Pack_Start
        (Child   => L2,
         Expand  => False,
         Fill    => False,
         Padding =>  2);

-- Info label below TC(x,y) | descrip
      Gtk.Separator.Gtk_New
        (Separator    => Sepa_H,
         Orientation  => Gtk.Enums.Orientation_Horizontal);
      Vbox.Pack_Start
        (Child   => Sepa_H,
         Expand  => False,
         Fill    => True,
         Padding =>  2);
      Gtk.Box.Gtk_New_HBox
        (Box         => Info_Box,
         Homogeneous => False,
         Spacing     => 2);
      Info_Box.Set_Margin_Bottom (5);
      Vbox.Pack_Start
        (Child   => Info_Box,
         Expand  => False,
         Fill    => False,
         Padding =>  2);
      Gtk.Label.Gtk_New (Info_L, Info_Label);
      Info_L.Set_Attributes
          (Attrs => Wdgt_Fonts.Get_Attributes
            (Wdgt_Fonts.F_Text2_Sans, Wdgt_Colors.Black));
      Info_Box.Pack_Start
        (Child   => Info_L,
         Expand  => False,
         Fill    => False,
         Padding =>  2);

   end Create_One_Main_Title;









-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Gtk_New
     (Tc_Tm_Page          : out Frame_Tc_Tm_Page;
      Title               : in String;
      Tc_Title_1          : in String;
      Tc_Title_2          : in String;
      Tm_Title_1          : in String;
      Tm_Title_2          : in String) is
   begin
      Tc_Tm_Page := new Frame_Tc_Tm_Page_Record;
      Initialize
        (Tc_Tm_Page, Title, Tc_Title_1, Tc_Title_2, Tm_Title_1, Tm_Title_2);
   end Gtk_New;

   procedure Initialize
     (Tc_Tm_Page          : access Frame_Tc_Tm_Page_Record'Class;
      Title               : in String;
      Tc_Title_1          : in String;
      Tc_Title_2          : in String;
      Tm_Title_1          : in String;
      Tm_Title_2          : in String)
   is
      Scrolled_Win     : Gtk.Scrolled_Window.Gtk_Scrolled_Window      := Null;
      Tc_Tm_Box        : Gtk.Box.Gtk_Box                              := Null;
      Vbox_Tc          : Gtk.Box.Gtk_Box                              := Null;
      Box_Title_Tc     : Gtk.Box.Gtk_Box                              := Null;
      Vbox_Tm          : Gtk.Box.Gtk_Box                              := Null;
      Box_Title_Tm     : Gtk.Box.Gtk_Box                              := Null;
      Pixmap           : Gtk.Image.Gtk_Image                          := Null;
      Label            : Gtk.Label.Gtk_Label                          := Null;
      Separator        : Gtk.Separator.Gtk_Separator                  := null;
      Book_Closed_Icon : Gdk.Pixbuf.Gdk_Pixbuf                        :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Closed);

   begin

-- Initialize current composition widget. It is built in the previous Gtk_New procedure
      Gtk.Frame.Initialize (Tc_Tm_Page, "");

-- Create the main V box that use all the frame
      Gtk.Box.Gtk_New_Vbox
        (Box         => Tc_Tm_Page.Main_V_Box,
         Homogeneous => False,
         Spacing     => 0);
      Tc_Tm_Page.Add (Tc_Tm_Page.Main_V_Box);

-- Create the H Box to display the TC and TM parameters
      Gtk.Box.Gtk_New_HBox
        (Box         => Tc_Tm_Page.H_Box1,
         Homogeneous => False,
         Spacing     => 0);

      Tc_Tm_Page.Main_V_Box.Pack_Start
        (Child   => Tc_Tm_Page.H_Box1,
         Expand  => True,
         Fill    => True,
         Padding => 2);

-- Scrolled window to display TC and TM parameters
      Scrolled_Win := Gtk.Scrolled_Window.Gtk_Scrolled_Window_New;
      Scrolled_Win.Set_Border_Width (Border_Width => Border_Widths_C);
      Scrolled_Win.Set_Policy
        (Hscrollbar_Policy => Gtk.Enums.Policy_Automatic,
         Vscrollbar_Policy => Gtk.Enums.Policy_Automatic);

      Tc_Tm_Page.H_Box1.Pack_Start
       (Child   => Scrolled_Win,
        Expand  => True,
        Fill    => True,
        Padding => 1);

-- The H Box to place the V TC Box, separator and V TM Box
      Gtk.Box.Gtk_New_HBox
        (Box         => Tc_Tm_Box,
         Homogeneous => False,
         Spacing     => 0);
      Tc_Tm_Box.Set_Border_Width (Border_Widths_C);
      Scrolled_Win.Add (Tc_Tm_Box);

-- V box for TC
      Gtk.Box.Gtk_New_Vbox
        (Box         => Vbox_Tc,
         Homogeneous => False,
         Spacing     => 0);
      Gtk.Box.Set_Border_Width (Vbox_Tc, Border_Widths_C);
      Tc_Tm_Box.Pack_Start
        (Child   => Vbox_Tc,
         Expand  => False,
         Fill    => True,
         Padding => 2);

-- Box at the top of the V boxTC to insert the title of the TC
      Gtk.Box.Gtk_New_Vbox (Box_Title_Tc);
      Vbox_Tc.Pack_Start (Box_Title_Tc);

      if Tc_Title_1 /= "TC_TM_Unknow" then

         Create_One_Main_Title
           (Vbox         => Box_Title_Tc,
            Srv_Title    => Tc_Title_1,
            Srv_Descript => Tc_Title_2,
            Info_Label   => "Select values to build a new instance of this TC:");

      end if;

-- Separator line between V box of TC and TM
      Gtk.Separator.Gtk_New_Vseparator (Separator);
-- TODO: COMO HACERLO MAS ANCHO??     Separator.Set Border_Width (0);
--      Separator.Set_Shadow_Type (Gtk.Enums.Shadow_None);
      Separator.Override_Background_Color
       (State => Gtk.Enums.Gtk_State_Flag_Normal,
        Color => Wdgt_Colors.Separator_2);
      Tc_Tm_Box.Pack_Start (Separator, False, True, 1);

-- V box for TM
      Gtk.Box.Gtk_New_Vbox
        (Box         => Vbox_Tm,
         Homogeneous => False,
         Spacing     => 0);
      Gtk.Box.Set_Border_Width (Vbox_Tm, Border_Widths_C);
      Tc_Tm_Box.Pack_Start
        (Child   => Vbox_Tm,
         Expand  => False,
         Fill    => True,
         Padding => 0);

-- Box at the top of the V boxTM to insert the title of the TM
      if Tm_Title_1 /= "TC_TM_Unknow" then

         Gtk.Box.Gtk_New_Vbox (Box_Title_Tm);
         Vbox_Tm.Pack_Start (Box_Title_Tm);
         Create_One_Main_Title
           (Vbox         => Box_Title_Tm,
            Srv_Title    => Tm_Title_1,
            Srv_Descript => Tm_Title_2,
            Info_Label   => "Last values received of this TM:");

      end if;

-- Create the Label Box used to insert this wdgt into a Notebook
      Gtk.Box.Gtk_New_Hbox (Tc_Tm_Page.Label_Box, False, 0);
      Gtk.Image.Gtk_New (Pixmap, Book_Closed_Icon);
      Gtk.Box.Pack_Start (Tc_Tm_Page.Label_Box, Pixmap, False, True, 0);
      Gtk.Image.Set_Padding (Pixmap, 3, 1);

      Gtk.Label.Gtk_New (Label, Title);
      Gtk.Box.Pack_Start (Tc_Tm_Page.Label_Box, Label, False, True, 0);
      Gtk.Box.Show_All (Tc_Tm_Page.Label_Box);

-- Create the TC and TM Grids where put the parameters
      Gtk.Grid.Gtk_New (Tc_Tm_Page.Tc_Grid);
      Tc_Tm_Page.Tc_Grid.Set_Border_Width (Border_Widths_C);

      Gtk.Box.Pack_Start
        (In_Box  => Vbox_Tc,
         Child   => Tc_Tm_Page.Tc_Grid,
         Expand  => True,
         Fill    => True,
         Padding =>  0);

      Gtk.Grid.Gtk_New (Tc_Tm_Page.Tm_Grid);
      Tc_Tm_Page.Tm_Grid.Set_Border_Width (Border_Widths_C);

      Gtk.Box.Pack_Start
        (In_Box  => Vbox_Tm,
         Child   => Tc_Tm_Page.Tm_Grid,
         Expand  => True,
         Fill    => True,
         Padding =>  0);

--      Create_Main_Titles
--        (Box_Title_Tc => Hbox_Title_Tc,
--         Tc_Title     => Tc_Title_1,
--         Tc_Descript  => Tc_Title_2,
--         Box_Title_Tm => Hbox_Title_Tm,
--         Tm_Title     => Tm_Title_1,
--         Tm_Descript  => Tm_Title_2);




--Child.Modify_Fg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));
--Child.Modify_Bg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));
   end Initialize;





end Wdgt_Tc_Tm_Page;
