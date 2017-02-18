-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Executer
--  Unit Type           : Package Specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Executer of OEU simulation
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Glib;

package Oeu_Executer is


   procedure Init_Libraries;

   procedure Init_Components;

   function UIF_Periodic_CB(Data : Glib.Gint) return Boolean;

   function UIF_Idle_CB(Data : Glib.Gint) return Boolean;

end Oeu_Executer;
