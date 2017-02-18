-- ****************************************************************************
--  Project             : OLCI_ICM_SW
--  Unit Name           : Basic_Types
--  Unit Type           : Package specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/12/12 15:33:39 $
--  Revision            : $Revision: 1.2 $
--  Function            : Basic types and constants used in the OEU ICM APSW
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.17     iiiv 03/03/2010: Change names in accordance with the Coding
--                             Standard
--
--      Changes for oeu_simulation
--   - new name for Uint8_Array_Nc_T type: Byte_Array_T
--   - new enum for byte lengths
--   - new type of string_100
-- ****************************************************************************

with Interfaces;
with System;
with Ada.Real_Time;

package Basic_Types_I is


-----------------------------------------------------------------------------------------
-- Declaration of constants used in the next declarations of basic types
-----------------------------------------------------------------------------------------
   Size_1_C       : constant        := 1;
   Size_2_C       : constant        := 2;
   Size_3_C       : constant        := 3;
   Size_4_C       : constant        := 4;
   Size_5_C       : constant        := 5;
   Size_6_C       : constant        := 6;
   Size_7_C       : constant        := 7;
   Size_8_C       : constant        := 8;
   Size_9_C       : constant        := 9;
   Size_10_C      : constant        := 10;
   Size_11_C      : constant        := 11;
   Size_12_C      : constant        := 12;
   Size_13_C      : constant        := 13;
   Size_14_C      : constant        := 14;
   Size_15_C      : constant        := 15;
   Size_16_C      : constant        := 16;
   Size_17_C      : constant        := 17;
   Size_18_C      : constant        := 18;
   Size_19_C      : constant        := 19;
   Size_20_C      : constant        := 20;
   Size_21_C      : constant        := 21;
   Size_22_C      : constant        := 22;
   Size_23_C      : constant        := 23;
   Size_24_C      : constant        := 24;
   Size_25_C      : constant        := 25;
   Size_26_C      : constant        := 26;
   Size_27_C      : constant        := 27;
   Size_28_C      : constant        := 28;
   Size_29_C      : constant        := 29;
   Size_30_C      : constant        := 30;
   Size_31_C      : constant        := 31;
   Size_32_C      : constant        := 32;
   Size_48_C      : constant        := 48;
   Size_56_C      : constant        := 56;
   Size_64_C      : constant        := 64;

-----------------------------------------------------------------------------------------
-- Boolean type of one byte length
-----------------------------------------------------------------------------------------
   type Boolean_T is new Boolean;
   for Boolean_T use (False => 0, True => 1);
   for Boolean_T'Size use 8;

-----------------------------------------------------------------------------------------
-- Basic Unsigned types, with bit range from 1 until 64
-----------------------------------------------------------------------------------------
   type Unsigned_1_T       is  mod 2 ** Size_1_C;
   for  Unsigned_1_T'Size  use Size_1_C;

   type Unsigned_2_T       is  mod 2 ** Size_2_C;
   for  Unsigned_2_T'Size  use Size_2_C;

   type Unsigned_3_T       is  mod 2 ** Size_3_C;
   for  Unsigned_3_T'Size  use Size_3_C;

   type Unsigned_4_T       is  mod 2 ** Size_4_C;
   for  Unsigned_4_T'Size  use Size_4_C;

   type Unsigned_5_T       is  mod 2 ** Size_5_C;
   for  Unsigned_5_T'Size  use Size_5_C;

   type Unsigned_6_T       is  mod 2 ** Size_6_C;
   for  Unsigned_6_T'Size  use Size_6_C;

   type Unsigned_7_T       is  mod 2 ** Size_7_C;
   for  Unsigned_7_T'Size  use Size_7_C;

   type Unsigned_8_T       is  mod 2 ** Size_8_C;
   for  Unsigned_8_T'Size  use Size_8_C;
   subtype Byte_T          is  Unsigned_8_T;

   type Unsigned_10_T      is  mod 2 ** Size_10_C;
   for  Unsigned_10_T'Size use Size_10_C;

   type Unsigned_11_T      is  mod 2 ** Size_11_C;
   for  Unsigned_11_T'Size use Size_11_C;

   type Unsigned_12_T      is  mod 2 ** Size_12_C;
   for  Unsigned_12_T'Size use Size_12_C;

   type Unsigned_14_T      is  mod 2 ** Size_14_C;
   for  Unsigned_14_T'Size use Size_14_C;

   type Unsigned_15_T      is  mod 2 ** Size_15_C;
   for  Unsigned_15_T'Size use Size_15_C;

   type Unsigned_16_T      is  mod 2 ** Size_16_C;
   for  Unsigned_16_T'Size use Size_16_C;

   type Unsigned_19_T      is  mod 2 ** Size_19_C;
   for  Unsigned_19_T'Size use Size_19_C;

   type Unsigned_20_T      is  mod 2 ** Size_20_C;
   for  Unsigned_20_T'Size use Size_20_C;

   type Unsigned_24_T      is  mod 2 ** Size_24_C;
   for  Unsigned_24_T'Size use Size_24_C;

   type Unsigned_28_T      is  mod 2 ** Size_28_C;
   for  Unsigned_28_T'Size use Size_28_C;

   type Unsigned_32_T     is  mod 2 ** Size_32_C;
   for  Unsigned_32_T'Size use Size_32_C;

   type Unsigned_48_T      is  mod 2 ** Size_48_C;
   for  Unsigned_48_T'Size use Size_48_C;

   type Unsigned_56_T      is  mod 2 ** Size_56_C;
   for  Unsigned_56_T'Size use Size_56_C;

   type Unsigned_64_T      is  mod 2 ** Size_64_C;
   for  Unsigned_64_T'Size use Size_64_C;



