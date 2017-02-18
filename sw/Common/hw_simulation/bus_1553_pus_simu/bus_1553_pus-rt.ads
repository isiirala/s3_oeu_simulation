

with Basic_Types_1553;
with Basic_Types_I;
with Bus_1553_Pus.Bc;
with Bus_1553_Pus.Rt_Sa;
with If_Bus_1553_Pus;
with Lib_Icm_Sw_If_Types;

with Prot_Monitor;

package Bus_1553_Pus.Rt is


   type Bus_1553_Pus_Rt_Record_T is new Bus_1553_Pus_Record_T and
     If_Bus_1553_Pus.If_Bus_1553_Pus_Rt_T with private;

   type Bus_1553_Pus_Rt_T is access all Bus_1553_Pus_Rt_Record_T'Class;

   procedure Create_New
     (Rt_Id       : in Basic_Types_1553.Rt_Id_T;
      Bc_Access   : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T;
      Rt          : out Bus_1553_Pus_Rt_T;
      Result      : out Basic_Types_I.Unsigned_32_T);


   procedure Initialize
     (Rt          : not null access Bus_1553_Pus_Rt_Record_T'Class;
      Rt_Id       : in Basic_Types_1553.Rt_Id_T;
      Bc_Access   : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T;
      Result      : out Basic_Types_I.Unsigned_32_T);


--   procedure Rt_For_User_Init
--     (Rt_Id       : in Bus_1553_Pus_Types.Rt_Id_T;
--      Bc_Access   : in If_Bus_1553_Pus_Bc_For_Rt.Bus_1553_Pus_Bc_For_Rt_T;
--      Rt_For_User : in out Bus_1553_Pus_Rt_Record_T;
--      Result      : out Basic_Types_I.Unsigned_32_T);

   procedure Rt_For_User_Set_Transaction
     (Rt            : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Tx_Or_Rx      : in Boolean;
      Msg_N         : in Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T);

   procedure Rt_For_User_Set_Data_Tx
     (Rt            : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data      : in System.Address;
      Dw_N          : in Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T);


   procedure Rt_For_User_Get_Data_Rx
     (Rt            : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data      : in System.Address;
      Dw_N          : out Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T);

-- RT FOR BC

   procedure Rt_For_Bc_Set_Data_Rx
     (Rt        : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id     : in Basic_Types_1553.Sa_Id_T;
      Ptr_Data  : in System.Address;
      Dw_N      : in Basic_Types_I.Unsigned_32_T;
      Result    : out Basic_Types_I.Unsigned_32_T);

   procedure Rt_For_Bc_Get_Data_Tx
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id             : in Basic_Types_1553.Sa_Id_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Count       : out Basic_Types_I.Unsigned_32_T);

   procedure Rt_For_Bc_Get_First_Frame_Tx
     (Rt        : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id     : in Basic_Types_1553.Sa_Id_T;
      Frame     : in out Basic_Types_1553.Sa_Data_Frame_T);



   procedure Rt_For_Bc_Send_Mode_Code
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T;
      Mc_Vector         : in Basic_Types_I.Unsigned_32_T);

   procedure Rt_For_Bc_Send_Pps
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T);

   procedure Rt_For_Bc_Time_Distribution
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T;
      Raw_Time          : in Basic_Types_1553.Raw_Time_Msg_T;
      Error             : out Boolean);
   -- The BC is "sending" to this RT the raw time message. The RT simulates a time
   -- reception reading the current time from the simulation of the HW Clock (epica_simu)



--   procedure Rt_For_Bc_Get_Data_Tx(
--     Rt_For_Bc     : in Bus_1553_Pus_Rt_Record_T;
--     Sa_Id         : in Basic_Types_I.Unsigned_32_T;
--     Ptr_Data      : in System.Address;
--     Dw_N          : out Basic_Types_I.Unsigned_32_T;
--     Result        : out Basic_Types_I.Unsigned_32_T);



-- --------------------------------------------------------------------------------------
-- Operations no defined in the interface: Specific operations for RT HW

   procedure Set_Interrupt_Routines
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Ic1_Handler  : in Lib_Icm_Sw_If_Types.Ic1_Handler_T;
      Ic2_Handler  : in Lib_Icm_Sw_If_Types.Ic2_Handler_T);

   procedure Get_Rx_Sa_Info
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T;
      Tc_N         : out Basic_Types_I.Unsigned_32_T);

   procedure Get_Rx_Sa_First_Tc
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T;
      Tc_Data      : in out Basic_Types_I.Byte_Array_T;
      Last_I       : out Basic_Types_I.Unsigned_32_T);

   procedure Get_Rx_Sa_First_Tc
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T;
      Ptr_Data     : in System.Address;
      Bytes_N      : out Basic_Types_I.Unsigned_32_T);

   procedure Reset_Sa
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T);

private

   type Array_Sa_T is array (Basic_Types_1553.Sa_Id_T'Range)
     of Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;
   Empty_Array_Sa_C       : constant Array_Sa_T       := (others => Null);


   type Bus_1553_Pus_Rt_Record_T is new Bus_1553_Pus_Record_T and
     If_Bus_1553_Pus.If_Bus_1553_Pus_Rt_T with record

      Rt_Id       : Basic_Types_1553.Rt_Id_T;
      Bc_Access   : If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T;
      Array_Tx_Sa : Array_Sa_T;
      Array_Rx_Sa : Array_Sa_T;


      Ic1_Handler  : Lib_Icm_Sw_If_Types.Ic1_Handler_T;
      Ic2_Handler  : Lib_Icm_Sw_If_Types.Ic2_Handler_T;

-- Hoare Monitor for to protect the access to the Tranfer Request Message
      Prot_Transfer_Req    : Prot_Monitor.Prot_Monitor_T;

   end record;

end Bus_1553_Pus.Rt;

