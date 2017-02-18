
package body Byte_Array_Buffer is


   procedure Incr_Index
     (Index : in out Buffer_Range_T;
      Count : in Basic_Types_I.Unsigned_32_T) is
   begin

      if (Index + Count) > Last_Index_C then
         Index := First_Index_C + (Count - (Last_Index_C - Index)) - 1;
      else
         Index := Index + Count;
      end if;
   end Incr_Index;


   function Empty_Bytes_From_W_To_End
     (Buffer : access Buffer_Record_T'Class) return Basic_Types_I.Unsigned_32_T
   is
      Result : Basic_Types_I.Unsigned_32_T  := 0;
   begin

-- Returns the empty bytes from W_Index until Last_Index_C or until R_Index
      if Buffer.Read_Index <= Buffer.Write_Index then
         Result := (Last_Index_C - Buffer.Write_Index) + 1;

      else
         Result := (Buffer.Read_Index - Buffer.Write_Index);
      end if;
      return Result;
   end Empty_Bytes_From_W_To_End;


   function Empty_Bytes_From_Begin_To_R
     (Buffer : access Buffer_Record_T'Class) return Basic_Types_I.Unsigned_32_T
   is
      Result : Basic_Types_I.Unsigned_32_T  := 0;
   begin

-- Returns the empty bytes from First_Index_C until R_Index or 0 if W_Index < R
      if Buffer.Read_Index <= Buffer.Write_Index then
         Result := Buffer.Read_Index - First_Index_C;
      else
         Result := 0;
      end if;
      return Result;
   end Empty_Bytes_From_Begin_To_R;


   procedure New_Buffer(Buffer : out Buffer_T) is
   begin
      Buffer := new Buffer_Record_T;
      Initialize (Buffer);
   end New_Buffer;

   procedure Initialize(Buffer : access Buffer_Record_T'Class) is
   begin
      Buffer.Data         := (others => 0);
      Buffer.Read_Index   := Buffer_Range_T'First;
      Buffer.Write_Index  := Buffer_Range_T'First;
--      Buffer.Data_Full    := False;
   end Initialize;


   procedure Insert
     (Buffer : access Buffer_Record_T'Class;
      Data   : in Basic_Types_I.Byte_Array_T;
      Result : out Buffer_Result_T)
   is
      Data_Len_C   : constant Basic_Types_I.Unsigned_32_T   := Data'Length;
      Data_First_C : constant Basic_Types_I.Unsigned_32_T   := Data'First;
      Data_Last_C  : constant Basic_Types_I.Unsigned_32_T   := Data'Last;

      Empty_Until_Last : Basic_Types_I.Unsigned_32_T  := 0;
      Source_Last_1    : Basic_Types_I.Unsigned_32_T  := 0;
      Source_First_2   : Basic_Types_I.Unsigned_32_T  := 0;
      Target_Last_1    : Buffer_Range_T               := 0;
      Target_Last_2    : Buffer_Range_T               := 0;
      Second_Set       : Boolean                      := False;

   begin
      Result := Result_Ok;

      if Data_Len_C <= Empty_Bytes(Buffer) then

         Empty_Until_Last := Empty_Bytes_From_W_To_End (Buffer);
         if Data_Len_C <= Empty_Until_Last then

            Target_Last_1 := Buffer.Write_Index + Data_Len_C - 1;
            Source_Last_1 := Data_Last_C;

         else
            Second_Set    := True;
            Target_Last_1 := Last_Index_C;
            Source_Last_1 := Data_First_C + Empty_Until_Last - 1;

            Target_Last_2  := Data_Len_C - Empty_Until_Last - 1;
            Source_First_2 := Source_Last_1 + 1;
         end if;

         Buffer.Data(Buffer.Write_Index .. Target_Last_1) :=
           Data(Data_First_C .. Source_Last_1);

         if Second_Set then
            Buffer.Data (First_Index_C .. Target_Last_2) :=
              Data(Source_First_2 .. Data_Last_C);
         end if;
         Incr_Index(Buffer.Write_Index, Data_Len_C);
      else
         Result := Result_Full;
      end if;
   end Insert;


   procedure Exact_Retrieve
     (Buffer : access Buffer_Record_T'Class;
      Data   : in out Basic_Types_I.Byte_Array_T;
      Result : out Buffer_Result_T)
   is
      Data_Len_C      : constant Basic_Types_I.Unsigned_32_T := Data'Length;
      Data_First_C    : constant Basic_Types_I.Unsigned_32_T := Data'First;
      Data_Last_C     : constant Basic_Types_I.Unsigned_32_T := Data'Last;

      Target_Last_1   : Basic_Types_I.Unsigned_32_T          := 0;
      Target_First_2  : Basic_Types_I.Unsigned_32_T          := 0;
      Source_Last_1   : Buffer_Range_T                       := 0;
      Source_Last_2   : Buffer_Range_T                       := 0;
      Used_Length     : Basic_Types_I.Unsigned_32_T          := 0;
      Used_Until_Last : Basic_Types_I.Unsigned_32_T          := 0;
      Second_Get      : Boolean                              := False;

   begin
      Result := Result_Ok;

      Used_Length := (Byte_Len - 1) - Empty_Bytes(Buffer);
      if Used_Length >= Data_Len_C then

-- The buffer contains at last the required length. Get bytes from R_Index
-- until buffer end, if required length is bigger, get bytes from buffer begin
-- until W_Index
         Used_Until_Last := (Last_Index_C - Buffer.Read_Index) + 1;

         if Data_Len_C <= Used_Until_Last then

            Target_Last_1 := Data_Last_C;
            Source_Last_1 := Buffer.Read_Index + Data_Len_C - 1;
         else
            Second_Get    := True;
            Target_Last_1 := Data_First_C + Used_Until_Last - 1;
            Source_Last_1 := Last_Index_C;

            Target_First_2 := Target_Last_1 + 1;
            Source_Last_2  := First_Index_C + (Data_Len_C - Used_Until_Last) - 1;
         end if;

         Data(Data_First_C .. Target_Last_1) :=
           Buffer.Data(Buffer.Read_Index .. Source_Last_1);

         if Second_Get then
            Data(Target_First_2 .. Data_Last_C) :=
              Buffer.Data(First_Index_C .. Source_Last_2);
         end if;

         Incr_Index(Buffer.Read_Index, Data_Len_C);
      else
         Result := Result_Empty;
      end if;
   end Exact_Retrieve;


   procedure Retrieve
     (Buffer     : access Buffer_Record_T'Class;
      Data       : in out Basic_Types_I.Byte_Array_T;
      Last_Index : out Basic_Types_I.Unsigned_32_T;
      Result     : out Buffer_Result_T)
   is
      Data_Len_C      : constant Basic_Types_I.Unsigned_32_T  := Data'Length;
      Data_First_C    : constant Basic_Types_I.Unsigned_32_T  := Data'First;
      Data_Last_C     : constant Basic_Types_I.Unsigned_32_T  := Data'Last;

      Used_Length     : Basic_Types_I.Unsigned_32_T           := 0;
      Used_Last_Index : Basic_Types_I.Unsigned_32_T           := 0;
   begin

      Last_Index := 0;
      Result     := Result_Ok;

      Used_Length := (Byte_Len - 1) - Empty_Bytes(Buffer);
      if Used_Length = 0 then

         Result := Result_Empty;

      else
-- If there is less data in Buffer than requested, adapt the reading length to
-- get all data in buffer
         if Used_Length >= Data_Len_C then
            Used_Last_Index := Data_Last_C;
         else
            Used_Last_Index := Data_First_C + Used_Length - 1;
         end if;

         Exact_Retrieve
           (Buffer => Buffer,
            Data   => Data(Data_First_C .. Used_Last_Index),
            Result => Result);
         Last_Index := Used_Last_Index;

      end if;
   end Retrieve;


   function Empty_Bytes
     (Buffer : access Buffer_Record_T'Class) return Basic_Types_I.Unsigned_32_T
   is
      Result : Basic_Types_I.Unsigned_32_T  := (Byte_Len - 1);
   begin

-- When the two index are equal means Buffer empty
-- When W index + 1 = R index means Buffer full (the max used length is
-- Byte_Len - 1), for this reason the result is decremented in one
      if Buffer.Read_Index /= Buffer.Write_Index then
         Result := Empty_Bytes_From_W_To_End(Buffer) +
           Empty_Bytes_From_Begin_To_R(Buffer) - 1;
      end if;
      return Result;
   end Empty_Bytes;

   function Used_Bytes
     (Buffer : access Buffer_Record_T'Class) return Basic_Types_I.Unsigned_32_T
   is
   begin
      return ((Byte_Len - 1) - Empty_Bytes(Buffer));
   end Used_Bytes;

   function Get_Undo_Data
     (Buffer    : access Buffer_Record_T'Class) return Buffer_Undo_Record_T
   is
      Undo_Data : Buffer_Undo_Record_T;
   begin
      Undo_Data.Read_Index  := Buffer.Read_Index;
      Undo_Data.Write_Index := Buffer.Write_Index;
      Undo_Data.Good_Values := True;
      return Undo_Data;
   end Get_Undo_Data;

   procedure Set_Undo_Data
     (Buffer    : access Buffer_Record_T'Class;
      Undo_Data : in out Buffer_Undo_Record_T;
      Result    : out Buffer_Result_T)
   is
   begin
      Result := Result_Empty;
      if Undo_Data.Good_Values then
         Buffer.Read_Index     := Undo_Data.Read_Index;
         Buffer.Write_Index    := Undo_Data.Write_Index;
         Undo_Data.Good_Values := False;
         Result                := Result_Ok;
      end if;
   end Set_Undo_Data;


   procedure Test_Point
     (Buffer   : access Buffer_Record_T'Class;
      R_Index  : out Buffer_Range_T;
      W_Index  : out Buffer_Range_T)
   is
   begin
      R_Index := Buffer.Read_Index;
      W_Index := Buffer.Write_Index;
   end Test_Point;

end Byte_Array_Buffer;