-----------------------------------------------------------------------------------------
-- Range subtypes, used to define arrays of 16 and 32 bits
-- TODO. Deberian llamarse simplemente Range_x_T
-----------------------------------------------------------------------------------------
   subtype Range_4_T          is Unsigned_16_T range 1 .. 4;

   subtype Range_8_Bits_T     is Unsigned_16_T range 0 .. 7;
   subtype Range_16_Bits_T    is Unsigned_16_T range 0 .. 15;
   subtype Range_32_Bits_T    is Unsigned_16_T range 0 .. 31;
   subtype Range_64_Bits_T    is Unsigned_16_T range 0 .. 63;


-----------------------------------------------------------------------------------------
-- Basic signed types of 8, 16, 32 and 64 bits
-----------------------------------------------------------------------------------------
   type Integer_8_T is range
     -(2 ** (Size_8_C - 1)) .. ((2 ** (Size_8_C - 1)) - 1);
   for Integer_8_T'Size use Size_8_C;

   type Integer_16_T is range
     -(2 ** (Size_16_C - 1)) .. ((2 ** (Size_16_C - 1)) - 1);
   for Integer_16_T'Size use Size_16_C;

   type Integer_32_T is range
     -(2 ** (Size_32_C - 1)) .. ((2 ** (Size_32_C - 1)) - 1);
   for Integer_32_T'Size use Size_32_C;

   type Integer_64_T is range
     -(2 ** (Size_64_C - 1)) .. ((2 ** (Size_64_C - 1)) - 1);
   for Integer_64_T'Size use Size_64_C;



-----------------------------------------------------------------------------------------
-- Redefinition of the float type
-----------------------------------------------------------------------------------------
   subtype Float_T         is  Interfaces.IEEE_Float_32;


-----------------------------------------------------------------------------------------
-- Redefinition of the real time
-----------------------------------------------------------------------------------------
   subtype Time_T          is  Ada.Real_Time.Time;
   Null_Time_C          : constant Ada.Real_Time.Time       :=
     Ada.Real_Time.Time_First;

-----------------------------------------------------------------------------------------
-- CUC time
-----------------------------------------------------------------------------------------
   type Fine_Time_T    is new Basic_Types_I.Unsigned_24_T;
   for  Fine_Time_T'Size use Basic_Types_I.Size_24_C;

   type Coarse_Time_T  is new Basic_Types_I.Unsigned_32_T;
   for  Coarse_Time_T'Size use Basic_Types_I.Size_32_C;

   type Cuc_Time_T is
   record
     Coarse_Time    : Coarse_Time_T;
     Fine_Time      : Fine_Time_T;
   end record;

   for Cuc_Time_T use
   record
     Coarse_Time     at 0 range 0 .. 31;
     Fine_Time       at 4 range 0 .. 23;
   end record;

   for Cuc_Time_T'Alignment use 1;
   for Cuc_Time_T'Size use 56;

   Null_Cuc_Time_C : constant Cuc_Time_T :=
     (Coarse_Time => 0,
      Fine_Time   => 0);


