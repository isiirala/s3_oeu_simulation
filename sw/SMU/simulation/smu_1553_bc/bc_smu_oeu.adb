
with Ada.Calendar;
with System;


with Basic_Types_1553;
with Basic_Tools;
with Bus_1553_Pus.Bc;
with Bus_1553_Pus_Types;
with Cuc_Decoder;
with Hw_Clock;
with Byte_Meta_Buffer;
with Debug_Log;
with Smu_1553_Log;
with Smu_Tc_Buffer;


package body Bc_Smu_Oeu is


   Rt_Nominal_C : constant                    := 2;


   package Pkg_Tm_Block_Buff is new Byte_Meta_Buffer
     (Meta_Buffer_Len    => Smu_Data.Max_Tm_Block_In_Buffer_C *
       (Smu_1553_Types.Tm_Block_Info_T'Size / 8),
      Data_Buffer_Len    => Smu_Data.Max_Tm_Block_In_Buffer_C *
        Smu_Data.Max_Tm_Block_Bytes_C,
      User_Meta_Byte_Len => (Smu_1553_Types.Tm_Block_Info_T'Size / 8));


   Bus_Bc_Obj        : Bus_1553_Pus.Bc.Bus_1553_Pus_Bc_T;

   Pkg_Init          : Boolean                                     := False;

   Buff_Result_Copying_Sa_Data : Pkg_Tm_Block_Buff.Buffer_Result_T :=
        Pkg_Tm_Block_Buff.Result_Ok;


   Clock_For_Broadcast : Hw_Clock.Clock_T;
   -- Hw_Clock used for the time message that BC sends in broadcast to all RTs

-- =====================================================================================
-- %% Protected object
-- =====================================================================================

   protected Buff_Protected is

      procedure Init;

      procedure Insert
        (Tm_Block_Info : in Smu_1553_Types.Tm_Block_Info_T;
         Tm_Block      : in Basic_Types_I.Byte_Array_T;
         Result        : out Pkg_Tm_Block_Buff.Buffer_Result_T);

      procedure Retrieve
        (Tm_Block      : in out Basic_Types_I.Byte_Array_T;
         Last_Index    : out Basic_Types_I.Unsigned_32_T;
         Tm_Block_Info : out Smu_1553_Types.Tm_Block_Info_T;
         Result        : out Pkg_Tm_Block_Buff.Buffer_Result_T);

   private

      function Tm_Info_To_Raw
        (Tm_Info     : in Smu_1553_Types.Tm_Block_Info_T)
        return Pkg_Tm_Block_Buff.Meta_Raw_T;

      function Raw_To_Tm_Info
        (Meta_Raw : in Pkg_Tm_Block_Buff.Meta_Raw_T)
        return Smu_1553_Types.Tm_Block_Info_T;

      Tm_Block_Buffer : Pkg_Tm_Block_Buff.Buffer_T;

   end Buff_Protected;

   protected body Buff_Protected is

      function Tm_Info_To_Raw
        (Tm_Info     : in Smu_1553_Types.Tm_Block_Info_T)
        return Pkg_Tm_Block_Buff.Meta_Raw_T
      is
         Local_Info : Smu_1553_Types.Tm_Block_Info_T := Tm_Info;
         Local_Raw  : Pkg_Tm_Block_Buff.Meta_Raw_T;
         for Local_Raw'Address use Local_Info'Address;
      begin
         return Local_Raw;
      end Tm_Info_To_Raw;
-- -------------------------------------------------------------------------------------
      function Raw_To_Tm_Info
        (Meta_Raw : in Pkg_Tm_Block_Buff.Meta_Raw_T)
        return Smu_1553_Types.Tm_Block_Info_T
      is
         Local_Raw  : Pkg_Tm_Block_Buff.Meta_Raw_T         := Meta_Raw;
         Local_Info : Smu_1553_Types.Tm_Block_Info_T;
         for Local_Info'Address use Local_Raw'Address;
      begin
         return Local_Info;
      end Raw_To_Tm_Info;
-- -------------------------------------------------------------------------------------
      procedure Init is
      begin
         Pkg_Tm_Block_Buff.New_Buffer (Tm_Block_Buffer);
      end Init;
-- -------------------------------------------------------------------------------------
      procedure Insert
        (Tm_Block_Info : in Smu_1553_Types.Tm_Block_Info_T;
         Tm_Block      : in Basic_Types_I.Byte_Array_T;
         Result        : out Pkg_Tm_Block_Buff.Buffer_Result_T)
      is
      begin
         Tm_Block_Buffer.Insert
           (Meta_Raw => Tm_Info_To_Raw (Tm_Block_Info),
            Data_Raw => Tm_Block,
            Result   => Result);
      end Insert;
-- -------------------------------------------------------------------------------------
      procedure Retrieve
        (Tm_Block      : in out Basic_Types_I.Byte_Array_T;
         Last_Index    : out Basic_Types_I.Unsigned_32_T;
         Tm_Block_Info : out Smu_1553_Types.Tm_Block_Info_T;
         Result        : out Pkg_Tm_Block_Buff.Buffer_Result_T)
      is
         Meta_Raw  : Pkg_Tm_Block_Buff.Meta_Raw_T :=
           Pkg_Tm_Block_Buff.Null_Meta_Raw_C;
      begin

         Tm_Block_Info := Smu_1553_Types.Null_Tm_Block_Info_C;
         Tm_Block_Buffer.Retrieve
           (Data_Raw   => Tm_Block,
            Last_Index => Last_Index,
            Meta_Raw   => Meta_Raw,
            Result     => Result);
         Tm_Block_Info := Raw_To_Tm_Info (Meta_Raw);

      end Retrieve;
   end Buff_Protected;


-- =====================================================================================
-- %% Internal operations
-- =====================================================================================

-- Callback to copy the TM block of one SA during the process of Retrieve TM
   procedure Copy_Sa_Data_Routine
     (Rt_Id      : in Basic_Types_1553.Rt_Id_T;
      Sa_Id      : in Basic_Types_1553.Sa_Id_T;
      Sa_Data    : in Basic_Types_I.Byte_Array_T)
   is
      use type Pkg_Tm_Block_Buff.Buffer_Result_T;

      Tm_Block_Info  : Smu_1553_Types.Tm_Block_Info_T    :=
        Smu_1553_Types.Null_Tm_Block_Info_C;
      Buff_Result    : Pkg_Tm_Block_Buff.Buffer_Result_T :=
        Pkg_Tm_Block_Buff.Buffer_Result_T'First;
   begin

--      Debug_Log.Do_Log ("[Bc_Smu_Oeu.Copy_Sa_Data_Routine] DataLen:" &
--        Basic_Types_I.Unsigned_32_T'Image (Sa_Data'Length));

      Tm_Block_Info.Rt_Id    := Basic_Types_I.Unsigned_16_T (Rt_Id);
      Tm_Block_Info.Sa_Id    := Basic_Types_I.Unsigned_16_T (Sa_Id);
      Tm_Block_Info.Time_Tag := Ada.Calendar.Clock;

      Buff_Protected.Insert
        (Tm_Block_Info => Tm_Block_Info,
         Tm_Block      => Sa_Data,
         Result        => Buff_Result);

      if Buff_Result /= Pkg_Tm_Block_Buff.Result_Ok then
         Debug_Log.Do_Log ("[Bc_Smu_Oeu.Copy_Sa_Data_Routine]: " &
           "Error copying SA Data. Buff_Result: " & String (
           Pkg_Tm_Block_Buff.Buffer_Result_To_Str_C (Buff_Result)));
      end if;
   end Copy_Sa_Data_Routine;



-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Init
     (Bc_Access_For_Rts : out
       If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T)
   is
      Bc_Result  : Basic_Types_I.Uint32_T     := 0;
   begin

-- Create the bus 1553 bus controller
      Bus_1553_Pus.Bc.Create_New
        (Bc        => Bus_Bc_Obj,
         Bus_Id    => 1,
         Bus_Title => "SMU-OLCI  ");

      Bc_Access_For_Rts := If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T (Bus_Bc_Obj);

      if not Pkg_Init then
         Buff_Protected.Init;
         Pkg_Init := True;
      end if;

-- --------------------------------------------------------------------------------------
-- Create the Hw_Clock used for the time message that BC sends in broadcast to all RTs.
-- Init this Clock with the current clock time of the host machine
      Hw_Clock.Init
        (Debug_Proc => Debug_Log.Do_Log'Access,
         Clock      => Clock_For_Broadcast);

       Hw_Clock.Set_Time
         (Time  => Cuc_Decoder.Time_To_Cuc (Ada.Calendar.Clock),
          Clock => Clock_For_Broadcast);
-- --------------------------------------------------------------------------------------

   end Init;


   procedure Do_Retrieve_Tm
     (Limit_Bytes  : in Basic_Types_I.Unsigned_32_T;
      Actual_Bytes : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Bc_Result         : Basic_Types_I.Unsigned_32_T := 0;
   begin
      Actual_Bytes := 0;

      Bus_Bc_Obj.Bc_For_User_Retrieve
        (Copy_Sa_Data_Proc => Copy_Sa_Data_Routine'Access,
         Bytes_Limit       => Limit_Bytes,
         Bytes_Actual      => Actual_Bytes,
         Result            => Bc_Result);

      if Bc_Result /= Bus_1553_Pus_Types.Ok_Result_C then
         Debug_Log.Do_Log ("[bc_smu_oeu.adb Do_Retrieve_Tm]: " &
           "Error retrieving. Bc_Result:" & Debug_Log.U32_To_Str (Bc_Result));
      end if;

   end Do_Retrieve_Tm;



   procedure Get_A_Tm_Block
     (Tm_Block_Data  : in out Smu_1553_Types.Tm_Block_Container_T;
      Last_Index     : out Basic_Types_I.Unsigned_32_T;
      Tm_Block_Info  : out Smu_1553_Types.Tm_Block_Info_T)
   is
      use type Pkg_Tm_Block_Buff.Buffer_Result_T;

      Buff_Result : Pkg_Tm_Block_Buff.Buffer_Result_T  :=
        Pkg_Tm_Block_Buff.Buffer_Result_T'First;
   begin

      Last_Index    := 0;
      Tm_Block_Info := Smu_1553_Types.Null_Tm_Block_Info_C;

      Buff_Protected.Retrieve
        (Tm_Block      => Tm_Block_Data,
         Last_Index    => Last_Index,
         Tm_Block_Info => Tm_Block_Info,
         Result        => Buff_Result);

      if Buff_Result /= Pkg_Tm_Block_Buff.Result_Ok then
         Last_Index    := 0;
         Tm_Block_Info := Smu_1553_Types.Null_Tm_Block_Info_C;

         if Buff_Result /= Pkg_Tm_Block_Buff.Result_Meta_Empty then
            Debug_Log.Do_Log ("[bc_smu_oeu.adb Get_A_Tm_Block]: " &
              "Error retrieving next TM Block. Buff_Result: " & String (
              Pkg_Tm_Block_Buff.Buffer_Result_To_Str_C (Buff_Result)));
         end if;
      end if;
   end Get_A_Tm_Block;


   procedure Ack_Retrieved_Tms is
   begin

--  When the TM block of a SA is received by the BC, the BC sets the corresponding
--  bit in the Transfer ACK message to inform to that RT that the SA can be used to
--  transmit another TM block

      Bus_Bc_Obj.Bc_For_User_Send_Transfer_Ack;
  end Ack_Retrieved_Tms;




   procedure Transmit_Tcs
   is
      use type Basic_Types_I.Unsigned_32_T;


      Max_Tc_N_C      : constant Basic_Types_I.Unsigned_32_T := 10;

      Tc_Buffer       : Smu_Data.Tc_Buffer_Data_T   := Smu_Data.Empty_Tc_Buffer_Data_C;
      Bc_Result       : Basic_Types_I.Unsigned_32_T := 0;
      Dw_N            : Basic_Types_I.Unsigned_32_T := 0;
      Tc_Ptr          : System.Address              := System.Null_Address;
      Tc_Send_Counter : Basic_Types_I.Unsigned_32_T := 0;
   begin

-- TODO: COMO ELEGIR RT: N ó R ???
-- TODO: USAR LIMITES
-- TODO: DE MOMENTO SÓLO MANDA LOS TC PARA RT 2

      loop

         Smu_Tc_Buffer.Retrieve_Tc_Block
           (Rt_Id      => Rt_Nominal_C,
            Tc_Data    => Tc_Buffer);

         if Tc_Buffer.Last_Index > 0 then

            Dw_N    := Tc_Buffer.Last_Index / 2;
            Tc_Ptr  := Tc_Buffer.Tc_Block'Address;

            Debug_Log.Do_Log ("[Bc_Smu_Oeu.Transmit_Tcs]SA:" &
              Debug_Log.U8_To_Str (Tc_Buffer.Metadata.Sa_Id) &
              " Dw_N:" & Debug_Log.U32_To_Str (Dw_N));

            Bus_Bc_Obj.Bc_For_User_Set_Data_Tx
              (Rt_Id       => Rt_Nominal_C,
               Sa_Id       => Basic_Types_I.Unsigned_32_T (Tc_Buffer.Metadata.Sa_Id),
               Ptr_Data    => Tc_Ptr,
               Dw_N        => Dw_N,
               Result      => Bc_Result);

            Tc_Buffer.Metadata.Time_Tag := Ada.Calendar.Clock;

            if Bc_Result = Bus_1553_Pus_Types.Ok_Result_C then
               Smu_1553_Log.Decode_Tc (Tc_Buffer);
            else
               Debug_Log.Do_Log ("[Bc_Smu_Oeu.Transmit_Tcs]Error in TX. SA:" &
                 Debug_Log.U8_To_Str (Tc_Buffer.Metadata.Sa_Id) &
                 " Bc_Result:" & Debug_Log.U32_To_Str (Bc_Result));
            end if;
            Tc_Send_Counter := Tc_Send_Counter + 1;
         end if;
         exit when (Tc_Send_Counter >= Max_Tc_N_C) or (Tc_Buffer.Last_Index = 0);
      end loop;
   end Transmit_Tcs;


   procedure Send_Sync_With_Data_Word
   is
      Bit_Sync_With_Data_C : constant Basic_Types_I.Unsigned_32_T    := 16;
      -- Sync With Data Word Mode Code position in INT_PEND_MODE_CODE EPICA register

   begin

-- TODO: COMO ELEGIR RT: N ó R ???
      Bus_Bc_Obj.Bc_For_User_Send_Mode_Code
        (Rt_Id       => Rt_Nominal_C,
         Mc_Vector   => Bit_Sync_With_Data_C);

   end Send_Sync_With_Data_Word;


   procedure Send_Pps
   is

   begin

-- TODO: COMO ELEGIR RT: N ó R ???
      Bus_Bc_Obj.Bc_For_User_Send_Pps
        (Rt_Id       => Rt_Nominal_C);

   end Send_Pps;



   procedure Time_Distribution
   is
      Raw_Time_Msg    : Basic_Types_1553.Raw_Time_Msg_T  := (others => 0);
      Tc_Buffer       : Smu_Data.Tc_Buffer_Data_T   := Smu_Data.Empty_Tc_Buffer_Data_C;
   begin

-- TODO: COMO ELEGIR RT: N ó R ???    O QUITAR ESTE PARAMETRO. EL PROBLEMA ES QUE EL BC NO SABE POR EJEMPLO QUE RT 2 Y 18 ES EL MISMO
-- O DA IGUAL QUE LO REPITA ???

      Raw_Time_Msg := Basic_Types_1553.To_Raw_Time_Msg
        (Hw_Clock.Get_Time (Clock_For_Broadcast));

      Bus_Bc_Obj.Bc_For_User_Time_Distribution
        (Rt_Id          => Rt_Nominal_C,
         Raw_Time_Msg   => Raw_Time_Msg);


      Tc_Buffer.Tc_Block (1 .. Basic_Types_1553.Raw_Time_Msg_Len_C) := Raw_Time_Msg;
      Tc_Buffer.Last_Index := Basic_Types_1553.Raw_Time_Msg_Len_C;

      Tc_Buffer.Metadata.Sa_Id    := 16;
      Tc_Buffer.Metadata.Time_Tag := Ada.Calendar.Clock;
      Smu_1553_Log.Decode_Tc (Tc_Buffer);

   end Time_Distribution;


end Bc_Smu_Oeu;

