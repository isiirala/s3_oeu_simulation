-- ****************************************************************************
--  Project             : OLCI_ICM_SW
--  Unit Name           : Oeu_Simu_Sched_Params
--  Unit Type           : Package specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2012/06/18 06:39:31 $
--  Revision            : $Revision: 1.17 $
--  Function            : Priority declarations of all tasks and protected
--                        objects in the OEU Simulation
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0
-- ****************************************************************************

with System;
with Ada.Real_Time;
with Ada.Interrupts.Names;


--pragma Warnings (Off);
--with System.Tasking;
--pragma Warnings (On);

with Basic_Types_I;

package Oeu_Simu_Sched_Params is

-------------------------------------------------------------------------------
-- Types of the structures to configure each task type
-------------------------------------------------------------------------------
   type Sporadic_Task_Parameters_T is
   record
      Priority    : System.Any_Priority                  := 0;
      Task_Name   : Basic_Types_I.Unsigned_32_T;
   end record;

   type Cyclic_Task_Parameters_T is
   record
      Period      : Ada.Real_Time.Time_Span;
      Priority    : System.Any_Priority                  := 0;
      Task_Name   : Basic_Types_I.Unsigned_32_T;
   end record;


   type Protected_Object_Parameters_T is
   record
      Ceiling_Priority : System.Any_Priority := 0;
   end record;


-- OEU Simu Tasks names
   Oeu_Unknown_Task_C      : constant Basic_Types_I.Unsigned_32_T  := 16#900#;
   Smu_Executer_Name_C     : constant Basic_Types_I.Unsigned_32_T  := 16#901#;
--   Startup_Name_C          : constant Basic_Types_I.Unsigned_32_T  := 16#A01#;
--   Critical_Error_Name_C   : constant Basic_Types_I.Unsigned_32_T  := 16#A02#;
--   Tc_Bus_Manager_Name_C   : constant Basic_Types_I.Unsigned_32_T  := 16#A03#;
--   Tm_Bus_Manager_Name_C   : constant Basic_Types_I.Unsigned_32_T  := 16#A04#;
--   Pps_Manager_Name_C      : constant Basic_Types_I.Unsigned_32_T  := 16#A05#;
--
---- Array to hold the Worst Case Execution time of each task
--   type Rsw_Wce_Times_T is array (Tc_Bus_Manager_Name_C .. Single_Edac_Name_C)
--     of Basic_Types_I.Unsigned_32_T;
--
---- The WCE Array is mapped in the WD_Context Log memory zone
--   Wce_Times        : Rsw_Wce_Times_T;
--   for Wce_Times'Address use Memory_Map.Start_Log_Rsw_Wce_Addr_C;
--
---- Stack size for the tasks that use the PUS library to implement
---- operations of memory check. This value must be bigger than:
----   Pus_Config.Checked_Data_Buffer_Size_C
--   Stack_Size_To_Use_Pus_C : constant                            :=
--     (20 * 1024) * 2;

-------------------------------------------------------------------------------
-- Tasks identifiers
-------------------------------------------------------------------------------
--   Startup_Id              : System.Tasking.Task_Id      :=
--     System.Tasking.Null_Task;
--
--   Critical_Error_Manager_Id  : System.Tasking.Task_Id   :=
--     System.Tasking.Null_Task;
--
--   Tc_Bus_Manager_Id       : System.Tasking.Task_Id      :=
--     System.Tasking.Null_Task;
--
--   Tm_Bus_Manager_Id       : System.Tasking.Task_Id      :=
--     System.Tasking.Null_Task;
--

-------------------------------------------------------------------------------
-- Tasks configuration
-------------------------------------------------------------------------------
--   Startup_Task_C                    : constant Sporadic_Task_Parameters_T :=
---- ICM_REHOST_BEGIN
----     (Priority  => System.Interrupt_Priority'Last,
--     (Priority  => (System.Priority'Last + 1) - 1,
--      Task_Name => Startup_Name_C);
--
   Smu_Executer_Task_C           : constant Cyclic_Task_Parameters_T   :=
     (Period    => Ada.Real_Time.Microseconds (62500),
      Priority  => System.Default_Priority,
      Task_Name => Smu_Executer_Name_C);
   -- Period of 62.5 Milliseconds = 125/2

   Smu_Executer_Init_Delay_C     : constant Ada.Real_Time.Time_Span    :=
     Ada.Real_Time.Milliseconds (3000);
   -- 3 s of initial delay of BC waiting for RTs

--   Critical_Error_Manager_Task_C     : constant Sporadic_Task_Parameters_T :=
--     (Priority  => (System.Priority'Last + 1) - 1,
--      Task_Name => Critical_Error_Name_C);
--

-------------------------------------------------------------------------------
-- Protected objects related to interrupt handlers
-------------------------------------------------------------------------------
   Fifo_String_Buffer_C  : constant Protected_Object_Parameters_T :=
     (Ceiling_Priority => System.Default_Priority + 1);

--   Epica_Ic1_Protected_C         : constant Protected_Object_Parameters_T :=
--     (Ceiling_Priority => Ada.Interrupts.Names.External_Interrupt_0_Priority);
--
--   Epica_Ic2_Protected_C         : constant Protected_Object_Parameters_T :=
--     (Ceiling_Priority => Ada.Interrupts.Names.External_Interrupt_1_Priority);
--
--   Single_Edac_Error_Protected_C : constant Protected_Object_Parameters_T :=
--     (Ceiling_Priority =>
--        Ada.Interrupts.Names.Correctable_Error_In_Memory_Priority);

-------------------------------------------------------------------------------
-- Protected objects configuration
-------------------------------------------------------------------------------
--   Time_Status_Protected_C        : constant Protected_Object_Parameters_T :=
--     (Ceiling_Priority => (System.Priority'Last + 1) - 1);
--
--   Tc_Buffer_Protected_C          : constant Protected_Object_Parameters_T :=
--     (Ceiling_Priority => (System.Priority'Last + 1) - 2);
--

end Oeu_Simu_Sched_Params;
