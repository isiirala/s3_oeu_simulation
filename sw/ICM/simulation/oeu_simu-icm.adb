-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu.Icm
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : ICM main simulation package of OEU
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

--with Debug_Log;

--with Glib;



with Icm_Rsw_Dll_If;
with Icm_Opsw_Dll_If;
with Lib_Icm_Sw_If_Types;

with Bus_1553_Pus_Types;
with Bus_1553_Pus.Rt;

with Uif_Oeu_Simu.Icm;

with Bus_Rt_Icm;
with Debug_Log;

package body Oeu_Simu.Icm is


-- Routine to elaborate the SAL (StandAloneLibrary) of RSW
--   procedure init_lib_icm_rsw;
--   pragma Import(C, init_lib_icm_rsw, "IcmRswSalinit"); --"icm_rswinit");

   Rsw_Init_Out_Config  : Lib_Icm_Sw_If_Types.Lib_Output_Init_T;
   Opsw_Init_Out_Config : Lib_Icm_Sw_If_Types.Lib_Output_Init_T;

   Local_Bc_Access      : If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T := null;



   procedure Jump_To_Rsw (Str : in String)
   is
   begin

--      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Jump_To_Rsw]!! ");

--      Icm_Opsw_Dll_If.Switch_Off;


null;
--      Icm_Opsw_Dll_If.Switch_Off;
-- Initialize the simulation of the bus 1553 and connect it to the RSW
--      Bus_Rt_Icm.Init
--        (Bc_Access   => Local_Bc_Access,
--         Ic1_Handler => Rsw_Init_Out_Config.Ic1_Handler,
--         Ic2_Handler => Rsw_Init_Out_Config.Ic2_Handler);
--      Icm_Rsw_Dll_If.Switch_On;
   end Jump_To_Rsw;


   procedure Jump_To_Opsw (Str : in String)
   is
   begin

      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Jump_To_Opsw]!! ");

      Icm_Rsw_Dll_If.Switch_Off;

-- Initialize the simulation of the bus 1553 and connect it to the OPSW
      Bus_Rt_Icm.Connect_Interrupt_Routines
        (Ic1_Handler => Opsw_Init_Out_Config.Ic1_Handler,
         Ic2_Handler => Opsw_Init_Out_Config.Ic2_Handler);

      Icm_Opsw_Dll_If.Switch_On;

   end Jump_To_Opsw;



   procedure Init
     (Bc_Access  : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T)
   is

      Icm_Init_In_Config   : Lib_Icm_Sw_If_Types.Lib_Input_Init_T;

   begin

--      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Init]Begin ");

      Local_Bc_Access := Bc_Access;

-- Elaborate the RSW & OPSW libraries
      Icm_Rsw_Dll_If.IcmRswSalinit;
      Icm_Opsw_Dll_If.IcmOpswSalinit;

      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Init]Onboard SW Elaborated");

-- -----------------------------------------------------------------------------
-- Initialize and configure the RSW library. Begin

-- Connect debug procedures
      Icm_Init_In_Config.Log_Debug_Proc          := Write_Obsw_Log'Access;
      Icm_Init_In_Config.File_Debug_Proc         := Debug_Log.Do_Log'Access;
      Icm_Init_In_Config.File_Debug_In_Line_Proc := Debug_Log.Do_Log_Same_Line'Access;

-- Connect bus 1553 Routines
      Icm_Init_In_Config.Bus_1553_Init_Sa    := Bus_Rt_Icm.Bus_1553_Init_Sa_Raw'Access;
      Icm_Init_In_Config.Bus_1553_Tx         := Bus_Rt_Icm.Bus_1553_Tx_Sa_Raw'Access;
      Icm_Init_In_Config.Bus_1553_Rx         := Bus_Rt_Icm.Bus_1553_Rx_Sa_Raw'Access;
      Icm_Init_In_Config.Bus_1553_Pus_Rx_Sa_Info       :=
        Bus_Rt_Icm.Bus_1553_Pus_Rx_Sa_Info'Access;
      Icm_Init_In_Config.Bus_1553_Pus_Rx_Sa_First_Tc   :=
        Bus_Rt_Icm.Bus_1553_Pus_Rx_Sa_First_Tc'Access;
      Icm_Init_In_Config.Bus_1553_Pus_Sa_Reset         :=
        Bus_Rt_Icm.Bus_1553_Pus_Sa_Reset'Access;

-- Connect the terminate procedure of the RSW towars the OPSW
      Icm_Init_In_Config.Terminate_Proc      := Jump_To_Opsw'Access;

      Icm_Rsw_Dll_If.Init (Icm_Init_In_Config, Rsw_Init_Out_Config);
      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Init] RSW Onboard SW Initialised");

-- Connect the terminate procedure of the OPSW towars the RSW
      Icm_Init_In_Config.Terminate_Proc      := Jump_To_Rsw'Access;

      Icm_Opsw_Dll_If.Init (Icm_Init_In_Config, Opsw_Init_Out_Config);
      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Init] OPSW Onboard SW Initialised");


-- Initialize and configure the RSW library. End
-- -----------------------------------------------------------------------------

-- Initialize the simulation of the bus 1553 and connect it to the RSW
      Bus_Rt_Icm.Init
        (Bc_Access   => Local_Bc_Access);

--      Bus_Rt_Icm.Connect_Interrupt_Routines
--        (Ic1_Handler => Rsw_Init_Out_Config.Ic1_Handler,
--         Ic2_Handler => Rsw_Init_Out_Config.Ic2_Handler);


      Debug_Log.Do_Log ("[Oeu_Simu.Icm.Init]Done");
   end Init;



   procedure Switch_On is
   begin

-- Connect RSW interrupt routines before start it
      Bus_Rt_Icm.Connect_Interrupt_Routines
        (Ic1_Handler => Rsw_Init_Out_Config.Ic1_Handler,
         Ic2_Handler => Rsw_Init_Out_Config.Ic2_Handler);

      Icm_Rsw_Dll_If.Switch_On;

   end Switch_On;
   procedure Switch_Off is
   begin

-- 22
--Parece Que Si Se Ejecuta Y Ya Está Apagado Da Error. Ademas Hay Que Hacer El Switch Off Del OPSW

      Icm_Opsw_Dll_If.Switch_Off;
      Icm_Rsw_Dll_If.Switch_Off;

   end Switch_Off;





   Fifo_Buffer : Fifo_String_Buffer;



   procedure Write_Obsw_Log(Str : in String) is
   begin

--      Debug_Log.Do_Log (" [Oeu_Simu.Icm.Write_Obsw_Log]: " & Str);

      Fifo_Buffer.Write(Str);
   end Write_Obsw_Log;

   procedure Read_Obsw_Log(Str : in out String; Actual_Len : out Natural) is
   begin
      Fifo_Buffer.Read(Str, Actual_Len);
   end Read_Obsw_Log;




end Oeu_Simu.Icm;

