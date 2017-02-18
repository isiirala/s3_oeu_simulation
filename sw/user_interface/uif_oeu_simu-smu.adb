-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu.Smu
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Builder of SMU User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************
with Ada.Exceptions;
with Ada.Strings.Unbounded;
with System;

with Debug_Log;

with Gdk.Threads;

with Gtk;                --use Gtk;
with Gtk.Button;         --use Gtk.Button;

with Gtk.Dialog;
with Gtk.Label;

with Gtk.Enums;          --use Gtk.Enums;
with Gtk.Handlers;       --use Gtk.Handlers;
with Gtk.Widget;         --use Gtk.Widget;
with Gtk.Frame;          --use Gtk.Frame;
with Glib.Values;
with Gtk.Alignment;      --use Gtk.Alignment;
with Gtk.Scrolled_Window; --use Gtk.Scrolled_Window;
with Gtk.Text_View;   --use Gtk.Text_View;
with Gtk.Text_Tag_Table; --use Gtk.Text_Tag_Table;
with Gtk.Text_Tag;    --use Gtk.Text_Tag;
with Gtk.Text_Iter;   --use Gtk.Text_Iter;
with Gtk.Text_Buffer; --use Gtk.Text_Buffer;
with Pango.Font;      --use Pango.Font;

with Gtk.Enums;       --use Gtk.Enums;

with Pango.Font;      --use Pango.Font;
with Gtk.Label;     --use Gtk.Label;

with Gtk.Style;         --use Gtk.Style;
with Gtk.Image;         -- use Gtk.Image;
with Gtk.Hbutton_Box;   --  use Gtk.Hbutton_Box;
with Gtk.Container;
with Gtk.Stock;
with Gtk.Text_Mark;   --use Gtk.Text_Mark;
with Gtk.Window;
with Pango.Font;

with Gdk.Rgba;
with Glib;



with Basic_Types_1553;
with Basic_Types_I;
with Basic_Types_Gtk;

with Uif_Tc_Tm_I;

with Events_From_Simu;

--with lib_rsw_if;
with Uif_Configs;
with Uif_Oeu_Simu.Icm;
--with Icm;
with Oeu_Simu.Smu;
with Smu_Data;

with Wdgt_Log;
with Wdgt_Buttons;
with Wdgt_Colors;
with Wdgt_Common;
--with Oeu_Simu.Icm.Wrapper_To_Obsw;
with Wdgt_Image_Title;

with Wdgt_Images;



package body UIF_Oeu_Simu.Smu is


-- -----------------------------------------------------------------------------
-- Widgets
-- -----------------------------------------------------------------------------

   Buttons_Column     : Wdgt_Buttons.Frame_Buttons;

   Main_Pwr_B_Id           : constant              := 1;
   Main_Pwr_B_Label_On     : aliased  String       := "Switch On OEU";
   Main_Pwr_B_Label_Off    : aliased  String       := "Switch Off OEU";

   Send_Tc_B_Id            : constant              := 2;
   Send_Tc_B_Label         : aliased String        := " TC/TM";
   Send_Tc_B_Img           : Gtk.Image.Gtk_Image;

   Config_B_Id             : constant              := 3;
   Config_B_Label          : aliased String        := " Config";
   Config_B_Img            : Gtk.Image.Gtk_Image;

   Oeu_Rt_Nominal_C        : Basic_Types_1553.Rt_Id_T   := 2;
   Oeu_Rt_Redundant_C      : Basic_Types_1553.Rt_Id_T   := 18;

   Input_Sa_Of_Oeu_C       : Basic_Types_1553.Sa_Id_T   := 1;

   Title                   : Wdgt_Image_Title.Frame_Image_Title;

   Exe_Log                 : Wdgt_Log.Frame_Log;



