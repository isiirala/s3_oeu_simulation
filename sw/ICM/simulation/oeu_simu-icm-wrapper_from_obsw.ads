-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu.Icm.Wrapper_From_Obsw
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Routines to call/use the ICM UIF from OBSW
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with System;

with Glib;


--with Basic_Types_I;

package Oeu_Simu.Icm.Wrapper_From_Obsw is

  
--   procedure Init;
   

   procedure obsw_debug_char (C : in Character);   
   procedure obsw_debug_str (Str : in String);
   
--   procedure obsw_debug_1553_tm (Str : in String);


--   function obsw_bus_set_data_trans (
--     Sa_Id    : in Basic_Types_I.Unsigned_32_T;
--     Ptr_Data : in System.Address;
--     Dw_N     : in Basic_Types_I.Unsigned_32_T) 
--   return Basic_Types_I.Unsigned_32_T;


   
private

--   Log_Buffer_First_Index_C  : constant       := 1;
--   Log_Buffer_Last_Index_C   : constant       := 4000;
--   subtype Log_Buffer_Index_T is Glib.Guint range 
--     Log_Buffer_First_Index_C .. Log_Buffer_Last_Index_C;
--   subtype Log_Buffer_T is String(
--     Log_Buffer_First_Index_C .. Log_Buffer_Last_Index_C);



--   null;


end Oeu_Simu.Icm.Wrapper_From_Obsw;

