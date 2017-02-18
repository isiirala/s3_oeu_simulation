

with Bc_Smu_Oeu;
with Smu_Tc_Buffer;
with Smu_1553_Handler;
with Smu_1553_Log;

package body Smu_1553_Bc_I is



   procedure Init
     (Bc_Access_For_Rts : out If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T)
   is
   begin

      Bc_Smu_Oeu.Init (Bc_Access_For_Rts);
      Smu_1553_Handler.Do_Init;
      Smu_1553_Log.Init;
      Smu_Tc_Buffer.Init;

   end Init;

   procedure Do_Step
     (First_Part_Cycle : in Boolean;
      One_Second_Cycle : in Boolean)
   renames Smu_1553_Handler.Do_Step;

   procedure Send_Tc_Block
     (Rt_Id   : in Basic_Types_1553.Rt_Id_T;
      Sa_Id   : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc  : in Basic_Types_I.Byte_Array_T)
   renames Smu_Tc_Buffer.Append_Tc_Block;

   procedure Read_Tm_Params
     (Tm_Param_Id   : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T)
   renames Smu_1553_Log.Read_Tm_Params;

   procedure Read_Uif_Log
     (Log_Data  : in out Smu_Data.Log_Data_T)
   renames Smu_1553_Log.Read_Uif_Log;


end Smu_1553_Bc_I;
