-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Builder
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Main builder of the User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Ada.Exceptions;
with Gnat.Os_Lib;


with Gdk.Threads;
with Glib.Application;
with Glib.Main;

with Gtk.Application;
with Gtk.Application_Window;
with Gtk.Main;
with Gtk.Style_Provider;
with Gtkada.Style;

with Debug_Log;
with Oeu_Executer;
with Uif_Configs;
with UIF_Oeu_Simu;
with UIF_Oeu_Simu.Smu;
with UIF_Oeu_Simu.Pcdm;
with UIF_Oeu_Simu.Dpm;
with UIF_Oeu_Simu.Icm;
with Uif_Resources_Lib;
with Wdgt_Colors;

package body UIF_Builder is


   package Interrupt_Handler is new Glib.Main.Generic_Sources(
     Data_Type => Glib.Gint);


   The_App              : Gtk.Application.Gtk_Application    := Null;
   App_Error            : Boolean                            := False;
   Is_App_Startup       : Boolean                            := False;
   Is_App_Activated     : Boolean                            := False;


   Periodic_Source      : Glib.Main.G_Source;

   Periodic_Source_Id   : Glib.Main.G_Source_Id := Glib.Main.No_Source_Id;
   Idle_Source_Id       : Glib.Main.G_Source_Id := Glib.Main.No_Source_Id;


   procedure Log_When_Load_Style (Str : String)
   is
   begin

      Debug_Log.Do_Log(" Log loading Styles: " & Str);
   end Log_When_Load_Style;

   procedure Destroy_Uif_Cb is
   begin
      UIF_Oeu_Simu.Smu.Destroy;
      UIF_Oeu_Simu.Pcdm.Destroy;
      UIF_Oeu_Simu.Dpm.Destroy;
      UIF_Oeu_Simu.Icm.Destroy;
   end Destroy_Uif_Cb;


   procedure Config_UIF_Callbacks
     (Period       : in Glib.Guint;
      Periodic_CB  : in Handler_Func_T;
      Idle_CB      : in Handler_Func_T)
   is
   begin

--      Debug_Log.Do_Log ("[UIF_Builder.Config_UIF_Callbacks]Begin");

-- Create the source in the Glib main loop
      Periodic_Source := Glib.Main.Timeout_Source_New
        (Interval => Period);

-- Set a low priority
      Glib.Main.Set_Priority
        (Source    => Periodic_Source,
         Priority  => Glib.Main.Priority_Low);

-- Attach source in the default context
      Periodic_Source_Id := Glib.Main.Attach
        (Source  => Periodic_Source,
         Context => null);

-- Configure the periodic callback
      Interrupt_Handler.Set_Callback
        (Source   => Periodic_Source,
         Func     => Interrupt_Handler.G_Source_Func (Periodic_CB),
         Data     => 0);

