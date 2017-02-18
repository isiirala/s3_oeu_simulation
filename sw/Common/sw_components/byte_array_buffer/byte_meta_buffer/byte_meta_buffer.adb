

with Ada.Synchronous_Task_Control;


package body Byte_Meta_Buffer is


   subtype Leng_01_Raw_T is Basic_Types_I.Byte_Array_T (1 .. 1);
   Null_Leng_01_Raw_C : constant Leng_01_Raw_T := (others => 0);
   subtype Leng_02_Raw_T is Basic_Types_I.Byte_Array_T (1 .. 2);
   Null_Leng_02_Raw_C : constant Leng_02_Raw_T := (others => 0);
   subtype Leng_04_Raw_T is Basic_Types_I.Byte_Array_T (1 .. 4);
   Null_Leng_04_Raw_C : constant Leng_04_Raw_T := (others => 0);


-- Complete metadata to hold data length and user metadata
   Complete_Meta_Raw_Byte_Len_C : constant Basic_Types_I.Unsigned_32_T :=
     Basic_Types_I.Byte_Length_To_Num_Bytes_C (Bytes_For_Data_Len) +
     User_Meta_Byte_Len;

   subtype Complete_Meta_Raw_T is Basic_Types_I.Byte_Array_T (1 ..
     Complete_Meta_Raw_Byte_Len_C);
   Null_Complete_Meta_Raw_C : constant Complete_Meta_Raw_T := (others => 0);


   Lock : Ada.Synchronous_Task_Control.Suspension_Object;
   -- Lock to make thread self the read and write operations


   procedure U08_To_Raw
     (Data_Len   : in Basic_Types_I.Unsigned_32_T;
      Meta_Raw   : in out Complete_Meta_Raw_T;
      Next_Index : out Basic_Types_I.Unsigned_32_T)
   is
      Local_Len : Basic_Types_I.Unsigned_8_T := Basic_Types_I.Unsigned_8_T
        (Data_Len);
      Local_Raw : Leng_01_Raw_T;
      for Local_Raw'Address use Local_Len'Address;
   begin
      Meta_Raw (1 .. 1) := Local_Raw (1 .. 1);
      Next_Index        := 2;
   end U08_To_Raw;

   procedure U16_To_Raw
     (Data_Len   : in Basic_Types_I.Unsigned_32_T;
      Meta_Raw   : in out Complete_Meta_Raw_T;
      Next_Index : out Basic_Types_I.Unsigned_32_T)
   is
      Local_Len : Basic_Types_I.Unsigned_16_T := Basic_Types_I.Unsigned_16_T
        (Data_Len);
      Local_Raw : Leng_02_Raw_T;
      for Local_Raw'Address use Local_Len'Address;
   begin
      Meta_Raw (1 .. 2) := Local_Raw (1 .. 2);
      Next_Index        := 3;
   end U16_To_Raw;

   procedure U32_To_Raw
     (Data_Len   : in Basic_Types_I.Unsigned_32_T;
      Meta_Raw   : in out Complete_Meta_Raw_T;
      Next_Index : out Basic_Types_I.Unsigned_32_T)
   is
      Local_Len : Basic_Types_I.Unsigned_32_T := Data_Len;
      Local_Raw : Leng_04_Raw_T;
      for Local_Raw'Address use Local_Len'Address;
   begin
      Meta_Raw (1 .. 4) := Local_Raw (1 .. 4);
      Next_Index        := 5;
   end U32_To_Raw;


   procedure Raw_To_U08
     (Meta_Raw   : in Complete_Meta_Raw_T;
      Data_Len   : out Basic_Types_I.Unsigned_32_T;
      Next_Index : out Basic_Types_I.Unsigned_32_T)
   is
      Local_Raw : Leng_01_Raw_T  := Null_Leng_01_Raw_C;
      Local_Len : Basic_Types_I.Unsigned_8_T;
      for Local_Len'Address use Local_Raw'Address;
   begin
      Local_Raw (1 .. 1) := Meta_Raw (1 .. 1);
      Data_Len           := Basic_Types_I.Unsigned_32_T (Local_Len);
      Next_Index         := 2;
   end Raw_To_U08;

   procedure Raw_To_U16
     (Meta_Raw   : in Complete_Meta_Raw_T;
      Data_Len   : out Basic_Types_I.Unsigned_32_T;
      Next_Index : out Basic_Types_I.Unsigned_32_T)
   is
      Local_Raw : Leng_02_Raw_T  := Null_Leng_02_Raw_C;
      Local_Len : Basic_Types_I.Unsigned_16_T;
      for Local_Len'Address use Local_Raw'Address;
   begin
      Local_Raw (1 .. 2) := Meta_Raw (1 .. 2);
      Data_Len           := Basic_Types_I.Unsigned_32_T (Local_Len);
      Next_Index         := 3;
   end Raw_To_U16;

   procedure Raw_To_U32
     (Meta_Raw   : in Complete_Meta_Raw_T;
      Data_Len   : out Basic_Types_I.Unsigned_32_T;
      Next_Index : out Basic_Types_I.Unsigned_32_T)
   is
      Local_Raw : Leng_04_Raw_T  := Null_Leng_04_Raw_C;
      Local_Len : Basic_Types_I.Unsigned_32_T;
      for Local_Len'Address use Local_Raw'Address;
   begin
      Local_Raw (1 .. 4) := Meta_Raw (1 .. 4);
      Data_Len           := Local_Len;
      Next_Index         := 5;
   end Raw_To_U32;


   procedure Join_Complete_Meta
     (User_Meta     : in Meta_Raw_T;
      Data_Len      : in Basic_Types_I.Unsigned_32_T;
      Complete_Meta : in out Complete_Meta_Raw_T;
      Result        : out Buffer_Result_T)
   is
      First_Index_C : constant Basic_Types_I.Unsigned_32_T := User_Meta'First;
      Last_Index_C  : constant Basic_Types_I.Unsigned_32_T := User_Meta'Last;
      Complete_Last_Index_C : constant Basic_Types_I.Unsigned_32_T :=
        Complete_Meta'Last;
      Index_1_For_User_Meta : Basic_Types_I.Unsigned_32_T := 0;
   begin
      Result := Result_Ok;

      if Data_Len <= Max_Byte_Per_Operation_C then
         case Bytes_For_Data_Len is
            when Basic_Types_I.One_Byte =>
               U08_To_Raw
                 (Data_Len   => Data_Len,
                  Meta_Raw   => Complete_Meta,
                  Next_Index => Index_1_For_User_Meta);

            when Basic_Types_I.Two_Bytes =>
               U16_To_Raw
                 (Data_Len   => Data_Len,
                  Meta_Raw   => Complete_Meta,
                  Next_Index => Index_1_For_User_Meta);

            when Basic_Types_I.Four_Bytes =>
               U32_To_Raw
                 (Data_Len   => Data_Len,
                  Meta_Raw   => Complete_Meta,
                  Next_Index => Index_1_For_User_Meta);
         end case;

         if ( (Complete_Last_Index_C - Index_1_For_User_Meta) =
           (Last_Index_C - First_Index_C) ) then
            Complete_Meta (Index_1_For_User_Meta .. Complete_Last_Index_C) :=
              User_Meta (First_Index_C .. Last_Index_C);
         else
            Result := Result_Internal_Error;
         end if;
      else
         Result := Result_Data_Too_Long;
      end if;
   end Join_Complete_Meta;

   procedure Split_Complete_Meta
     (Complete_Meta : in Complete_Meta_Raw_T;
      Data_Len      : out Basic_Types_I.Unsigned_32_T;
      User_Meta     : out Meta_Raw_T;
      Result        : out Buffer_Result_T)
   is
      First_Index_C : constant Basic_Types_I.Unsigned_32_T := User_Meta'First;
      Last_Index_C  : constant Basic_Types_I.Unsigned_32_T := User_Meta'Last;
      Complete_Last_Index_C : constant Basic_Types_I.Unsigned_32_T :=
        Complete_Meta'Last;
      Index_1_Of_User_Meta  : Basic_Types_I.Unsigned_32_T := 0;
   begin
      Data_Len  := 0;
      User_Meta := Null_Meta_Raw_C;
      Result    := Result_Internal_Error;

      case Bytes_For_Data_Len is
         when Basic_Types_I.One_Byte =>
            Raw_To_U08
              (Meta_Raw   => Complete_Meta,
               Data_Len   => Data_Len,
               Next_Index => Index_1_Of_User_Meta);

         when Basic_Types_I.Two_Bytes =>
            Raw_To_U16
              (Meta_Raw   => Complete_Meta,
               Data_Len   => Data_Len,
               Next_Index => Index_1_Of_User_Meta);

         when Basic_Types_I.Four_Bytes =>
            Raw_To_U32
              (Meta_Raw   => Complete_Meta,
               Data_Len   => Data_Len,
               Next_Index => Index_1_Of_User_Meta);
      end case;

      if ( (Complete_Last_Index_C - Index_1_Of_User_Meta) =
        (Last_Index_C - First_Index_C) ) then

         User_Meta (First_Index_C .. Last_Index_C) :=
           Complete_Meta (Index_1_Of_User_Meta .. Complete_Last_Index_C);
         Result := Result_Ok;
      end if;
   end Split_Complete_Meta;


   procedure Get_Lock is
   begin

      if Use_Protection then
