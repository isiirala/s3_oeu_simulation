-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Builder
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Main builder of the User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Glib;

package UIF_Builder is

   
   type Handler_Func_T is access function (Data : Glib.Gint) return Boolean;
   
   
   procedure Build_Application;
   
--   procedure Config_UIF_Callbacks(
--     Period       : in Glib.Guint;
--     Periodic_CB  : in Handler_Func_T;
--     Idle_CB      : in Handler_Func_T);
     
   procedure Main_Loop;
   
   procedure Terminate_UIF;
   
--   Program_Version : String (1 .. 5) := "v 0.1";
   


end UIF_Builder;
