
with System;

with Basic_Types_1553;
with Basic_Types_I;

package Bus_1553_Pus_Types is


   subtype Sa_Tm_Transfer_T is Basic_Types_1553.Sa_Id_T            range 1 .. 12;
   -- SA range in the TM Transfer request message

   type Array_Sa_Bool_T is array (Basic_Types_1553.Sa_Id_T'Range) of Boolean;
   Array_Sa_Bool_C       : constant Array_Sa_Bool_T       := (others => False);


   type Debug_Proc_T is access procedure (Str : in String);


-- --------------------------------------------------------------------------------------
-- Return results codes (begin)
--
-- Return results of the operations. Invalid_Sa_Status is returned when Tx in a
-- non free SA o Rx from a free SA
   Ok_Result_C                : constant Basic_Types_I.Unsigned_32_T  :=
     16#04000001#;
--  Bus_Nok_Bad_Sa_C
   Ko_Invalid_Sa_C            : constant Basic_Types_I.Unsigned_32_T  :=
     16#04000053#;
--  Bus_Nok_Bad_Len_C
   Ko_Invalid_Len_C           : constant Basic_Types_I.Unsigned_32_T  :=
     16#04000012#;
--  Bus_Nok_Not_Inited_C
   Ko_Use_But_Not_Init_C      : constant Basic_Types_I.Unsigned_32_T  :=
     16#0400009B#;
--  Bus_Nok_Not_Declared_In_Bc_C
   Ko_Rt_Not_Declared_In_Bc_C : constant Basic_Types_I.Unsigned_32_T  :=
     16#0400009C#;

--   Bus_Nok_Interf_Fail_C. Internal error in the BUS if
   Ko_Internal_If_C           : constant Basic_Types_I.Unsigned_32_T :=
     16#04000000#;

--  Below the error conditions not supported by Onboard SW (start from 040100000):

--  Error status not supported by Onboard SW, starts from 040100000

   Ko_Invalid_Sa_Status_C    : constant Basic_Types_I.Unsigned_32_T  := 16#040100001#;

   Ko_Unable_Write_Sa_C      : constant Basic_Types_I.Unsigned_32_T  := 16#040100002#;
   -- Unable to write data in the data buffer of a SA, normally if it is full

   Ko_Invalid_Rt_C           : constant Basic_Types_I.Unsigned_32_T  := 16#040100003#;
   -- Error when selected RT is not initialised or in error

--   Ko_From_Bc_To_Rt_C        : constant Basic_Types_I.Unsigned_32_T  := 16#040100003#;
   -- Error when a RT operation uses a BC operation that returns error




--   Bus_Nok_Bad_Addr_C    : constant := 16#04000011#;
--   Bus_Nok_Bad_Align_C   : constant := 16#04000019#;
--   Bus_Nok_Test_Failed_C : constant := 16#0400009A#;

-- Return results codes (end)
-- --------------------------------------------------------------------------------------

   type Sa_Rx_Pendings_Handler_T is access procedure
     (Arr_Sa_Rx    : in Basic_Types_I.Unsigned_32_T);

   type Mc_Pendings_Handler_T is access procedure
     (Arr_Mc       : in Basic_Types_I.Unsigned_32_T);


--     (Epica_Eint_Int_Pend_Reg : in U32_T;
--      Epica_Int_Alarm_Reg     : in U32_T;
--      Epica_Int_Pend_Rx_Reg   : in U32_T;
--      Epica_Int_Pend_Mc_Reg   : in U32_T);




--   type Write_Input_Sa_Cb_T is access procedure
--     (Sa_Id     : in Sa_Id_T;
--      Ptr_Data  : in System.Address;
--      Dw_N      : in Basic_Types_I.Unsigned_32_T);
   -- Callback routine type provided by each RT to the BC in the declaration routine.
   -- The BC uses it to write 1553 messges in the input SAs of the RT


-- --------------------------------------------------------------------------------------
--  Transfer Request message
-- --------------------------------------------------------------------------------------

   type Trans_Request_Sa_T is record
      Num_Frames        : Basic_Types_I.Unsigned_5_T;
      Num_Dw_Last_Frame : Basic_Types_I.Unsigned_5_T;
   end record;

-- The bits range is the opposite... because the different endians?
   for Trans_Request_Sa_T use record
      Num_Frames        at 0 range 0 .. 4;
      Num_Dw_Last_Frame at 1 range 0 .. 4;
   end record;
   pragma Pack(Trans_Request_Sa_T);
   for Trans_Request_Sa_T'Size use (16);


   type Trans_Request_T is array(Sa_Tm_Transfer_T'Range) of Trans_Request_Sa_T;
   pragma Pack(Trans_Request_T);

-- --------------------------------------------------------------------------------------
--  Transfer Ack message
-- --------------------------------------------------------------------------------------
   type Trans_Ack_Sa_T is record
      Ack_Bit        : Basic_Types_I.Unsigned_1_T;
      Rest           : Basic_Types_I.Unsigned_15_T;
   end record;

   for Trans_Ack_Sa_T use record
      Ack_Bit        at 0 range 15 .. 15;
      Rest           at 0 range 0 .. 14;
   end record;
   pragma Pack(Trans_Ack_Sa_T);
   for Trans_Ack_Sa_T'Size use (16);

   Empty_Trans_Ack_Sa_C  : constant Trans_Ack_Sa_T  :=
     (Ack_Bit   => 0,
      Rest      => 0);

   type Trans_Ack_T is array(Sa_Tm_Transfer_T'Range) of Trans_Ack_Sa_T;
   pragma Pack(Trans_Ack_T);

   Empty_Trans_Ack_C  : constant Trans_Ack_T := (others => Empty_Trans_Ack_Sa_C);






end Bus_1553_Pus_Types;

