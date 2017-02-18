-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu.Icm
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Builder of ICM User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************


with Ada.Strings.Unbounded;
with System;

with Gtk.Box;
with Gdk.RGBA;

--with Gdk.Threads;

with Gtk;                --use Gtk;
with Gtk.Adjustment;
--with Gtk.Alignment;
with Gtk.Button;         --use Gtk.Button;
with Gtk.Enums;          --use Gtk.Enums;
with Gtk.Handlers;       --use Gtk.Handlers;
with Gtk.Image;
with Gtk.Layout;
with Gtk.Widget;         --use Gtk.Widget;
with Gtk.Frame;          --use Gtk.Frame;
with Gtk.Scrolled_Window;
with Glib.Values;
with Gtk.Alignment;      --use Gtk.Alignment;

with Gtk.Overlay;

with Gtk.Enums;       --use Gtk.Enums;

with Pango.Font;      --use Pango.Font;
with Gtk.Label;     --use Gtk.Label;

with Gtk.Image;         -- use Gtk.Image;
with Gtk.Hbutton_Box;   --  use Gtk.Hbutton_Box;
with Gtk.Container;
with Gtk.Stock;
with Gtk.Style;         --use Gtk.Style;



--with Common;
with Basic_Types_Gtk;
--with Icm_Rsw_Dll_If; --lib_rsw_if;
with Wdgt_Buttons;
with Wdgt_Colors;
with Wdgt_Image_Title;
with Wdgt_Log;

with Wdgt_Images;

package body UIF_Oeu_Simu.Icm is


-- -----------------------------------------------------------------------------
-- Widgets
-- -----------------------------------------------------------------------------

   Buttons_Column     : Wdgt_Buttons.Frame_Buttons;

--   Send_Tc_B_Id            : constant            := 1;
--   Send_Tc_B_Label         : aliased String      := "Send TC";
   Config_B_Id             : constant            := 1;
   Config_B_Label          : aliased String      := "Config";
   Config_B_Img            : Gtk.Image.Gtk_Image;


--   Main_Pwr_B_Id           : constant            := 3;
--   Main_Pwr_B_Label_On     : aliased  String     := "Switch On OEU";
--   Main_Pwr_B_Label_Off    : aliased  String     := "Switch Off OEU";


   Title              : Wdgt_Image_Title.Frame_Image_Title;

   Exe_Log            : Wdgt_Log.Frame_Log;

   Back_Buttons_Color : Gdk.RGBA.Gdk_RGBA         := Gdk.RGBA.Null_RGBA;
   Uif_Built          : Boolean                   := False;

-- -----------------------------------------------------------------------------
-- Private subprograms declaration
-- -----------------------------------------------------------------------------
   procedure Send_Tc_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Config_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);