-- -----------------------------------------------------------------------------
-- Private subprograms declaration
-- -----------------------------------------------------------------------------
   procedure Send_Tc_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Config_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Main_Pwr_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);

   Tag_Decoded_C  : constant Basic_Types_Gtk.Font_Config_Range_T := 1;
   Tag_Info_C     : constant Basic_Types_Gtk.Font_Config_Range_T := 2;
   Tag_Summary_C  : constant Basic_Types_Gtk.Font_Config_Range_T := 3;

   type Log_Tag_To_Font_Tag_T is array (Smu_Data.Log_Tag_T) of
     Basic_Types_Gtk.Font_Config_Range_Neutral_T;
   -- Array type to assign SMU log tags to font tags implemented in the text log

   Log_Tag_To_Font_Tag_C  : constant Log_Tag_To_Font_Tag_T   :=
     (Smu_Data.Tag_Raw     => (Value => Tag_Decoded_C, Neutral_Element => True),
      Smu_Data.Tag_Decoded => (Value => Tag_Decoded_C, Neutral_Element => False),
      Smu_Data.Tag_Info    => (Value => Tag_Info_C,    Neutral_Element => False),
      Smu_Data.Tag_Summary => (Value => Tag_Summary_C, Neutral_Element => False));
   -- Constant to assign SMU log tags to font tags implemented in the text log.
   -- The Raw text uses the neutral element, so it's written with default text config

   Border_Frame           : Gtk.Frame.Gtk_Frame;
   H_Box                  : Gtk.Box.Gtk_Box;
   V_Box                  : Gtk.Box.Gtk_Box;


--   Uif_Built                  : Boolean                          := False;

   Uif_Built_Receiver         : Events_From_Simu.Receiver_Id_T   :=
     Events_From_Simu.Null_Receiver_Id_C;
   -- Event from Simulation to know when UIF is built and can be updated
   Main_Pwr_Switch_Receiver   : Events_From_Simu.Receiver_Id_T   :=
     Events_From_Simu.Null_Receiver_Id_C;
   -- Event from Simulation to know when change the Main Pwr Switch, and update the UIF

-- ======================================================================================
-- %% Internal operations
-- ======================================================================================
   procedure Switch_On_Smu is
      Img                : Gtk.Image.Gtk_Image;
   begin

-- Update UIF: only the button, set label and img to command a disconection
      Buttons_Column.Widget_Config (Main_Pwr_B_Id).Button.Set_Label
        (Main_Pwr_B_Label_Off);


      Buttons_Column.Widget_Config (Main_Pwr_B_Id).Button.Set_Margin_Left (0);


--        Main_Pwr_B_Img_Off      := Gtk.Image.Gtk_Image_New_From_Icon_Name
--          (Icon_Name => Gtk.Stock.Stock_Disconnect,
--           Size      => Gtk.Enums.Icon_Size_Menu);
      Img      := Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Unconnect_Mini));

      Buttons_Column.Widget_Config (Main_Pwr_B_Id).Button.Set_Image (Img);
   end Switch_On_Smu;

   procedure Switch_Off_Smu is
      Img                : Gtk.Image.Gtk_Image;
   begin

