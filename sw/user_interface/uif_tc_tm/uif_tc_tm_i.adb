
with Ada.Text_IO;
with Ada.Exceptions;
with System;


with Gdk.Color;
with Gdk.Pixbuf;
with Gdk.Rgba;

with Glib;
with Glib.Action_Map;
with Glib.Error;
with Glib.Object;
with Glib.Menu_Model;
with Glib.Application;
with Glib.Simple_Action;
with Glib.Variant;

with Gtk.Arguments;
with Gtk.Box;
with Gtk.Builder;
with Gtk.Button;
with Gtk.Combo_Box_Text;
with Gtk.Container;
with Gtk.Enums;
with Gtk.GEntry;
with Gtk.Grid;
with Gtk.Frame;
with Gtk.Handlers;
with Gtk.Image;
with Gtk.Image_Menu_Item;
with Gtk.Label;
with Gtk.Menu;
with Gtk.Menu_Item;
with Gtk.Menu_Tool_Button;
with Gtk.Notebook;
with Gtk.Scrolled_Window;
with Gtk.Table;
with Gtk.Window;
with Gtk.Widget;

--with Pango.Font;
--with Pango.Enums;

with Debug_Log;
with Wdgt_Frame_User_Data;
with Wdgt_Images;
with Wdgt_Colors;
with Wdgt_Ui_Def;
with Wdgt_Tc_Tm_Page;

with Uif_Tc_Tm_1;
with Uif_Tc_Tm_3;
with Uif_Tc_Tm_5;
with Uif_Tc_Tm_6;
with Uif_Tc_Tm_9;
with Uif_Tc_Tm_12;
with Uif_Tc_Tm_17;
with Uif_Tc_Tm_128;
with Uif_Tc_Tm_129;
with Uif_Tc_Tm_130;
with Uif_Tc_Tm_Common;


--with Pus_Types_I;
--with Basic_Services;

package body Uif_Tc_Tm_I is

