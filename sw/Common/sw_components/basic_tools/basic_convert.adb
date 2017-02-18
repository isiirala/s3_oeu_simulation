

with Basic_Tools;

package body Basic_Convert is


-- ======================================================================================
-- %% Type and constant declarations
-- ======================================================================================



-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   function Unsig_16_To_Array_Bits_Invert
     (Input_Data : in  Basic_Types_I.Unsigned_16_T)
     return Basic_Types_I.Array_16_Bits_T
   is
      New_Int     : Basic_Types_I.Unsigned_16_T;
      New_Word    : Basic_Types_I.Array_16_Bits_T;

      for New_Word use at New_Int'Address;
      pragma Volatile (New_Word);
   begin

-- Take a copy of the input
      New_Int := Input_Data;

-- New_Word and New_Int are overlaid, in New_Word there is an
-- implicit conversion
      return (New_Word);
   end Unsig_16_To_Array_Bits_Invert;


   function Array_Bits_To_Unsig_16
     (Input_Data   : in  Basic_Types_I.Array_16_Bits_T)
     return Basic_Types_I.Unsigned_16_T
   is

      New_Bits    : Basic_Types_I.Array_16_Bits_T;
      New_Int     : Basic_Types_I.Unsigned_16_T;
      for New_Int use at New_Bits'Address;
      pragma Volatile(New_Int);

   begin

-- Take a copy of the input
      New_Bits := Input_Data;

-- New_Int and New_Bits are overlaid, returning New_Int does an
-- implicit conversion
      return (New_Int);
   end Array_Bits_To_Unsig_16;




-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Byte_Swap
     (Message   : in out Basic_Types_I.Uint8_Array_Nc_T)
   is
      use type Basic_Types_I.Uint32_T;

      One_Byte     : Basic_Types_I.Uint8_T             := 0;
      I            : Basic_Types_I.Uint32_T            := Message'First;
      J            : Basic_Types_I.Uint32_T            := Message'Last;
   begin

      loop
         One_Byte := Message (I);
         Message (I) := Message (J);
         Message (J) := One_Byte;
         I := I + 1;
         J := J - 1;
         exit when I >= J;
      end loop;
   end Byte_Swap;


   function Extract_Num_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Uint32_T
   is
      use type Basic_Types_I.Uint32_T;

      Bytes_Len_C    : constant Basic_Types_I.Uint32_T := Bytes'Length;
      Bytes_First_C  : constant Basic_Types_I.Uint32_T := Bytes'First;
      Bytes_Last_C   : constant Basic_Types_I.Uint32_T := Bytes'Last;
      Local_In_Bytes : Basic_Types_I.Byte_Array_T (1 .. Bytes_Len_C) := Bytes;
      Convert_Bytes  : Basic_Types_I.Byte_Array_T (1 .. 4) := (others => 0);
      Local_Uint32   : Basic_Types_I.Uint32_T;

      for Local_Uint32 use at Convert_Bytes'Address;
      pragma Volatile (Local_Uint32);