-----------------------------------------------------------------------------------------
-- Additional basic types required by PUS library
-----------------------------------------------------------------------------------------
   type Bit_T is mod (2 ** Size_1_C);
   for Bit_T'Size use Size_1_C;

   type Bits2_T is mod (2 ** Size_2_C);
   for Bits2_T'Size use Size_2_C;

   type Bits3_T is mod (2 ** Size_3_C);
   for Bits3_T'Size use Size_3_C;

   type Bits4_T is mod (2 ** Size_4_C);
   for Bits4_T'Size use Size_4_C;

   type Bits5_T is mod (2 ** Size_5_C);
   for Bits5_T'Size use Size_5_C;

   type Bits6_T is mod (2 ** Size_6_C);
   for Bits6_T'Size use Size_6_C;

   type Bits7_T is mod (2 ** Size_7_C);
   for Bits7_T'Size use Size_7_C;

   type Bits8_T is mod (2 ** Size_8_C);
   for Bits8_T'Size use Size_8_C;

   type Bits9_T is mod (2 ** Size_9_C);
   for Bits9_T'Size use Size_9_C;

   type Bits10_T is mod (2 ** Size_10_C);
   for Bits10_T'Size use Size_10_C;

   type Bits11_T is mod (2 ** Size_11_C);
   for Bits11_T'Size use Size_11_C;

   type Bits12_T is mod (2 ** Size_12_C);
   for Bits12_T'Size use Size_12_C;

   type Bits13_T is mod (2 ** Size_13_C);
   for Bits13_T'Size use Size_13_C;

   type Bits14_T is mod (2 ** Size_14_C);
   for Bits14_T'Size use Size_14_C;

   type Bits15_T is mod (2 ** Size_15_C);
   for Bits15_T'Size use Size_15_C;

   type Bits16_T is mod (2 ** Size_16_C);
   for Bits16_T'Size use Size_16_C;

   type Bits17_T is mod (2 ** Size_17_C);
   for Bits17_T'Size use Size_17_C;

   type Bits18_T is mod (2 ** Size_18_C);
   for Bits18_T'Size use Size_18_C;

   type Bits19_T is mod (2 ** Size_19_C);
   for Bits19_T'Size use Size_19_C;

   type Bits20_T is mod (2 ** Size_20_C);
   for Bits20_T'Size use Size_20_C;

   type Bits21_T is mod (2 ** Size_21_C);
   for Bits21_T'Size use Size_21_C;

   type Bits22_T is mod (2 ** Size_22_C);
   for Bits22_T'Size use Size_22_C;

   type Bits23_T is mod (2 ** Size_23_C);
   for Bits23_T'Size use Size_23_C;

   type Bits24_T is mod (2 ** Size_24_C);
   for Bits24_T'Size use Size_24_C;

   type Bits25_T is mod (2 ** Size_25_C);
   for Bits25_T'Size use Size_25_C;

   type Bits26_T is mod (2 ** Size_26_C);
   for Bits26_T'Size use Size_26_C;

   type Bits27_T is mod (2 ** Size_27_C);
   for Bits27_T'Size use Size_27_C;

   type Bits28_T is mod (2 ** Size_28_C);
   for Bits28_T'Size use Size_28_C;

   type Bits29_T is mod (2 ** Size_29_C);
   for Bits29_T'Size use Size_29_C;

   type Bits30_T is mod (2 ** Size_30_C);
   for Bits30_T'Size use Size_30_C;

   type Bits31_T is mod (2 ** Size_31_C);
   for Bits31_T'Size use Size_31_C;

   type Bits32_T is mod (2 ** Size_32_C);
   for Bits32_T'Size use Size_32_C;


