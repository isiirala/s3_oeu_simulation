

with Basic_Tools;
with Debug_Log;

package body Bus_1553_Pus.Rt_Sa is


   procedure Create_New
     (Sa_Id             : in Basic_types_1553.Sa_Id_T;
      Frames_Before_Int : in Basic_Types_I.Unsigned_32_T;
      Sa                : out Bus_1553_Pus_Rt_Sa_T)
   is
   begin
      Sa := new Bus_1553_Pus_Rt_Sa_Record_T;
      Initialize
        (Sa                => Sa,
         Sa_Id             => Sa_Id,
         Frames_Before_Int => Frames_Before_Int);
   end Create_New;

   procedure Initialize
     (Sa                : access Bus_1553_Pus_Rt_Sa_Record_T'Class;
      Sa_Id             : in Basic_types_1553.Sa_Id_T;
      Frames_Before_Int : in Basic_Types_I.Unsigned_32_T)
   is
   begin
      Sa.User_Init         := True;
      Sa.Sa_Id             := Sa_Id;
      Sa.First_I           := Basic_Types_1553.Sa_Data_Range_T'First;
      Sa.Last_I            := Basic_Types_1553.Sa_Data_Range_T'First;
      Sa.Frames_Before_Int := Frames_Before_Int;
      Sa.Current_Frames_N  := 0;
   end Initialize;


   procedure Append_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Ptr_Data      : in System.Address;
      Dw_N          : in Basic_Types_I.Unsigned_32_T;
      Frames_Latch  : out Boolean;
      Result        : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
      use type Basic_Types_I.Unsigned_8_T;

      Byte_Len_C     : constant Basic_Types_I.Uint32_T  := Dw_N * 2;

      Local_Data     : Basic_Types_I.Byte_Array_T (1 .. Byte_Len_C);
      for Local_Data'Address use Ptr_Data;
   begin

      if (Byte_Len_C >= 9) and (Local_Data (8) /= 0) then
         Debug_Log.Do_Log
           ("[Bus_1553_Pus.Rt_Sa Append_Data]SA:" &
            Basic_Types_1553.Sa_Id_T'Image (Sa.Sa_Id) & " dw:" &
            Basic_Types_I.Uint32_T'Image (Dw_N) & " PUS_Srv(" &
            Basic_types_I.Unsigned_8_T'Image (Local_Data (8)) & "," &
            Basic_types_I.Unsigned_8_T'Image (Local_Data (9)) & ")");
      end if;

      Append_Data
        (Sa            => Sa,
         Data          => Local_Data,
         Frames_Latch  => Frames_Latch,
         Result        => Result);
   end Append_Data;


   procedure Append_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Data          : in Basic_Types_I.Byte_Array_T;
      Frames_Latch  : out Boolean;
      Result        : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Data_Len_C     : constant Basic_Types_I.Uint32_T  := Data'Length;
      Dw_N_C         : constant Basic_Types_I.Uint32_T  := Data_Len_C / 2;
      Last_I_Limit_C : constant Basic_Types_I.Uint32_T  :=
        Basic_Types_1553.Sa_Data_Range_T'Last;

      Dw_Quot        : Basic_Types_I.Uint32_T           := 0;
      Dw_Rem         : Basic_Types_I.Uint32_T           := 0;
      Buff_Len       : Basic_Types_I.Data_32_Len_T      :=
        (Last_Used  => Sa.Last_I,
         Data_Empty => (Sa.Current_Frames_N = 0));
   begin

-- Init output parameters
      Frames_Latch := False;
      Result       := Bus_1553_Pus_Types.Ok_Result_C;

--      Debug_Log.Do_Log
--        ("[Bus_1553_Pus.Rt_Sa Append_Data] Append_Data2. first:" &
--         Basic_types_I.Unsigned_8_T'Image (Data (1)) & " last:" &
--         Basic_types_I.Unsigned_8_T'Image (Data (Data'Last)));

-- Append the new data into the SA buffer
      begin
         Basic_Tools.Append
           (Annex      => Data,
            Buff_Data  => Sa.Sa_Data,
            Buff_Len   => Buff_Len);

         Sa.Last_I   := Buff_Len.Last_Used;