-- Update UIF: only the button, set label and img to command a conection
      Buttons_Column.Widget_Config (Main_Pwr_B_Id).Button.Set_Label
        (Main_Pwr_B_Label_On);


      Buttons_Column.Widget_Config (Main_Pwr_B_Id).Button.Set_Margin_Left (0);


      Img      := Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Connect_Mini));
      Buttons_Column.Widget_Config (Main_Pwr_B_Id).Button.Set_Image (Img);
   end Switch_Off_Smu;


   procedure On_Event_From_Simulation
     (Event_Id    : in Events_From_Simu.Event_T;
      User_Data1  : in Basic_Types_I.Uint32_T;
      User_Data2  : in Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;
      use type Basic_Types_I.Ena_Dis_T;
      use type Events_From_Simu.Event_T;

   begin

      if Uif_Configs.Uif_Built then

         Debug_Log.Do_Log ("[UIF_OEU_Simu.SMU.On_Event_From_Simulation]Event: " & Event_Id'Image);


         if Event_Id = Events_From_Simu.Main_Pwr_Switch then
-- Main PWR Switch changed in the simulation

            if User_Data1 = 0 then
               Switch_Off_Smu;
            else
               Switch_On_Smu;
            end if;

         elsif Event_Id = Events_From_Simu.Uif_Built then
-- UIF is built, update it to the inital status of the simulation

--            Uif_Built := True;
-- Config the Main Pwr button in accordance with the simulation
            if Oeu_Simu.Smu.Get_Main_Switch = Basic_Types_I.Disabled then
               Switch_Off_Smu;
            else
               Switch_On_Smu;
            end if;

         end if;
      end if;
   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_OEU_Simu.SMU.On_Event_From_Simulation]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end On_Event_From_Simulation;



   procedure Build
   is
      use type Basic_Types_I.Ena_Dis_T;

      Log_Fonts    : Basic_Types_Gtk.Font_Configs_T :=
        (Tag_Decoded_C =>
          (Name     => Ada.Strings.Unbounded.Null_Unbounded_String,
           Color    => Ada.Strings.Unbounded.To_Unbounded_String ("#009000"),
           Bk_Color => Ada.Strings.Unbounded.To_Unbounded_String ("White")),
         Tag_Info_C =>
          (Name     => Ada.Strings.Unbounded.Null_Unbounded_String,
           Color    => Ada.Strings.Unbounded.To_Unbounded_String ("#0000FF"),
           Bk_Color => Ada.Strings.Unbounded.Null_Unbounded_String),
         Tag_Summary_C =>
          (Name     => Ada.Strings.Unbounded.To_Unbounded_String ("Arial Black 8"),
           Color    => Ada.Strings.Unbounded.To_Unbounded_String ("#0050C0"),
           Bk_Color => Ada.Strings.Unbounded.To_Unbounded_String ("#F5F5F5")),
         others => (Basic_Types_Gtk.Font_Config_Empty_C));
      -- Configuration of the font tags to be used in the text widget. Order of
      -- colors: {red, green, blue}

      Log_Config   : Wdgt_Log.User_Config_T  :=
        (Frame_Label         => Ada.Strings.Unbounded.Null_Unbounded_String,
         Frame_Shadow        => Gtk.Enums.Shadow_None,
         Frame_Border_Width  => 0,
         Default_Font        =>
           (Name     => Ada.Strings.Unbounded.To_Unbounded_String ("Arial 8"),
            Color    => Ada.Strings.Unbounded.To_Unbounded_String ("Black"),
            Bk_Color => Ada.Strings.Unbounded.Null_Unbounded_String),
         Editable            => False,
         Text_Wrap_Mode      => Gtk.Enums.Wrap_None);

      Main_Pwr_B_Img_On       : Gtk.Image.Gtk_Image;


   begin

-- Build used images
      Main_Pwr_B_Img_On       := Gtk.Image.Gtk_Image_New_From_Icon_Name
        (Icon_Name => Gtk.Stock.Stock_Connect,
         Size      => Gtk.Enums.Icon_Size_Menu);
--      Main_Pwr_B_Img_Off      := Gtk.Image.Gtk_Image_New_From_Icon_Name
--        (Icon_Name => Gtk.Stock.Stock_Disconnect,
--         Size      => Gtk.Enums.Icon_Size_Menu);
      Send_Tc_B_Img           := Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Pixbuf    => Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Megaphone_Mini));
      Config_B_Img            := Gtk.Image.Gtk_Image_New_From_Icon_Name
        (Icon_Name => Gtk.Stock.Stock_Page_Setup,
         Size      => Gtk.Enums.Icon_Size_Menu);

-- Frame and Box for SMU
      Gtk.Frame.Gtk_New (
        Frame  => Border_Frame);
--        Label =>"smuBorder");

      Gtk.Box.Gtk_New_HBox (
        Box         => H_Box,
        Homogeneous => False,
        Spacing     => 1);
      Gtk.Box.Gtk_New_VBox (
        Box         => V_Box,
        Homogeneous => False,
        Spacing     => 1);

      Gtk.Box.Pack_Start(
        Smu_H_Box,
        Border_Frame,
        Expand => True,
        Fill => True,
        Padding => 0);
      Gtk.Frame.Add (Border_Frame, H_Box);
      Gtk.Box.Pack_Start(H_Box, V_Box, Expand => False, Fill => False, Padding => 0);

      Wdgt_Image_Title.Gtk_New (
        Image_Title   => Title,
        Image         => Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Cartoon_Smu)),
        Title         => " SMU ", --& ASCII.LF & "controls",
        Title_Pos     => Gtk.Enums.Pos_Top,
        Title_Color   => Wdgt_Colors.Smu_1,
        Frame_Shadow  => Gtk.Enums.Shadow_None); -- Shadow_Etched_In);

      Title.Set_Tooltip_Text ("SMU: Satellite Management Unit. " & ASCII.LF &
        "It sends TCs to OEU and collects its TMs");


      Gtk.Box.Pack_Start(V_Box, Title, Expand => False, Fill => False, Padding => 0);

      Wdgt_Buttons.Gtk_New
        (Buttons      => Buttons_Column,
         Horizontal   => False,
         Config       =>
           (Main_Pwr_B_Id =>
            (Main_Pwr_B_Label_On'Access, Main_Pwr_B_Handler'Access, Main_Pwr_B_Img_On,
              Ada.Strings.Unbounded.To_Unbounded_String
                ("Control the OEU power supply")),
           Send_Tc_B_Id  =>
            (Send_Tc_B_Label'Access, Send_Tc_B_Handler'Access, Send_Tc_B_Img,
              Ada.Strings.Unbounded.To_Unbounded_String
                ("Send TCs to OEU, check TMs and build test scripts")),
           Config_B_Id   =>
            (Config_B_Label'Access, Config_B_Handler'Access, Config_B_Img,
              Ada.Strings.Unbounded.To_Unbounded_String ("")))
--        Frame_Label   => "Frame Buttons",
--        Frame_Shadow  => Gtk.Enums.Shadow_Etched_In
      );




