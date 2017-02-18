

with Glib.Object;


with Gtk.Aspect_Frame;
with Gtk.Button;
with Gtk.Enums;
with Gtk.Frame;
with Gtk.GEntry;
with Gtk.Image;
with Gtk.Label;
with Gdk.Pixbuf;
with Gtk.Scrolled_Window;

with Debug_Log;

with Wdgt_Colors;
with Wdgt_Fonts;
with Wdgt_Images;
with Wdgt_Colors;
with Wdgt_Frame_User_Data;

with Oeu_Simu.Smu;

package body Uif_Tc_Tm_Common is


   Oeu_Rt_Nominal_C        : Basic_Types_1553.Rt_Id_T   := 2;
   Oeu_Rt_Redundant_C      : Basic_Types_1553.Rt_Id_T   := 18;

   Input_Sa_Of_Oeu_C       : Basic_Types_1553.Sa_Id_T   := 1;



-- ======================================================================================
-- %% Internal operations
-- ======================================================================================


   function Srv_To_Title (Srv  : in Services_T)
   return String
   is
   begin
      case Srv is
         when Tm_1   => return "TM(1, ";
         when Tc_3   => return "TC(3, ";
         when Tc_5   => return "TC(5, ";
         when Tc_6   => return "TC(6, ";
         when Tc_9   => return "TC(9, ";
         when Tc_12  => return "TC(12, ";
         when Tc_17  => return "TC(17, ";
         when Tc_128 => return "TC(128, ";
         when Tc_129 => return "TC(129, ";
         when Tc_130 => return "TC(130, ";
      end case;
   end Srv_To_Title;

   function Srv_To_Summary (Srv  : in Services_T)
   return String
   is
   begin
      case Srv is
         when Tm_1   => return "Verification";
         when Tc_3   => return "Housekeeping";
         when Tc_5   => return "Events reports";
         when Tc_6   => return "Memory management";
         when Tc_9   => return "Time operations";
         when Tc_12  => return "Monitoring";
         when Tc_17  => return "Test service";
         when Tc_128 => return "Modes management";
         when Tc_129 => return "Instructions/parameters";
         when Tc_130 => return "Configurations";
      end case;
   end Srv_To_Summary;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Create_Wdgts_Pages
     (Page_Config : in Notebook_Page_Config_T;
      Notebook    : not null access Gtk.Notebook.Gtk_Notebook_Record'Class;
      Page_Wdgts  : out Notebook_Page_Wdgt_T)
   is
      use type Glib.Gint;
      use type Basic_Types_1553.Tc_Tm_Id_T;

      Range_Error    : Boolean                        := False;
      The_Title      : Basic_Types_1553.Tc_Tm_Id_T    := Basic_Types_1553.Tc_Tm_None;
   begin

      if Page_Config'Last /= Page_Wdgts'Last then
         Range_Error := True;
      end if;
      if Page_Config'First /= Page_Wdgts'First then
         Range_Error := True;
      end if;

      if not Range_Error then

         for I in Page_Config'Range loop

            if Page_Config (I).Tc_Page /= Basic_Types_1553.Tc_Tm_None then
               The_Title := Page_Config (I).Tc_Page;
            else
               The_Title := Page_Config (I).Tm_Page;
            end if;

            Wdgt_Tc_Tm_Page.Gtk_New
              (Tc_Tm_Page => Page_Wdgts (I),
               Title      => Basic_Types_1553.Tc_Tm_Id_To_Str (The_Title),
               Tc_Title_1 => Basic_Types_1553.Tc_Tm_Id_To_Str (Page_Config (I).Tc_Page),
               Tc_Title_2 => Basic_Types_1553.Tc_Tm_Id_To_Descript
                 (Page_Config (I).Tc_Page),
               Tm_Title_1 => Basic_Types_1553.Tc_Tm_Id_To_Str (Page_Config (I).Tm_Page),
               Tm_Title_2 => Basic_Types_1553.Tc_Tm_Id_To_Descript
                 (Page_Config (I).Tm_Page));

            Notebook.Append_Page
              (Child      => Page_Wdgts (I),
               Tab_Label  => Page_Wdgts (I).Label_Box);

         end loop;

      else
         Debug_Log.Do_Log
           ("[Uif_Tc_Tm_Common.Create_Wdgts_Pages]Error Invalid ranges: ");
         if Page_Config'Last > 0 then
            Debug_Log.Do_Log
              ("TC: " & Page_Config (Page_Config'First).Tc_Page'Image & ", TM: " &
               Page_Config (Page_Config'First).Tm_Page'Image);
         end if;
      end if;
   end Create_Wdgts_Pages;





   procedure Create_A_Title_Line
     (The_Grid    : access Gtk.Grid.Gtk_Grid_Record'Class;
      Label_Title : in String;
      Grid_Left   : in Glib.Gint;
      Grid_Top    : in Glib.Gint;
      Grid_Width  : in Glib.Gint   := 1;
      Grid_Height : in Glib.Gint   := 1)
   is
      Line_Frm      : Gtk.Aspect_Frame.Gtk_Aspect_Frame    := Null;
      Line_Box      : Gtk.Box.Gtk_Box                      := Null;
      Line_Label    : Gtk.Label.Gtk_Label                  := Null;
   begin

      Gtk.Aspect_Frame.Gtk_New
        (Aspect_Frame => Line_Frm,
         Label        => "",
         Xalign       => 0.5,
         Yalign       => 0.5,
         Ratio        => 0.0,
         Obey_Child   => True);
      Line_Frm.Set_Border_Width (6);
      Line_Frm.Set_Shadow_Type (Gtk.Enums.Shadow_None);
      The_Grid.Attach (Line_Frm, Grid_Left, Grid_Top, Grid_Width, Grid_Height);

      Gtk.Box.Gtk_New_Hbox
        (Box         => Line_Box,
         Homogeneous => True,
         Spacing     =>  1);
      Line_Frm.Add (Line_Box);
      Gtk.Label.Gtk_New (Line_Label, Label_Title);
      Line_Label.Set_Width_Chars (40);
      Line_Label.Set_Padding (Xpad => 0, Ypad => 0);
      Gtk.Box.Pack_Start (Line_Box, Line_Label, False, True, 0);

      Gtk.Box.Show_All (Line_Box);
   end Create_A_Title_Line;


   procedure Create_A_Param_Line
     (The_Grid    : access Gtk.Grid.Gtk_Grid_Record'Class;
      Param       : in Test_Params_I.Param_T;
      Line_Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Grid_Left   : in Glib.Gint;
      Grid_Top    : in Glib.Gint;
      Grid_Width  : in Glib.Gint   := 1;
      Grid_Height : in Glib.Gint   := 1)
   is
      Line_Frm      : Gtk.Aspect_Frame.Gtk_Aspect_Frame    := Null;
      Line_Box      : Gtk.Box.Gtk_Box                      := Null;
      Line_Label    : Gtk.Label.Gtk_Label                  := Null;
   begin

      Gtk.Aspect_Frame.Gtk_New
        (Aspect_Frame => Line_Frm,
         Label        => "",
         Xalign       => 0.5,
         Yalign       => 0.5,
         Ratio        => 0.0,
         Obey_Child   => True);
      Line_Frm.Set_Border_Width (1);
      Line_Frm.Set_Shadow_Type(Gtk.Enums.Shadow_Etched_Out);-- .Shadow_In);
      The_Grid.Attach (Line_Frm, Grid_Left, Grid_Top, Grid_Width, Grid_Height);

--Line_Frm.Modify_Fg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));

      Gtk.Box.Gtk_New_Hbox
        (Box         => Line_Box,
         Homogeneous => True,
         Spacing     =>  1);
      Line_Frm.Add (Line_Box);
      Gtk.Label.Gtk_New
        (Label => Line_Label,
         Str   => String (Test_Params_I.Get_Name (Param)));
      Line_Label.Set_Width_Chars (30);
      Line_Label.Set_Attributes
        (Attrs => Wdgt_Fonts.Get_Attributes
          (Wdgt_Fonts.F_Text2_Sans, Wdgt_Colors.Black));

      Line_Label.Set_Padding (Xpad => 0, Ypad => 0);
      Gtk.Box.Pack_Start (Line_Box, Line_Label, False, True, 0);