--   procedure Main_Pwr_B_Handler (
--     Button : access Gtk.Button.Gtk_Button_Record'Class);






   Border_Frame           : Gtk.Frame.Gtk_Frame;
   V_Box                  : Gtk.Box.Gtk_Box;
   V_Control_Box          : Gtk.Box.Gtk_Box;

-- Para poner una imagen de fondo:
--      window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
--      gtk_window_set_default_size(GTK_WINDOW(window), 290, 200);
--      gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
--
--      layout = gtk_layout_new(NULL, NULL);
--      gtk_container_add(GTK_CONTAINER (window), layout);
--      gtk_widget_show(layout);
--
--      image = gtk_image_new_from_file("/home/my_background_image.jpg");
--      gtk_layout_put(GTK_LAYOUT(layout), image, 0, 0);
--
--      button = gtk_button_new_with_label("Button");
--      gtk_layout_put(GTK_LAYOUT(layout), button, 150, 50);
--      gtk_widget_set_size_request(button, 80, 35);



   procedure Build  is

      Log_Config   : Wdgt_Log.User_Config_T  :=
        (Frame_Label         => Ada.Strings.Unbounded.Null_Unbounded_String,
         Frame_Shadow        => Gtk.Enums.Shadow_None,
         Frame_Border_Width  => 0,
         Default_Font        =>
           (Name     => Ada.Strings.Unbounded.To_Unbounded_String ("Arial Black 7"),
            Color    => Ada.Strings.Unbounded.To_Unbounded_String ("Black"),
            Bk_Color => Ada.Strings.Unbounded.Null_Unbounded_String),
         Editable            => False,
         Text_Wrap_Mode      => Gtk.Enums.Wrap_None);


--      Alig : Gtk.Alignment.Gtk_Alignment;
--Layout_Frame    : Gtk.Frame.Gtk_Frame;
--Layout          : Gtk.Layout.Gtk_Layout;
--Image           : Gtk.Image.Gtk_Image;
Color_Ok: Boolean := False;
--Width : Glib.Gint;
--Height : Glib.Gint;
   begin

-- Build used images
      Config_B_Img            := Gtk.Image.Gtk_Image_New_From_Icon_Name
        (Icon_Name => Gtk.Stock.Stock_Page_Setup,
         Size      => Gtk.Enums.Icon_Size_Menu);


-- Frame and Box
      Gtk.Frame.Gtk_New (
        Frame  => Border_Frame);
--        Label =>"Border");
      Gtk.Box.Pack_Start(
        In_Box  => Oeu_H_Box,
        Child   => Border_Frame,
        Expand  => True,
        Fill    => True,
        Padding => 0);

      Gtk.Box.Gtk_New_VBox (
        Box         => V_Box,
        Homogeneous => False,
        Spacing     => 0);
      Gtk.Frame.Add (Border_Frame, V_Box);

--      Gtk.Frame.Gtk_New (
--        Frame  => Layout_Frame);
--      Gtk.Box.Pack_Start(
--        In_Box  => V_Box,
--        Child   => Layout_Frame, --V_Control_Box,
--        Expand  => True,
--        Fill    => True,
--        Padding => 0);

--      Gtk.Layout.Gtk_New(
--        Layout => Layout);
--      Gtk.Frame.Add (Layout_Frame, Layout);

      Gtk.Box.Gtk_New_VBox (
        Box         => V_Control_Box,
        Homogeneous => False,
        Spacing     => 0);
      Gtk.Box.Pack_Start(
        In_Box  => V_Box,
        Child   => V_Control_Box,
        Expand  => False,
        Fill    => True,
        Padding => 0);

--      Gtk.Image.Gtk_New(
--        Image => Image,
--        Filename => "icons\Icm1.jpg");
--      Gtk.Layout.Put(
--        Layout       => Layout,
--        Child_Widget => Image,
--        X => 0,
--        Y => 0);

      Wdgt_Image_Title.Gtk_New (
        Image_Title   => Title,
        Image         => Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Cartoon_Icm)),
        Title         => " ICM ", -- & ASCII.LF & "controls",
        Title_Pos     => Gtk.Enums.Pos_Right,
        Title_Color   => Wdgt_Colors.Icm_1,
        Frame_Shadow  => Gtk.Enums.Shadow_None); --Shadow_Etched_In);

      Title.Set_Tooltip_Text ("ICM: OEU Instrument Control Module. " & ASCII.LF &
        "It recives the OEU TCs from SMU and send the OEU TMs");


      Gtk.Box.Pack_Start(
        In_Box  => V_Control_Box,
        Child   => Title,
        Expand  => False,
        Fill    => False,
        Padding => 0);



--Gdk.RGBA.Parse
--      (Self    => Back_Buttons_Color,
--       Spec    => "#265373",
--       Success => Color_Ok);
--       Back_Buttons_Color.Alpha := 0.7;

