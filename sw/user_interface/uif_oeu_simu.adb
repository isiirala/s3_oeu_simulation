-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Root builder of User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Ada.Exceptions;
with System;

with GNAT.Strings;
with GNAT.OS_Lib;

with Glib.Error;
with Glib.Values;
with Glib.Object;

with Gdk.Event;
with Gdk.Main;

with Gtk.About_Dialog;
with Gtk.Accel_Group;
with Gtk.Alignment;
with Gtk.Box;
with Gtk.Builder;
with Gtk.Button;
with Gtk.Check_Button;
with Gtk.Enums;
with Gtk.Frame;
with Gtk.Dialog;
with Gtk.Handlers;
with Gtk.Hbutton_Box;
with Gtk.Image;
with Gtk.Image_Menu_Item;
with Gtk.Label;
with Gtk.Main;
with Gtk.Menu;
with Gtk.Notebook;
with Gtk.Widget;
with Gdk.Pixbuf;
with Gtk.Style;
with Gtk.Toggle_Button;
with Gtk.Window;

with Gtk.Enums;
with Gtk.Menu_Bar;
with Gtk.Menu_Item;
with Gtk.Check_Menu_Item;
with Gtk.Separator_Menu_Item;
with Gtk.Stock;

with Pango.Font;

with Gtk.Container;

with Debug_Log;
with Events_From_Simu;
with Oeu_Simu.Smu;
with Oeu_Simu_Types;
with Uif_Configs;
with Wdgt_Common;
with Wdgt_Images;
with Wdgt_Os_Lib;
with Wdgt_Ui_Def;

with Uif_Oeu_Simu.Smu;

-- a borrar:
--with Interfaces.C.Strings;

package body UIF_Oeu_Simu is

--   package Mdi_Root is new Mdi_N.Mdi_N_Conf (
--     Num_Box      => 3,
--     Childs_Group => 2);
--   package Mdi_Oeu is new Mdi_N.Mdi_N_Conf (
--     Num_Box      => 3,
--     Childs_Group => 3);

--   package Paned_Oeu is new Paned_N.Paned_N_Conf (
--     Num_box => 2);



   package Wdt_Handler is new Gtk.Handlers.Callback (Gtk.Widget.Gtk_Widget_Record);


-------------------------------------------------------------------------------
-- Widget of the main window
--   Main_Win             : aliased Gtk.Window.Gtk_Window   := null;
   Main_Win             : Gtk.Application_Window.Gtk_Application_Window  := null;

-- Window of the dialog of the configuration of the log files
   Config_Logs_Dialog   : Gtk.Window.Gtk_Window;

   Pcdm_Frame           : Gtk.Frame.Gtk_Frame;
   Pcdm_VBox             : Gtk.Box.Gtk_Box;
   Pcdm_Config_B        : Gtk.Button.Gtk_Button;

   Dpm_Frame            : Gtk.Frame.Gtk_Frame;
   Dpm_VBox              : Gtk.Box.Gtk_Box;
   Dpm_Config_B         : Gtk.Button.Gtk_Button;


   Local_Destroy_Cb     : Basic_Types_I.Callback_T            := null;
   -- Callback to close the rest of UIF when user close the main window

--   Uif_Built                 : Boolean                        := False;

   Main_Pwr_Switch_Receiver  : Events_From_Simu.Receiver_Id_T :=
     Events_From_Simu.Null_Receiver_Id_C;
   -- Event from Simulation to know when change the Main Pwr Switch, and update the UIF
   Uif_Built_Receiver        : Events_From_Simu.Receiver_Id_T :=
     Events_From_Simu.Null_Receiver_Id_C;
   -- Event from Simulation to know when UIF is built

-------------------------------------------------------------------------------

-- Destroy_Main_Win_CB is a callback to destroy the main window and terminate
-- the program execution when the [X] button at top right of the window is clicked.
-- Or when Exit option in menu is selected
   procedure On_Destroy_Main_Win
     (Object : access Gtk.Widget.Gtk_Widget_Record'Class) is
   begin

-- Execute the callback to destroy the rest of the UIF. Toplevels created
      if not Basic_Types_I.Is_Null_Callback (Local_Destroy_Cb) then
         Local_Destroy_Cb.all;
      end if;

-- Close the main window of the program
      Main_Win.Close;

-- Terminate program (close the black OS window)
      GNAT.OS_Lib.OS_Exit (0);
--      Gtk.Main.Main_Quit;
   end On_Destroy_Main_Win;

-- Callback of the Checks Menu Items that activate/deactivate the data dump to the file
   procedure On_Menu_File_Log_Toggle
     (Self : access Gtk.Check_Menu_Item.Gtk_Check_Menu_Item_Record'Class)
   is
      New_Value      : Boolean                := Self.Get_Active;
      Log            : Oeu_Simu_Types.Log_T   := Oeu_Simu_Types.Log_T'First;
      Wdgt_Name      : Glib.UTF8_String       := Self.Get_Name;
      Unknow_Check   : Boolean                := False;
   begin

      if Uif_Configs.Uif_Built then

         if Wdgt_Name = "App" then
            Log := Oeu_Simu_Types.Log_App_Exe;
         elsif Wdgt_Name = "1553" then
            Log := Oeu_Simu_Types.Log_Smu_1553;
         elsif Wdgt_Name = "Icm" then
            Log := Oeu_Simu_Types.Log_Icm_Exe;
         elsif Wdgt_Name = "Dpm" then
            Log := Oeu_Simu_Types.Log_Dpm_Exe;
         elsif Wdgt_Name = "Pcdm" then
            Log := Oeu_Simu_Types.Log_Pcdm_Exe;
         else
            Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Menu_File_Log_Toggle]Warning " &
                                "Check_Menu_Item bad configured");
            Unknow_Check := True;
         end if;

         if not Unknow_Check then
            Uif_Configs.Active_Dump_Logs (Log) := New_Value;
         end if;
      end if;
   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Menu_File_Log_Toggle]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end On_Menu_File_Log_Toggle;