--   function U8_To_Str (Basic_Types.Uint8_T) return String is
--   begin
--   end U8_To_Str;

   use type Glib.Gint;

   type Gint_Childrem_T   is array (Uif_Tc_Tm_Common.Services_T'Range) of Glib.Gint;
   type Frames_Childrem_T   is array (Uif_Tc_Tm_Common.Services_T'Range) of
     Wdgt_Frame_User_Data.Frame_User_Data;
   type Ntbooks_Childrem_T  is array (Uif_Tc_Tm_Common.Services_T'Range) of
     Gtk.Notebook.Gtk_Notebook;
   type Bool_Childrem_T     is array (Uif_Tc_Tm_Common.Services_T'Range) of Boolean;


--   The_App              : Gtk.Application.Gtk_Application    := Null;
   Toplevel_Win            : Gtk.Window.Gtk_Window              := Null;
   Toplevel_Built          : Boolean                            := False;

   Base_V_Box              : Gtk.Box.Gtk_Box                    := Null;
   Tcs_H_Box               : Gtk.Box.Gtk_Box                    := Null;
   Srv_Ntbook              : Gtk.Notebook.Gtk_Notebook          := Null;

   Frames_Childrem         : Frames_Childrem_T                  := (others => null);
   Ntbooks_Childrem        : Ntbooks_Childrem_T                 := (others => null);
   Built_Childrem          : Bool_Childrem_T                    := (others => False);
   Subpage_Active_Childrem : Gint_Childrem_T                    := (others => -1);

--   Cmd_H_Box               : Gtk.Box.Gtk_Box                    := Null;

   Menu_Item_Quit          : Gtk.Image_Menu_Item.Gtk_Image_Menu_Item := null;





--   Tm_Displayed         : Basic_Types_1553.Tc_Tm_Id_T        :=
--     Basic_Types_1553.Tc_Tm_None;


-- TODO: LLEVAR A COMMON, cambiarlo
   package Widget_Handler is new Gtk.Handlers.Callback (Gtk.Widget.Gtk_Widget_Record);

   package Notebook_Cb is new Gtk.Handlers.Callback (Gtk.Notebook.Gtk_Notebook_Record);


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

--   procedure Hide (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) is
--   begin
--      Gtk.Widget.Hide (Widget);
--   end Hide;


   procedure Destroy_Toplevel is
   begin

--      Srv_Ntbook.Destroy;
      Toplevel_Win.Destroy;

      Srv_Ntbook    := null;
      Toplevel_Win  := null;
      Toplevel_Built := False;
   end Destroy_Toplevel;



   procedure On_Destroy_Toplevel_Menuitem
     (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is
      pragma Unreferenced (Self);
   begin
      Destroy_Toplevel;
   end On_Destroy_Toplevel_Menuitem;

   procedure On_Destroy_Toplevel (Self : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
      pragma Unreferenced (Self);
   begin
      Destroy_Toplevel;
   end On_Destroy_Toplevel;


   procedure On_Page_Sub_Srv_Switch
     (Notebook : access Gtk.Notebook.Gtk_Notebook_Record'Class;
      Child    : not null access Gtk.Widget.Gtk_Widget_Record'Class;
      Page_Num : Glib.Guint)
   is
      Old_Page_C     : constant Glib.Gint                    :=
        Gtk.Notebook.Get_Current_Page (Notebook);

      Pixmap         : Gtk.Image.Gtk_Image                   := Null;
      Widget         : Gtk.Widget.Gtk_Widget                 := Null;
      Frame_U_Data   : Wdgt_Frame_User_Data.Frame_User_Data  := Null;

      Book_Closed    : Gdk.Pixbuf.Gdk_Pixbuf                 :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Closed);
      Book_Open      : Gdk.Pixbuf.Gdk_Pixbuf                 :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Open);

   begin

--      Debug_Log.Do_Log ("[Uif_Tc_Tm_I.On_Page_Sub_Srv_Switch] OldPage: " &
--          Glib.Gint'Image (Old_Page_C) & " , NewPage: " & Glib.Guint'Image (Page_Num));

-- Put the Book Open in the Open Page
      Widget := Notebook.Get_Nth_Page (Glib.Gint (Page_Num));
      Pixmap := Gtk.Image.Gtk_Image
        (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box
        (Gtk.Notebook.Get_Tab_Label (Notebook, Widget)), 0));
      Pixmap.Set (Book_Open);

      if Old_Page_C >= 0 then
-- Put the Book Closed in the closed Page
         Widget := Notebook.Get_Nth_Page (Old_Page_C);
         Pixmap := Gtk.Image.Gtk_Image
           (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box
           (Gtk.Notebook.Get_Tab_Label (Notebook, Widget)), 0));
         Pixmap.Set (Book_Closed);
      end if;

-- Store the current page displayed in the child notebook
      Subpage_Active_Childrem
        (Uif_Tc_Tm_Common.Num_To_Page (Srv_Ntbook.Get_Current_Page))  :=
        Glib.Gint (Page_Num);
   end On_Page_Sub_Srv_Switch;




   procedure New_Sub_Srv_Ntbook
     (Up_Frame : access Gtk.Frame.Gtk_Frame_Record'Class;
      Ntbook   : in out Gtk.Notebook.Gtk_Notebook)
   is
   begin

      Up_Frame.Set_Border_Width (Wdgt_Tc_Tm_Page.Border_Widths_C);
      Gtk.Notebook.Gtk_New (Ntbook);
      Up_Frame.Add (Ntbook);
      Gtk.Notebook.Set_Border_Width (Ntbook, Wdgt_Tc_Tm_Page.Border_Widths_C);

-- NoteBook without popup property
      Ntbook.Popup_Disable;

      Gtk.Notebook.Realize (Ntbook);
   end New_Sub_Srv_Ntbook;


   procedure Create_Sub_Srv_Page
     (Up_Frame : access Gtk.Frame.Gtk_Frame_Record'Class;
      Srv      : in Uif_Tc_Tm_Common.Services_T)
   is
      use type Uif_Tc_Tm_Common.Services_T;

   begin

      New_Sub_Srv_Ntbook
        (Up_Frame => Up_Frame,
         Ntbook   => Ntbooks_Childrem (Srv));

      case Srv is
         when Uif_Tc_Tm_Common.Tm_1   =>
            Uif_Tc_Tm_1.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_3   =>
            Uif_Tc_Tm_3.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_5   =>
            Uif_Tc_Tm_5.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_6   =>
            Uif_Tc_Tm_6.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_9   =>
            Uif_Tc_Tm_9.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_12  =>
            Uif_Tc_Tm_12.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_17  =>
            Uif_Tc_Tm_17.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_128 =>
            Uif_Tc_Tm_128.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_129 =>
            Uif_Tc_Tm_129.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
         when Uif_Tc_Tm_Common.Tc_130 =>
            Uif_Tc_Tm_130.Create_Sub_Srv_Pages (Ntbooks_Childrem (Srv));
      end case;

      Ntbooks_Childrem (Srv).On_Switch_Page (On_Page_Sub_Srv_Switch'Access);
      Built_Childrem (Srv) := True;
   end Create_Sub_Srv_Page;


   procedure Destroy_Sub_Srv_Page (Page : in Uif_Tc_Tm_Common.Services_T)
   is
   begin
   null;
   end Destroy_Sub_Srv_Page;



   procedure On_Page_Switch
     (Notebook : access Gtk.Notebook.Gtk_Notebook_Record'Class;
      Params   : Gtk.Arguments.Gtk_Args)
   is
--      use type Glib.Gint;

      Old_Page_C     : constant Glib.Gint                    :=
        Gtk.Notebook.Get_Current_Page (Notebook);
      Page_Num_C     : constant Glib.Gint                    :=
        Glib.Gint (Gtk.Arguments.To_Guint (Params, 2));
      Srv_Page_C     : constant Uif_Tc_Tm_Common.Services_T  :=
        Uif_Tc_Tm_Common.Num_To_Page (Page_Num_C);

      Pixmap         : Gtk.Image.Gtk_Image                   := Null;
      Widget         : Gtk.Widget.Gtk_Widget                 := Null;
      Frame_U_Data   : Wdgt_Frame_User_Data.Frame_User_Data  := Null;

      Book_Closed    : Gdk.Pixbuf.Gdk_Pixbuf                 :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Closed);
      Book_Open      : Gdk.Pixbuf.Gdk_Pixbuf                 :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Open);

   begin

--      Debug_Log.Do_Log ("[Uif_Tc_Tm_I.On_Page_Switch] OldPage: " &
--        Glib.Gint'Image (Old_Page_C) & " , NewPage: " & Glib.Gint'Image (Page_Num_C));

-- Put the Book Open in the Open Page
      Widget := Notebook.Get_Nth_Page (Page_Num_C);
      Pixmap := Gtk.Image.Gtk_Image
        (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box
        (Gtk.Notebook.Get_Tab_Label (Notebook, Widget)), 0));
      Pixmap.Set (Book_Open);

      if not Built_Childrem (Srv_Page_C) then

         Create_Sub_Srv_Page
           (Up_Frame => Frames_Childrem (Srv_Page_C),
            Srv      => Srv_Page_C);

         Frames_Childrem (Srv_Page_C).Show_All;
      end if;

      if Old_Page_C >= 0 then