-- The data is appened in the SA buffer. Update the frames counter and generates the
-- frames latch if limit is reached
         Basic_Tools.Div
           (Dividend      => Dw_N_C,
            Divisor       => Basic_Types_1553.Dw_Per_Frame_C,
            Quotient      => Dw_Quot,
            Remainder     => Dw_Rem);

         Sa.Current_Frames_N := Sa.Current_Frames_N + Dw_Quot;
         if Dw_Rem > 0 then
            Sa.Current_Frames_N := Sa.Current_Frames_N + 1;
         end if;

         if Sa.Current_Frames_N >= Sa.Frames_Before_Int then
            Frames_Latch := True;
         end if;

      exception
         when others =>

-- There was an error appening the data in the SA buffer
            Sa.First_I          := Basic_Types_1553.Sa_Data_Range_T'First;
            Sa.Last_I           := Basic_Types_1553.Sa_Data_Range_T'First;
            Sa.Current_Frames_N := 0;
            Result              := Bus_1553_Pus_Types.Ko_Internal_If_C;
      end;
   end Append_Data;

   procedure Set_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Data          : in Basic_Types_I.Byte_Array_T;
      Result        : out Basic_Types_I.Unsigned_32_T)
   -- Overwrite the data of the SA starting from first frame. Used to TX of time message
   is
      use type Basic_Types_I.Unsigned_32_T;

      Data_Len_C     : constant Basic_Types_I.Uint32_T  := Data'Length;
      Dw_N_C         : constant Basic_Types_I.Uint32_T  := Data_Len_C / 2;

      Buff_Len       : Basic_Types_I.Data_32_Len_T      :=
        (Last_Used  => Basic_Types_1553.Sa_Data_Range_T'First,
         Data_Empty => True);
      Dw_Quot        : Basic_Types_I.Uint32_T           := 0;
      Dw_Rem         : Basic_Types_I.Uint32_T           := 0;
   begin

-- Init output parameters
      Result       := Bus_1553_Pus_Types.Ok_Result_C;

      begin
         Basic_Tools.Append
           (Annex      => Data,
            Buff_Data  => Sa.Sa_Data,
            Buff_Len   => Buff_Len);

         Sa.Last_I   := Buff_Len.Last_Used;

-- The data is appened in the SA buffer. Update the frames counter and generates the
-- frames latch if limit is reached
         Basic_Tools.Div
           (Dividend      => Dw_N_C,
            Divisor       => Basic_Types_1553.Dw_Per_Frame_C,
            Quotient      => Dw_Quot,
            Remainder     => Dw_Rem);

         Sa.Current_Frames_N := Dw_Quot;
         if Dw_Rem > 0 then
            Sa.Current_Frames_N := Sa.Current_Frames_N + 1;
         end if;

      exception
         when others =>

-- There was an error settin the data in the SA buffer
            Sa.First_I          := Basic_Types_1553.Sa_Data_Range_T'First;
            Sa.Last_I           := Basic_Types_1553.Sa_Data_Range_T'First;
            Sa.Current_Frames_N := 0;
            Result              := Bus_1553_Pus_Types.Ko_Internal_If_C;
      end;
   end Set_Data;

   procedure Retrieve_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Data          : in out Basic_Types_1553.Sa_Data_Buff_T;
      Last_I        : out Basic_Types_1553.Sa_Data_Range_T;
      Empty         : out Boolean)
   is
      use type Basic_Types_I.Unsigned_8_T;
      use type Basic_Types_I.Unsigned_32_T;

      Data_First_C   : constant Basic_Types_1553.Sa_Data_Range_T    :=
        Basic_Types_1553.Sa_Data_Range_T'First;

      Data_Last      : Basic_Types_1553.Sa_Data_Range_T             :=
        Sa.Last_I - Sa.First_I + 1;

   begin

      Last_I := Data_First_C;
      Empty  := True;

      if Sa.Current_Frames_N > 0 then

         Data (Data_First_C .. Data_Last) := Sa.Sa_Data (Sa.First_I .. Sa.Last_I);
         Sa.Set_As_Empty;

         Last_I              := Data_Last;
         Empty               := False;

         if ((Data_Last - Data_First_C) >= 9) and (Data (Data_First_C + 7) /= 0) then

            Debug_Log.Do_Log
              ("[Bus_1553_Pus.Rt_Sa Retrieve_Data]SA:" &
               Basic_Types_1553.Sa_Id_T'Image (Sa.Sa_Id)  & " PUS_Srv(" &
               Basic_types_I.Unsigned_8_T'Image (Data (Data_First_C + 7)) & "," &
               Basic_types_I.Unsigned_8_T'Image (Data (Data_First_C + 8)) & ")");
--           Last_I:" & Basic_Types_1553.Sa_Data_Range_T'Image (Last_I)
         end if;

      end if;

   end Retrieve_Data;


   procedure Retrieve_All_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Ptr_Data      : in System.Address;
      Dw_N          : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Bytes_In_Word_C  : constant                                     := 2;
      Data_First_C     : constant Basic_Types_1553.Sa_Data_Range_T    :=
        Basic_Types_1553.Sa_Data_Range_T'First;

      Local_Data       : Basic_Types_1553.Sa_Data_Buff_T;
      for Local_Data'Address use Ptr_Data;
      Div_Quot         : Basic_Types_I.Unsigned_32_T                  := 0;
      Div_Rem          : Basic_Types_I.Unsigned_32_T                  := 0;
   begin

-- Init output parameters
      Dw_N         := 0;

--      Debug_Log.Do_Log
--        ("[Bus_1553_Pus.Rt_Sa Retrieve_All_Data]Last_I:" &
--         Basic_Types_1553.Sa_Data_Range_T'Image (Sa.Last_I) & "SA:" &
--         Basic_Types_1553.Sa_Id_T'Image (Sa.Sa_Id)  & " 5th:" &
--         Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Data_First_C + 5)));

      if Sa.Current_Frames_N > 0 then

