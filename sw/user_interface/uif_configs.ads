-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Uif_Configs
--  Unit Type           : Package specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Global configurations used in the UIF User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Ada.Strings.Unbounded;

with Glib;

with Oeu_Simu_Types;

package Uif_Configs is

   use type Glib.Guint;



   Prog_Title_C       : constant String    := "Sentinel 3 OEU simulation ";
   Prog_Sh_Title_C    : constant String    := "OEU_Simu";
   Prog_Version_C     : constant String    := "Demo v1.0";

   Application_Id_C   : constant String    := "gmv.s3.oeu_simulation_demo";


-- Increase time period in the simulation, to make the execution of
-- simulator easier
   Simulation_Time_Factor_C    : constant Glib.Guint    := 10;

-- Period to configure a time interrupt in GTK to execute the OBSW
   Period_Glib_Interrupt_C     : constant Glib.Guint   :=
     11 * Simulation_Time_Factor_C;


   Uif_Built          : Boolean             := False;
   -- It is set to True when UIF is built

-- --------------------------------------------------------------------------------------
-- Directories
-- TODO: PONER EN UN FICHERO DE CONFIGURACION DE LA APP PARA USAR LO ELEGIDO POR USUARIO
-- pero ojo con las \ por si el usuario no las pone

   Dir_Images_C         : constant Ada.Strings.Unbounded.Unbounded_String   :=
     Ada.Strings.Unbounded.To_Unbounded_String (".\images\");

   Dir_Exe_Logs         : Ada.Strings.Unbounded.Unbounded_String            :=
     Ada.Strings.Unbounded.To_Unbounded_String (".\exe_logs\");

   Subdir_Current_Logs  : Ada.Strings.Unbounded.Unbounded_String            :=
     Ada.Strings.Unbounded.To_Unbounded_String ("");

   Rename_Subdir_Logs   : Boolean                                           := True;
   -- If True the logs are generated in a subdirectory with a timestamp

-- --------------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------------
-- Execution logs to dump to files
   Active_Dump_Logs    : Oeu_Simu_Types.Arr_Bool_Log_T            :=
     (Oeu_Simu_Types.Log_App_Exe      => True,
      Oeu_Simu_Types.Log_Smu_1553     => True,
      Oeu_Simu_Types.Log_Icm_Exe      => False,
      Oeu_Simu_Types.Log_Dpm_Exe      => False,
      Oeu_Simu_Types.Log_Pcdm_Exe     => False);

   type Arr_Logs_File_Name_T  is array (Oeu_Simu_Types.Log_T'Range) of
     Ada.Strings.Unbounded.Unbounded_String;

   Arr_Logs_File_Name  : Arr_Logs_File_Name_T                     :=
     (Oeu_Simu_Types.Log_App_Exe      => Ada.Strings.Unbounded.To_Unbounded_String
       ("program_log.txt"),
      Oeu_Simu_Types.Log_Smu_1553     => Ada.Strings.Unbounded.To_Unbounded_String
       ("Simu_SMU_1553.log"),
      Oeu_Simu_Types.Log_Icm_Exe      => Ada.Strings.Unbounded.To_Unbounded_String
       ("Simu_Icm_Exe.log"),
      Oeu_Simu_Types.Log_Dpm_Exe      => Ada.Strings.Unbounded.To_Unbounded_String
       ("Simu_Dpm_Exe.log"),
      Oeu_Simu_Types.Log_Pcdm_Exe     => Ada.Strings.Unbounded.To_Unbounded_String
       ("Simu_Pcdm_Exe.log"));

-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- Specific configurations for the execution logs
   Smu_1553_Decode_Tcs         : Boolean           := True;
   Smu_1553_Decode_Tcs_Full    : Boolean           := False;
   Smu_1553_Decode_Tms         : Boolean           := True;
   Smu_1553_Decode_Tms_Full    : Boolean           := False;


   Icm_Exe_Wrap_Line_End       : Boolean           := False;

-- --------------------------------------------------------------------------------------



end Uif_Configs;

