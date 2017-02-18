
with Ada.Exceptions;
with Ada.Real_Time;

with Basic_Types_I;
with Debug_Log;
with Oeu_Simu_Sched_Params;
with Pus_Format_I;
with Smu_1553_Bc_I;
with Task_Initializator;

package body Smu_Executer is


   type Odd_Cycles_Counter_T is mod 7;

   Initializator         : Task_Initializator.Task_Initializator_Obj_T;

   Odd_Cycle             : Boolean                                     := True;
   Odd_Cycles_Counter    : Odd_Cycles_Counter_T                        := 0;

-- ============================================================================
-- %% Internal operations
-- ============================================================================

   procedure Thread_Init is
   begin
   null;
--      Pus_Format_I.Init
--        (Debug_Procedure => Debug_Log.Do_Log'Access,
--         Valid_Apid      => 16#400#);
--      Smu_1553_Handler.Do_Init;
   end Thread_Init;

   procedure Thread_Action is


   begin

-- Manage 1553 buses connected to SMU
      Smu_1553_Bc_I.Do_Step (Odd_Cycle, (Odd_Cycles_Counter = 0));

-- Change between Odd and even cycle
      Odd_Cycle := not Odd_Cycle;

-- Increment odd cycles counter, each 8 odd cycles counter there is a one-second latch
      Odd_Cycles_Counter := Odd_Cycles_Counter + 1;

--      Debug_Log.Do_Log(" Smu_exe do_action ");
--      null;
   end Thread_Action;

-- ============================================================================
-- %% Cyclic object
-- ============================================================================

   task  Smu_Exe_Task is
--      pragma Priority     (Scheduling_Parameters.Tc_Server_Task_C.Priority);
--      pragma Storage_Size (Scheduling_Parameters.Stack_Size_To_Use_Pus_C);
   end Smu_Exe_Task;

   task body Smu_Exe_Task is

      use type Ada.Real_Time.Time;
      use type Task_Initializator.Task_Init_Status_T;

      Period_C     : constant Ada.Real_Time.Time_Span := Oeu_Simu_Sched_Params.
        Smu_Executer_Task_C.Period;
      Next         : Ada.Real_Time.Time               := Ada.Real_Time.Clock;
      Begin_Time   : Ada.Real_Time.Time               := Ada.Real_Time.Time_First;

   begin

-- Initial delay waiting for initialisation of the RTs
      Next    := Next + Oeu_Simu_Sched_Params.Smu_Executer_Init_Delay_C;
      delay until Next;
      Next    := Ada.Real_Time.Clock;

      loop

         if Initializator.Get_Status = Task_Initializator.Task_Starting then
            Thread_Init;
            Initializator.Starting_End;
         end if;

         Next := Next + Period_C;
         delay until Next;

         if Initializator.Get_Status = Task_Initializator.Task_Started then

            Begin_Time := Ada.Real_Time.Clock;

            Thread_Action;

--            Basic_Services.Update_Wce_Time
--              (Time_Begin  => Begin_Time,
--               Task_Id     => Scheduling_Parameters.Tc_Server_Name_C);
         end if;
      end loop;


   exception
      when Event : others =>
         Debug_Log.Do_Log ("[Smu_Exe_Task]Except: " &
           Ada.Exceptions.Exception_Information (Event));


   end Smu_Exe_Task;




-- ============================================================================
-- %% Provided operations
-- ============================================================================

   procedure Simulate_On is
   begin
      Initializator.Start;
   end Simulate_On;

   procedure Simulate_Off is
   begin
      Initializator.Stop;
   end Simulate_Off;

end Smu_Executer;

