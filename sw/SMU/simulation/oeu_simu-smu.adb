-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu.Pcdm
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : SMU main simulation package of OEU
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Debug_Log;

with Glib;

--with Bc_Smu_Oeu;
--with Smu_1553_Handler;
with Basic_Types_I;
with Events_From_Simu;

with Oeu_Simu.Icm;

with Smu_1553_Bc_I;
with Smu_Executer;

package body Oeu_Simu.Smu is

   Main_Pwr_Switch         : Basic_Types_I.Ena_Dis_T    := Basic_Types_I.Disabled;


   procedure Power_On is
   begin

      Smu_Executer.Simulate_On;

      Oeu_Simu.Icm.Switch_On;
   end Power_On;

   procedure Power_Off is
   begin

      Smu_Executer.Simulate_Off;

      Oeu_Simu.Icm.Switch_Off;
   end Power_Off;


   procedure Init
     (Bc_Access_For_Rts : out If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T) is
   begin

      Smu_1553_Bc_I.Init (Bc_Access_For_Rts);

--      Debug_Log.Do_Log ("[Oeu_Simu.Smu.Init]");
   end Init;


   procedure Set_Main_Switch (New_Status : in Basic_Types_I.Ena_Dis_T)
   is
      use type Basic_Types_I.Ena_Dis_T;

   begin

      if (New_Status = Basic_Types_I.Enabled) and then
        (Main_Pwr_Switch = Basic_Types_I.Disabled) then

         Power_On;
         Main_Pwr_Switch := Basic_Types_I.Enabled;

-- The status Main Pwr Switch is an Event From The Simulation, activate this event to
-- refresh the UIF connected to this event
         Events_From_Simu.Activate
           (Event_Id   => Events_From_Simu.Main_Pwr_Switch,
            User_Data1 => 1,
            User_Data2 => 0);

      elsif (New_Status = Basic_Types_I.Disabled) and then
        (Main_Pwr_Switch = Basic_Types_I.Enabled) then

         Power_Off;
         Main_Pwr_Switch := Basic_Types_I.Disabled;

-- The status Main Pwr Switch is an Event From The Simulation, activate this event to
-- refresh the UIF connected to this event
         Events_From_Simu.Activate
           (Event_Id   => Events_From_Simu.Main_Pwr_Switch,
            User_Data1 => 0,
            User_Data2 => 0);

      end if;
   end Set_Main_Switch;


   function Get_Main_Switch return Basic_Types_I.Ena_Dis_T
   is
   begin
      return Main_Pwr_Switch;
   end Get_Main_Switch;



   procedure Read_Internal_Log
     (Log_Data  : in out Smu_Data.Log_Data_T)
   renames Smu_1553_Bc_I.Read_Uif_Log;


   procedure Send_Tc_Block
     (Rt_Id   : in Basic_Types_1553.Rt_Id_T;
      Sa_Id   : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc  : in Basic_Types_I.Byte_Array_T)
--   is
--   begin

-- Insert TC Block in the queue
--      Smu_Tc_Buffer.Append_Tc_Block
--        (Rt_Id  => Rt_Id,
--         Sa_Id  => Sa_Id,
--         Raw_Tc => Raw_Tc);

-- Generate interrupt in the RT if the limit of 1553 messages are reached

--   end Send_Tc_Block;
   renames Smu_1553_Bc_I.Send_Tc_Block;


   procedure Read_Tm_Params
     (Tm_Param_Id   : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T)
   renames Smu_1553_Bc_I.Read_Tm_Params;



end Oeu_Simu.Smu;


