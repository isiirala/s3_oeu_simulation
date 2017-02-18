-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Executer
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Executer of OEU simulation
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

--with If_Bus_1553_Pus;
with Basic_Types_I;
with Basic_Types_1553;
with Debug_Log;
with If_Bus_1553_Pus;
with Oeu_Simu.Icm;
with Oeu_Simu.Smu;
with Pus_Format_I;
with Uif_Oeu_Simu.Icm;
with Uif_Oeu_Simu.Smu;
with Uif_Tc_Tm_I;
with Smu_Data;

with Dump_Logs;
with Test_Params_I;
--with icm_rsw_windowsmain;

with Events_From_Simu;
with Oeu_Simu_Types;
with Uif_Configs;
with Wdgt_Images;
with Wdgt_Ui_Def;

package body Oeu_Executer is



--   Tm_Param_Val  : Basic_Types_I.String_T
--     (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C) := (others => ' ');
--   Tm_Param_Len  : Basic_Types_I.Data_32_Len_T                       :=
--     Basic_Types_I.Data_32_Len_Empty_C;

   Tm_Displayed_Params     : Test_Params_I.Array_Params_T
     (1 .. Basic_Types_1553.Max_Tc_Tm_Params_C);
   -- Parameters value of the current displayed TM in the TC/TM window

   Tm_Displayed_Params_Len : Basic_Types_I.Data_32_Len_T    :=
     Basic_Types_I.Data_32_Len_Empty_C;
   -- Length used of the Tm_Displayed_Params


   Idle_To_Init_C     : constant Basic_Types_I.Uint32_T      := 3;
   Uif_Is_Built       : Boolean                              := False;
   Idle_Cb_Counter    : Basic_Types_I.Uint32_T               := 0;



   procedure Init_Libraries is
      Bus_Bc_Access : If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T;
   begin

--      Debug_Log.Do_Log("[Oeu_Executer.Init_Libraries]Begin ");

-- Init external library of PUS and utils
      Pus_Format_I.Init
        (Debug_Procedure => Debug_Log.Do_Log'Access,
         Valid_Apid      => 16#400#);

-- Init SMU simulation and create the Bus Controller of the bus 1553 simulation
      Oeu_Simu.Smu.Init (Bus_Bc_Access);

-- Init ICM simulation and create the Bus Remote Terminal connected to the BC
      Oeu_Simu.Icm.Init (Bc_Access => Bus_Bc_Access);

      Debug_Log.Do_Log ("[Oeu_Executer.Init_Libraries]Done");
   end Init_Libraries;


   procedure Init_Components
   is
   begin

      Wdgt_Images.Init (Debug_Log.Do_Log'Access);
      Wdgt_Ui_Def.Init (Debug_Log.Do_Log'Access);

   end Init_Components;


   function UIF_Periodic_CB(Data : Glib.Gint) return Boolean is
   begin
--      Debug_Log.Do_Log(" PeriodicCB ");


      return True;
   end UIF_Periodic_CB;



   function UIF_Idle_CB(Data : Glib.Gint) return Boolean
   is
      use type Basic_Types_I.Uint32_T;

      Icm_Log    : String(1 .. 50) := (others => ' ');
      Actual_Len : Natural         := 0;


      Tm_Displayed           : Basic_Types_1553.Tc_Tm_Id_T          :=
        Basic_Types_1553.Tc_Tm_None;


      Log_Data   : Smu_Data.Log_Data_T;

   begin


      if not Uif_Is_Built then

         Idle_Cb_Counter := Idle_Cb_Counter + 1;
         if Idle_Cb_Counter >= Idle_To_Init_C then

            Debug_Log.Do_Log("[OEU_Executer.UIF_Idle_CB]Consider UIF built ");
            Uif_Is_Built := True;

            Uif_Configs.Uif_Built := True;

-- The UIF is built and widgets access can be used to update the UIF to the initial
-- status in accordance with the simulation
            Events_From_Simu.Activate
              (Event_Id   => Events_From_Simu.Uif_Built,
               User_Data1 => 0,
               User_Data2 => 0);
         end if;
      end if;

------------------------------------------
-- Collect log traces of ICM simulation
      Oeu_Simu.Icm.Read_Obsw_Log (Icm_Log, Actual_Len);
      Uif_Oeu_Simu.Icm.Write_Str_In_Log (Icm_Log (1 .. Actual_Len));

      if Uif_Configs.Active_Dump_Logs (Oeu_Simu_Types.Log_Icm_Exe) then
         Dump_Logs.Dump_Same_Line_To_File
           (Log  => Oeu_Simu_Types.Log_Icm_Exe,
            Str  => Basic_Types_I.String_T (Icm_Log (1 .. Actual_Len)));
      end if;

------------------------------------------
-- Collect log traces of the SMU 1553 simulation
      Oeu_Simu.Smu.Read_Internal_Log (Log_Data);
      Uif_Oeu_Simu.Smu.Write_Str_In_Log (Log_Data);

      if Uif_Configs.Active_Dump_Logs (Oeu_Simu_Types.Log_Smu_1553) then
         Dump_Logs.Dump_Same_Line_To_File
           (Log  => Oeu_Simu_Types.Log_Smu_1553,
            Str  => Log_Data.Str (1 .. Log_Data.Last_Index));
      end if;

------------------------------------------
-- Collect last TM parameters received in SMU. If TC/TM application is active get
-- the current TM page displayed and update it
      if Uif_Tc_Tm_I.Is_Built then

         Tm_Displayed := Uif_Tc_Tm_I.Get_Tm_Displayed;

--         Debug_Log.Do_Log(" UIF_Idle_CB moving parameters TM_Displayed:" &
--           Basic_Types_1553.Tc_Tm_Id_T'Image(Tm_Displayed));

         Oeu_Simu.Smu.Read_Tm_Params
           (Tm_Param_Id    => Tm_Displayed,
            Tm_Params      => Tm_Displayed_Params,
            Tm_Params_Len  => Tm_Displayed_Params_Len);

         if not Tm_Displayed_Params_Len.Data_Empty then

--            Debug_Log.Do_Log(" ====== There are parameters in " &
--              Basic_Types_1553.Tc_Tm_Id_T'Image(Tm_Displayed));

            Uif_Tc_Tm_I.Update_Tm_Params
              (Tm_Id         => Tm_Displayed,
               Tm_Params     => Tm_Displayed_Params,
               Tm_Params_Len => Tm_Displayed_Params_Len);

-- Clear array of parameters
            Tm_Displayed_Params_Len := Basic_Types_I.Data_32_Len_Empty_C;
         end if;
      end if;



      return True;
   end UIF_Idle_CB;


--begin

--Tc_Server'Elab_Body;
--init_lib_icm_rsw;

--   icm_rsw_windowsmain.icm_rsw_windowsinit;

end Oeu_Executer;