-- --------------------------------------------------------------------------------------
-- Menu/File/Config Log Files dialog (begin)

   Smu_1553_Decode_Tcs_Chkb      : Gtk.Check_Button.Gtk_Check_Button;
   Smu_1553_Decode_Tcs_Full_Chkb : Gtk.Check_Button.Gtk_Check_Button;
   Smu_1553_Decode_Tms_Chkb      : Gtk.Check_Button.Gtk_Check_Button;
   Smu_1553_Decode_Tms_Full_Chkb : Gtk.Check_Button.Gtk_Check_Button;
   Icm_Exe_Wrap_Line_End_Chkb    : Gtk.Check_Button.Gtk_Check_Button;

-- Callback of the Config Logs toplevel when button Accept is pressed
-- Read user configs and destroy the top-level
   function Config_Logs_Accept
     (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Button)
   return Boolean
   is
   begin

-- Get configuration selected by user and store in the SW config variables
      Uif_Configs.Smu_1553_Decode_Tcs      := Smu_1553_Decode_Tcs_Chkb.Get_Active;
      Uif_Configs.Smu_1553_Decode_Tcs_Full := Smu_1553_Decode_Tcs_Full_Chkb.Get_Active;
      Uif_Configs.Smu_1553_Decode_Tms      := Smu_1553_Decode_Tms_Chkb.Get_Active;
      Uif_Configs.Smu_1553_Decode_Tms_Full := Smu_1553_Decode_Tms_Full_Chkb.Get_Active;
      Uif_Configs.Icm_Exe_Wrap_Line_End    := Icm_Exe_Wrap_Line_End_Chkb.Get_Active;

      Config_Logs_Dialog.Destroy;
      return True;
   end Config_Logs_Accept;

-- Callback of the Config Logs top-level when button Cancel button is pressed.
-- Only destroy the topLevel
   function Config_Logs_Cancel
     (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Button)
   return Boolean
   is
   begin

      Config_Logs_Dialog.Destroy;
      return True;
   end Config_Logs_Cancel;


