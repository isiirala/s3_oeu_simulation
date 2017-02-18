
with Basic_Tools;
with Debug_Log;

package body Bus_1553_Pus.Bc is


   Empty_Rt_Data_C : constant Rt_Arr_T := (others =>
     (False,
      Bus_1553_Pus_Types.Sa_Tm_Transfer_T'First,
      (others => (Num_Frames => 0, Num_Dw_Last_Frame => 0)),
      (others => Bus_1553_Pus_Types.Empty_Trans_Ack_Sa_C),
      False,
      False,
      null));


   Transfer_Request_Sa_C  : constant  := 15;



-- =====================================================================================
-- %% Internal operations
-- =====================================================================================

   procedure Increment_Rt (Rt_Id : in out Basic_types_1553.Rt_Id_T) is
     use type Basic_types_1553.Rt_Id_T;
   begin
      if Rt_Id < Basic_types_1553.Rt_Id_T'Last then
         Rt_Id := Rt_Id + 1;
      else
         Rt_Id := Basic_types_1553.Rt_Id_T'First;
      end if;
   end Increment_Rt;

   procedure Increment_Sa(I_Sa : in out Bus_1553_Pus_Types.Sa_Tm_Transfer_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
   begin
      if I_Sa = Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Last then
         I_Sa := Bus_1553_Pus_Types.Sa_Tm_Transfer_T'First;
      else
         I_Sa := I_Sa + 1;
      end if;
   end Increment_Sa;

--   procedure Decrement_Sa(I_Sa : in out Bus_1553_Pus_Types.Sa_Id_T)
--   is
--      use type Basic_Types_I.Unsigned_32_T;
--   begin
--      if I_Sa = Bus_1553_Pus_Types.Sa_Id_T'First then
--         I_Sa := Bus_1553_Pus_Types.Sa_Id_T'Last;
--      else
--         I_Sa := I_Sa - 1;
--      end if;
--   end Decrement_Sa;


   procedure Address_To_Byte_Array
     (Ptr_Data   : in System.Address;
      Dw_N       : in Basic_Types_I.Unsigned_32_T;
      Data_Array : in out Basic_Types_I.Byte_Array_T;
      Last_Index : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Bytes_N     : Basic_Types_I.Unsigned_32_T  := Dw_N * 2;
      Local_Array : Basic_Types_I.Byte_Array_T (1 .. Bytes_N);
      for Local_Array'Address use Ptr_Data;
      First_Index : Basic_Types_I.Unsigned_32_T  := Data_Array'First;
      End_Index   : Basic_Types_I.Unsigned_32_T  := First_Index + Bytes_N - 1;

   begin
      Last_Index := 0;

      if Data_Array'Length >= Bytes_N then
         Data_Array(First_Index .. End_Index) := Local_Array;
         Last_Index := End_Index;
      end if;

   end Address_To_Byte_Array;

   procedure Update_Transfer_Ack
     (Bc     : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id  : in Basic_types_1553.Rt_Id_T;
      I_Sa   : in Bus_1553_Pus_Types.Sa_Tm_Transfer_T)
   --************************************************************************************
   --  PURPOSE: Set to True the corresponding ACK bit in the Rt_Data structure
   --  PARAMETERS:
   --    Rt_Id: RT number identifier
   --    I_Sa: SA number identifier
   --************************************************************************************
   is
--      use type Basic_types_I.Unsigned_32_T;
   begin
      Bc.Rt_Data (Rt_Id).Trans_Ack (I_Sa).Ack_Bit := 1;
      Bc.Rt_Data (Rt_Id).Trans_Ack_Empty          := False;
   end Update_Transfer_Ack;



   procedure Read_Trans_Request
     (Frame         : in Basic_Types_1553.Sa_Data_Frame_T;
--      Ptr_Data      : in System.Address;
      Trans_Request : out Bus_1553_Pus_Types.Trans_Request_T)
   is
--      Local_Frame     : Basic_Types_1553.Sa_Data_Frame_T
      Local_Trans_Req : Bus_1553_Pus_Types.Trans_Request_T;
      for Local_Trans_Req'Address use Frame'Address;
   begin
      Trans_Request := Local_Trans_Req;
   end Read_Trans_Request;

   procedure Debug_Trans_Request
     (Trans_Request : in Bus_1553_Pus_Types.Trans_Request_T;
      Rt_Id         : in Basic_types_1553.Rt_Id_T)
   is
      use type Basic_Types_I.Unsigned_5_T;

      Header_Written   : Boolean     := False;
   begin

      for Sa in Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Range loop
         if Trans_Request (Sa).Num_Frames > 0 then
            if not Header_Written then
               Header_Written := True;
               Debug_Log.Do_Log_Same_Line ("[Bus_1553_Pus.Bc Received TransReq]");
            end if;
            Debug_Log.Do_Log_Same_Line (" SA:" &
              Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Image (Sa));
            Debug_Log.Do_Log_Same_Line (" (" &
              Basic_Types_I.Unsigned_5_T'Image (Trans_Request (Sa).Num_Frames));
            Debug_Log.Do_Log_Same_Line ("," &
              Basic_Types_I.Unsigned_5_T'Image
              (Trans_Request (Sa).Num_Dw_Last_Frame) & ")");
         end if;
      end loop;
      if Header_Written then
         Debug_Log.Do_Log("");
      end if;
--      if not Header_Written then
--         Debug_Log.Do_Log ("[Bus_1553_Pus.Bc Received TransReq]Empty!");
--      end if;
   end Debug_Trans_Request;


   procedure Retrieve_One_Rt
     (Bc                : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id             : in Basic_types_1553.Rt_Id_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Limit       : in Basic_Types_I.Unsigned_32_T;
      Bytes_Actual      : out Basic_Types_I.Unsigned_32_T;
      Result            : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
      use type Basic_Types_I.Unsigned_5_T;

      End_Read            : Boolean                             := False;
      I_Sa                : Bus_1553_Pus_Types.Sa_Tm_Transfer_T :=
        Bus_1553_Pus_Types.Sa_Tm_Transfer_T'First;
      Bytes_Count         : Basic_Types_I.Unsigned_32_T         := 0;
      Local_Bytes_Actual  : Basic_Types_I.Unsigned_32_T         := 0;

   begin
--***************************************************************************************
-- IMPLEMENTATION:
--   When the retrieval of a TM block is completed, this routine sets the corresponding
--   bit in the Transfer ACK message. This message is used to inform to the RT that
--   the SA is now free and can be used to transmit another TM block
--***************************************************************************************

      Bytes_Actual := 0;
      Result       := Bus_1553_Pus_Types.Ok_Result_C;

--      Debug_Log.Do_Log ("[Bus_1553_pus.bc Retrieve_One_Rt]Rt_Id: " &
--        Bus_1553_Pus_Types.Rt_Id_T'Image (Rt_Id));
--      Debug_Trans_Request
--        (Trans_Request => Rt_Data(Rt_Id).Trans_Request,
--         Rt_Id         => Rt_Id);

      if Bc.Rt_Data (Rt_Id).Used then

-- If this RT was init, inspect data in output SAs starting from the last one checked.
-- Go through each SAs (checking TransRequest message) to retrieve the TM blocks until
-- all SAs are checked or the byte limit is reached.

         I_Sa    := Bc.Rt_Data (Rt_Id).Last_Sa_Rx;
         loop
            if Bc.Rt_Data (Rt_Id).Trans_Request (I_Sa).Num_Frames > 0 then

--               Debug_Log.Do_Log ("[Bus_1553_Pus.BC Retrieve_One_Rt]RT:" &
--                 Basic_types_1553.Rt_Id_T'Image (Rt_Id) & " Sa: " &
--                 Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Image (I_Sa));

-- Retrieve data stored for TX in the SA of that RT
               Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Get_Data_Tx
                 (Sa_Id             => I_Sa,
                  Copy_Sa_Data_Proc => Copy_Sa_Data_Proc,
                  Bytes_Count       => Bytes_Count);

-- Put as True the bit related with this SA in the Transfer ACK Message
               Update_Transfer_Ack
                 (Bc    => Bc,
                  Rt_Id => Rt_Id,
                  I_Sa  => I_Sa);

--               Bc.Rt_Data (Rt_Id).Trans_Request (I_Sa).Num_Frames := 0;

               Local_Bytes_Actual := Local_Bytes_Actual + Bytes_Count;
               if Local_Bytes_Actual >= Bytes_Limit then
                  End_Read     := True;
                  Bytes_Actual := Local_Bytes_Actual;
               end if;
            end if;
            Increment_Sa (I_Sa);
            exit when ((I_Sa = Bc.Rt_Data (Rt_Id).Last_Sa_Rx) or End_Read);
         end loop;

         Bc.Rt_Data(Rt_Id).Last_Sa_Rx := I_Sa;
      else
         Result := Bus_1553_Pus_Types.Ko_Invalid_Rt_C;
      end if;
   end Retrieve_One_Rt;



-- =====================================================================================
-- %% Provided operations
-- =====================================================================================


   procedure Create_New
     (Bc          : out Bus_1553_Pus_Bc_T;
      Bus_Id      : in Basic_Types_I.Uint32_T;
      Bus_Title   : in Basic_Types_I.String_10_T)
   is
   begin
      Bc := new Bus_1553_Pus_Bc_Record_T;
      Initialize(Bc, Bus_Id, Bus_Title);
   end Create_New;

   procedure Initialize
     (Bc          : not null access Bus_1553_Pus_Bc_Record_T'Class;
      Bus_Id      : in Basic_Types_I.Uint32_T;
      Bus_Title   : in Basic_Types_I.String_10_T)
   is
   begin
      Bc.User_Init         := True;
      Bc.Bus_Id            := Bus_Id;
      Bc.Bus_Title         := Bus_Title;
      Bc.Rt_Data           := Empty_Rt_Data_C;
      Bc.Rt_Last_Retrieve  := Basic_Types_1553.Rt_Id_T'First;
   end Initialize;


--   procedure Bc_For_User_Init
--     (Bc_For_User   : in Bus_1553_Pus_Bc_Record_T;
--     Result        : out Basic_Types_I.Unsigned_32_T) is
--   begin
--      Result := 0; --Fail_Invalid_Sa;
--   end Bc_For_User_Init;


   procedure Bc_For_User_Set_Transaction
     (Bc            : not null access Bus_1553_Pus_Bc_Record_T;
      Sa_Id         : in Basic_Types_I.Unsigned_32_T;
      Tx_Or_Rx      : in Boolean;
      Msg_N         : in Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T) is
   begin
      Result := 0; --Fail_Invalid_Sa;


   end Bc_For_User_Set_Transaction;


   procedure Bc_For_User_Set_Data_Tx
     (Bc         : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id      : in Basic_types_1553.Rt_Id_T;
      Sa_Id      : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data   : in System.Address;
      Dw_N       : in Basic_Types_I.Unsigned_32_T;
      Result     : out Basic_Types_I.Unsigned_32_T)
   is
   begin

      Result := Bus_1553_Pus_Types.Ok_Result_C;

      if Bc.Rt_Data (Rt_Id).Used then

-- Use the access to the RT to write in its imput SA
         Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Set_Data_Rx
           (Sa_Id    => Sa_Id,
            Ptr_Data => Ptr_Data,
            Dw_N     => Dw_N,
            Result   => Result);


--         Debug_Log.Do_Log ("[Bus_1553_Pus.Bc_For_User_Set_Data_Tx] Rt_Id: " &
--           Basic_types_1553.Rt_Id_T'Image (Rt_Id) &
--           " Sa_Id: " & Basic_Types_I.Unsigned_32_T'Image (Sa_Id) & " Dw_N: " &
--           Basic_Types_I.Uint32_T'Image (Dw_N));

      end if;

   end Bc_For_User_Set_Data_Tx;


   procedure Bc_For_User_Retrieve
     (Bc                : not null access Bus_1553_Pus_Bc_Record_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Limit       : in Basic_Types_I.Unsigned_32_T;
      Bytes_Actual      : out Basic_Types_I.Unsigned_32_T;
      Result            : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Frame             : Basic_Types_1553.Sa_Data_Frame_T   := (others => 0);
      Rt_Id             : Basic_types_1553.Rt_Id_T      := Bc.Rt_Last_Retrieve;
      Bytes_Total_Count : Basic_Types_I.Unsigned_32_T   := 0;
      Bytes_Rt_Count    : Basic_Types_I.Unsigned_32_T   := 0;
      Limit_For_Rt      : Basic_Types_I.Unsigned_32_T   := Bytes_Limit;
      Bc_Result         : Basic_Types_I.Unsigned_32_T   := 0;
   begin

      Bytes_Actual := 0;
      Result       := Bus_1553_Pus_Types.Ok_Result_C;


      loop

         if Bc.Rt_Data (Rt_Id).Used then

-- Retrieve the Transfer Request Message of the RT
            Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Get_First_Frame_Tx
              (Sa_Id       => Transfer_Request_Sa_C,
               Frame       => Frame);

            Read_Trans_Request (Frame, Bc.Rt_Data (Rt_Id).Trans_Request);

            Debug_Trans_Request
              (Trans_Request => Bc.Rt_Data (Rt_Id).Trans_Request,
               Rt_Id         => Rt_Id);


-- Retrieve TMs from the RT
            Bc.Retrieve_One_Rt
              (Rt_Id             => Rt_Id,
               Copy_Sa_Data_Proc => Copy_Sa_Data_Proc,
               Bytes_Limit       => Limit_For_Rt,
               Bytes_Actual      => Bytes_Rt_Count,
               Result            => Bc_Result);

            if Bc_Result = Bus_1553_Pus_Types.Ok_Result_C then

               Bytes_Total_Count := Bytes_Total_Count + Bytes_Rt_Count;
               Basic_Tools.Decrement (Limit_For_Rt, Bytes_Rt_Count);

            elsif Bc_Result = Bus_1553_Pus_Types.Ko_Invalid_Rt_C then

-- The RT is disconnected or not initialised
               null;
            else
               Debug_Log.Do_Log ("[Bus_1553_Pus.Bc Bc_For_User_Retrieve]" &
                 "Error RT retrieving. RT:" & Basic_types_1553.Rt_Id_T'Image (Rt_Id) &
                 " Bc_Result:" & Debug_Log.U32_To_Str (Bc_Result) &
                 " Limit_For_Rt:" & Debug_Log.U32_To_Str (Limit_For_Rt));
            end if;
         end if;

         Increment_Rt (Rt_Id);
         exit when ((Rt_Id = Bc.Rt_Last_Retrieve) or
           (Bytes_Total_Count >= Bytes_Limit));
      end loop;
      Bc.Rt_Last_Retrieve := Rt_Id;

   end Bc_For_User_Retrieve;



   procedure Bc_For_User_Send_Mode_Code
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id     : in Basic_Types_1553.Rt_Id_T;
      Mc_Vector : in Basic_Types_I.Unsigned_32_T)
   is

   begin

      if Bc.Rt_Data (Rt_Id).Used then
         Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Send_Mode_Code
           (Mc_Vector => Mc_Vector);
      else
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.BC Bc_For_User_Send_Mode_Code] RT not init" &
            " Rt_Id: " & Basic_types_1553.Rt_Id_T'Image (Rt_Id));
      end if;
   end Bc_For_User_Send_Mode_Code;


   procedure Bc_For_User_Send_Pps
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id     : in Basic_Types_1553.Rt_Id_T)
   is

   begin

      if Bc.Rt_Data (Rt_Id).Used then
         Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Send_Pps;
      else
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.BC Bc_For_User_Send_Pps] RT not init" &
            " Rt_Id: " & Basic_types_1553.Rt_Id_T'Image (Rt_Id));
      end if;
   end Bc_For_User_Send_Pps;


   procedure Bc_For_User_Time_Distribution
     (Bc            : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id         : in Basic_Types_1553.Rt_Id_T;
      Raw_Time_Msg  : in Basic_Types_1553.Raw_Time_Msg_T)
   is
      Found_Error  : Boolean  := False;
   begin

      if Bc.Rt_Data (Rt_Id).Used then
         Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Time_Distribution
           (Raw_Time => Raw_Time_Msg,
            Error    => Found_Error);
         if Found_Error then
            Debug_Log.Do_Log
              ("[Bus_1553_Pus.BC Bc_For_User_Time_Distribution] found error in RT");
         end if;
      else
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.BC Bc_For_User_Time_Distribution] RT not init" &
            " Rt_Id: " & Basic_types_1553.Rt_Id_T'Image (Rt_Id));
      end if;
   end Bc_For_User_Time_Distribution;



   procedure Bc_For_Rt_Declare_Rt
     (Bc                : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id             : in Basic_types_1553.Rt_Id_T;
      Rt                : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Rt_For_Bc_T)
   is
   begin

      Bc.Rt_Data (Rt_Id).Used      := True;
      Bc.Rt_Data (Rt_Id).Acc_Rt    := Rt;

   end Bc_For_Rt_Declare_Rt;



   procedure Bc_For_Rt_Set_Data_Tx
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id     : in Basic_types_1553.Rt_Id_T;
      Sa        : not null access If_Bus_1553_Pus.If_Bus_1553_Pus_Sa_T'Class)
   is
      use type Basic_types_1553.Sa_Id_T;

      Sa_Id     : Basic_types_1553.Sa_Id_T             := Sa.Get_Id;
      Frame     : Basic_Types_1553.Sa_Data_Frame_T     := (others => 0);
   begin

--***************************************************************************************
-- IMPLEMENTATION: Depending on the TX SA, the BC performs the following operations:
--   * If the TX SA is the 30 one, read the wrap arround test result of that RT
--
-- TODO: quitar
--   * If the TX SA is the 15 one, read the PUS-TRANSFER-REQUEST message of that RT
--
--   The rest of TX SA are discarted in this implementation, because PUS standard is
--   based on the Transfer Request/Ack messages and there is not communication RT-RT
--***************************************************************************************

      if Bc.Rt_Data(Rt_Id).Used then

         if Sa_Id = Transfer_Request_Sa_C then
--            Sa.Retrieve_First_Frame (Frame);
--            Sa.Set_As_Empty;
--            Read_Trans_Request (Frame, Bc.Rt_Data (Rt_Id).Trans_Request);

--            Debug_Trans_Request
--              (Trans_Request => Bc.Rt_Data (Rt_Id).Trans_Request,
--               Rt_Id         => Rt_Id);
null;
         end if;

-- TODO: process Data Wrap around response


      else
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.Bc Bc_For_Rt_Set_Data_Tx]Error RT not in use: " &
            Basic_types_1553.Rt_Id_T'Image (Rt_Id));
      end if;

   end Bc_For_Rt_Set_Data_Tx;


   procedure Bc_For_User_Send_Transfer_Ack
     (Bc                : not null access Bus_1553_Pus_Bc_Record_T)
   is
      use type Basic_Types_I.Unsigned_1_T;
      use type Basic_Types_I.Unsigned_32_T;

      Result            : Basic_Types_I.Unsigned_32_T  := 0;
--      Log_Head_Written  : Boolean                      := False;
   begin

      for Rt_Id in Basic_types_1553.Rt_Id_T'Range loop
         if Bc.Rt_Data (Rt_Id).Used then

            if not (Bc.Rt_Data (Rt_Id).Trans_Ack_Empty and
               Bc.Rt_Data (Rt_Id).Trans_Ack_Empty_Transmitted) then

-- Log the sending Transfer ACK
--               for Sa_I in Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Range loop
--                  if Bc.Rt_Data (Rt_Id).Trans_Ack (Sa_I).Ack_Bit > 0 then
--                     if not Log_Head_Written then
--                        Log_Head_Written := True;
--                        Debug_Log.Do_Log ("->SMU-BC Sends Transfer_Ack:");
--                     end if;
--                     Debug_Log.Do_Log_Same_Line (" SA:" &
--                       Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Image (Sa_I));
--                  end if;
--               end loop;

-- Send to the SA 15 of the corresponding RT the Transfer ACK message
               Bc.Rt_Data (Rt_Id).Acc_Rt.Rt_For_Bc_Set_Data_Rx
                 (Sa_Id    => 15,
                  Ptr_Data => Bc.Rt_Data (Rt_Id).Trans_Ack'Address,
                  Dw_N     => 8,
                  Result   => Result);

               if Result /= Bus_1553_Pus_Types.Ok_Result_C then
                  Debug_Log.Do_Log
                    ("[Bus_1553_Pus.Bc Bc_For_User_Send_Transfer_Ack]Tx error: " &
                       Basic_Types_I.Unsigned_32_T'Image (Result));
               end if;

               if Bc.Rt_Data (Rt_Id).Trans_Ack_Empty then
                  Bc.Rt_Data (Rt_Id).Trans_Ack_Empty_Transmitted := True;
               else
                  Bc.Rt_Data (Rt_Id).Trans_Ack_Empty_Transmitted := False;
               end if;
            end if;

-- Reset the Transfer ACK message of this RT
            for Sa_I in Bus_1553_Pus_Types.Sa_Tm_Transfer_T'Range loop
               Bc.Rt_Data (Rt_Id).Trans_Ack (Sa_I).Ack_Bit := 0;
            end loop;
            Bc.Rt_Data (Rt_Id).Trans_Ack_Empty := True;
         end if;
      end loop;

   end Bc_For_User_Send_Transfer_Ack;


end Bus_1553_Pus.Bc;