-- Configure the idle callback
      Periodic_Source_Id := Interrupt_Handler.Idle_Add
        (Func     => Interrupt_Handler.G_Source_Func (Idle_CB),
         Data     => 0);

      Debug_Log.Do_Log ("[UIF_Builder.Config_UIF_Callbacks]Done");

   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_Builder.Config_UIF_Callbacks] Ex: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));
   end Config_UIF_Callbacks;



   procedure App_Startup (Self : access Glib.Application.Gapplication_Record'Class)
   is
--      use type Glib.Guint;

--      App      : constant Gtk.Application.Gtk_Application   :=
--        Gtk.Application.Gtk_Application (Self);
--      Builder  : Gtk.Builder.Gtk_Builder                    :=
--        Wdgt_Ui_Def.Get_Builder (Wdgt_Ui_Def.Tc_Tm_Top);
--      Success  : Glib.Guint;
--      Error    : aliased Glib.Error.GError;
   begin
-- TODO:
      --  Startup is when the application should create its menu bar. For
      --  this, we load an xml file and then extra parts of its to get the
      --  contents of the application menu and menu bar.

      if not Is_App_Startup then


-- Create the Application log debug file
         Debug_Log.Init;

-- Init libraries used by the application: PUS, OBSW...
         Oeu_Executer.Init_Libraries;
         Oeu_Executer.Init_Components;

-- Init widgets
         Wdgt_Colors.Init;

-- Load CSS Style configuration file
         Gtkada.Style.Load_Css_String
           (Data     => Uif_Resources_Lib.Css_Style_C,
            Error    => Log_When_Load_Style'Access,
            Priority => Gtk.Style_Provider.Priority_Application);


--         Debug_Log.Do_Log ("[Uif_Builder.App_Startup] B ");

--      Builder := Gtk.Builder.Gtk_Builder_New;
--      Success := Builder.Add_From_String
--        (Wdgt_Ui_Def.Get_Ui (Wdgt_Ui_Def.Tc_Tm_Top), Error'Access);
--      if Success = 0 then
--         Debug_Log.Do_Log ("Uif_Tc_Tm.App_Startup. Error parsing menus.ui: " &
--           Glib.Error.Get_Message (Error));
--      else
--         App.Set_App_Menu (Glib.Menu_Model.Gmenu_Model (Builder.Get_Object ("appmenu")));
--         App.Set_Menubar (Glib.Menu_Model.Gmenu_Model (Builder.Get_Object ("menubar")));
--null;
--      end if;
--      Builder.Unref;  --  no longer needed

         Debug_Log.Do_Log ("[Uif_Builder.App_Startup]Done");

         Is_App_Startup := True;
      end if;
   end App_Startup;


   procedure App_Activate (Self : access Glib.Application.Gapplication_Record'Class)
   is
--      use type Glib.Error.Gerror;
--      use type Glib.Guint;

      App_C        : constant Gtk.Application.Gtk_Application        :=
        Gtk.Application.Gtk_Application (Self);

      Win          : Gtk.Application_Window.Gtk_Application_Window   := Null;
--      Menu_Tool    : Gtk.Menu_Tool_Button.Gtk_Menu_Tool_Button       := Null;
--      Tool_Menu    : Glib.Menu_Model.Gmenu_Model                     := Null;
--      Success      : Glib.Guint                                      := 0;
--      G_Error      : aliased Glib.Error.GError                       := Null;
--      Icon         : Gdk.Pixbuf.Gdk_Pixbuf                           :=
--        Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Megaphone_Mini);
   begin
--  Activation is when we should create the main window

      if not Is_App_Activated then

--         Debug_Log.Do_Log ("[Uif_Builder.App_Activate] B ");

         Win := Gtk.Application_Window.Gtk_Application_Window_New (App_C);

         UIF_Oeu_Simu.Build_Main_Window
           (The_Main_Win => Win,
            Destroy_Cb   => Destroy_Uif_Cb'Access);

         UIF_Oeu_Simu.Smu.Build;
         UIF_Oeu_Simu.Pcdm.Build;
         UIF_Oeu_Simu.Icm.Build;
         UIF_Oeu_Simu.Dpm.Build;
         UIF_Oeu_Simu.Show_Main_Window;


         Debug_Log.Do_Log ("[Uif_Builder.App_Activate]Done");
         Is_App_Activated := True;
      end if;
   end App_Activate;


   procedure App_Shutdown (Self : access Glib.Application.Gapplication_Record'Class)
   is
      pragma Unreferenced (Self);
   begin

      Debug_Log.Do_Log ("[Uif_Builder.App_Shutdown]");
      Debug_Log.Flush;
   end App_Shutdown;









   procedure Build_Application
   is
      use type Gtk.Application.Gtk_Application;

   begin

--      Debug_Log.Do_Log("[UIF_Builder.Build_Application]Begin");

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- Initialize GtkAda for a multithread program. But, multithread support of
-- GtkAda / GTK+ in Windows does not work
--     Gdk.Threads.G_Init;
--     Gdk.Threads.Init;
      Gtk.Main.Init;
--      if not Gtk.Main.Init_Check then
--         Debug_Log.Do_Log("[UIF_Builder.Build_Application]Error return by Gtk.Init_Check ");
--      end if;



--      Debug_Log.Do_Log
--        ("[UIF_Builder.Build_Application]Register application. App Id: " &
--         Uif_Configs.Application_Id_C & " Validity of this App Id: " & Boolean'Image
--         (Glib.Application.Id_Is_Valid (Uif_Configs.Application_Id_C)));

-----------------------------------------------------------------------------------------
-- Create the GTK Application
      The_App := Gtk.Application.Gtk_Application_New
        (Application_Id => Uif_Configs.Application_Id_C,
         Flags          => Glib.Application.G_Application_Flags_None);

      if The_App = null then
--         Debug_Log.Do_Log
--           ("[UIF_Builder.Build_Application]Error. Gtk Application is null");
         App_Error := True;
      end if;

      if not App_Error then

-- GTK defines "remote" applications the second and next instances of the same app
         App_Error := The_App.Get_Is_Remote;

         if not App_Error then
            The_App.On_Startup  (App_Startup'Access);
            The_App.On_Activate (App_Activate'Access);
            The_App.On_Shutdown (App_Shutdown'Access);
         end if;
      end if;


-- Set priority of the user interface task
--   Debug_Log.Do_Log("User Interface Default Priority:" &
--     Integer'Image(Integer(Ada.Dynamic_Priorities.Get_Priority)) & " ");
--   Ada.Dynamic_Priorities.Set_Priority(System.Max_Priority);
--   Debug_Log.Do_Log("User Interface Configured Priority:" &
--     Integer'Image(Integer(Ada.Dynamic_Priorities.Get_Priority)) & " ");

      Debug_Log.Do_Log("[UIF_Builder.Build_Application]GTK application build Done");


   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_Builder.Build_Application]Except: " &
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));

   end Build_Application;




   procedure Main_Loop is
      Result         : Glib.Gint            := 0;
   begin

      Debug_Log.Do_Log ("[UIF_Builder.Main_Loop]Enter GTK Main Loop");

--  Start the Gtk+ main loop in a multithread program
--   Gdk.Threads.Enter;
--      Gtk.Main.Main;
--   Gdk.Threads.Leave;

      if not App_Error then

         Config_UIF_Callbacks
           (Period       => Uif_Configs.Period_Glib_Interrupt_C,
            Periodic_CB  => Oeu_Executer.UIF_Periodic_CB'Access,
            Idle_CB      => Oeu_Executer.UIF_Idle_CB'Access);


         Result := The_App.Run (0, (1 .. 0 => null));

      else
         The_App.Quit;
         Gtk.Main.Main_Quit;
         Gnat.Os_Lib.OS_Exit (Status => 1);
      end if;

   exception
      when Excep : others =>
         Debug_Log.Do_Log ("[UIF_Builder.Main_Loop]Except: " &
           Ada.Exceptions.Exception_Name (Excep) & " " &
           Ada.Exceptions.Exception_Message (Excep));
   end Main_Loop;


   procedure Terminate_UIF is
   begin
null;
--      Glib.Main.Source_Destroy (Source => Periodic_Source);
   end Terminate_UIF;



end UIF_Builder;