-- Put the Book Closed in the closed Page
         Widget := Notebook.Get_Nth_Page (Old_Page_C);
         Pixmap := Gtk.Image.Gtk_Image
           (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box
           (Gtk.Notebook.Get_Tab_Label (Notebook, Widget)), 0));
         Pixmap.Set (Book_Closed);

      end if;

   end On_Page_Switch;

--     procedure Page_Switch_Sub_Srv
--       (Notebook : access Gtk.Notebook.Gtk_Notebook_Record'Class;
--        Params   : Gtk.Arguments.Gtk_Args)
--     is
--        use type Glib.Gint;
--
--        Old_Page_C     : constant Glib.Gint                    :=
--          Gtk.Notebook.Get_Current_Page (Notebook);
--        Page_Num_C     : constant Glib.Gint                    :=
--          Glib.Gint (Gtk.Arguments.To_Guint (Params, 2));
--
--        Pixmap         : Gtk.Image.Gtk_Image                   := Null;
--        Widget         : Gtk.Widget.Gtk_Widget                 := Null;
--        Frame_U_Data   : Wdgt_Frame_User_Data.Frame_User_Data  := Null;
--
--        Book_Closed    : Gdk.Pixbuf.Gdk_Pixbuf                 :=
--          Gdk.Pixbuf.Gdk_New_From_Xpm_Data (Wdgt_Icons.Book_Closed_Xpm);
--        Book_Open      : Gdk.Pixbuf.Gdk_Pixbuf                 :=
--          Gdk.Pixbuf.Gdk_New_From_Xpm_Data (Wdgt_Icons.Book_Open_Xpm);
--
--     begin
--
--        Widget := Gtk.Notebook.Get_Nth_Page (Notebook, Page_Num_C);
--        Pixmap := Gtk.Image.Gtk_Image
--          (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box (Gtk.Notebook.Get_Tab_Label (Notebook, Widget)), 0));
--        Pixmap.Set (Book_Open);
--
--  --      Pixmap := Gtk.Image.Gtk_Image
--  --        (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box (Gtk.Notebook.Get_Menu_Label (Notebook, Widget)), 0));
--  --      Pixmap.Set (Book_Open);
--
--        if Old_Page_C >= 0 then
--           Widget := Gtk.Notebook.Get_Nth_Page (Notebook, Old_Page_C);
--           Pixmap := Gtk.Image.Gtk_Image
--             (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box (Gtk.Notebook.Get_Tab_Label (Notebook, Widget)), 0));
--           Pixmap.Set (Book_Closed);
--  --         Pixmap := Gtk.Image.Gtk_Image
--  --           (Gtk.Box.Get_Child (Gtk.Box.Gtk_Box (Gtk.Notebook.Get_Menu_Label (Notebook, Widget)), 0));
--  --         Pixmap.Set (Book_Closed);
--        end if;
--
--
--
--
--  -- Get the TM_Data parameters used in the new active page.
--        begin
--           Frame_U_Data       := Wdgt_Frame_User_Data.Frame_User_Data (Widget);
--  --           Gtk.Notebook.Get_Nth_Page (Notebook, Page_Num_C));
--  --         Tm_Displayed       := Basic_Types_1553.Tc_Tm_Id_T'Val
--  --           (Frame_U_Data.User_Data_Int2);
--
--           Debug_Log.Do_Log ("====Uif_Tc_Tm.Page_Switch_Sub_Srv to: " &
--    --         Basic_Types_1553.Tc_Tm_Id_T'Image (Tm_Displayed) &
--             " page-n: " & Glib.Gint'Image (Page_Num_C) &
--             " Int1: " & Glib.Gint'Image (Frame_U_Data.User_Data_Int1) &
--             " Int2: " & Glib.Gint'Image (Frame_U_Data.User_Data_Int2) &
--             " Int3: " & Glib.Gint'Image (Frame_U_Data.User_Data_Int3));
--   --     exception
--   --        when others =>
--   --           Tm_Displayed := Basic_Types_1553.Tc_Tm_None;
--        end;
--     end Page_Switch_Sub_Srv;





   procedure Create_Srv_Pages
     (Notebook  : access Gtk.Notebook.Gtk_Notebook_Record'Class)
   is
      Label_Box        : Gtk.Box.Gtk_Box                      := Null;
      Pixmap           : Gtk.Image.Gtk_Image                  := Null;
      Label            : Gtk.Label.Gtk_Label                  := Null;
      Book_Closed_Icon : Gdk.Pixbuf.Gdk_Pixbuf                :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Book_Closed);

--      Vbox      : Gtk.Box.Gtk_Box;
--      Button    : Gtk.Button.Gtk_Button;

   begin

      for Srv in Uif_Tc_Tm_Common.Services_T'Range loop

         Wdgt_Frame_User_Data.Gtk_New
           (Frame_U_Data => Frames_Childrem (Srv),
            Label        => " " & Uif_Tc_Tm_Common.Srv_To_Title (Srv) & " : " &
              Uif_Tc_Tm_Common.Srv_To_Summary (Srv) & " ");
         Frames_Childrem (Srv).Set_Border_Width (Wdgt_Tc_Tm_Page.Border_Widths_C);

--         Gtk.Box.Gtk_New_Vbox (Vbox, True, 0);
--         Gtk.Box.Set_Border_Width (Vbox, Border_Widths_C);
--         Gtk.Frame.Add (Child, Vbox);
--         Gtk.Button.Gtk_New (Button, "Hide page");
--         Gtk.Box.Pack_Start (Vbox, Button, True, True, 5);
--         Widget_Handler.Object_Connect
--           (Button, "clicked", Hide'Access, Slot_Object => Child);
--         Gtk.Frame.Show_All (Child);

         Gtk.Box.Gtk_New_Hbox (Label_Box, False, 0);
         Gtk.Image.Gtk_New (Pixmap, Book_Closed_Icon);
         Gtk.Box.Pack_Start (Label_Box, Pixmap, False, True, 0);
         Gtk.Image.Set_Padding (Pixmap, 1, 1);

         Gtk.Label.Gtk_New
           (Label  => Label,
            Str    => Uif_Tc_Tm_Common.Srv_To_Title (Srv));
         Gtk.Box.Pack_Start (Label_Box, Label, False, True, 0);
         Gtk.Box.Show_All (Label_Box);

--         Gtk.Box.Gtk_New_Vbox (Menu_Box, False, 0);
--         Gtk.Image.Gtk_New (Pixmap, Book_Closed_Icon);
--         Gtk.Box.Pack_Start (Menu_Box, Pixmap, False, True, 0);
--         Gtk.Image.Set_Padding (Pixmap, 3, 1);

--         Gtk.Label.Gtk_New (Label, "LabelOfMenuBox"); --Uif_Tc_Tm_Common.Srv_To_Summary (Srv));
--         Gtk.Box.Pack_Start (Menu_Box, Label, False, True, 0);
--         Gtk.Box.Show_All (Menu_Box);

         Frames_Childrem (Srv).Show_All;


--Child.Modify_Fg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));
--Child.Modify_Bg
--  (State => Gtk.Enums.State_Normal, -- .State_Active,
--   Color => Gdk.Color.Parse("Blue"));