--Line_Box.Modify_Fg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));
--Line_Label.Modify_Bg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));


      if Line_Widget /= Null then
         Gtk.Box.Pack_Start (Line_Box, Line_Widget, False, True, 1);
      end if;
      Gtk.Box.Show_All (Line_Box);
   end Create_A_Param_Line;


   procedure Create_Butt_Append_Tc
     (The_Grid       : access Gtk.Grid.Gtk_Grid_Record'Class;
      Grid_Left      : in Glib.Gint;
      Grid_Top       : in Glib.Gint;
      Append_Handler : in Wdgt_Common.Widget_Handler.Simple_Handler;
      Send_Handler   : in Wdgt_Common.Widget_Handler.Simple_Handler)
   is
      use type Wdgt_Common.Widget_Handler.Simple_Handler;

      Line_Frm         : Gtk.Aspect_Frame.Gtk_Aspect_Frame    := Null;
      Line_Box         : Gtk.Box.Gtk_Box                      := Null;
      Line_Label       : Gtk.Label.Gtk_Label                  := Null;
      Line_Entry       : Gtk.GEntry.Gtk_Entry                 := Null;
      Butt             : Gtk.Button.Gtk_Button                := Null;
      Butt_Image       : Gtk.Image.Gtk_Image                  := Null;
      Arrows_Down_Icon : Gdk.Pixbuf.Gdk_Pixbuf                :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Arrows_Down_Mini);
      Envelop_Icon     : Gdk.Pixbuf.Gdk_Pixbuf                :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Envelope_Mini);

   begin

      Gtk.Aspect_Frame.Gtk_New
        (Aspect_Frame => Line_Frm,
         Label        => "",
         Xalign       => 0.5,
         Yalign       => 0.5,
         Ratio        => 0.0,
         Obey_Child   => True);
      Line_Frm.Set_Border_Width (7);
      Line_Frm.Set_Shadow_Type(Gtk.Enums.Shadow_Etched_Out);

      Gtk.Box.Gtk_New_Hbox
        (Box         => Line_Box,
         Homogeneous => False,
         Spacing     =>  1);
      Line_Frm.Add (Line_Box);
      Gtk.Label.Gtk_New (Line_Label, "Summary:");
      Line_Label.Set_Attributes
        (Attrs => Wdgt_Fonts.Get_Attributes
          (Wdgt_Fonts.F_Text2_Sans, Wdgt_Colors.Black));
