

with Basic_Types_1553;
with Basic_Types_I;
with Pus_Format_Types_I;
with Smu_Data;
with Test_Params_I;

package Smu_1553_Log is


   procedure Init;


   procedure Decode_Tms
     (Max_Tm_Block  : in Basic_Types_I.Unsigned_32_T);
   --************************************************************************************
   --  PURPOSE: Request to the BC_SMU_OEU object the TMs retrieved and decode they in
   --    the string log
   --************************************************************************************


   procedure Decode_Tc
     (Tc_Buffer       : in Smu_Data.Tc_Buffer_Data_T);
   --************************************************************************************
   --  PURPOSE: Decode in the string log the TC provided
   --************************************************************************************

   procedure Read_Tm_Params
     (Tm_Id         : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T);
   --************************************************************************************
   --  PURPOSE: Returns last TM parameters received in the SMU
   --************************************************************************************


   procedure Read_Uif_Log
     (Log_Data  : in out Smu_Data.Log_Data_T);
   --************************************************************************************
   --  PURPOSE: Returns the string log with the TC/TM 1553 messages decoded.
   --    The parameter includes metadata to know the text tag to use for each text piece
   --************************************************************************************


end Smu_1553_Log;