--         Title.Override_Background_Color
--           (State  => Gtk.Enums.Gtk_State_Flag_Normal,
--            Color  => Back_Buttons_Color);
--         Gtk.Box.Override_Background_Color(
--           Widget => V_Control_Box,
--           State  => Gtk.Enums.Gtk_State_Flag_Normal,
--           Color  => Back_Buttons_Color);


      Wdgt_Buttons.Gtk_New (
        Buttons      => Buttons_Column,
        Horizontal   => True,
        Config       => (

--          Send_Tc_B_Id  => (Send_Tc_B_Label'Access, Send_Tc_B_Handler'Access),
          Config_B_Id   =>
            (Config_B_Label'Access, Config_B_Handler'Access, Config_B_Img,
              Ada.Strings.Unbounded.To_Unbounded_String (""))),
--          Main_Pwr_B_Id => (Main_Pwr_B_Label_On'Access, Main_Pwr_B_Handler'Access)),

        Back_Buttons_Color => Back_Buttons_Color
--        Frame_Label   => "Frame Buttons",
--        Frame_Shadow  => Gtk.Enums.Shadow_Etched_In
        );
-- TODO: Use Config button
      Buttons_Column.Widget_Config (Config_B_Id).Button.Set_Sensitive (False);

      Gtk.Box.Pack_Start(
        In_Box  => Title.V2_Box,   -- V_Control_Box,
        Child   => Buttons_Column,
        Expand  => False,
        Fill    => False,
        Padding => 0);

--      Buttons_Column.


--      Gtk.Layout.Put(
--        Layout       => Layout,
--        Child_Widget => V_Control_Box,
--        X => 0,
--        Y => 0);

--      Gtk.Layout.Set_Size (Layout, 8000, 6000);

--Buttons.Get_Size_Request(
-- Widget => Buttons_Column,
--       Width  => Width,
--       Height => Height);



      Wdgt_Log.Gtk_New
        (Title            => "ICM SW execution log:",
         Config           => Log_Config, --Log.User_Config_Default_C,
         Font_Tags_Config => Basic_Types_Gtk.Font_Configs_Empty_C,
         Log              => Exe_Log);

      Exe_Log.Set_Tooltip_Text
        ("Execution log of the onboard ICM SW adapted to PC architecture");


      Gtk.Box.Pack_End(
        In_Box  => V_Box,
        Child   => Exe_Log,
        Expand  => True,
        Fill    => True,
        Padding => 0);

      Uif_Built := True;
   end Build;

   procedure Destroy is
   begin
      null;
   end Destroy;




--   procedure Write_Char_In_Log (C : in Character) is
--   begin
--      Log.Write_A_Character(Exe_Log, C);
--   end Write_Char_In_Log;

   procedure Write_Str_In_Log (Str : in String) is
   begin

      if Uif_Built then
         Exe_Log.Write_Str (Str);
      end if;
   end Write_Str_In_Log;


--     procedure Switch_On is
--     begin
--  --      lib_rsw_if.Switch_On;
--        Icm_Rsw_Dll_If.Switch_On;
--     end Switch_On;
--     procedure Switch_Off is
--     begin
--  --      lib_rsw_if.Switch_Off;
--        Icm_Rsw_Dll_If.Switch_Off;
--     end Switch_Off;



   procedure Send_Tc_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin

      if Uif_Built then
         Exe_Log.Write_Str ("Send TC");
      end if;
   end Send_Tc_B_Handler;

   procedure Config_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin

      if Uif_Built then
         Exe_Log.Write_Str ("Config");
      end if;
   end Config_B_Handler;

--     procedure Main_Pwr_B_Handler (
--       Button : access Gtk.Button.Gtk_Button_Record'Class) is
--     begin
--
--        if Gtk.Button.Get_Label(Button) = Main_Pwr_B_Label_On then
--           Gtk.Button.Set_Label(Button, Main_Pwr_B_Label_Off);
--           Exe_Log.Write_Str ("Pwr Off");
--
--        else
--           Gtk.Button.Set_Label(Button, Main_Pwr_B_Label_On);
--           Exe_Log.Write_Str ("Pwr On");
--        end if;
--     end Main_Pwr_B_Handler;




end UIF_Oeu_Simu.Icm;