-- Wait until lock is open and close it
         Ada.Synchronous_Task_Control.Suspend_Until_True (Lock);
      end if;
   end Get_Lock;

   procedure Release_Lock is
   begin

      if Use_Protection then
-- Open the lock
         Ada.Synchronous_Task_Control.Set_True (Lock);
      end if;
   end Release_Lock;


   procedure New_Buffer(Buffer : out Buffer_T) is
   begin
      Buffer := new Buffer_Record_T;
      Buffer.Meta_Buffer := new Meta_Buff.Buffer_Record_T;
      Buffer.Data_Buffer := new Data_Buff.Buffer_Record_T;
      Initialize (Buffer);
   end New_Buffer;

   procedure Initialize(Buffer : access Buffer_Record_T'Class) is
   begin

-- Init each buffer
      Buffer.Meta_Buffer.Initialize;
      Buffer.Data_Buffer.Initialize;

-- Init the lock in the release status
      Release_Lock;
   end Initialize;


   procedure Insert
     (Buffer   : access Buffer_Record_T'Class;
      Meta_Raw : in Meta_Raw_T;
      Data_Raw : in Basic_Types_I.Byte_Array_T;
      Result   : out Buffer_Result_T)
   is
      use type Meta_Buff.Buffer_Result_T;
      use type Data_Buff.Buffer_Result_T;

      Data_Len_C  : constant Basic_Types_I.Unsigned_32_T := Data_Raw'Length;

      All_Meta_Raw    : Complete_Meta_Raw_T   := Null_Complete_Meta_Raw_C;
      Meta_Result : Meta_Buff.Buffer_Result_T :=
        Meta_Buff.Buffer_Result_T'First;
      Data_Result : Data_Buff.Buffer_Result_T :=
        Data_Buff.Buffer_Result_T'First;
   begin
      Result := Result_Ok;

-- Enter in the exclusion area
      Get_Lock;

      if Buffer.Meta_Buffer.Empty_Bytes < Complete_Meta_Raw_Byte_Len_C then
         Result := Result_Meta_Full;
      elsif Buffer.Data_Buffer.Empty_Bytes < Data_Len_C then
         Result := Result_Data_Full;
      end if;

      if Result = Result_Ok then

         Join_Complete_Meta
           (User_Meta     => Meta_Raw,
            Data_Len      => Data_Len_C,
            Complete_Meta => All_Meta_Raw,
            Result        => Result);

         if Result = Result_Ok then

            Buffer.Meta_Buffer.Insert
              (Data   => All_Meta_Raw,
               Result => Meta_Result);
            if Meta_Result = Meta_Buff.Result_Full then
               Result := Result_Meta_Full;
            elsif Meta_Result = Meta_Buff.Result_Empty then
               Result := Result_Meta_Empty;
            else

               Buffer.Data_Buffer.Insert
                 (Data   => Data_Raw,
                  Result => Data_Result);
               if Data_Result /= Data_Buff.Result_Ok then
                  Result := Result_Unsynchronized;
               end if;
            end if;
         end if;
      end if;

-- Go out from the exclusion area
      Release_Lock;
   end Insert;


   procedure Retrieve
     (Buffer     : access Buffer_Record_T'Class;
      Data_Raw   : in out Basic_Types_I.Byte_Array_T;
      Last_Index : out Basic_Types_I.Unsigned_32_T;
      Meta_Raw   : out Meta_Raw_T;
      Result     : out Buffer_Result_T)
   is
      use type Meta_Buff.Buffer_Result_T;
      use type Data_Buff.Buffer_Result_T;

      Data_Len_C   : constant Basic_Types_I.Unsigned_32_T := Data_Raw'Length;
      Data_First_C : constant Basic_Types_I.Unsigned_32_T := Data_Raw'First;

      Complete_Meta_Raw  : Complete_Meta_Raw_T    := Null_Complete_Meta_Raw_C;
      Meta_Result : Meta_Buff.Buffer_Result_T     :=
        Meta_Buff.Buffer_Result_T'First;
      Data_Result : Data_Buff.Buffer_Result_T     :=
        Data_Buff.Buffer_Result_T'First;
      Data_Last   : Basic_Types_I.Unsigned_32_T   := 0;
      Len_From_Meta : Basic_Types_I.Unsigned_32_T := 0;
      Meta_Undo   : Meta_Buff.Buffer_Undo_Record_T;

   begin

      Last_Index := 0;
      Meta_Raw   := Null_Meta_Raw_C;
      Result     := Result_Meta_Empty;

-- Enter in the exclusion area
      Get_Lock;

-- Retrieve the next (FIFO) metadata
      Meta_Undo := Buffer.Meta_Buffer.Get_Undo_Data;
      Buffer.Meta_Buffer.Exact_Retrieve
        (Data   => Complete_Meta_Raw,
         Result => Meta_Result);
      if Meta_Result = Meta_Buff.Result_Full then
         Result := Result_Meta_Full;
      elsif Meta_Result = Meta_Buff.Result_Empty then
         Result := Result_Meta_Empty;
      else
-- Get the metadata structure and check if the data buffer contains
-- enought space to store the corresponding data to this metadata
         Split_Complete_Meta
           (Complete_Meta => Complete_Meta_Raw,
            Data_Len      => Len_From_Meta,
            User_Meta     => Meta_Raw,
            Result        => Result);


         if Data_Len_C < Len_From_Meta then

-- If data does not fit into the buffer, return Result_Data_Too_Short and make
-- an undo in the metadata buffer, if there is an error executing the undo
-- returns Unsynchronized because Metadata and Data are not synchronized
            Buffer.Meta_Buffer.Set_Undo_Data(Meta_Undo, Meta_Result);
            if Meta_Result = Meta_Buff.Result_Ok then
               Result := Result_Data_Too_Short;
            else
               Result := Result_Unsynchronized;
            end if;
         else
            Data_Last := Data_First_C + Len_From_Meta - 1;
            Buffer.Data_Buffer.Exact_Retrieve
              (Data   => Data_Raw(Data_First_C .. Data_Last),
               Result => Data_Result);
            if Data_Result = Data_Buff.Result_Full then
               Result := Result_Meta_Full;
            elsif Data_Result = Data_Buff.Result_Empty then
               Result := Result_Meta_Empty;
            else
               Result := Result_Ok;
            end if;
            Last_Index := Data_Last;
         end if;
      end if;

-- Go out from the exclusion area
      Release_Lock;
   end Retrieve;

   function Get_Num_Items(Buffer     : access Buffer_Record_T'Class)
     return Basic_Types_I.Unsigned_32_T
   is
      Used_C       : constant Basic_Types_I.Unsigned_32_T :=
        Buffer.Meta_Buffer.Used_Bytes;
      Len_A_Meta_C : constant Basic_Types_I.Unsigned_32_T :=
        Complete_Meta_Raw_Byte_Len_C;
   begin

      return Used_C / Len_A_Meta_C;
   end Get_Num_Items;

end Byte_Meta_Buffer;