-- Callback of the menu option: Menu/File/Config Log Files
   procedure On_Menu_Config_Logs (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is
      Builder        : Gtk.Builder.Gtk_Builder              :=
        Wdgt_Ui_Def.Get_Builder (Wdgt_Ui_Def.Logs_Config);
      One_Button     : Gtk.Button.Gtk_Button;
   begin

      if Uif_Configs.Uif_Built then
         Config_Logs_Dialog := Gtk.Window.Gtk_Window (Builder.Get_Object ("window1"));

-- TODO: poner un icono al top-level relacionada con la configuracion
-- (una OEU con un destornillador)

-- --------------------------------------------------------------------------------------
-- Connect the widgets of the dialog

-- Decodification options of the logs (SMU_1553 and ICM SW exe)
-- Set the value in dialog (Checked or Uncked) in accordance with the SW variables

         Smu_1553_Decode_Tcs_Chkb := Gtk.Check_Button.Gtk_Check_Button
           (Builder.Get_Object ("Chb1553_DecodeTc"));
         Smu_1553_Decode_Tcs_Chkb.Set_Active (Uif_Configs.Smu_1553_Decode_Tcs);

         Smu_1553_Decode_Tcs_Full_Chkb := Gtk.Check_Button.Gtk_Check_Button
           (Builder.Get_Object ("Chb1553_DecodeTcComplete"));
         Smu_1553_Decode_Tcs_Full_Chkb.Set_Active (Uif_Configs.Smu_1553_Decode_Tcs_Full);

         Smu_1553_Decode_Tms_Chkb := Gtk.Check_Button.Gtk_Check_Button
           (Builder.Get_Object ("Chb1553_DecodeTm"));
         Smu_1553_Decode_Tms_Chkb.Set_Active (Uif_Configs.Smu_1553_Decode_Tms);

         Smu_1553_Decode_Tms_Full_Chkb := Gtk.Check_Button.Gtk_Check_Button
           (Builder.Get_Object ("Chb1553_DecodeTmComplete"));
         Smu_1553_Decode_Tms_Full_Chkb.Set_Active (Uif_Configs.Smu_1553_Decode_Tms_Full);

         Icm_Exe_Wrap_Line_End_Chkb := Gtk.Check_Button.Gtk_Check_Button
           (Builder.Get_Object ("ChbIcm_RespectLineEnds"));
         Icm_Exe_Wrap_Line_End_Chkb.Set_Active (Uif_Configs.Icm_Exe_Wrap_Line_End);

-- Connect the buttons of the dialog
         One_Button := Gtk.Button.Gtk_Button (Builder.Get_Object ("btAccept"));
         One_Button.On_Button_Release_Event (Config_Logs_Accept'Access);

         One_Button := Gtk.Button.Gtk_Button (Builder.Get_Object ("btCancel"));
         One_Button.On_Button_Release_Event (Config_Logs_Cancel'Access);

         Config_Logs_Dialog.Show_All;

-- Free the builder
         Builder.Unref;
      end if;
   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Menu_Config_Logs]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end On_Menu_Config_Logs;

-- Menu/File/Config Log Files dialog (end)
-- --------------------------------------------------------------------------------------

   Switch_Oeu_Menu_Item      : Gtk.Image_Menu_Item.Gtk_Image_Menu_Item;


   procedure Switch_Off_Smu
   is
      On_Label_C         : constant Glib.UTF8_String  := "Switch On OEU Simulation";

      Img                : Gtk.Image.Gtk_Image;
   begin

      Switch_Oeu_Menu_Item.Set_Label (On_Label_C);

      Img      := Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Connect_Mini));
      Switch_Oeu_Menu_Item.Set_Image (Img);
   end Switch_Off_Smu;

   procedure Switch_On_Smu
   is
      Off_Label_C        : constant Glib.UTF8_String  := "Switch Off OEU Simulation";

      Img                : Gtk.Image.Gtk_Image;
   begin

      Switch_Oeu_Menu_Item.Set_Label (Off_Label_C);

      Img      := Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Unconnect_Mini));

-- TODO: no se pueden tener las dos y usar una o otra en vez de crearlas???
      Switch_Oeu_Menu_Item.Set_Image (Img);
   end Switch_On_Smu;

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

--         Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Event_From_Simulation]Event: " & Event_Id'Image);

         if Event_Id = Events_From_Simu.Main_Pwr_Switch then
-- Main PWR Switch changed in the simulation

            if User_Data1 = 0 then
               Switch_Off_Smu;
            else
               Switch_On_Smu;
            end if;

         elsif Event_Id = Events_From_Simu.Uif_Built then
-- UIF is built, update it to the inital status of the simulation

-- Set the menu item of Main Switch in accordance with the simulation
            if Oeu_Simu.Smu.Get_Main_Switch = Basic_Types_I.Disabled then
               Switch_Off_Smu;
            else
               Switch_On_Smu;
            end if;
         end if;
      end if;
   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Event_From_Simulation]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end On_Event_From_Simulation;


-- Callback of the menu option: Menu/Simulation/Switch ON / OFF OEU
   procedure On_Simu_Oeu_Switch
     (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is
      pragma Warnings (Off, Self);
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
         Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Simu_Oeu_Switch]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end On_Simu_Oeu_Switch;

