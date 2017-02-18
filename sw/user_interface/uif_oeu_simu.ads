-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Root builder of User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Basic_Types_I;

with Gtk.Box;
with Gtk.Application_Window;

package UIF_Oeu_Simu is

   
   procedure Build_Main_Window
     (The_Main_Win : in Gtk.Application_Window.Gtk_Application_Window;
      Destroy_Cb   : in Basic_Types_I.Callback_T);
-- **************************************************************************************
--  PURPOSE: Build the main window of the UIF.
--  PARAMETERS: Destroy_Cb: Callback that will be executed when main windows receives 
--     the Close or Exit command from the user 
-- **************************************************************************************
     
   
   procedure Show_Main_Window;



private

   Base_V_Box    : Gtk.Box.Gtk_Box;
   Smu_H_Box     : Gtk.Box.Gtk_Box;
   Oeu_H_Box     : Gtk.Box.Gtk_Box;


end UIF_Oeu_Simu;