--      Line_Label.Set_Padding (Xpad => 0, Ypad => 5);
      Line_Box.Pack_Start (Line_Label, False, False, 1);

      Line_Entry := Gtk.GEntry.Gtk_Entry_New;
      Line_Entry.Set_Alignment (Xalign => 0.1);
      Line_Entry.Set_Tooltip_Text
        ("Optional summary for this TC in the Test Script below");
      Line_Box.Pack_Start (Line_Entry, False, False, 1);

-- Button with arrows to copy TC in the TC script below
      Gtk.Button.Gtk_New (Butt, "");
      Gtk.Image.Gtk_New (Butt_Image);
      Butt_Image.Set (Arrows_Down_Icon);
      Butt.Set_Image (Butt_Image);
      Butt.Set_Relief (Gtk.Enums.Relief_Normal);
      Butt.Set_Tooltip_Text ("Insert this TC in the the Test Script below");
      Butt.Set_State (State => Gtk.Enums.State_Insensitive); -- TBC <====================
      Line_Box.Pack_Start (Butt, False, False, 1);
      if Append_Handler /= null then
         Wdgt_Common.Widget_Handler.Connect
           (Widget => Butt,
            Name   => "clicked",
            Cb     => Append_Handler);
      end if;

-- Button with envelop to send the TC just now
      Gtk.Button.Gtk_New (Butt, "");
      Gtk.Image.Gtk_New (Butt_Image);
      Butt_Image.Set (Envelop_Icon);
      Butt.Set_Image (Butt_Image);
      Butt.Set_Relief (Gtk.Enums.Relief_Normal);
      Butt.Set_Tooltip_Text ("Send this TC just now");
      Line_Box.Pack_Start (Butt, False, False, 1);
      if Send_Handler /= null then
         Wdgt_Common.Widget_Handler.Connect
           (Widget => Butt,
            Name   => "clicked",
            Cb     => Send_Handler);
      end if;

      Gtk.Box.Show_All (Line_Box);
      The_Grid.Attach (Line_Frm, Grid_Left, Grid_Top);
   end Create_Butt_Append_Tc;

   procedure Create_Butt_Append_Tm
     (The_Grid       : access Gtk.Grid.Gtk_Grid_Record'Class;
      Grid_Left      : in Glib.Gint;
      Grid_Top       : in Glib.Gint;
      Append_Handler : in Wdgt_Common.Widget_Handler.Simple_Handler)
   is
      use type Wdgt_Common.Widget_Handler.Simple_Handler;

      Line_Frm         : Gtk.Aspect_Frame.Gtk_Aspect_Frame    := Null;
      Line_Box         : Gtk.Box.Gtk_Box                      := Null;
      Line_Label       : Gtk.Label.Gtk_Label                  := Null;
      Line_Entry       : Gtk.GEntry.Gtk_Entry                 := Null;
      Butt             : Gtk.Button.Gtk_Button                := Null;
      Butt_Image       : Gtk.Image.Gtk_Image                  := Null;
      Arrows_Down_Icon : Gdk.Pixbuf.Gdk_Pixbuf                :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Arrows_Down_Mini);
      Envelop_Icon     : Gdk.Pixbuf.Gdk_Pixbuf                :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Envelope_Mini);

   begin

      Gtk.Aspect_Frame.Gtk_New
        (Aspect_Frame => Line_Frm,
         Label        => "",
         Xalign       => 0.5,
         Yalign       => 0.5,
         Ratio        => 0.0,
         Obey_Child   => True);
      Line_Frm.Set_Border_Width (7);
      Line_Frm.Set_Shadow_Type(Gtk.Enums.Shadow_Etched_Out);

      Gtk.Box.Gtk_New_Hbox
        (Box         => Line_Box,
         Homogeneous => False,
         Spacing     =>  1);
      Line_Frm.Add (Line_Box);
      Gtk.Label.Gtk_New (Line_Label, "Summary:");
      Line_Label.Set_Attributes
        (Attrs => Wdgt_Fonts.Get_Attributes
          (Wdgt_Fonts.F_Text2_Sans, Wdgt_Colors.Black));
