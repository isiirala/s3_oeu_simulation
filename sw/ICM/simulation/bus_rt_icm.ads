

with System;


with Basic_Types_I;
--with Bus_1553_Pus.Bc;
with If_Bus_1553_Pus;
with Lib_Icm_Sw_If_Types;

package Bus_Rt_Icm is

   procedure Init
     (Bc_Access   : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T);

   procedure Connect_Interrupt_Routines
     (Ic1_Handler : in Lib_Icm_Sw_If_Types.Ic1_Handler_T;
      Ic2_Handler : in Lib_Icm_Sw_If_Types.Ic2_Handler_T);


   procedure Bus_1553_Init_Sa_Raw
     (Sa_Id     : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Tx_Or_Rx  : in Boolean;
      Msg_N     : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Result    : out Lib_Icm_Sw_If_Types.Uint32_T); --Basic_Types_I.Unsigned_32_T);
   -- Routine for the onboard SW to initialise a SA

   procedure Bus_1553_Tx_Sa_Raw
     (Sa_Id    : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Ptr_Data : in System.Address;
      Dw_N     : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Result   : out Lib_Icm_Sw_If_Types.Uint32_T); --Basic_Types_I.Unsigned_32_T);
   -- Routine for the onboard SW to transmit an output SA

   procedure Bus_1553_Rx_Sa_Raw
     (Sa_Id    : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Ptr_Data : in System.Address;
      Dw_N     : out Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Result   : out Lib_Icm_Sw_If_Types.Uint32_T); --Basic_Types_I.Unsigned_32_T);
   -- Routine for the onboard SW to receive an input SA

   procedure Bus_1553_Pus_Rx_Sa_Info
     (Sa_Id_Raw : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Tc_N      : out Lib_Icm_Sw_If_Types.Uint32_T); --Basic_Types_I.Unsigned_32_T);
   -- Routine for the onboard SW to get information about an input SA

   procedure Bus_1553_Pus_Rx_Sa_First_Tc
     (Sa_Id_Raw : in Lib_Icm_Sw_If_Types.Uint32_T; --Basic_Types_I.Unsigned_32_T;
      Data_Addr : in System.Address; --Tc_Data   : in out Basic_Types_I.Byte_Array_T;
      Bytes_N   : out Lib_Icm_Sw_If_Types.Uint32_T); --Last_I    : out Basic_Types_I.Unsigned_32_T);
   -- Routine for the onboard SW to get the first TC stored in the input SA

   procedure Bus_1553_Pus_Sa_Reset
     (Sa_Id_Raw : in Lib_Icm_Sw_If_Types.Uint32_T); --Basic_Types_I.Unsigned_32_T);
   -- Routine for the onboard SW to reset the input SA when all TCs are read

end Bus_Rt_Icm;