-----------------------------------------------------------------------------------------
-- Declaration of types for PUS library
-----------------------------------------------------------------------------------------
   subtype Uint8_T  is Unsigned_8_T;

   subtype Uint16_T is Unsigned_16_T;

   subtype Uint32_T is Unsigned_32_T;

   subtype Uint64_T is Unsigned_64_T;

   subtype Int8_T   is Integer_8_T;

   subtype Int16_T  is Integer_16_T;

   subtype Int32_T  is Integer_32_T;

   subtype Int64_T  is Integer_64_T;


-----------------------------------------------------------------------------------------
-- Redefinition of address type
-----------------------------------------------------------------------------------------
   type Address_T   is new System.Address;


-----------------------------------------------------------------------------------------
-- Unconstrained array type used by PUS library to hold TC and TM
-----------------------------------------------------------------------------------------
   subtype Array_Index_T is Uint32_T;

   type Uint8_Array_Nc_T is array (Array_Index_T range <>) of Uint8_T;
   pragma Pack (Uint8_Array_Nc_T);

-- New for OEU_SIMULATOR
   type Byte_Array_T is new Uint8_Array_Nc_T;

   type Byte_Array_2_T is array (Array_Index_T range <>, Array_Index_T range <>)
     of Uint8_T;
   pragma Pack (Byte_Array_2_T);



-- New for OEU_SIMULATOR
   type String_T is array (Array_Index_T range <>) of Character;
   pragma Pack (String_T);

   type Data_32_Len_T is record
      Last_Used    : Array_Index_T;
      Data_Empty   : Boolean;
   end record;
   -- Struct to hold the used length of an unconstrained array, when the length is
   -- is based on 32 bits range.
   -- Last_Used is a range type of the buffer without neutre element, for this
   -- reason it is necessary the Data_Empty flag

   Data_32_Len_Empty_C : constant Data_32_Len_T      :=
     (Last_Used    => Array_Index_T'First,
      Data_Empty   => True);



-- For Debug Transfer functions
   type String_10_T  is new String (1 .. 10);

-- New for OEU_SIMULATOR
   type String_30_T is new String (1 .. 30);


   type Array_String_30_T is array (Array_Index_T range <>) of String_30_T;


   type String_100_Str_T is record
      Str    : String_T (1 .. 100);
      Last_I : Uint32_T;
   end record;

   String_100_Str_Empty_C : constant String_100_Str_T :=
     (Str    => (others => ' '),
      Last_I => 0);

   Empty_String_C     : constant String_T (1 .. 0) := (others => ' ');

--   type Access_String_T is access String_T;


-- New enum for byte lengths
   type Byte_Length_T is (One_Byte, Two_Bytes, Four_Bytes);

   type Byte_Length_To_Max_Len_T is array (Byte_Length_T) of
     Unsigned_32_T;
   Byte_Length_To_Max_Len_C : constant Byte_Length_To_Max_Len_T :=
     (One_Byte    => (2 ** 8) - 1,
      Two_Bytes   => (2 ** 16) - 1,
      Four_Bytes  => (2 ** 32) - 1);

   type Byte_Length_To_Num_Bytes_T is array (Byte_Length_T) of
     Unsigned_32_T;
   Byte_Length_To_Num_Bytes_C : constant Byte_Length_To_Num_Bytes_T :=
     (One_Byte    => 1,
      Two_Bytes   => 2,
      Four_Bytes  => 4);


-----------------------------------------------------------------------------------------
-- Enumerated types used by PUS library
-----------------------------------------------------------------------------------------
   type Ena_Dis_T is (Disabled, Enabled);
   for Ena_Dis_T use (Disabled => 0, Enabled => 1);
   for Ena_Dis_T'Size use 8;

   type Significative_Status_T is (Not_Significant, Significant);
   for Significative_Status_T use (Not_Significant => 0, Significant => 1);
   for Significative_Status_T'Size use 8;

-- Type used by PUS library to manage parameters:
   type Basic_Type_E is
     (Float_K, String_K, Integer_K, Sign_Integer_K, Boolean_K,
     Character_K, Sequence_K, Struct_K, Array_K, Enum_K, Long_K);

