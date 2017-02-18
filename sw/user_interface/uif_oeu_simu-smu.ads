-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu.Smu
--  Unit Type           : Package specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Builder of SMU User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

--with Gtk.Box;

--with Basic_Types_I;
with Smu_Data;

package UIF_Oeu_Simu.Smu is


   procedure Build;
   
   procedure Destroy;
   
--     Base_Box : in out Gtk.Box.Gtk_Box);

   procedure Write_Str_In_Log (Log_Data   : in Smu_Data.Log_Data_T);


--   procedure Set_Main_Switch (New_Status : in Basic_Types_I.Ena_Dis_T);
--   function Get_Main_Switch return Basic_Types_I.Ena_Dis_T;
   

end UIF_Oeu_Simu.Smu;
