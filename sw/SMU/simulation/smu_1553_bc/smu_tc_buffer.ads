

with Basic_Types_1553;
with Basic_Types_I;
with Smu_Data;

package Smu_Tc_Buffer is


   procedure Init;
   -- Initialize the package: Build internal TC buffers

   procedure Append_Tc_Block
     (Rt_Id   : in Basic_Types_1553.Rt_Id_T;
      Sa_Id   : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc  : in Basic_Types_I.Byte_Array_T);
   -- Append a new TC block in the TC buffer of the specified RT

   procedure Retrieve_Tc_Block
     (Rt_Id      : in Basic_Types_1553.Rt_Id_T;
      Tc_Data    : out Smu_Data.Tc_Buffer_Data_T);
   -- Get first TC block from the TC buffer of the specified RT

end Smu_Tc_Buffer;