-- Callback of the menu option: Menu/Simulation/Pause / Resume OEU
   procedure On_Simu_Oeu_Pause
     (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is

   begin

      if Uif_Configs.Uif_Built then
-- TODO
         null;
      end if;
   end On_Simu_Oeu_Pause;


-- Callback of the menu option: Menu/Help/Links
   procedure On_Help_Link_Activate
     (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class)
   is

      Wdgt_Name         : Glib.UTF8_String           := Self.Get_Name;
      Link_Result       : Boolean                    := False;
   begin

      if Uif_Configs.Uif_Built then
         if Wdgt_Name = "AdaCore" then
            Link_Result := Wdgt_Os_Lib.Open_Link ("http://libre.adacore.com");
         elsif Wdgt_Name = "Gtk3" then
            Link_Result := Wdgt_Os_Lib.Open_Link
              ("https://developer.gnome.org/gtk3/stable/");
         elsif Wdgt_Name = "AdaBinding" then
            Link_Result := Wdgt_Os_Lib.Open_Link
              ("http://libre.adacore.com//tools/gtkada/");
         elsif Wdgt_Name = "Gmv" then
            Link_Result := Wdgt_Os_Lib.Open_Link ("http://www.gmv.com");
         else
            Debug_Log.Do_Log ("[UIF_OEU_Simu.On_Help_Link_Activate]Warning " &
                                "Check_Menu_Item bad configured: " & Wdgt_Name);
         end if;
      end if;
   end On_Help_Link_Activate;


-------------------------------------------------------------------------------
-- About dialog (begin)

   About_Dialog : aliased Gtk.About_Dialog.Gtk_About_Dialog := null;

   procedure On_About_Destroy
     (Self        : access Gtk.Widget.Gtk_Widget_Record'Class) is
      pragma Warnings (Off, Self);

      use type Gtk.About_Dialog.Gtk_About_Dialog;

   begin

      if About_Dialog /= null then
         declare
            Authors    : GNAT.Strings.String_List := About_Dialog.Get_Authors;
         begin
            for I in Authors'Range loop
               GNAT.Strings.Free (Authors (I));
            end loop;
            About_Dialog.Destroy;
            About_Dialog := null;
         end;
      end if;
   end On_About_Destroy;

   procedure On_About_Response
     (Self        : access Gtk.Dialog.Gtk_Dialog_Record'Class;
      Response_Id : Gtk.Dialog.Gtk_Response_Type)
   is
      use type Gtk.Dialog.Gtk_Response_Type;

      Dialog_Response : Gtk.Dialog.Gtk_Response_Type :=
        Gtk.Dialog.Gtk_Response_Type (Response_Id);
   begin

--      Debug_Log.Do_Log ("[AboutDialog]Response: " &
--        Gtk.Dialog.Gtk_Response_Type'Image (Dialog_Response));
      if Dialog_Response = Gtk.Dialog.Gtk_Response_Delete_Event then
         On_About_Destroy (Self);
      end if;
   end On_About_Response;


   function On_About_Activate_Link
      (About : access Gtk.About_Dialog.Gtk_About_Dialog_Record'Class;
       URI   : String) return Boolean
   is
      pragma Unreferenced (About);

   begin

      return Wdgt_Os_Lib.Open_Link (URI);
   end On_About_Activate_Link;


   procedure On_Menu_Item_Activate_About (
      Object : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class) is

      use type Gtk.About_Dialog.Gtk_About_Dialog;

   begin

      if Uif_Configs.Uif_Built and (About_Dialog = null) then
         Gtk.About_Dialog.Gtk_New (About_Dialog);

         About_Dialog.Set_Name
           (Name   => Uif_Configs.Prog_Title_C & Uif_Configs.Prog_Version_C);
         About_Dialog.Set_Comments
           (Comments => "Simulation of OEU from Sentinel 3 OLCI component");
         About_Dialog.Set_Copyright
           (Copyright => "Copyright (c) GMV");
         About_Dialog.Set_Logo
           (Logo  => Wdgt_Images.Get_Image_Xpm (Wdgt_Images.About_Dialog));
         About_Dialog.Set_Transient_For (Parent => Main_Win);
         About_Dialog.Set_Destroy_With_Parent (True);
         About_Dialog.Set_Modal (False);

         About_Dialog.On_Activate_Link (On_About_Activate_Link'Access);
         About_Dialog.On_Response (On_About_Response'Access);
         About_Dialog.On_Destroy (On_About_Destroy'Access);

         About_Dialog.Set_Authors
           (Authors => (1 => new String'("Isidro Irala <iirala@gmv.com>")));
         About_Dialog.Set_License
           (License =>
             "This is a demo program; you can redistribute it but not modify it." &
             ASCII.LF &
             "This program is distributed in the hope to demonstrate that it is " &
             "possible the implementation of an engineering simulation of the " &
             "Sentinel 3 OEU. This demo program is distributed WITHOUT ANY WARRANTY");
         About_Dialog.Set_License_Type
           (License_Type => Gtk.About_Dialog.License_Custom);
         About_Dialog.Set_Wrap_License (True);
         About_Dialog.Set_Program_Name (Name => Uif_Configs.Prog_Title_C);
         About_Dialog.Set_Version (Version => Uif_Configs.Prog_Version_C);
         About_Dialog.Set_Website (Website => "http://www.gmv.com");
         About_Dialog.Set_Website_Label (Website_Label => "GMV");

         About_Dialog.Set_Keep_Above(Setting => False);
         About_Dialog.Present;
      else
         null;
--         About_Dialog.Set_Keep_Above(Setting => True);
      end if;
   end On_Menu_Item_Activate_About;

-- About dialog (end)
-------------------------------------------------------------------------------


   procedure Do_Main_Menu
   is
      use type Basic_Types_I.Ena_Dis_T;

      Menu_H_Box     : Gtk.Box.Gtk_Box;
      Menu_V_Box     : Gtk.Box.Gtk_Box;
      Builder        : Gtk.Builder.Gtk_Builder              :=
        Wdgt_Ui_Def.Get_Builder (Wdgt_Ui_Def.Main_Menu);
      Gmv_Image      : Gtk.Image.Gtk_Image                  :=
        Gtk.Image.Gtk_Image_New_From_Pixbuf
        (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Gmv_Mini));
      Menu_Item      : Gtk.Image_Menu_Item.Gtk_Image_Menu_Item;
      Chk_Menu_Item  : Gtk.Check_Menu_Item.Gtk_Check_Menu_Item;
   begin

      Gtk.Box.Gtk_New_HBox
        (Box         => Menu_H_Box,
         Homogeneous => False,
         Spacing     => 0);
      Base_V_Box.Pack_Start
        (Child   => Menu_H_Box,
         Expand  => False,
         Fill    => True,
         Padding => 0);

      Gtk.Box.Gtk_New_HBox
        (Box         => Menu_V_Box,
         Homogeneous => False,
         Spacing     => 0);
      Menu_H_Box.Pack_End
        (Child   => Menu_V_Box,
         Expand  => True,
         Fill    => True,
         Padding => 0);

-- Get the Menu Bar from the builder
      Menu_V_Box.Pack_Start
        (Child   => Gtk.Menu_Bar.Gtk_Menu_Bar (Builder.Get_Object ("MainMenuBar")),
         Expand  => True,
         Fill    => True,
         Padding => 0);

-- Pack GMV image at the right end of the box, after the menu
      Menu_V_Box.Pack_Start
        (Child   => Gmv_Image,
         Expand  => False,
         Fill    => True,
         Padding => 0);

-- --------------------------------------------------------
-- Connect the Menu Items with the correct Callback

-- Connect the Exit MenuItem
      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("MainQuit"));
      Wdgt_Common.Widget_Callback_Pkg.Connect
        (Widget      => Menu_Item,
         Name        => "activate",
         Cb          => On_Destroy_Main_Win'Access);

-- Connect the Check MenuItems to dump or not the logs to files
      Chk_Menu_Item := Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
        (Builder.Get_Object ("chkFileAppExeLog"));
      Chk_Menu_Item.On_Toggled(On_Menu_File_Log_Toggle'Access);

      Chk_Menu_Item := Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
        (Builder.Get_Object ("chkFileDump1553"));
      Chk_Menu_Item.On_Toggled(On_Menu_File_Log_Toggle'Access);

      Chk_Menu_Item := Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
        (Builder.Get_Object ("chkFileDumpIcm"));
      Chk_Menu_Item.On_Toggled(On_Menu_File_Log_Toggle'Access);

      Chk_Menu_Item := Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
        (Builder.Get_Object ("chkFileDumpDpm"));
      Chk_Menu_Item.On_Toggled(On_Menu_File_Log_Toggle'Access);

      Chk_Menu_Item := Gtk.Check_Menu_Item.Gtk_Check_Menu_Item
        (Builder.Get_Object ("chkFileDumpPcdm"));
      Chk_Menu_Item.On_Toggled(On_Menu_File_Log_Toggle'Access);

-- Connect the menu iten of the Execution Logs dialog
      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("ConfigExeLogs"));
      Menu_Item.On_Activate (On_Menu_Config_Logs'Access);

-- Connect the menu itens about Simulation
-- Connect the menu item Menu/Simulation/Switch On/Off OEU
      Switch_Oeu_Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("SwitchOnOEU"));
      Switch_Oeu_Menu_Item.On_Activate (On_Simu_Oeu_Switch'Access);

-- Connect the menu item Simulation/Pause OEU. TODO: IMPLEMENT PAUSE FUNCTIONALITY
      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("PauseOEU"));
      Menu_Item.Set_Sensitive (False);
      Menu_Item.On_Activate (On_Simu_Oeu_Pause'Access);


-- Connect the menu items of the Help:
-- Connect the menu item Help/User Manual. TODO: CREATE UM
      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("UserManual"));
      Menu_Item.Set_Sensitive (False);

-- Connect the menu item Help/Links
      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("HelpLinkAdaCore"));
      Menu_Item.On_Activate (On_Help_Link_Activate'Access);

      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("HelpLinkGtk3"));
      Menu_Item.On_Activate (On_Help_Link_Activate'Access);

      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("HelpLinkGtkAdaBinding"));
      Menu_Item.On_Activate (On_Help_Link_Activate'Access);

      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("HelpLinkGmv"));
      Menu_Item.On_Activate (On_Help_Link_Activate'Access);

-- Connect the menu iten of the Help/About dialog
      Menu_Item := Gtk.Image_Menu_Item.Gtk_Image_Menu_Item
        (Builder.Get_Object ("HelpAbout"));
      Menu_Item.On_Activate (On_Menu_Item_Activate_About'Access);


-- Free the builder
      Builder.Unref;

   end Do_Main_Menu;








-- Quit_Tab is an available selection on the 'File' dropdown menu. This
-- procedure takes the appropriate action when 'Quit' is clicked.
   procedure On_Quit_Tab_Activate (
     Object : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class) is
   begin

      Gtk.Main.Main_Quit;
   end On_Quit_Tab_Activate;


--     procedure Do_Oeu (Base_Box : in Gtk.Box.Gtk_Box) is
--  --      Group  : Gtk.Accel_Group.Gtk_Accel_Group;
--        The_Base_Box : Gtk.Box.Gtk_Box := Base_Box;
--
--     begin
--
--  -- Frame and Box for OEU(PCDM, DPM & ICM)
--        Gtk.Frame.Gtk_New (
--          Frame  => Oeu_Frame);
--
--        Gtk.Box.Gtk_New_HBox (
--          Box         => Oeu_Box,
--          Homogeneous => False,
--          Spacing     => 0);
--
--        Gtk.Box.Add (Base_VBox, Oeu_Frame);
--        Oeu_Frame.Add (Oeu_Box);
--
--  --       Mdi_Oeu.Gtk_New (
--  --         Mdi_N_New   => The_Mdi_Oeu,
--  --         Base_Box    => The_Base_Box, --Base_VBox,
--  --         Orientation => Gtk.Enums.Orientation_Horizontal,
--  --         Independent => True); --False);
--
--
--  null;
--
--     end Do_Oeu;


   procedure Do_Pcdm is
--      Style    : Gtk.Style.Gtk_Style;
--      Bbox     : Gtk.Hbutton_Box.Gtk_Hbutton_Box;
--      Label    : Gtk.Label.Gtk_Label;
--      Image    : Gtk.Image.Gtk_Image;
--      Title    : Image_Title.Gtk_Image_Title;

   begin

-- Frame and Box for PCDM
      Gtk.Frame.Gtk_New (
        Frame  => Pcdm_Frame);
--        Label  => "PCDM simulation");

--      Gtk.Alignment.Gtk_New (
--        Alignment => Tmp_Align,
--        Xalign	   => 0.0,
--        Yalign	   => 0.0,
--        Xscale	   => 0.0,
--        Yscale    => 0.0);
--      Gtk.Alignment.Set_Padding (
--        Alignment      => Tmp_Align,
--        Padding_Top	  => 10,
--        Padding_Bottom => 5,
--        Padding_Left	  => 10,
--        Padding_Right  => 10);
--      Add (Tmp_Align, Pcdm_Frame);

      Gtk.Box.Gtk_New_VBox (
        Box         => Pcdm_VBox,
        Homogeneous => False,
        Spacing     => 0);

--      Gtk.Box.Pack_Start (
--        In_Box => Oeu_Box,
--        Child  => Tmp_Align,
--        Expand => True,
--        Fill   => True,
--        Padding => 0);

--      Add (Oeu_Box, Pcdm_Frame);
--      Add (Paned_Oeu.Get_Child_Box(The_Paned_Oeu, 1), Pcdm_Frame);
      Pcdm_Frame.Add(Pcdm_VBox);

--      Style := Copy (Common.Win_Style);
--      Gtk.Style.Set_Font_Description (Style, Pango.Font.From_String ("Helvetica Bold 10"));

--      Gtk.Label.Gtk_New (Label, "PCDM");
--      Set_Style (Label, Style);
--      Pack_Start (Pcdm_VBox, Label, Expand => False, Fill => False, Padding => 10);

--      Gtk.Image.Gtk_New (Image, "icons\pcdm_hw.gif");
--      Pack_Start (Pcdm_VBox, Image, Expand => False, Padding => 5);

--function Get
--(	Image	: access Gtk_Image_Record) return Gdk.Pixbuf.Gdk_Pixbuf;

--      Image_Title.Gtk_New (
--       Image_Title   => Title,
----       Base_Box    => Pcdm_VBox,
--       File_Image    => "icons\pcdm_hw.gif",
--       Title         => "PCDM");

--      Gtk_New (Bbox);
--      Set_Layout (Bbox, Buttonbox_Start); --Buttonbox_Spread);
--      Set_Spacing (Bbox, 2);

      Gtk.Button.Gtk_New (Pcdm_Config_B, "Configuration");
--      Button_Range_Cb.Connect (
--        Widget => Close_Button,
--        Name   => "clicked",
--        Marsh  => Button_Range_Cb.To_Marshaller (
--          Close_Cl_Window'Access),
--        User_Data => I);
--      Pack_Start (Bbox, Pcdm_Config_B, Expand => True, Fill => False);

--      Pack_Start (Pcdm_VBox, Bbox, Expand => False, Padding => 5);

   end Do_Pcdm;


   procedure Do_Dpm is
--      Tmp_Align            : Gtk.Alignment.Gtk_Alignment;
--      Style    : Gtk.Style.Gtk_Style;
--      Bbox     : Gtk.Hbutton_Box.Gtk_Hbutton_Box;
--      Label    : Gtk.Label.Gtk_Label;
--      Image    : Gtk.Image.Gtk_Image;

--      Title : Image_Title.Gtk_Image_Title;

   begin

-- Frame and Box for DPM
      Gtk.Frame.Gtk_New (
        Frame  => Dpm_Frame);
--        Label  => "PCDM simulation");

--      Gtk.Alignment.Gtk_New (
--        Alignment => Tmp_Align,
--        Xalign	   => 0.0,
--        Yalign	   => 0.0,
--        Xscale	   => 0.0,
--        Yscale    => 0.0);
--      Gtk.Alignment.Set_Padding (
--        Alignment      => Tmp_Align,
--        Padding_Top	  => 10,
--        Padding_Bottom => 5,
--        Padding_Left	  => 10,
--        Padding_Right  => 10);
--      Add (Tmp_Align, Pcdm_Frame);

      Gtk.Box.Gtk_New_VBox (
        Box         => Dpm_VBox,
        Homogeneous => False,
        Spacing     => 0);

--      Gtk.Box.Pack_Start (
--        In_Box => Oeu_Box,
--        Child  => Tmp_Align,
--        Expand => True,
--        Fill   => True,
--        Padding => 0);

--      Add (Oeu_Box, Dpm_Frame);
--      Add (Paned_Oeu.Get_Child_Box(The_Paned_Oeu, 2), Dpm_Frame);
--      Add (Dpm_Frame, Dpm_VBox);


--      Image_Title.Gtk_New (
--       Image_Title   => Title,
----       Base_Box      => Dpm_VBox,
--       File_Image    => "icons\dpm_hw.gif",
--       Title         => "DPM");


--      Style := Copy (Common.Win_Style);
--      Gtk.Style.Set_Font_Description (Style, Pango.Font.From_String ("Helvetica Bold 10"));
--
--      Gtk.Label.Gtk_New (Label, "DPM");
--      Set_Style (Label, Style);
--      Pack_Start (Dpm_VBox, Label, Expand => False, Fill => False, Padding => 10);
--
--      Gtk.Image.Gtk_New (Image, "icons\dpm_hw.gif");
--      Pack_Start (Dpm_VBox, Image, Expand => False, Padding => 5);

--      Gtk_New (Bbox);
--      Set_Layout (Bbox, Buttonbox_Start); --Buttonbox_Spread);
--      Set_Spacing (Bbox, 2);

      Gtk.Button.Gtk_New (Dpm_Config_B, "Configuration");
--      Button_Range_Cb.Connect (
--        Widget => Close_Button,
--        Name   => "clicked",
--        Marsh  => Button_Range_Cb.To_Marshaller (
--          Close_Cl_Window'Access),
--        User_Data => I);
--      Pack_Start (Bbox, Dpm_Config_B, Expand => True, Fill => False);

--      Pack_Start (Dpm_VBox, Bbox, Expand => False, Padding => 5);
   end Do_Dpm;





--   procedure Gtk_New (Win : out Main_Window) is
--   begin
--
--   Debug_Log.Do_Log("Main_Window.Gtk_New begin");
--
--      Win := new Main_Window_Record;
--      Gtk.Window.Initialize (Win);
--   Debug_Log.Do_Log("Main_Window.Gtk_New end");
--   end Gtk_New;


--   procedure Initialize (Win : access Main_Window_Record'Class) is
--      Frame    : Gtk.Frame.Gtk_Frame;
--      Label    : Gtk.Label.Gtk_Label;
--      Vbox     : Gtk.Box.Gtk_Box;

--      Button   : Gtk.Button.Gtk_Button;
--      Bbox     : Gtk.Hbutton_Box.Gtk_Hbutton_Box;
--      Icon_Ok       : Boolean;
--      Style           : Gtk.Style.Gtk_Style;
--      Main_Panel_Box : Gtk.Box.Gtk_Box;
--      Smu_Panel_Box  : Gtk.Box.Gtk_Box;
--      Oeu_Panel_Box  : Gtk.Box.Gtk_Box;
--      Icm_Box        : Gtk.Box.Gtk_Box;


--      Oeu_Paned_Frames : Paned_Oeu.Child_Frames_T;

--   begin

--   Debug_Log.Do_Log("Main_Window.Initialize begin");

--      Gtk.Window.Initialize (Win, Gtk.Enums.Window_Toplevel);
--      Set_Default_Size (Win, 110, 600);
--      Icon_Ok := Set_Icon_From_File (    --Gtk.Window.
--        Window   => Win,
--        Filename => "icons/oeu_icon.gif"); --mini.gif");

--      Set_Title (
--        Window => Win,
--        Title  => "Sentinel 3 OEU simulation " & Program_Version);

--      Common.Window_Callback_Pkg.Connect (
--        Widget => Win,
--        Name   => "destroy",
--        Marsh  => Common.Window_Callback_Pkg.To_Marshaller (
--          On_X_Button_Destroy'Access));

      --  The global box
--      Gtk.Box.Gtk_New_Vbox (Base_Vbox, Homogeneous => False, Spacing => 0);
--      Add (Win, Base_Vbox);

      --  Label
--      Common.Win_Style := Copy (Get_Style (Win));
--      Common.Main_Win := Win;


--       Mdi_Root.Gtk_New (
--         Mdi_N_New   => The_Mdi_Root,
--         Base_Box    => Base_VBox,
--         Orientation => Gtk.Enums.Orientation_Vertical,
--         Independent => False);



--      Main_Panel_Box := Mdi_Root.Get_Child_Box(The_Mdi_Root, 1);
--      Smu_Panel_Box  := Mdi_Root.Get_Child_Box(The_Mdi_Root, 2);
--      Oeu_Panel_Box  := Mdi_Root.Get_Child_Box(The_Mdi_Root, 3);

--      Main_Main_Panel.Build (Main_Panel_Box);  --(Base_Vbox);
--      Main_Smu_Panel.Build (Smu_Panel_Box);  --(Base_Vbox);
--      Do_Oeu (Oeu_Panel_Box);
--      Do_Pcdm;
--      Do_Dpm;

--      Oeu_Paned_Frames := (Pcdm_Frame, Dpm_Frame);

-- Dibujar todo en los frames y pasarselos al constructor para que lo ponga cada uno en su panel
--      Paned_Oeu.Gtk_New (
--        Paned_N_New  => The_Paned_Oeu,
--        Base_Box     => Oeu_Box,
--        Child_Frames => Oeu_Paned_Frames,
--        Orientation  => Gtk.Enums.Orientation_Horizontal);

--INVESTIGAR LA FORMA DE PONER UN TAMAÑO MÍNIMO PARA LIMITIAR LO PEQUEÑO QUE SE PUEDE HACER UN PANEL


      --  Display everything
--      Show_All (Base_Vbox);

--   Debug_Log.Do_Log("Main_Window.Initialize end");

--   end Initialize;



-- ////////////////////////////////////////////////////////////////////////////


   procedure Build_Main_Window
     (The_Main_Win : in Gtk.Application_Window.Gtk_Application_Window;
      Destroy_CB   : in Basic_Types_I.Callback_T)
   is
      Icon_Ok         : Boolean                    := False;
--      Label    : Gtk.Label.Gtk_Label;

      Oeu_Icon        : Gdk.Pixbuf.Gdk_Pixbuf      :=
        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Oeu_Icon);
   begin

--      Debug_Log.Do_Log ("[UIF_OEU_Simu.Build_Main_Window]Begin");
      Local_Destroy_Cb := Destroy_Cb;

-- Create the main window of the application
--      Gtk.Window.Gtk_New
--        (Window   => Main_Win,
--         The_Type => Gtk.Enums.Window_Toplevel);
      Main_Win  := The_Main_Win;

-- Configure main window: default size, title, icon
      Main_Win.Set_Default_Size(800, 600);
      Main_Win.Set_Title
        (Title  => Uif_Configs.Prog_Title_C & " " & Uif_Configs.Prog_Version_C);
      Main_Win.Set_Icon (Oeu_Icon);


      Wdt_Handler.Connect
        (Widget => Main_Win,
         Name   => "destroy",
         Cb     => On_Destroy_Main_Win'Access);

--  The global V box
      Gtk.Box.Gtk_New_Vbox(
        Box         => Base_V_Box,
        Homogeneous => False,
        Spacing     => 0);
      Main_Win.Add(Base_V_Box);

      Do_Main_Menu;

      Gtk.Box.Gtk_New_HBox (
        Box         => Smu_H_Box,
        Homogeneous => False,
        Spacing     => 0);
      Base_V_Box.Pack_Start(
        Child   => Smu_H_Box,
        Expand  => True,
        Fill    => True,
        Padding => 0);




--      Debug_Log.Do_Log("Main_Window.Call If_Smu.Build ");
--      If_Smu.Build(Base_Vbox);

      Gtk.Box.Gtk_New_HBox (
        Box         => Oeu_H_Box,
        Homogeneous => False,
        Spacing     => 0);
      Base_V_Box.Pack_Start(
        Child   => Oeu_H_Box,
        Expand  => True,
        Fill    => True,
        Padding => 0);

--      Debug_Log.Do_Log("Main_Window.Call If_Pcdm.Build ");
--      If_Pcdm.Build(Oeu_H_Box);

--      Debug_Log.Do_Log("Main_Window.Call If_Dpm.Build ");
--      If_Dpm.Build(Oeu_H_Box);

--      Debug_Log.Do_Log("Main_Window.Call If_Icm.Build ");
--      If_Icm.Build(Oeu_H_Box);


--      Gtk.Window.Show_All (Main_Win);


--      Uif_Built  := True;

-- Create a receiver to receive the used Simulation events
      Events_From_Simu.Create_Receiver
        (Event_Id     => Events_From_Simu.Uif_Built,
         User_Cb      => On_Event_From_Simulation'Access,
         Receiver_Id  => Uif_Built_Receiver);
      Events_From_Simu.Create_Receiver
        (Event_Id     => Events_From_Simu.Main_Pwr_Switch,
         User_Cb      => On_Event_From_Simulation'Access,
         Receiver_Id  => Main_Pwr_Switch_Receiver);

      Debug_Log.Do_Log("[UIF_OEU_Simu.Build_Main_Window]Done");
   end Build_Main_Window;

   procedure Destroy_Main_Window is
   begin
      null;
   end Destroy_Main_Window;

   procedure Show_Main_Window is

   begin

--      Gtk.Window.Show_All (Main_Win);
      Main_Win.Show_All;
      null;

   end Show_Main_Window;




end UIF_Oeu_Simu;