-- Copy data buffer to the input ptr
         Local_Data (Data_First_C .. Sa.Last_I) := Sa.Sa_Data
           (Data_First_C .. Sa.Last_I);

-- Convert byte lenght into word length
         Basic_Tools.Div
           (Dividend  => Sa.Last_I,
            Divisor   => Bytes_In_Word_C,
            Quotient  => Div_Quot,
            Remainder => Div_Rem);

         Dw_N := Div_Quot;
         if Div_Rem > 0 then
            Dw_N := Dw_N + 1;
         end if;

--         Debug_Log.Do_Log
--           (" dw_n:" & Basic_Types_I.Unsigned_32_T'Image (Dw_N));

      end if;

-- Set SA as empty
      Sa.Set_As_Empty;

   end Retrieve_All_Data;


   procedure Retrieve_Data
     (Sa                : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Count       : out Basic_Types_I.Unsigned_32_T)
   is
     use type Basic_Types_I.Unsigned_8_T;
     use type Basic_Types_I.Unsigned_32_T;
   begin

-- Init ouput parameter
      Bytes_Count := (Sa.Last_I - Sa.First_I + 1);

-- If number of frames is positive copy all SA data
      if Sa.Current_Frames_N > 0 then
         Copy_Sa_Data_Proc
           (Rt_Id      => Rt_Id,
            Sa_Id      => Sa.Sa_Id,
            Sa_Data    => Sa.Sa_Data (Sa.First_I .. Sa.Last_I));

         if ((Sa.Last_I - Sa.First_I) >= 9) and (Sa.Sa_Data (Sa.First_I + 7) /= 0) then

            Debug_Log.Do_Log
              ("[Bus_1553_Pus.Rt_Sa Retrieve_Data]SA:" &
               Basic_Types_1553.Sa_Id_T'Image (Sa.Sa_Id)  & " PUS_Srv(" &
               Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Sa.First_I + 7)) & "," &
               Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Sa.First_I + 8)) & ")");
--           Last_I:" & Basic_Types_1553.Sa_Data_Range_T'Image (Last_I)
         end if;

      else