--      Line_Label.Set_Padding (Xpad => 0, Ypad => 5);
      Line_Box.Pack_Start (Line_Label, False, False, 1);

      Line_Entry := Gtk.GEntry.Gtk_Entry_New;
      Line_Entry.Set_Alignment (Xalign => 0.1);
      Line_Entry.Set_Tooltip_Text
        ("Optional summary for this TM in the Test Script below");
      Line_Box.Pack_Start (Line_Entry, False, False, 1);

-- Button with arrows to copy TM in the test script below
      Gtk.Button.Gtk_New (Butt, "");
      Gtk.Image.Gtk_New (Butt_Image);
      Butt_Image.Set (Arrows_Down_Icon);
      Butt.Set_Image (Butt_Image);
      Butt.Set_Relief (Gtk.Enums.Relief_Normal);
      Butt.Set_Tooltip_Text ("Insert a check of this TM in the the Test Script below");
      Butt.Set_State (State => Gtk.Enums.State_Insensitive);   -- <====================
      Line_Box.Pack_Start (Butt, False, False, 1);
      if Append_Handler /= null then
         Wdgt_Common.Widget_Handler.Connect
           (Widget => Butt,
            Name   => "clicked",
            Cb     => Append_Handler);
      end if;

      Gtk.Box.Show_All (Line_Box);
      The_Grid.Attach (Line_Frm, Grid_Left, Grid_Top);
   end Create_Butt_Append_Tm;