-----------------------------------------------------------------------------------------
-- Constants of array index of the Unconstrained array type
-----------------------------------------------------------------------------------------
   Index_Byte_1_C          : constant Array_Index_T      := 1;
   Index_Byte_2_C          : constant Array_Index_T      := 2;
   Index_Byte_3_C          : constant Array_Index_T      := 3;
   Index_Byte_4_C          : constant Array_Index_T      := 4;
   Index_Byte_5_C          : constant Array_Index_T      := 5;
   Index_Byte_6_C          : constant Array_Index_T      := 6;
   Index_Byte_7_C          : constant Array_Index_T      := 7;
   Index_Byte_8_C          : constant Array_Index_T      := 8;
   Index_Byte_9_C          : constant Array_Index_T      := 9;
   Index_Byte_10_C         : constant Array_Index_T      := 10;
   Index_Byte_11_C         : constant Array_Index_T      := 11;
   Index_Byte_12_C         : constant Array_Index_T      := 12;
   Index_Byte_13_C         : constant Array_Index_T      := 13;
   Index_Byte_14_C         : constant Array_Index_T      := 14;
   Index_Byte_15_C         : constant Array_Index_T      := 15;
   Index_Byte_16_C         : constant Array_Index_T      := 16;
   Index_Byte_17_C         : constant Array_Index_T      := 17;
   Index_Byte_18_C         : constant Array_Index_T      := 18;
   Index_Byte_19_C         : constant Array_Index_T      := 19;
   Index_Byte_20_C         : constant Array_Index_T      := 20;
   Index_Byte_21_C         : constant Array_Index_T      := 21;
   Index_Byte_22_C         : constant Array_Index_T      := 22;
   Index_Byte_23_C         : constant Array_Index_T      := 23;
   Index_Byte_24_C         : constant Array_Index_T      := 24;
   Index_Byte_25_C         : constant Array_Index_T      := 25;
   Index_Byte_26_C         : constant Array_Index_T      := 26;
   Index_Byte_27_C         : constant Array_Index_T      := 27;
   Index_Byte_28_C         : constant Array_Index_T      := 28;
   Index_Byte_29_C         : constant Array_Index_T      := 29;
   Index_Byte_30_C         : constant Array_Index_T      := 30;
   Index_Byte_31_C         : constant Array_Index_T      := 31;
   Index_Byte_32_C         : constant Array_Index_T      := 32;



-- For bits log
   type Four_Bytes_Bits_Field_T  is array (0 .. 31) of Unsigned_1_T;
   pragma Pack (Four_Bytes_Bits_Field_T);
   for Four_Bytes_Bits_Field_T'Size use 32;




-----------------------------------------------------------------------------------------
-- Boolean bit arrays to map words
-----------------------------------------------------------------------------------------

-- Bus word representation like an array of 8 bits
   type Array_8_Bits_T is array (Range_8_Bits_T'Range) of Boolean;
   for  Array_8_Bits_T'Size use 8;
   pragma Pack (Array_8_Bits_T);

-- Bus word representation like an array of 16 bits
   type Array_16_Bits_T is array (Range_16_Bits_T'Range) of Boolean;
   for  Array_16_Bits_T'Size use 16;
   pragma Pack (Array_16_Bits_T);

-- Bus word representation like an array of 32 bits
   type Array_32_Bits_T is array (Range_32_Bits_T'Range) of Boolean;
   for  Array_32_Bits_T'Size use 32;
   pragma Pack (Array_32_Bits_T);

-- Bits array of 64 bits, 8 bytes
   subtype Byte_8_Array_T is Byte_Array_T (1 .. 8);
   type Array_64_Bits_T is array (Range_64_Bits_T'Range) of Boolean;
   for  Array_64_Bits_T'Size use 64;
   pragma Pack (Array_64_Bits_T);


   type Array_4_Bytes_T is array (Range_4_T'Range) of Uint8_T;
   -- Array to hold 4 bytes
   for  Array_4_Bytes_T'Size use 32;
   pragma Pack (Array_4_Bytes_T);


   type Param_Type_T is (Param_Uint, Param_Int, Param_Flt);

-- Basic Callback without parameters
   type Callback_T is access procedure;
   function Is_Null_Callback (Callback  : Callback_T) return Boolean;

-- Debug_Proc_T is an access to a procedure that accept a string (normally to write a
-- debug trace)
   type Debug_Proc_T is access procedure (Str : in String);
   function Is_Null_Debug_Proc (Debug_Proc  : Debug_Proc_T) return Boolean;



end Basic_Types_I;