-- TODO: Use Config button
      Buttons_Column.Widget_Config (Config_B_Id).Button.Set_Sensitive (False);

      Gtk.Box.Pack_Start
        (V_Box,
         Buttons_Column,
         Expand         => False,
         Fill           => False,
         Padding        => 0);


      Wdgt_Log.Gtk_New
        (Title            => "Bus 1553 traffic log:",
         Config           => Log_Config,
         Font_Tags_Config => Log_Fonts,
         Log              => Exe_Log);
      Exe_Log.Set_Tooltip_Text
        ("Log of the TCs and TMs traffic between the SMU and the OEU" &
         " through the Bus 1553");

      Gtk.Box.Pack_Start
        (H_Box,
         Exe_Log,    -- Scrolled,
         Expand => True,
         Fill => True,
         Padding => 0);

--      Uif_Built := True;

-- Create a receiver to receive the event when UIF is built
      Events_From_Simu.Create_Receiver
        (Event_Id     => Events_From_Simu.Uif_Built,
         User_Cb      => On_Event_From_Simulation'Access,
         Receiver_Id  => Uif_Built_Receiver);
-- Create a receiver to receive the Simulation event of Main Pwr Switch
      Events_From_Simu.Create_Receiver
        (Event_Id     => Events_From_Simu.Main_Pwr_Switch,
         User_Cb      => On_Event_From_Simulation'Access,
         Receiver_Id  => Main_Pwr_Switch_Receiver);


   end Build;