--     procedure Create_A_Sub_Srv_Page
--       (Notebook    : access Gtk.Notebook.Gtk_Notebook_Record'Class;
--        Title       : in String;
--        Title_Info  : in String;
--  --      Tc_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
--  --      Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
--        Vbox_Tc     : out Gtk.Box.Gtk_Box;
--        Vbox_Tm     : out Gtk.Box.Gtk_Box)
--     is
--        Child            : Gtk.Frame.Gtk_Frame                          := Null;
--  --      Child            : Wdgt_Frame_User_Data.Frame_User_Data         := Null;
--
--        Scrolled_Win     : Gtk.Scrolled_Window.Gtk_Scrolled_Window      := Null;
--        Label_Box        : Gtk.Box.Gtk_Box                              := Null;
--        Menu_Box         : Gtk.Box.Gtk_Box                              := Null;
--        Main_Box         : Gtk.Box.Gtk_Box                              := Null;
--        Pixmap           : Gtk.Image.Gtk_Image                          := Null;
--        Label            : Gtk.Label.Gtk_Label                          := Null;
--
--  --------------------------------------------------------------------------------------------------
--  -- TODO: CAMBIAR POR Gtk.Separator
--        Separator_Frm    : Gtk.Frame.Gtk_Frame                          := Null;
--
--
--
--        Book_Closed_Icon : Gdk.Pixbuf.Gdk_Pixbuf                        :=
--          Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Closed);
--  --        Gdk.Pixbuf.Gdk_New_From_Xpm_Data
--  --          (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Closed));
--
--     begin
--
--  --      Wdgt_Frame_User_Data
--        Gtk.Frame.Gtk_New (Child); --, Title_Info);
--  --      Wdgt_Frame_User_Data
--  --      Gtk.Frame.Set_Border_Width (Child, Uif_Tc_Tm_Common.Border_Widths_C);
--
--        Scrolled_Win := Gtk.Scrolled_Window.Gtk_Scrolled_Window_New;
--        Scrolled_Win.Set_Border_Width (Border_Width => 10);
--        Scrolled_Win.Set_Policy
--          (Hscrollbar_Policy => Gtk.Enums.Policy_Automatic,
--           Vscrollbar_Policy => Gtk.Enums.Policy_Automatic);
--
--        Child.Add (Scrolled_Win);
--
--  -- Store the identifier of the TM Parameter used in this page in the frame_User_Data
--  --      Child.User_Data_Int1 := Glib.Gint
--  --        (Basic_Types_1553.Tc_Tm_Id_To_Int_C (Tc_Id));
--  --      Child.User_Data_Int2 := Glib.Gint
--  --        (Basic_Types_1553.Tc_Tm_Id_To_Int_C (Tm_Id));
--  --      Child.User_Data_Int3 := 33;
--
--        Gtk.Box.Gtk_New_Hbox (Main_Box, False, 0);
--        Gtk.Box.Set_Border_Width (Main_Box, Uif_Tc_Tm_Common.Border_Widths_C);
--        Scrolled_Win.Add (Main_Box);
--
--  -- V box for TC
--        Gtk.Box.Gtk_New_Vbox (Vbox_Tc, True, 0);
--        Gtk.Box.Set_Border_Width (Vbox_Tc, Uif_Tc_Tm_Common.Border_Widths_C);
--        Main_Box.Pack_Start (Vbox_Tc, True, True, 0);
--
--  -- Separator line between V box of TC and TM
--        Gtk.Frame.Gtk_New (Separator_Frm);
--        Separator_Frm.Set_Border_Width (0);
--        Separator_Frm.Set_Shadow_Type (Gtk.Enums.Shadow_None);
--        Separator_Frm.Override_Background_Color
--         (State => Gtk.Enums.Gtk_State_Flag_Normal,
--          Color => Wdgt_Colors.Separator_1);
--        Main_Box.Pack_Start (Separator_Frm, False, False, 1);
--
--  -- V box for TM
--        Gtk.Box.Gtk_New_Vbox (Vbox_Tm, True, 0);
--        Gtk.Box.Set_Border_Width (Vbox_Tm, Uif_Tc_Tm_Common.Border_Widths_C);
--        Main_Box.Pack_Start (Vbox_Tm, True, True, 0);
--
--  --      Wdgt_Frame_User_Data
--        Gtk.Frame.Show_All (Child);
--        Gtk.Box.Gtk_New_Hbox (Label_Box, False, 0);
--        Gtk.Image.Gtk_New (Pixmap, Book_Closed_Icon);
--        Gtk.Box.Pack_Start (Label_Box, Pixmap, False, True, 0);
--        Gtk.Image.Set_Padding (Pixmap, 3, 1);
--
--        Gtk.Label.Gtk_New (Label, Title);
--        Gtk.Box.Pack_Start (Label_Box, Label, False, True, 0);
--        Gtk.Box.Show_All (Label_Box);
--
--        Gtk.Box.Gtk_New_Vbox (Menu_Box, False, 0);
--        Gtk.Image.Gtk_New (Pixmap, Book_Closed_Icon);
--        Gtk.Box.Pack_Start (Menu_Box, Pixmap, False, True, 0);
--        Gtk.Image.Set_Padding (Pixmap, 3, 1);
--
--        Gtk.Label.Gtk_New (Label, Title);
--        Gtk.Box.Pack_Start (Menu_Box, Label, False, True, 0);
--        Gtk.Box.Show_All (Menu_Box);
--
--
--  --Child.Modify_Fg
--  --  (State => Gtk.Enums.State_Normal, -- .State_Active,
--  --   Color => Gdk.Color.Parse("Blue"));
--  --Child.Modify_Bg
--  --  (State => Gtk.Enums.State_Normal, -- .State_Active,
--  --   Color => Gdk.Color.Parse("Blue"));
--
--
--        Gtk.Notebook.Append_Page_Menu (Notebook, Child, Label_Box, Menu_Box);
--     end Create_A_Sub_Srv_Page;



   procedure Send_A_Tc
     (Raw_Tc  : in Basic_Types_I.Byte_Array_T)
   is
   begin

      Oeu_Simu.Smu.Send_Tc_Block
           (Rt_Id   => Oeu_Rt_Nominal_C,
            Sa_Id   => Input_Sa_Of_Oeu_C,
            Raw_Tc  => Raw_Tc);
   end Send_A_Tc;