-- If number of frames is 0 set the correct number of bytes
         Bytes_Count := 0;
      end if;

   end Retrieve_Data;


   procedure Retrieve_First_Frame
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Frame     : in out Basic_Types_1553.Sa_Data_Frame_T)
   is
   begin

      Frame (Basic_Types_1553.Frame_Byte_Range_T'Range) :=
        Sa.Sa_Data (Basic_Types_1553.Frame_Byte_Range_T'Range);

   end Retrieve_First_Frame;


   procedure Set_As_Empty
     (Sa           : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   is
   begin
      Sa.First_I           := Basic_Types_1553.Sa_Data_Range_T'First;
      Sa.Last_I            := Basic_Types_1553.Sa_Data_Range_T'First;
      Sa.Current_Frames_N  := 0;
   end Set_As_Empty;

   function Get_Ptr_To_Data
     (Sa           : not null access Bus_1553_Pus_Rt_Sa_Record_T) return System.Address
   is
   begin
      return Sa.Sa_Data'Address;
   end Get_Ptr_To_Data;


   function Get_Last_Index
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_1553.Sa_Data_Range_T
   is
   begin
      return Sa.Last_I;
   end Get_Last_Index;


   function Is_Data_Empty
     (Sa    : not null access Bus_1553_Pus_Rt_Sa_Record_T) return Boolean
   is
      use type Basic_Types_I.Unsigned_32_T;
   begin
      return (Sa.Current_Frames_N = 0);
   end Is_Data_Empty;


   function Get_Frames_Before_Int
     (Sa    : not null access Bus_1553_Pus_Rt_Sa_Record_T) return Basic_Types_I.Uint32_T
   is
   begin
      return Sa.Frames_Before_Int;
   end Get_Frames_Before_Int;


   function Get_Id
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_1553.Sa_Id_T is
   begin
      return Sa.Sa_Id;
   end Get_Id;


-- --------------------------------------------------------------------------------------
-- Rountines not declared in the interface (begin)

   function Get_Nun_Pus_Tc
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_I.Unsigned_32_T
   is
      use type Basic_Types_I.Unsigned_32_T;

      Min_Tc_Len_C     : constant Basic_Types_I.Unsigned_32_T  := 12;
      Tc_Len_Offset_C  : constant Basic_Types_I.Unsigned_32_T  := 6;
      Len_Correction_C : constant Basic_Types_I.Unsigned_32_T  := 7;
      Byte_Len_C       : constant Basic_Types_I.Unsigned_32_T  := Sa.Last_I -
        Sa.First_I + 1;

      Local_I          : Basic_Types_I.Unsigned_32_T           := Sa.First_I;
      Tc_Len           : Basic_Types_I.Unsigned_32_T           := 0;
      Result_Return    : Basic_Types_I.Unsigned_32_T           := 0;
   begin

      if (Sa.Current_Frames_N > 0) and then
        (Byte_Len_C >= Min_Tc_Len_C) then

         Result_Return := 1;
         Local_I := Local_I + Tc_Len_Offset_C;
         Tc_Len  := Basic_Tools.Two_Bytes_To_Uint32
           (Sa.Sa_Data (Local_I .. Local_I + 1)) + Len_Correction_C;

         Local_I := (Local_I - Tc_Len_Offset_C) + Tc_Len;
         while Local_I < Sa.Last_I loop

            Result_Return := Result_Return + 1;
            Local_I := Local_I + Tc_Len_Offset_C;
            Tc_Len  := Basic_Tools.Two_Bytes_To_Uint32
              (Sa.Sa_Data (Local_I .. Local_I + 1)) + Len_Correction_C;

            Local_I := (Local_I - Tc_Len_Offset_C) + Tc_Len;
         end loop;

--         Debug_Log.Do_Log
--           ("[Bus_1553_Pus.Rt_Sa Get_Nun_Pus_Tc] N_TCs:" &
--            Basic_types_I.Unsigned_32_T'Image (Result_Return));
      end if;

      return Result_Return;
   end Get_Nun_Pus_Tc;

   procedure Retrieve_First_Pus_Tc
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Tc_Data  : in out Basic_Types_I.Byte_Array_T;
      Last_I   : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Min_Tc_Len_C     : constant Basic_Types_I.Unsigned_32_T  := 12;
      Tc_Len_Offset_C  : constant Basic_Types_I.Unsigned_32_T  := 4;
      Len_Correction_C : constant Basic_Types_I.Unsigned_32_T  := 7;
      Byte_Len_C       : constant Basic_Types_I.Unsigned_32_T  := Sa.Last_I -
        Sa.First_I + 1;

      Local_I          : Basic_Types_I.Unsigned_32_T           := Sa.First_I;
      Tc_Len           : Basic_Types_I.Unsigned_32_T           := 0;
      I                : Basic_Types_I.Unsigned_32_T           := 1;
      Tmp_Val          : Basic_Types_I.Unsigned_8_T            := 0;

   begin

      if (Sa.Current_Frames_N > 0) and then
        (Byte_Len_C >= Min_Tc_Len_C) then

         Local_I := Local_I + Tc_Len_Offset_C;
         Tc_Len  := Basic_Tools.Two_Bytes_To_Uint32
           (Sa.Sa_Data (Local_I .. Local_I + 1)) + Len_Correction_C;

--         Debug_Log.Do_Log
--           ("[Bus_1553_Pus.Rt_Sa Retrieve_First_Pus_Tc] TC_Len: " &
--            Basic_types_I.Unsigned_32_T'Image (Tc_Len) & " FirstLenByte:" &
--            Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Local_I)) &
--            " SecondLenByte:" &
--            Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Local_I + 1)));

         Tc_Data (1 .. Tc_Len) := Sa.Sa_Data (Sa.First_I .. (Sa.First_I + Tc_Len - 1));