-- Append the frame to the Srv Notebook to build the new Notebook page
         Notebook.Append_Page_Menu
           (Child      => Frames_Childrem (Srv),
            Tab_Label  => Label_Box,
            Menu_Label => null);

      end loop;

   end Create_Srv_Pages;



-- Create the main Notebook for all Services
   procedure Build_Toplevel_Inside
   is
   begin

      Gtk.Box.Gtk_New_HBox
        (Box         => Tcs_H_Box,
         Homogeneous => False,
         Spacing     => 0);
      Base_V_Box.Pack_Start
        (Child   => Tcs_H_Box,
         Expand  => True,
         Fill    => True,
         Padding => 0);

--      Gtk.Box.Gtk_New_HBox
--        (Box         => Cmd_H_Box,
--         Homogeneous => False,
--         Spacing     => 0);
--      Base_V_Box.Pack_Start
--        (Child   => Cmd_H_Box,
--         Expand  => True,
--         Fill    => True,
--         Padding => 0);

      Gtk.Notebook.Gtk_New (Srv_Ntbook);

      Notebook_Cb.Connect (Srv_Ntbook, "switch_page", On_Page_Switch'Access);

      Gtk.Box.Pack_Start (Tcs_H_Box, Srv_Ntbook, True, True, 0);
      Gtk.Notebook.Set_Border_Width (Srv_Ntbook, Wdgt_Tc_Tm_Page.Border_Widths_C);

-- NoteBook without popup property
      Srv_Ntbook.Popup_Disable;

-- NoteBook with Tabs on the top
      Srv_Ntbook.Set_Tab_Pos (Gtk.Enums.Pos_Top);

      Create_Srv_Pages (Srv_Ntbook);
      Srv_Ntbook.Set_Size_Request
        (Width  => -1,
         Height => 310);


-- Build the NoteBook
      Gtk.Notebook.Realize (Srv_Ntbook);

   end Build_Toplevel_Inside;



   procedure Toplevel_Startup
   is
--      use type Glib.Guint;

--      Builder  : Gtk.Builder.Gtk_Builder                    :=
--        Wdgt_Ui_Def.Get_Builder (Wdgt_Ui_Def.Tc_Tm_Top);
--      Success  : Glib.Guint;
--      Error    : aliased Glib.Error.GError;
   begin
      --  Startup is when the application should create its menu bar. For
      --  this, we load an xml file and then extra parts of its to get the
      --  contents of the application menu and menu bar.

--      Debug_Log.Do_Log ("Uif_Tc_Tm.App_Startup B ");

--      Builder := Gtk.Builder.Gtk_Builder_New;
--      Success := Builder.Add_From_String
--        (Wdgt_Ui_Def.Get_Ui (Wdgt_Ui_Def.Tc_Tm_Top), Error'Access);
--      if Success = 0 then
--         Debug_Log.Do_Log ("Uif_Tc_Tm.App_Startup. Error parsing menus.ui: " &
--           Glib.Error.Get_Message (Error));
--      else
--         App.Set_App_Menu (Glib.Menu_Model.Gmenu_Model (Builder.Get_Object ("appmenu")));
--         App.Set_Menubar (Glib.Menu_Model.Gmenu_Model (Builder.Get_Object ("menubar")));
null;
--      end if;
--      Builder.Unref;  --  no longer needed

--      Debug_Log.Do_Log ("Uif_Tc_Tm.App_Startup E ");

   end Toplevel_Startup;


   procedure Toplevel_Activate
   is


      Icon           : Gdk.Pixbuf.Gdk_Pixbuf                       :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Megaphone_Mini);

      Builder        : Gtk.Builder.Gtk_Builder                     :=
        Wdgt_Ui_Def.Get_Builder (Wdgt_Ui_Def.Tc_Tm_Test);
      Root_Frame     : Gtk.Frame.Gtk_Frame                         := null;

   begin
--  Activation is when we should create the main window

--      Debug_Log.Do_Log ("Uif_Tc_Tm.App_Activate B ");

      Toplevel_Win.Set_Title (" TC/TM Handler ");

-- Use an icon from disk
      Toplevel_Win.Set_Icon (Icon);

      Toplevel_Win.Set_Default_Size
        (Width  => 400,
         Height => 500);

      Toplevel_Win.On_Destroy (Call => On_Destroy_Toplevel'Access);


--  The global V box
      Gtk.Box.Gtk_New_Vbox
        (Box         => Base_V_Box,
         Homogeneous => False,
         Spacing     => 0);
      Toplevel_Win.Add (Base_V_Box);

      Build_Toplevel_Inside;


-- --------------------------------------------------------------------------------------
-- Use the builder to load Test menu.

-- Get the root frame and pack it into the main V Box
      Root_Frame := Gtk.Frame.Gtk_Frame (Builder.Get_Object ("Root_Frame"));
      Base_V_Box.Pack_Start
        (Child   => Root_Frame,
         Expand  => True,
         Fill    => True,
         Padding => 2);


-- Connect the menu items
      Menu_Item_Quit := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("MenuItemFileClose"));
      Menu_Item_Quit.On_Activate (On_Destroy_Toplevel_Menuitem'Access);



-- --------------------------------------------------------------------------------------


      Toplevel_Win.Show_All;

--      Debug_Log.Do_Log ("Uif_Tc_Tm.App_Activate E ");
   end Toplevel_Activate;



   function Get_Current_Page return Glib.Gint
   is
--      use type Glib.Gint;
      use type Gtk.Notebook.Gtk_Notebook;

      Return_Result     : Glib.Gint                := -1;
   begin

      BLOCK: begin
         if Is_Built and then (Srv_Ntbook /= null) then

            Return_Result := Srv_Ntbook.Get_Current_Page;
         end if;
      exception
         when Excep : others =>
            Return_Result := -1;
      end BLOCK;
      return Return_Result;
   end Get_Current_Page;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================


   procedure Build
   is
      use type Gtk.Window.Gtk_Window;

   begin

--      Is_App_Running  := True;
--      Debug_Log.Do_Log("Uif_Tc_Tm.Build_Top_Level B");

      if Toplevel_Win = Null then

-- Create the window of type TopLevel
         Gtk.Window.Gtk_New
            (Window       => Toplevel_Win,
             The_Type     => Gtk.Enums.Window_Toplevel);


         Toplevel_Startup;
         Toplevel_Activate;

      end if;

      Toplevel_Built := True;

--      Debug_Log.Do_Log ("Uif_Tc_Tm.Build_Top_Level E. Result:" &
--        Glib.Gint'Image (Result));

   end Build;

   procedure Destroy
   is
   begin

--      for Srv in Uif_Tc_Tm_Common.Services_T'Range loop
--         Ntbooks_Childrem (Srv).Destroy;
--         Frames_Childrem (Srv).Destroy;
--         Built_Childrem (Srv) := False;
--      end loop;
--      Srv_Ntbook.Destroy;

null;

   end Destroy;



   procedure Take_Focus
   is
   begin
-- TODO: how to put focus on this application?
      null;
--      The_App.Set_Flags(
   end Take_Focus;


   function Get_Tm_Displayed return Basic_Types_1553.Tc_Tm_Id_T
   is
--      use type Glib.Gint;

      N_Page_C             : constant Glib.Gint                   := Get_Current_Page;
      Srv_Page_C           : constant Uif_Tc_Tm_Common.Services_T :=
        Uif_Tc_Tm_Common.Num_To_Page (N_Page_C);

      Tc_Displayed         : Basic_Types_1553.Tc_Tm_Id_T        :=
        Basic_Types_1553.Tc_Tm_None;
      Tm_Displayed         : Basic_Types_1553.Tc_Tm_Id_T        :=
        Basic_Types_1553.Tc_Tm_None;

   begin

      if N_Page_C >= 0 then

--         Debug_Log.Do_Log ("[Uif_Tc_Tm_I.Get_Tm_Displayed] Srv: " &
--                Uif_Tc_Tm_Common.Services_T'Image (Srv_Page_C));

         case Srv_Page_C is
            when Uif_Tc_Tm_Common.Tm_1   =>
               Uif_Tc_Tm_1.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tm_1),
--                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_3   =>
               Uif_Tc_Tm_3.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_3),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_5   =>
               Uif_Tc_Tm_5.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_5),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_6   =>
               Uif_Tc_Tm_6.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_6),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_9   =>
               Uif_Tc_Tm_9.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_9),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_12  =>
               Uif_Tc_Tm_12.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_12),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_17  =>
               Uif_Tc_Tm_17.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_17),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_128 =>
               Uif_Tc_Tm_128.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_128),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_129 =>
               Uif_Tc_Tm_129.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_129),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
            when Uif_Tc_Tm_Common.Tc_130 =>
               Uif_Tc_Tm_130.Get_Message_Id_From_Index_Page
                 (Sub_Page_Index  => Subpage_Active_Childrem (Uif_Tc_Tm_Common.Tc_130),
                  Tc_Id           => Tc_Displayed,
                  Tm_Id           => Tm_Displayed);
         end case;
      end if;

      return Tm_Displayed;
   end Get_Tm_Displayed;


   procedure Update_Tm_Params
     (Tm_Id         : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_1553.Tc_Tm_Id_T;

   begin


--      Debug_Log.Do_Log (" TBC at Uif_Tc_Tm_I.Update_Tm_Params ");

      if Tm_Id = Basic_Types_1553.Tm_1_4 then
         Uif_Tc_Tm_1.Update_Tm_Params
           (Params     => Tm_Params,
            Params_Len => Tm_Params_Len);

      elsif Tm_Id = Basic_Types_1553.Tm_5_1 then
         Uif_Tc_Tm_5.Update_Tm_Params
           (Params     => Tm_Params,
            Params_Len => Tm_Params_Len);

      elsif Tm_Id = Basic_Types_1553.Tm_128_130 then
         Uif_Tc_Tm_128.Update_Tm_Params
           (Params     => Tm_Params,
            Params_Len => Tm_Params_Len);
      end if;
--      Debug_Log.Do_Log ("Uif_Tc_Tm.Update_Tm_Param to " &
--        Pus_Format_Types_I.Tm_Params_Id_T'Image (Tm_Param_Id) & String (
--        Tm_Param_Val (Tm_Param_Val'First .. Tm_Param_Len.Last_Used)));


   null;
   end Update_Tm_Params;


   function Is_Built return Boolean is
   begin
      return Toplevel_Built;
   end Is_Built;







end Uif_Tc_Tm_I;