-----------------------------------------------------------------------------------------
-- Functions creating widgets inserted in the sub services pages (Begin)

   function New_Combo_Oeu_Mode return Gtk.Combo_Box_Text.Gtk_Combo_Box_Text
   is
      Mode_Combo     : Gtk.Combo_Box_Text.Gtk_Combo_Box_Text  := Null;
   begin
      Gtk.Combo_Box_Text.Gtk_New (Mode_Combo);

      Mode_Combo.Insert(Position => 0,  Text => "RESCUE   (0)");
      Mode_Combo.Insert(Position => 1,  Text => "REFUSE   (1)");
      Mode_Combo.Insert(Position => 2,  Text => "STANDBY  (2)");
      Mode_Combo.Insert(Position => 3,  Text => "NORMAL   (3)");
      Mode_Combo.Insert(Position => 4,  Text => "SILENT   (4)");
      Mode_Combo.Insert(Position => 5,  Text => "S01 Seq  (101)");
      Mode_Combo.Insert(Position => 6,  Text => "S02 Seq  (102)");
      Mode_Combo.Insert(Position => 7,  Text => "S03 Seq  (103)");
      Mode_Combo.Insert(Position => 8,  Text => "S04 Seq  (104)");
      Mode_Combo.Insert(Position => 9,  Text => "S05 Seq  (105)");
      Mode_Combo.Insert(Position => 10, Text => "S06 Seq  (106)");
      Mode_Combo.Insert(Position => 11, Text => "S07 Seq  (107)");
      Mode_Combo.Insert(Position => 12, Text => "S08 Seq  (108)");
      Mode_Combo.Insert(Position => 13, Text => "S09 Seq  (109)");
      Mode_Combo.Set_Active (2);
      Mode_Combo.Set_Tooltip_Text ("Select an OEU mode");

      return Mode_Combo;
   end New_Combo_Oeu_Mode;

   function New_Entry
     (Initial_Value : in Glib.Gint;
      Read_Only     : in Boolean) return Gtk.Gentry.Gtk_Entry
   is
      The_Entry     : Gtk.Gentry.Gtk_Entry   := Gtk.Gentry.Gtk_Entry_New;
   begin

      The_Entry.Set_Editable (not Read_Only);
      The_Entry.Set_Text (Glib.Gint'Image (Initial_Value));
      The_Entry.Set_Alignment (Xalign => 1.0);

      return The_Entry;
   end New_Entry;

-- Functions creating widgets inserted in the sub services pages (End)
-----------------------------------------------------------------------------------------







   procedure Build_Page_Not_Implemented
     (The_Grid    : access Gtk.Grid.Gtk_Grid_Record'Class;
      Grid_Top    : in Glib.Gint)
   is
      Line_Frm       : Gtk.Aspect_Frame.Gtk_Aspect_Frame      := Null;
      Line_Label     : Gtk.Label.Gtk_Label                    := Null;
   begin


      Gtk.Aspect_Frame.Gtk_New
        (Aspect_Frame => Line_Frm,
         Label        => "",
         Xalign       => 0.5,
         Yalign       => 0.5,
         Ratio        => 0.0,
         Obey_Child   => True);
      Line_Frm.Set_Border_Width (1);

--      Gtk.Box.Pack_Start
--        (In_Box  => Vbox_Tc,
--         Child   => Line_Frm,
--         Expand  => True,
--         Fill    => True,
--         Padding =>  0);

      Gtk.Label.Gtk_New (Line_Label, "<NOT IMPLEMENTED>");

      Line_Label.Set_Attributes
        (Attrs => Wdgt_Fonts.Get_Attributes (Wdgt_Fonts.F_Title1, Wdgt_Colors.Orange_2));


      Line_Frm.Add (Line_Label);
      The_Grid.Attach
        (Child   => Line_Frm,
         Left    => 1,
         Top     => Grid_Top,
         Width   => 1,
         Height  => 1);


   end Build_Page_Not_Implemented;


   function Num_To_Page (Page  : Glib.Gint) return Uif_Tc_Tm_Common.Services_T
   is
      use type Glib.Gint;

      Result  : Uif_Tc_Tm_Common.Services_T    := Uif_Tc_Tm_Common.Services_T'First;
   begin

      if    Page = 0 then
         Result := Uif_Tc_Tm_Common.Tm_1;
      elsif Page = 1 then
         Result := Uif_Tc_Tm_Common.Tc_3;
      elsif Page = 2 then
         Result := Uif_Tc_Tm_Common.Tc_5;
      elsif Page = 3 then
         Result := Uif_Tc_Tm_Common.Tc_6;
      elsif Page = 4 then
         Result := Uif_Tc_Tm_Common.Tc_9;
      elsif Page = 5 then
         Result := Uif_Tc_Tm_Common.Tc_12;
      elsif Page = 6 then
         Result := Uif_Tc_Tm_Common.Tc_17;
      elsif Page = 7 then
         Result := Uif_Tc_Tm_Common.Tc_128;
      elsif Page = 8 then
         Result := Uif_Tc_Tm_Common.Tc_129;
      elsif Page = 9 then
         Result := Uif_Tc_Tm_Common.Tc_130;
      else
         Debug_Log.Do_Log ("[Uif_Tc_Tm_Common.Num_To_Page]Warning Unknow page num: " &
           Glib.Gint'Image (Page));
      end if;
      return Result;
   end Num_To_Page;


end Uif_Tc_Tm_Common;