-- Swap bytes of each bus word before to send it to the On board SW
         while I < Tc_Len loop
            Tmp_Val         := Tc_Data (I);
            Tc_Data (I)     := Tc_Data (I + 1);
            Tc_Data (I + 1) := Tmp_Val;
            I               := I + 2;
         end loop;

         Sa.First_I := Sa.First_I + Tc_Len;
         Last_I     := Tc_Len + 1;

--         Debug_Log.Do_Log
--           ("[Bus_1553_Pus.Rt_Sa Retrieve_First_Pus_Tc] FirstByte:" &
--            Basic_types_I.Unsigned_8_T'Image (Tc_Data (1)) &
--            " LastByte:" & Basic_types_I.Unsigned_8_T'Image (Tc_Data (Tc_Len)));

      end if;

   end Retrieve_First_Pus_Tc;


   procedure Retrieve_First_Pus_Tc
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Ptr_Data : in System.Address;
      Bytes_N  : out Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Min_Tc_Len_C     : constant Basic_Types_I.Unsigned_32_T  := 12;
      Tc_Len_Offset_C  : constant Basic_Types_I.Unsigned_32_T  := 4;
      Len_Correction_C : constant Basic_Types_I.Unsigned_32_T  := 7;
      Byte_Len_C       : constant Basic_Types_I.Unsigned_32_T  := Sa.Last_I -
        Sa.First_I + 1;

      Local_I          : Basic_Types_I.Unsigned_32_T           := Sa.First_I;
      Tc_Len           : Basic_Types_I.Unsigned_32_T           := 0;
      I                : Basic_Types_I.Unsigned_32_T           := 1;
      Tmp_Val          : Basic_Types_I.Unsigned_8_T            := 0;

      Tc_Data          : Basic_Types_I.Byte_Array_T (1 .. Basic_Types_1553.Max_Tc_Len_C);
      for Tc_Data'Address use Ptr_Data;

   begin

      if (Sa.Current_Frames_N > 0) and then
        (Byte_Len_C >= Min_Tc_Len_C) then

         Local_I := Local_I + Tc_Len_Offset_C;
         Tc_Len  := Basic_Tools.Two_Bytes_To_Uint32
           (Sa.Sa_Data (Local_I .. Local_I + 1)) + Len_Correction_C;

--         Debug_Log.Do_Log
--           ("[Bus_1553_Pus.Rt_Sa Retrieve_First_Pus_Tc] TC_Len: " &
--            Basic_types_I.Unsigned_32_T'Image (Tc_Len) & " FirstLenByte:" &
--            Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Local_I)) &
--            " SecondLenByte:" &
--            Basic_types_I.Unsigned_8_T'Image (Sa.Sa_Data (Local_I + 1)));
         if Tc_Len > 8 then
            Debug_Log.Do_Log
              ("[Bus_1553_Pus.Rt_Sa Retrieve_First_Pus_Tc]TC(" &
               Tc_Data (8)'Image & "," & Tc_Data (9)'Image & ")");
         end if;


         Tc_Data (1 .. Tc_Len) := Sa.Sa_Data (Sa.First_I .. (Sa.First_I + Tc_Len - 1));

-- Swap bytes of each bus word before to send it to the On board SW
         while I < Tc_Len loop
            Tmp_Val         := Tc_Data (I);
            Tc_Data (I)     := Tc_Data (I + 1);
            Tc_Data (I + 1) := Tmp_Val;
            I               := I + 2;
         end loop;

         Sa.First_I := Sa.First_I + Tc_Len;
         Bytes_N     := Tc_Len + 1;

--         Debug_Log.Do_Log
--           ("[Bus_1553_Pus.Rt_Sa Retrieve_First_Pus_Tc] FirstByte:" &
--            Basic_types_I.Unsigned_8_T'Image (Tc_Data (1)) &
--            " LastByte:" & Basic_types_I.Unsigned_8_T'Image (Tc_Data (Tc_Len)));

      end if;
   end Retrieve_First_Pus_Tc;

-- Rountines not declared in the interface (end)
-- --------------------------------------------------------------------------------------




end Bus_1553_Pus.Rt_Sa;

