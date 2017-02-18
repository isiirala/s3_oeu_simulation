

with Interfaces.C;

with Basic_Tools;


with Debug_Log;



package body Bus_1553_Pus.Rt is




--   subtype Rx_Sa_T is Bus_1553_Pus_Types.Sa_Id_T range
--     Rx_Min_Sa .. Rx_Max_Sa;
--   subtype Tx_Sa_T is Bus_1553_Pus_Types.Sa_Id_T range
--     Tx_Min_Sa .. Tx_Max_Sa;

--   subtype Rx_Message_Range_T is Basic_Types_I.Unsigned_32_T range
--     1 .. Rx_Max_Message_Len;
--   subtype Tx_Message_Range_T is Basic_Types_I.Unsigned_32_T range
--     1 .. Tx_Max_Message_Len;

--   subtype Rx_Message_Max_T is Basic_Types_I.Byte_Array_T
--     (Rx_Message_Range_T'Range);
--   subtype Tx_Message_Max_T is Basic_Types_I.Byte_Array_T
--     (Tx_Message_Range_T'Range);

--   type Rx_Data_T is record
--      Used              : Boolean;
--      Data              : Rx_Message_Max_T;
--      Data_Len          : Rx_Message_Range_T;
--      Data_Free         : Boolean;
---- Number of 1553 frames before interrupt
--      Frames_Before_Int : Basic_Types_I.Unsigned_32_T;
--   end record;
--   type Rx_Arr_Messages_T is array(Rx_Sa_T'Range) of Rx_Data_T;

--   type Tx_Data_T is record
--      Used              : Boolean;
--      Data              : Tx_Message_Max_T;
--      Data_Len          : Tx_Message_Range_T;
--      Data_Free         : Boolean;
---- Number of 1553 frames before interrupt
--      Frames_Before_Int : Basic_Types_I.Unsigned_32_T;
--   end record;
--   type Tx_Arr_Messages_T is array(Tx_Sa_T'Range) of Tx_Data_T;
--
--   Rx_Arr_Messages : Rx_Arr_Messages_T :=
--     (others => (
--       Used              => False,
--       Data              => (others => 0),
--       Data_Len          => Rx_Message_Range_T'First,
--       Data_Free         => True,
--       Frames_Before_Int => 0));
--
--   Tx_Arr_Messages : Tx_Arr_Messages_T :=
--     (others => (
--       Used              => False,
--       Data              => (others => 0),
--       Data_Len          => Tx_Message_Range_T'First,
--       Data_Free         => True,
--       Frames_Before_Int => 0));


   Bit_Int_1553_C       : constant Lib_Icm_Sw_If_Types.Uint32_T   := 1;
   Bit_Rt_Mode_Code_C   : constant Lib_Icm_Sw_If_Types.Uint32_T   := 128;



-- ============================================================================
-- %% Internal operations
-- ============================================================================

   procedure U32_To_Empty_Sa
     (Sa_Id_Raw : in Basic_Types_I.Unsigned_32_T;
      Sa_Id     : out Basic_types_1553.Sa_Id_T;
      Error     : out Boolean)
   -- Convert a raw U32 into a Basic_types_1553.Sa_Id_T
   is
      use type Basic_Types_I.Unsigned_32_T;

   begin
      Sa_Id   := Basic_types_1553.Sa_Id_T'First;
      Error   := True;

      if Sa_Id_Raw >= Basic_types_1553.Sa_Id_T'First and then
        Sa_Id_Raw <= Basic_types_1553.Sa_Id_T'Last then

         Sa_Id := Basic_types_1553.Sa_Id_T (Sa_Id_Raw);
         Error := False;
      end if;
   end U32_To_Empty_Sa;

   procedure U32_To_Tx_Sa
     (Rt        : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id_Raw : in Basic_Types_I.Unsigned_32_T;
      Tx_Sa     : out Basic_types_1553.Sa_Id_T;
      Error     : out Boolean)
   -- Convert a raw U32 into a Basic_types_1553.Sa_Id_T and check if this SA is declared
   -- as TX SA in current RT
   is
      use type Basic_Types_I.Unsigned_32_T;
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

   begin
      Tx_Sa   := Basic_types_1553.Sa_Id_T'First;
      Error   := True;

      if Sa_Id_Raw >= Basic_types_1553.Sa_Id_T'First and then
        Sa_Id_Raw <= Basic_types_1553.Sa_Id_T'Last then

         Tx_Sa := Basic_types_1553.Sa_Id_T (Sa_Id_Raw);

         if Rt.Array_Tx_Sa (Tx_Sa) /= Null then
            Error := False;
         end if;
      end if;
   end U32_To_Tx_Sa;


   procedure U32_To_Rx_Sa
     (Rt        : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id_Raw : in Basic_Types_I.Unsigned_32_T;
      Rx_Sa     : out Basic_types_1553.Sa_Id_T;
      Error     : out Boolean)
   -- Convert a raw U32 into a Basic_types_1553.Sa_Id_T and check if this SA is declared
   -- as RX SA in current RT
   is

      use type Basic_Types_I.Unsigned_32_T;
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

   begin
      Rx_Sa   := Basic_types_1553.Sa_Id_T'First;
      Error   := True;

      if Sa_Id_Raw >= Basic_types_1553.Sa_Id_T'First and then
        Sa_Id_Raw <= Basic_types_1553.Sa_Id_T'Last then

         Rx_Sa := Basic_types_1553.Sa_Id_T (Sa_Id_Raw);
         if Rt.Array_Rx_Sa (Rx_Sa) /= Null then
            Error := False;
         end if;
      end if;
   end U32_To_Rx_Sa;


--     procedure Get_Data_Rx
--       (Rt       : not null access Bus_1553_Pus_Rt_Record_T;
--        Rx_Sa    : in Basic_types_1553.Sa_Id_T;
--        Ptr_Data : in System.Address;
--        Dw_N     : out Basic_Types_I.Unsigned_32_T;
--        Result   : out Basic_Types_I.Unsigned_32_T)
--     is
--        use type Basic_Types_I.Unsigned_32_T;
--        use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;
--
--     begin
--
--        Dw_N   := 0;
--        Result := Bus_1553_Pus_Types.Ok_Result_C;
--
--        if Rt.Array_Rx_Sa (Rx_Sa) /= Null then
--           if not Rt.Array_Rx_Sa (Rx_Sa).Data_Empty then
--
--              declare
--                 Byte_Len_C    : constant Basic_Types_I.Unsigned_32_T :=
--                   Rt.Array_Rx_Sa (Rx_Sa).Used_Len;
--
--                 Local_Data    : Basic_Types_I.Byte_Array_T
--                   (1 .. Byte_Len_C);
--                 for Local_Data'Address use Ptr_Data;
--              begin
--
--                 Debug_Log.Do_Log (" Bus_1553_Pus.Rt.Get_Data_Rx SA:" &
--                   Basic_types_1553.Sa_Id_T'Image (Rx_Sa) & " Len:" &
--                   Bus_1553_Pus.Rt_Sa.Sa_Data_Range_T'Image (Byte_Len_C) & " ");
--
--                 Dw_N := Byte_Len_C / 2;
--
--                 Local_Data := Rt.Array_Rx_Sa (Rx_Sa).Sa_Data (1 .. Byte_Len_C);
--              end;
--
--              Rt.Array_Rx_Sa (Rx_Sa).Data_Empty      := True;
--              Rt.Array_Rx_Sa (Rx_Sa).Used_Len        := 1;
--              Rt.Array_Rx_Sa (Rx_Sa).Current_Frames_N := 0;
--
--  --         else
--  --            Result := Bus_1553_Pus_Types.Ko_Invalid_Sa_Status_C;
--           end if;
--        else
--
--  -- This SA is not initialised
--           Result := Bus_1553_Pus_Types.Ko_Invalid_Sa_Status_C;
--        end if;
--
--     end Get_Data_Rx;
--
--
--     procedure Set_Data_Rx
--       (Rt       : not null access Bus_1553_Pus_Rt_Record_T;
--        Rx_Sa    : in Basic_types_1553.Sa_Id_T;
--        Ptr_Data : in System.Address;
--        Dw_N     : in Basic_Types_I.Unsigned_32_T;
--        Result   : out Basic_Types_I.Unsigned_32_T)
--     is
--        use type Basic_Types_I.Unsigned_32_T;
--
--     begin
--
--        Result := Bus_1553_Pus_Types.Ok_Result_C;
--
--        if not Rt.Array_Rx_Sa (Rx_Sa).Data_Empty then
--
--           Debug_Log.Do_Log (" Bus_1553_Pus.Rt.Set_Data_Rx write RX SA, but it is not" &
--             " empty (not read by the RT). SA: " &
--             Basic_types_1553.Sa_Id_T'Image (Rx_Sa) & " ");
--        end if;
--
--        declare
--           Byte_Len_C    : constant Basic_Types_I.Unsigned_32_T := Dw_N * 2;
--
--           Local_Data    : Basic_Types_I.Byte_Array_T (1 .. Byte_Len_C);
--           for Local_Data'Address use Ptr_Data;
--        begin
--
--          Debug_Log.Do_Log (" Bus_1553_Pus.Rt.Set_Data_Rx SA:" &
--             Basic_types_1553.Sa_Id_T'Image (Rx_Sa) & " Len:" &
--             Bus_1553_Pus.Rt_Sa.Sa_Data_Range_T'Image (Byte_Len_C) & " ");
--
--          Rt.Array_Rx_Sa (Rx_Sa).Sa_Data (1 .. Byte_Len_C) := Local_Data;
--          Rt.Array_Rx_Sa (Rx_Sa).Data_Empty                := False;
--          Rt.Array_Rx_Sa (Rx_Sa).Used_Len                  := Byte_Len_C;
--        end;
--
--     end Set_Data_Rx;



--   procedure Write_Input_Sa_Cb
--     (Sa_Id     : in Bus_1553_Pus_Types.Sa_Id_T;
--      Ptr_Data  : in System.Address;
--      Dw_N      : in Basic_Types_I.Unsigned_32_T)
--   is
--   begin
--
--    if Rt.Array_Tx_Sa (Tx_Sa) /= Null then
---- If a SA is not initialised, it cannot be used to Tx, but none error is
---- reported.
--
--   null;
--   end Write_Input_Sa_Cb;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Create_New
     (Rt_Id       : in Basic_types_1553.Rt_Id_T;
      Bc_Access   : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T;
      Rt          : out Bus_1553_Pus_Rt_T;
      Result      : out Basic_Types_I.Unsigned_32_T)
   is
   begin
      Rt := new Bus_1553_Pus_Rt_Record_T;
      Initialize
        (Rt        => Rt,
         Rt_Id     => Rt_Id,
         Bc_Access => Bc_Access,
         Result    => Result);
   end Create_New;

   procedure Initialize
     (Rt          : not null access Bus_1553_Pus_Rt_Record_T'Class;
      Rt_Id       : in Basic_types_1553.Rt_Id_T;
      Bc_Access   : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T;
      Result      : out Basic_Types_I.Unsigned_32_T)
   is
   begin
      if not Rt.User_Init then

-- todo: llevar esta inicialización a cuando lo inicializa el sw de vuelo
--         for I in Bus_1553_Pus_Types.Sa_Id_T'Range loop
--            if (Rx_Sa_Used (I)) then
--               Bus_1553_Pus.Rt_Sa.Create_New
--                 (Sa                => Rx_Sa (I),
--                  Sa_Id             => I,
--                  Frames_Before_Int => );
--            end if;
--            if (Tx_Sa_Used (I)) then
--               Bus_1553_Pus.Rt_Sa.Create_New
--                 (Sa                => Tx_Sa (I),
--                  Sa_Id             => I,
--                  Frames_Before_Int => );
--            end if;
--         end loop;


-- TODO: CHEQUEAR QUE Rt_Id ESTÁ LIBRE, QUE NO HA SIDO DECLARADO PREVIAMENTE EN EL BC

         Rt.User_Init   := True;
         Rt.Rt_Id       := Rt_Id;
         Rt.Bc_Access   := Bc_Access;
         Rt.Array_Tx_Sa := Empty_Array_Sa_C;
         Rt.Array_Rx_Sa := Empty_Array_Sa_C;
         Rt.Ic1_Handler := null;
         Rt.Ic2_Handler := null;

         Rt.Bc_Access.Bc_For_Rt_Declare_Rt
           (Rt_Id             => Rt_Id,
            Rt                => Rt);
--            Write_Input_Sa_Cb => Write_Input_Sa_Cb'Access);

         Result                := Bus_1553_Pus_Types.Ok_Result_C;
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.Rt Initialize]RemoteTerminal " &
           Basic_types_1553.Rt_Id_T'Image (Rt_Id) & " Initialized");
      else
         Result                := Bus_1553_Pus_Types.Ko_Use_But_Not_Init_C;
         Debug_Log.Do_Log ("[Bus_1553_Pus.Rt Initialize] Fail init RT:" &
           Basic_types_1553.Rt_Id_T'Image (Rt_Id) & " is init yet");
      end if;
   end Initialize;

--   procedure Rt_For_User_Init
--     (Rt_Id         : in Bus_1553_Pus_Types.Rt_Id_T;
--      Bc_Access     : in If_Bus_1553_Pus_Bc_For_Rt.Bus_1553_Pus_Bc_For_Rt_T;
--      Rt_For_User   : in out Bus_1553_Pus_Rt_Record_T;
--      Result        : out Basic_Types_I.Unsigned_32_T) is
--   begin
--      if not Rt_For_User.User_Init then
--         Rt_For_User.Rt_Id     := Rt_Id;
--         Rt_For_User.Bc_Access := Bc_Access;
--         Rt_For_User.User_Init := True;
--
--         Rt_For_User.Bc_Access.Bc_For_Rt_Declare_Rt
--           (Rt_Id   => Rt_Id);
--
--         Result                := Ok_Result;
--
--         Debug_Proc(" Bus_1553_Pus.Rt.Rt_For_User_Init ");
--      else
--         Result                := Fail_Use_But_Not_Init;
--      end if;
--   end Rt_For_User_Init;


   procedure Rt_For_User_Set_Transaction
     (Rt            : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Tx_Or_Rx      : in Boolean;
      Msg_N         : in Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T)
   is

      Sa_Id         : Basic_types_1553.Sa_Id_T   := Basic_types_1553.Sa_Id_T'First;
      Invalid_Sa    : Boolean                    := False;
   begin

      Result := Bus_1553_Pus_Types.Ok_Result_C;

      if not Rt.User_Init then
         Result    := Bus_1553_Pus_Types.Ko_Use_But_Not_Init_C;
      else

         if Tx_Or_Rx then

            U32_To_Empty_Sa
              (Sa_Id_Raw => Sa_Raw_Id,
               Sa_Id     => Sa_Id,
               Error     => Invalid_Sa);
            if Invalid_Sa then
               Result := Bus_1553_Pus_Types.Ko_Invalid_Sa_C;
            else
               Bus_1553_Pus.Rt_Sa.Create_New
                 (Sa                => Rt.Array_Tx_Sa (Sa_Id),
                  Sa_Id             => Sa_Id,
                  Frames_Before_Int => Msg_N);

--               Debug_Log.Do_Log (" Rt_For_User_Set_Transaction TX SA:" &
--                 Basic_types_1553.Sa_Id_T'Image (Sa_Id));
            end if;
         else

            U32_To_Empty_Sa
              (Sa_Id_Raw => Sa_Raw_Id,
               Sa_Id     => Sa_Id,
               Error     => Invalid_Sa);
            if Invalid_Sa then
               Result := Bus_1553_Pus_Types.Ko_Invalid_Sa_C;
            else
               Bus_1553_Pus.Rt_Sa.Create_New
                 (Sa                => Rt.Array_Rx_Sa (Sa_Id),
                  Sa_Id             => Sa_Id,
                  Frames_Before_Int => Msg_N);

--               Debug_Log.Do_Log (" Rt_For_User_Set_Transaction RX SA:" &
--                 Basic_types_1553.Sa_Id_T'Image (Sa_Id));
            end if;
         end if;
      end if;
   end Rt_For_User_Set_Transaction;


   procedure Rt_For_User_Set_Data_Tx
     (Rt            : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Raw_Id     : in Basic_Types_I.Uint32_T;
      Ptr_Data      : in System.Address;
      Dw_N          : in Basic_Types_I.Uint32_T;
      Result        : out Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

      Tx_Sa         : Basic_types_1553.Sa_Id_T     := Basic_types_1553.Sa_Id_T'First;
      Sa_Error      : Boolean                      := False;

      Frames_Latch  : Boolean                      := False;
      Sa_Result     : Basic_Types_I.Uint32_T       := Bus_1553_Pus_Types.Ok_Result_C;

      Sa_Acc        : If_Bus_1553_Pus.Acc_Bus_1553_Pus_Sa_T := null;


   begin

      Result := Bus_1553_Pus_Types.Ok_Result_C;

      if not Rt.User_Init then
         Result  := Bus_1553_Pus_Types.Ko_Use_But_Not_Init_C;
      else

-- Convert raw SA identifier to a valid enumerated one
         U32_To_Tx_Sa
           (Rt        => Rt,
            Sa_Id_Raw => Sa_Raw_Id,
            Tx_Sa     => Tx_Sa,
            Error     => Sa_Error);

         if Sa_Error then
            Result := Bus_1553_Pus_Types.Ko_Invalid_Sa_C;
         else

-- If SA = 15 we are updating the Transfer Request Msg, then use the Hoare Monitor.
-- And empty the SA first because the new Transfer Request update the old one
            if Tx_Sa = 15 then
--               Rt.Prot_Transfer_Req.Wait_Acquire;
               Rt.Array_Tx_Sa (Tx_Sa).Set_As_Empty;
            end if;

-- Append data to SA buffer. Frames latch is not used in TX
            Rt.Array_Tx_Sa (Tx_Sa).Append_Data
              (Ptr_Data     => Ptr_Data,
               Dw_N         => Dw_N,
               Frames_Latch => Frames_Latch,
               Result       => Sa_Result);

-- If SA = 15 we are updating the Transfer Request Msg, then use the Hoare Monitor
--            if Tx_Sa = 15 then
--               Rt.Prot_Transfer_Req.Release;
--            end if;


            if Sa_Result = Bus_1553_Pus_Types.Ok_Result_C then

-- Inform to the BC that this SA have a new message. NOT NECESSARY EXCEPT FOR THE
-- WRAP AROUND TEST, because the BC make the retrieve of the Transfer Request before
-- the retrieve of TMs
--               Rt.Bc_Access.Bc_For_Rt_Set_Data_Tx
--                 (Rt_Id     => Rt.Rt_Id,
--                  Sa        => Rt.Array_Tx_Sa (Tx_Sa));
null;

            else
               Result := Bus_1553_Pus_Types.Ko_Unable_Write_Sa_C;
               Debug_Log.Do_Log
                 ("[Bus_1553_Pus.Rt Rt_For_User_Set_Data_Tx] Error appening data to " &
                  "the SA: " & Basic_types_1553.Sa_Id_T'Image (Tx_Sa) &
                  " Dw_N:" & Basic_Types_I.Uint32_T'Image (Dw_N) & " ");
            end if;
         end if;
      end if;
   end Rt_For_User_Set_Data_Tx;


   procedure Rt_For_User_Get_Data_Rx
     (Rt            : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data      : in System.Address;
      Dw_N          : out Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

      Sa_Error      : Boolean                      := False;
      Rx_Sa         : Basic_types_1553.Sa_Id_T     := Basic_types_1553.Sa_Id_T'First;

   begin
      Dw_N   := 0;
      Result := Bus_1553_Pus_Types.Ok_Result_C;

      if not Rt.User_Init then
         Result  := Bus_1553_Pus_Types.Ko_Use_But_Not_Init_C;
      else

         U32_To_Rx_Sa
           (Rt        => Rt,
            Sa_Id_Raw => Sa_Raw_Id,
            Rx_Sa     => Rx_Sa,
            Error     => Sa_Error);

         if not Sa_Error then

            if Rt.Array_Rx_Sa (Rx_Sa) /= Null then

-- If the SA is not initialised, it cannot be used to Rx, but none error is
-- reported.
               Rt.Array_Rx_Sa (Rx_Sa).Retrieve_All_Data
                 (Ptr_Data => Ptr_Data,
                  Dw_N     => Dw_N);
--               Get_Data_Rx
--                 (Rt       => Rt,
--                  Rx_Sa    => Rx_Sa,
--                  Ptr_Data => Ptr_Data,
--                  Dw_N     => Dw_N,
--                  Result   => Result);

            end if;
         end if;
      end if;
   end Rt_For_User_Get_Data_Rx;


   procedure Rt_For_Bc_Set_Data_Rx
     (Rt        : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id     : in Basic_types_1553.Sa_Id_T;
      Ptr_Data  : in System.Address;
      Dw_N      : in Basic_Types_I.Unsigned_32_T;
      Result    : out Basic_Types_I.Unsigned_32_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;
      use type Basic_Types_I.Unsigned_32_T;
      use type Lib_Icm_Sw_If_Types.Ic1_Handler_T;

      Bit_Int_1553_C       : constant Lib_Icm_Sw_If_Types.Uint32_T   := 1;
      Bit_Rt_Rx_Sa_C       : constant Lib_Icm_Sw_If_Types.Uint32_T   := 512;
      Bit_Sa_01_C          : constant Basic_Types_I.Unsigned_32_T    := 2;
      Bit_Sa_15_C          : constant Basic_Types_I.Unsigned_32_T    := 16#8000#;
      Bit_Sa_16_C          : constant Basic_Types_I.Unsigned_32_T    := 16#10000#;
      Bit_Sa_17_C          : constant Basic_Types_I.Unsigned_32_T    := 16#20000#;
      Bit_Sa_30_C          : constant Basic_Types_I.Unsigned_32_T    := 16#40000000#;

      Pend_Rx_Reg_Val      : Basic_Types_I.Unsigned_32_T             := 0;
      Send_Interrupt       : Boolean                                 := False;
      Local_Result         : Basic_Types_I.Unsigned_32_T             := 0;

   begin

      Result := Bus_1553_Pus_Types.Ok_Result_C;

-- If the SA is not initialised, it cannot be used to Rx.
      if Rt.Array_Rx_Sa (Sa_Id) /= Null then

-- Append current msg to the SA data. If limit of frames is reached generate the
-- interrupt to the user.

         Rt.Array_Rx_Sa (Sa_Id).Append_Data
           (Ptr_Data     => Ptr_Data,
            Dw_N         => Dw_N,
            Frames_Latch => Send_Interrupt,
            Result       => Local_Result);

         if Send_Interrupt then

-- Send interrupt to the RT user when the number of 1553 frames received had reached the
-- number configured to generate the interrupt

--            Debug_Log.Do_Log ("[Bus_1553_Pus.Rt.Rt_For_Bc_Set_Data_Rx]TX int. SA:" &
--              Basic_Types_1553.Sa_Id_T'Image (Sa_Id));

            if Sa_Id = 1 then
               Pend_Rx_Reg_Val := Bit_Sa_01_C;
            elsif Sa_Id = 15 then
               Pend_Rx_Reg_Val := Bit_Sa_15_C;
            elsif Sa_Id = 16 then
               Pend_Rx_Reg_Val := Bit_Sa_16_C;
            elsif Sa_Id = 17 then
               Pend_Rx_Reg_Val := Bit_Sa_17_C;
            elsif Sa_Id = 30 then
               Pend_Rx_Reg_Val := Bit_Sa_30_C;
            end if;

           if Rt.Ic1_Handler /= null then
               Rt.Ic1_Handler
                 (Epica_Eint_Int_Pend_Reg => Bit_Int_1553_C,
                  Epica_Int_Alarm_Reg     => Bit_Rt_Rx_Sa_C,
                  Epica_Int_Pend_Rx_Reg   =>
                    Lib_Icm_Sw_If_Types.Uint32_T (Pend_Rx_Reg_Val),
                  Epica_Int_Pend_Mc_Reg   => 0);
           else
               Debug_Log.Do_Log
                 ("[Bus_1553_Pus.Rt.Rt_For_Bc_Set_Data_Rx]Unable to use Ic1_Handler:" &
                  Basic_Types_1553.Sa_Id_T'Image (Sa_Id) & " Dw_N:");
           end if;
         end if;

         if Local_Result /= Bus_1553_Pus_Types.Ok_Result_C then

            Debug_Log.Do_Log
              ("[Bus_1553_Pus.Rt.Rt_For_Bc_Set_Data_Rx] error writing SA:" &
              Basic_Types_1553.Sa_Id_T'Image (Sa_Id) & " Dw_N:" &
              Basic_Types_I.Unsigned_32_T'Image (Dw_N) & " probably the SA is full");

         end if;

      else
         Result := Bus_1553_Pus_Types.Ko_Invalid_Sa_C;

         Debug_Log.Do_Log
           ("[Bus_1553_Pus.Rt Rt_For_Bc_Set_Data_Rx] BC makes a TX to a not " &
            "init RX SA. SA:" &
            Basic_types_1553.Sa_Id_T'Image (Sa_Id) &
            " Dw_N:" & Basic_Types_I.Uint32_T'Image (Dw_N) & " ");
      end if;

   end Rt_For_Bc_Set_Data_Rx;


   procedure Rt_For_Bc_Get_Data_Tx
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id             : in Basic_Types_1553.Sa_Id_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Count       : out Basic_Types_I.Unsigned_32_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

   begin
      Bytes_Count  := 0;

-- If the SA is built (it is used), do the retrieval and set it as empty
      if Rt.Array_Tx_Sa (Sa_Id) /= Null then

         Rt.Array_Tx_Sa (Sa_Id).Retrieve_Data
           (Rt_Id             => Rt.Rt_Id,
            Copy_Sa_Data_Proc => Copy_Sa_Data_Proc,
            Bytes_Count       => Bytes_Count);

         Rt.Array_Tx_Sa (Sa_Id).Set_As_Empty;

--         Debug_Log.Do_Log
--           ("[Bus_1553_Pus.Rt Rt_For_Bc_Get_Data_Tx] BC makes a RX to a not " &
--            "intialised TX SA. SA:" & Basic_types_1553.Sa_Id_T'Image (Sa_Id));
      end if;

   end Rt_For_Bc_Get_Data_Tx;


   procedure Rt_For_Bc_Get_First_Frame_Tx
     (Rt        : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id     : in Basic_Types_1553.Sa_Id_T;
      Frame     : in out Basic_Types_1553.Sa_Data_Frame_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;
      use type Basic_Types_1553.Sa_Id_T;
   begin

-- If the SA is built (it is used), do the retrieval and set it as empty
      if Rt.Array_Tx_Sa (Sa_Id) /= Null then


-- If SA = 15 we are reading the Transfer Request Msg, then use the Hoare Monitor
--         if Sa_Id = 15 then
--            Rt.Prot_Transfer_Req.Wait_Acquire;
--         end if;

         Rt.Array_Tx_Sa (Sa_Id).Retrieve_First_Frame (Frame => Frame);
         Rt.Array_Tx_Sa (Sa_Id).Set_As_Empty;

-- If SA = 15 we are reading the Transfer Request Msg, then use the Hoare Monitor
--         if Sa_Id = 15 then
--            Rt.Prot_Transfer_Req.Release;
--         end if;


      end if;
   end Rt_For_Bc_Get_First_Frame_Tx;



   procedure Rt_For_Bc_Send_Mode_Code
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T;
      Mc_Vector         : in Basic_Types_I.Unsigned_32_T)
   is
      use type Lib_Icm_Sw_If_Types.Ic1_Handler_T;

   begin

--      Debug_Log.Do_Log ("[Bus_1553_Pus.Rt.Rt_For_Bc_Send_Mode_Code]");

      if Rt.Ic1_Handler /= null then

         Rt.Ic1_Handler
           (Epica_Eint_Int_Pend_Reg => Bit_Int_1553_C,
            Epica_Int_Alarm_Reg     => Bit_Rt_Mode_Code_C,
            Epica_Int_Pend_Rx_Reg   => 0,
            Epica_Int_Pend_Mc_Reg   => Lib_Icm_Sw_If_Types.Uint32_T (Mc_Vector));
      else
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.Rt.Rt_For_Bc_Send_Mode_Code]Unable to use Ic1_Handler");
      end if;

   end Rt_For_Bc_Send_Mode_Code;


   procedure Rt_For_Bc_Send_Pps
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T)
   is
      use type Lib_Icm_Sw_If_Types.Ic2_Handler_T;

      Epica_Ext_Int_Pps_Position_C : constant Lib_Icm_Sw_If_Types.Uint32_T := 1024;

   begin

      Debug_Log.Do_Log ("[Bus_1553_Pus.Rt.Rt_For_Bc_Send_Pps]");

      if Rt.Ic2_Handler /= null then

         Rt.Ic2_Handler
           (Ic2_In_Service_1_Reg  => Epica_Ext_Int_Pps_Position_C);
      else
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.Rt.Rt_For_Bc_Send_Pps]Unable to use Ic2_Handler");
      end if;
   end Rt_For_Bc_Send_Pps;


   procedure Rt_For_Bc_Time_Distribution
     (Rt                : not null access Bus_1553_Pus_Rt_Record_T;
      Raw_Time          : in Basic_Types_1553.Raw_Time_Msg_T;
      Error             : out Boolean)
   -- The BC is "sending" to this RT the raw time message. The RT simulates a time
   -- reception reading the current time from the simulation of the HW Clock (epica_simu)
   is
      use type Basic_Types_I.Uint32_T;
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;
      use type Lib_Icm_Sw_If_Types.Ic1_Handler_T;

      Bit_Rt_Rx_Sa_C       : constant Basic_Types_I.Unsigned_32_T    := 512;
      Bit_Sa_16_C          : constant Basic_Types_I.Unsigned_32_T    := 16#10000#;

      Result  :  Basic_Types_I.Uint32_T   := Bus_1553_Pus_Types.Ok_Result_C;

   begin
      Error := True;

      if Rt.Array_Rx_Sa (16) /= null then

-- Write raw CUC time message into the T SA 16
         Rt.Array_RX_Sa (16).Set_Data
           (Data         => Raw_Time,
            Result       => Result);
         if Result = Bus_1553_Pus_Types.Ok_Result_C then

            Error := False;

-- Generate the interrupt of this SA in the RT
            if Rt.Ic1_Handler /= null then

               Rt.Ic1_Handler
                 (Epica_Eint_Int_Pend_Reg => Bit_Int_1553_C,
                  Epica_Int_Alarm_Reg     => Interfaces.C.Unsigned (Bit_Rt_Rx_Sa_C),
                  Epica_Int_Pend_Rx_Reg   => Interfaces.C.Unsigned (Bit_Sa_16_C),
                  Epica_Int_Pend_Mc_Reg   => 0);
            else
               Debug_Log.Do_Log
             ("[Bus_1553_Pus.Rt.Rt_For_Bc_Time_Distribution]Unable to use Ic1_Handler");
            end if;
         else
            Debug_Log.Do_Log
             ("[Bus_1553_Pus.Rt.Rt_For_Bc_Time_Distribution]Unable to write in R SA 16");
         end if;
      end if;
   end Rt_For_Bc_Time_Distribution;





--   procedure Rt_For_Bc_Set_Data_Rx(
--     Rt_For_Bc     : in Bus_1553_Pus_Rt_Record_T;
--     Sa_Id         : in Basic_Types_I.Unsigned_32_T;
--     Ptr_Data      : in System.Address;
--     Dw_N          : in Basic_Types_I.Unsigned_32_T;
--     Result        : out Basic_Types_I.Unsigned_32_T) is
--   begin
--      Result := Fail_Invalid_Sa;
--
--   end Rt_For_Bc_Set_Data_Rx;

--   procedure Rt_For_Bc_Get_Data_Tx(
--     Rt_For_Bc     : in Bus_1553_Pus_Rt_Record_T;
--     Sa_Id         : in Basic_Types_I.Unsigned_32_T;
--     Ptr_Data      : in System.Address;
--     Dw_N          : out Basic_Types_I.Unsigned_32_T;
--     Result        : out Basic_Types_I.Unsigned_32_T) is
--   begin
--      Dw_N   := 0;
--      Result := Fail_Invalid_Sa;

--   end Rt_For_Bc_Get_Data_Tx;




-- --------------------------------------------------------------------------------------
-- Operations no defined in the interface: Specific operations for RT HW

   procedure Set_Interrupt_Routines
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Ic1_Handler  : in Lib_Icm_Sw_If_Types.Ic1_Handler_T;
      Ic2_Handler  : in Lib_Icm_Sw_If_Types.Ic2_Handler_T)
   is

   begin
      Rt.Ic1_Handler  := Ic1_Handler;
      Rt.Ic2_Handler  := Ic2_Handler;
   end Set_Interrupt_Routines;

   procedure Get_Rx_Sa_Info
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T;
      Tc_N         : out Basic_Types_I.Unsigned_32_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;


   begin

      Tc_N    := 0;

      if Rt.Array_Rx_Sa (Sa_Id) /= null then
         Tc_N  := Rt.Array_Rx_Sa (Sa_Id).Get_Nun_Pus_Tc;
      end if;
   end Get_Rx_Sa_Info;

   procedure Get_Rx_Sa_First_Tc
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T;
      Tc_Data      : in out Basic_Types_I.Byte_Array_T;
      Last_I       : out Basic_Types_I.Unsigned_32_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

   begin

      Last_I   := 0;

      if Rt.Array_Rx_Sa (Sa_Id) /= null then
         Rt.Array_Rx_Sa (Sa_Id).Retrieve_First_Pus_Tc
           (Tc_Data => Tc_Data,
            Last_I  => Last_I);
      end if;
   end Get_Rx_Sa_First_Tc;

   procedure Get_Rx_Sa_First_Tc
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T;
      Ptr_Data     : in System.Address;
      Bytes_N      : out Basic_Types_I.Unsigned_32_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;

   begin

      Bytes_N   := 0;
      if Rt.Array_Rx_Sa (Sa_Id) /= null then
         Rt.Array_Rx_Sa (Sa_Id).Retrieve_First_Pus_Tc
           (Ptr_Data => Ptr_Data,
            Bytes_N  => Bytes_N);
      end if;
   end Get_Rx_Sa_First_Tc;



   procedure Reset_Sa
     (Rt           : not null access Bus_1553_Pus_Rt_Record_T;
      Sa_Id        : in Basic_Types_1553.Sa_Id_T)
   is
      use type Bus_1553_Pus.Rt_Sa.Bus_1553_Pus_Rt_Sa_T;
   begin

      if Rt.Array_Rx_Sa (Sa_Id) /= null then
         Rt.Array_Rx_Sa (Sa_Id).Set_As_Empty;
      end if;
   end Reset_Sa;


end Bus_1553_Pus.Rt;

