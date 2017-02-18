
with Basic_Types_1553;
with Basic_Types_I;
with If_Bus_1553_Pus;
with Pus_Format_Types_I;
with Smu_Data;
with Test_Params_I;

package Smu_1553_Bc_I is


   procedure Init
     (Bc_Access_For_Rts : out If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T);

   procedure Do_Step
     (First_Part_Cycle : in Boolean;
      One_Second_Cycle : in Boolean);

   procedure Send_Tc_Block
     (Rt_Id   : in Basic_Types_1553.Rt_Id_T;
      Sa_Id   : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc  : in Basic_Types_I.Byte_Array_T);

   procedure Read_Tm_Params
     (Tm_Param_Id   : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T);


   procedure Read_Uif_Log
     (Log_Data  : in out Smu_Data.Log_Data_T);



end Smu_1553_Bc_I;