--      Return_Val    : Basic_Types_I.Uint32_T          := 0;
   begin

      if Bytes_Len_C <= 4 then
         Byte_Swap (Basic_Types_I.Uint8_Array_Nc_T (Local_In_Bytes));
         Convert_Bytes (1 .. Bytes_Len_C) := Local_In_Bytes (1 .. Bytes_Len_C);
      end if;
      return Local_Uint32;
   end Extract_Num_Swap;

   function Extract_Num_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Int32_T
   is
      use type Basic_Types_I.Uint32_T;

      Bytes_Len_C    : constant Basic_Types_I.Uint32_T := Bytes'Length;
      Bytes_First_C  : constant Basic_Types_I.Uint32_T := Bytes'First;
      Bytes_Last_C   : constant Basic_Types_I.Uint32_T := Bytes'Last;
      Local_In_Bytes : Basic_Types_I.Byte_Array_T (1 .. Bytes_Len_C) := Bytes;
      Convert_Bytes  : Basic_Types_I.Byte_Array_T (1 .. 4) := (others => 0);
      Local_Int32    : Basic_Types_I.Int32_T;

      for Local_Int32 use at Convert_Bytes'Address;
      pragma Volatile (Local_Int32);

   begin

      if Bytes_Len_C <= 4 then
         Byte_Swap (Basic_Types_I.Uint8_Array_Nc_T (Local_In_Bytes));
         Convert_Bytes (1 .. Bytes_Len_C) := Local_In_Bytes (1 .. Bytes_Len_C);
      end if;
      return Local_Int32;
   end Extract_Num_Swap;

   function Extract_Num_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Float_T
   is
      use type Basic_Types_I.Uint32_T;

      Bytes_Len_C    : constant Basic_Types_I.Uint32_T := Bytes'Length;
      Bytes_First_C  : constant Basic_Types_I.Uint32_T := Bytes'First;
      Bytes_Last_C   : constant Basic_Types_I.Uint32_T := Bytes'Last;
      Local_In_Bytes : Basic_Types_I.Byte_Array_T (1 .. Bytes_Len_C) := Bytes;
      Convert_Bytes  : Basic_Types_I.Byte_Array_T (1 .. 4) := (others => 0);
      Local_Flt      : Basic_Types_I.Float_T;

      for Local_Flt use at Convert_Bytes'Address;
      pragma Volatile (Local_Flt);

   begin

      if Bytes_Len_C <= 4 then
         Byte_Swap (Basic_Types_I.Uint8_Array_Nc_T (Local_In_Bytes));
         Convert_Bytes (1 .. Bytes_Len_C) := Local_In_Bytes (1 .. Bytes_Len_C);
      end if;
      return Local_Flt;
   end Extract_Num_Swap;


   function Extract_Cuc_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Cuc_Time_T
   is
      use type Basic_Types_I.Uint32_T;

      Bytes_Len_C    : constant Basic_Types_I.Uint32_T := Bytes'Length;
      Bytes_First_C  : constant Basic_Types_I.Uint32_T := Bytes'First;
      Bytes_Last_C   : constant Basic_Types_I.Uint32_T := Bytes'Last;
      Local_In_Bytes : Basic_Types_I.Byte_Array_T (1 .. Bytes_Len_C) := Bytes;
      Convert_Bytes  : Basic_Types_I.Byte_Array_T (1 .. 7) := (others => 0);
      Local_Cuc      : Basic_Types_I.Cuc_Time_T;

      for Local_Cuc use at Convert_Bytes'Address;
      pragma Volatile (Local_Cuc);

   begin

      if Bytes_Len_C = 7 then
         Byte_Swap (Basic_Types_I.Uint8_Array_Nc_T (Local_In_Bytes));
         Convert_Bytes (1 .. Bytes_Len_C) := Local_In_Bytes (1 .. Bytes_Len_C);
      end if;
      return Local_Cuc;

   end Extract_Cuc_Swap;

   function Extract_Cuc
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Cuc_Time_T
   is
      use type Basic_Types_I.Uint32_T;

      Bytes_Len_C    : constant Basic_Types_I.Uint32_T := Bytes'Length;
      Local_In_Bytes : Basic_Types_I.Byte_Array_T (1 .. Bytes_Len_C) := Bytes;
      Convert_Bytes  : Basic_Types_I.Byte_Array_T (1 .. 7) := (others => 0);
      Local_Cuc      : Basic_Types_I.Cuc_Time_T;

      for Local_Cuc use at Convert_Bytes'Address;
      pragma Volatile (Local_Cuc);

   begin

      if Bytes_Len_C = 7 then
         Convert_Bytes (1 .. Bytes_Len_C) := Local_In_Bytes (1 .. Bytes_Len_C);
      end if;
      return Local_Cuc;

   end Extract_Cuc;


   procedure Pack_Cuc
     (Value : in Basic_Types_I.Cuc_Time_T;
      Bytes : in out Basic_Types_I.Byte_Array_T)
   is
      use type Basic_Types_I.Uint32_T;

      Cuc_Len_C     : constant Basic_Types_I.Uint32_T   := 7;
      Bytes_Len_C   : constant Basic_Types_I.Uint32_T   := Bytes'Length;
      Bytes_Fst_C   : constant Basic_Types_I.Uint32_T   := Bytes'First;
      Bytes_End_C   : constant Basic_Types_I.Uint32_T   := Bytes'First + Cuc_Len_C - 1;

      Array_Result  : Basic_Types_I.Byte_Array_T (1 .. Cuc_Len_C)  := (others => 0);
      Local_Value   : Basic_Types_I.Cuc_Time_T;
      for Local_Value'Address use Array_Result'Address;
      pragma Volatile (Local_Value);
   begin

      if Bytes_Len_C >= Cuc_Len_C then
         Local_Value := Value;
         Bytes (Bytes_Fst_C .. Bytes_End_C) := Array_Result;
      end if;
   end Pack_Cuc;


   function Str_To_Byte_Array
     (Str           : in Basic_Types_I.String_T) return Basic_Types_I.Byte_Array_T
   is
      First_C       : constant Basic_Types_I.Uint32_T  := Str'First;
      Last_C        : constant Basic_Types_I.Uint32_T  := Str'Last;

      Local_Str     : Basic_Types_I.String_T     (First_C .. Last_C) := Str;
      Local_Array   : Basic_Types_I.Byte_Array_T (First_C .. Last_C);
      for Local_Array'Address use Local_Str'Address;
   begin
      return Local_Array;
   end Str_To_Byte_Array;

   function Byte_Array_To_Str
     (Byte_Array    : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.String_T
   is
      First_C       : constant Basic_Types_I.Uint32_T  := Byte_Array'First;
      Last_C        : constant Basic_Types_I.Uint32_T  := Byte_Array'Last;

      Local_Array   : Basic_Types_I.Byte_Array_T (First_C .. Last_C) := Byte_Array;
      Local_Str     : Basic_Types_I.String_T     (First_C .. Last_C);
      for Local_Str'Address use Local_Array'Address;
   begin
      return Local_Str;
   end Byte_Array_To_Str;

   procedure Byte_Array_To_Str
     (Byte_Array : in Basic_Types_I.Byte_Array_T;
      Str        : in out Basic_Types_I.String_T;
      Str_Len    : in out Basic_Types_I.Data_32_Len_T)
   is
      One_Byte  : Basic_Types_I.Uint8_T  := 0;
   begin


      for I in Byte_Array'Range loop
         One_Byte  := Byte_Array (I);
         Basic_Tools.Append_Base_16
           (Num       => One_Byte,
            Buff_Data => Str,
            Buff_Len  => Str_Len);
      end loop;
   end Byte_Array_To_Str;


   function Byte_8_Array_To_Bits (Bytes : in Basic_Types_I.Byte_8_Array_T)
     return Basic_Types_I.Array_64_Bits_T
   is
      Local_Bytes  : Basic_Types_I.Byte_8_Array_T := Bytes;
      Local_Bits   : Basic_Types_I.Array_64_Bits_T;
      for Local_Bits'Address use Local_Bytes'Address;
   begin

      return Local_Bits;
   end Byte_8_Array_To_Bits;




end Basic_Convert;

