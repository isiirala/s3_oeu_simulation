-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu.Pcdm
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : SMU main simulation package of OEU
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Basic_Types_1553;
with Basic_Types_I;
with If_Bus_1553_Pus;
with Pus_Format_Types_I;
with Smu_1553_Handler;
with Smu_Data;

with Test_Params_I;

package Oeu_Simu.Smu is


   procedure Init
     (Bc_Access_For_Rts : out If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T);
   
   
--   procedure Power_On;
--   procedure Power_Off;
   procedure Set_Main_Switch (New_Status : in Basic_Types_I.Ena_Dis_T);
   function Get_Main_Switch return Basic_Types_I.Ena_Dis_T;
   
   
   procedure Read_Internal_Log 
     (Log_Data  : in out Smu_Data.Log_Data_T);
   -- The UIF uses this routine to get the SMU execution log: i.e. the bus 1553 log

 
   procedure Send_Tc_Block
     (Rt_Id   : in Basic_Types_1553.Rt_Id_T;
      Sa_Id   : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc  : in Basic_Types_I.Byte_Array_T);
   -- Insert the TC block in the TC queue of the corresponding RT. The TCs are extracted 
   -- by the 1553 scheduler and transmitted to the rehosted SW at the correct moment, 
   -- generating the event/interrupt in the RT about the new message
   --      Service     : 
   --      Sub_Service :
   --      Data_Field  :
 
 
   procedure Read_Tm_Params 
     (Tm_Param_Id   : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T);
   -- The UIF uses this routine to get the last value received of a PUS TM, 
 
   
--private
--
--   procedure Write_Internal_Sw_Log(Str : in String);


end Oeu_Simu.Smu;

