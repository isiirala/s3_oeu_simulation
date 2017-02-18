
with System;


with Basic_Types_I;

with Bus_1553_Pus_Types;

package Bus_1553_Pus is

   type Bus_1553_Pus_Record_T is tagged limited record
      User_Init  : Boolean;
   end record;

   type Bus_1553_Pus_T is access all Bus_1553_Pus_Record_T'Class;


end Bus_1553_Pus;

