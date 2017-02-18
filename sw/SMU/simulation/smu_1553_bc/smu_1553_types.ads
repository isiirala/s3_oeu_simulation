
with Ada.Calendar;

with Basic_Types_I;
with Smu_Data;

package Smu_1553_Types is


   type Tm_Block_Info_T is record
      Rt_Id        : Basic_Types_I.Unsigned_16_T;
      -- Id of the TX RT
      Sa_Id        : Basic_Types_I.Unsigned_16_T;
      -- Id of the TX SA in RT
      Time_Tag     : Ada.Calendar.Time;
      -- Time tag when BC receive the TM Block
   end record;
   -- Structure with extra information about a 1553 TM block to store with it (metadata)

   pragma Pack (Tm_Block_Info_T);
   for Tm_Block_Info_T'Alignment use 1;

   Null_Tm_Block_Info_C  : constant Tm_Block_Info_T :=
     (0, 0, Ada.Calendar.Clock);


   Subtype Tm_Block_Container_T is
     Basic_Types_I.Byte_Array_T (1 .. Smu_Data.Max_Tm_Block_Bytes_C);
   -- Byte array container to hold the data of a TM block

   Null_Tm_Block_Container_C : constant Tm_Block_Container_T := (others => 0);



end Smu_1553_Types;