-- Destroy Toplevels and Applications that are not destroyed automatically
   procedure Destroy is
   begin

      if Uif_Tc_Tm_I.Is_Built then
         Uif_Tc_Tm_I.Destroy;
      end if;
   end Destroy;


   procedure Send_Tc_B_Handler
     (Button : access Gtk.Button.Gtk_Button_Record'Class)
   is
   begin

      if not Uif_Tc_Tm_I.Is_Built then

-- Build the TC_Builder application (top level) if it is not built
         Uif_Tc_Tm_I.Build;


      else
-- If the application is built, put the focus on it
         Uif_Tc_Tm_I.Take_Focus;
      end if;


   end Send_Tc_B_Handler;

   procedure Config_B_Handler
     (Button : access Gtk.Button.Gtk_Button_Record'Class)
   is

      Tc_128_129  : Basic_Types_I.Byte_Array_T  :=
        (16#1C#, 16#00#, 16#F7#, 16#72#, 16#00#, 16#09#, 16#19#, 16#80#, 16#81#,
         16#01#, 16#00#, 16#00#, 16#00#, 16#00#, 16#72#, 16#61#);


      Dialog   : Gtk.Dialog.Gtk_Dialog    := null;
      Label    : Gtk.Label.Gtk_Label      := null;

   begin

-- TODO: Tal vez la interfaz gráfica deba mandar sólo el serv,sub-ser y los parametros
--       Porque los parametros de las cabeceras los debe poner la simulación de la SMU,
--       a no ser que los pueda configurar el usuario, en ese caso se ponen en la if de
--       esta rutina

--         Oeu_Simu.Smu.Send_Tc_Block
--           (Rt_Id   => Oeu_Rt_Nominal_C,
--            Sa_Id   => Input_Sa_Of_Oeu_C,
--            Raw_Tc  => Tc_128_129);

--      Service     =>
--      Sub_Service =>
--      Data_Field  =>

-- --------------------------------------------------------------------------------------
-- Test Dialog (begin)

      Gtk.Dialog.Gtk_New(Dialog);
--      Destroy_Dialog_Handler.Connect
--           (Dialog, "destroy",
--            Destroy_Dialog_Handler.To_Marshaller (Destroy_Dialog'Access),
--            Dialog'Access);
      Gtk.Dialog.Set_Title (Dialog, "Active TM test");
      Gtk.Dialog.Set_Border_Width (Dialog, 0);
      Gtk.Dialog.Set_Size_Request (Dialog, 200, 110);

      Gtk.Label.Gtk_New (Label, "Active TM displayed: " &
         Basic_Types_1553.Tc_Tm_Id_T'Image (Uif_Tc_Tm_I.Get_Tm_Displayed));
      Gtk.Box.Pack_Start (Gtk.Dialog.Get_Action_Area (Dialog), Label, True, True, 0);
--         Grab_Default (Button);
      Label.Show;
      Dialog.Show;

-- Test Dialog (end)
-- --------------------------------------------------------------------------------------


      null;
--      Log.Write_A_Str(Exe_Log, "Config");
   end Config_B_Handler;

   procedure Main_Pwr_B_Handler
     (Button : access Gtk.Button.Gtk_Button_Record'Class)
   is
      use type Basic_Types_I.Ena_Dis_T;

   begin

      if Uif_Configs.Uif_Built then
         Events_From_Simu.Pause_Receiver (Main_Pwr_Switch_Receiver);

         if Oeu_Simu.Smu.Get_Main_Switch = Basic_Types_I.Enabled then

            Oeu_Simu.Smu.Set_Main_Switch (New_Status => Basic_Types_I.Disabled);

            if Oeu_Simu.Smu.Get_Main_Switch = Basic_Types_I.Disabled then
               Switch_Off_Smu;
            end if;

         else

            Oeu_Simu.Smu.Set_Main_Switch (New_Status => Basic_Types_I.Enabled);

            if Oeu_Simu.Smu.Get_Main_Switch = Basic_Types_I.Enabled then
               Switch_On_Smu;
            end if;

         end if;
         Events_From_Simu.Resume_Receiver (Main_Pwr_Switch_Receiver);
      end if;

   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_OEU_Simu.SMU.Main_Pwr_B_Handler]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end Main_Pwr_B_Handler;


   procedure Write_Str_In_Log (Log_Data   : in Smu_Data.Log_Data_T) is
      use type Basic_Types_I.Uint32_T;
   begin

      if Uif_Configs.Uif_Built and (Log_Data.Last_Index > 0) then
         Wdgt_Log.Write_Str
           (Log      => Exe_Log,
            Str      => Glib.Utf8_String (Log_Data.Str (1 .. Log_Data.Last_Index)),
            Font_Tag => Log_Tag_To_Font_Tag_C (Log_Data.Metadata.Tag));
      end if;
   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_OEU_Simu.SMU.Write_Str_In_Log]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end Write_Str_In_Log;




--     procedure Set_Main_Switch (New_Status : in Basic_Types_I.Ena_Dis_T)
--     is
--        use type Basic_Types_I.Ena_Dis_T;
--
--     begin
--
--        if (New_Status = Basic_Types_I.Enabled) and then
--          (Main_Pwr_Switch = Basic_Types_I.Disabled) then
--
--           Switch_On_Smu;
--           Uif_Oeu_Simu.Icm.Switch_On;
--           Main_Pwr_Switch := Basic_Types_I.Enabled;
--
--        elsif (New_Status = Basic_Types_I.Disabled) and then
--          (Main_Pwr_Switch = Basic_Types_I.Enabled) then
--
--           Switch_Off_Smu;
--           Uif_Oeu_Simu.Icm.Switch_Off;
--           Main_Pwr_Switch := Basic_Types_I.Disabled;
--
--        end if;
--     end Set_Main_Switch;
--
--
--     function Get_Main_Switch return Basic_Types_I.Ena_Dis_T
--     is
--     begin
--        return Main_Pwr_Switch;
--     end Get_Main_Switch;




end UIF_Oeu_Simu.Smu;

