

with Basic_Types_I;
with Smu_Data;

package Smu_1553_Handler is

   procedure Do_Init;

   procedure Do_Step
     (First_Part_Cycle : in Boolean;
      One_Second_Cycle : in Boolean);



--   Init_Error     : exception;
   -- Exception error detected in the initialisation of the SMU 1553 Handler:
   --   - An error creating 1553 log buffer
   --   - An exception error detected during the initialisation process

--   Use_Error      : exception;
   -- Exception error detected in the SMU 1553 Handler after the initialisation
   --   - An error in

end Smu_1553_Handler;
