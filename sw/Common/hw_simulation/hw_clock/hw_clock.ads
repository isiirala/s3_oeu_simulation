

with Ada.Real_Time;

with Basic_Types_I;


package Hw_Clock is


   type Clock_T is limited private;


   procedure Init
     (Debug_Proc : in Basic_Types_I.Debug_Proc_T;
      Clock      : in out Clock_T);
--***************************************************************************************
-- PURPOSE: Set the current time as the 00:00 time for the simulated clock.
--   Current_Time - 00:00 = Simulated_Drift_Time
-- PARAMETERS:
--***************************************************************************************


   procedure Set_Time
     (Time   : in Basic_Types_I.Cuc_Time_T;
      Clock  : in out Clock_T);
--***************************************************************************************
-- PURPOSE: Configure the current time as the specified time value.
--    Current_Time - Time = Simulated_Drift_Time
-- PARAMETERS:
--***************************************************************************************

   function Get_Time
     (Clock  : in Clock_T) return Basic_Types_I.Cuc_Time_T;
--***************************************************************************************
-- PURPOSE: Return the current time of the simulated clock.
--    Time = Current_Time - Simulated_Drift_Time
-- PARAMETERS:
--***************************************************************************************

   function Get_Time_Msb_1_Zero
     (Clock  : in Clock_T) return Basic_Types_I.Cuc_Time_T;
--***************************************************************************************
-- PURPOSE: Return the current time of the simulated clock, but the Most Significat Byte
--    is set to zero, simulating clock that has not room to store all seconds of CUC
--    format.
--    Time = Current_Time - Simulated_Drift_Time, then MSB or Time is set to zero
-- PARAMETERS:
--***************************************************************************************

private

   type Clock_T is record

      Is_Init    : Boolean              := False;
      -- True when the instance of the clock is initialised

      Debug_Proc : Basic_Types_I.Debug_Proc_T := null;
      -- Procedure to show debug traces about execptions

      Time_0     : Ada.Real_Time.Time;
      -- Internal time to be compared with the current time

   end record;

end Hw_Clock;
