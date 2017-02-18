
with Basic_Types_I;

generic

   Byte_Len     : Basic_Types_I.Unsigned_32_T;

package Byte_Array_Buffer is

   use type Basic_Types_I.Unsigned_32_T;


   First_Index_C   : constant Basic_Types_I.Unsigned_32_T := 0;
   Last_Index_C    : constant Basic_Types_I.Unsigned_32_T := (Byte_Len - 1);

   subtype Buffer_Range_T is Basic_Types_I.Unsigned_32_T
     range First_Index_C .. Last_Index_C;

-- TODO: investigar como usar un tipo modular
--   type Buffer_Range_T is mod Byte_Len;


-- Tagged type to hold the buffer
   type Buffer_Record_T is tagged limited private;

-- Struct to hold internal pointers to do undo of the last insert/retrieve
   type Buffer_Undo_Record_T is private;


   type Buffer_T is access all Buffer_Record_T'Class;

-- Result type of the operations
   type Buffer_Result_T is (Result_Ok, Result_Full, Result_Empty);



   procedure New_Buffer(Buffer : out Buffer_T);

   procedure Initialize(Buffer : access Buffer_Record_T'Class);


   procedure Insert
     (Buffer : access Buffer_Record_T'Class;
      Data   : in Basic_Types_I.Byte_Array_T;
      Result : out Buffer_Result_T);


   procedure Exact_Retrieve
     (Buffer : access Buffer_Record_T'Class;
      Data   : in out Basic_Types_I.Byte_Array_T;
      Result : out Buffer_Result_T);


   procedure Retrieve
     (Buffer     : access Buffer_Record_T'Class;
      Data       : in out Basic_Types_I.Byte_Array_T;
      Last_Index : out Basic_Types_I.Unsigned_32_T;
      Result     : out Buffer_Result_T);


   function Empty_Bytes
     (Buffer : access Buffer_Record_T'Class) return Basic_Types_I.Unsigned_32_T;

   function Used_Bytes
     (Buffer : access Buffer_Record_T'Class) return Basic_Types_I.Unsigned_32_T;

   function Get_Undo_Data
     (Buffer    : access Buffer_Record_T'Class) return Buffer_Undo_Record_T;

   procedure Set_Undo_Data
     (Buffer    : access Buffer_Record_T'Class;
      Undo_Data : in out Buffer_Undo_Record_T;
      Result    : out Buffer_Result_T);


   procedure Test_Point
     (Buffer   : access Buffer_Record_T'Class;
      R_Index  : out Buffer_Range_T;
      W_Index  : out Buffer_Range_T);

private

   type Buffer_Record_T is tagged limited record
      Data        : Basic_Types_I.Byte_Array_T(Buffer_Range_T'Range) :=
        (others => 0);

-- First used possition to read
      Read_Index  : Buffer_Range_T      := Buffer_Range_T'First;

-- First empty possition to write
      Write_Index : Buffer_Range_T      := Buffer_Range_T'First;

-- When the two index are equal means Buffer empty
--      Data_Full   : Boolean             := False;
   end record;

   type Buffer_Undo_Record_T is record
-- Indexes of the buffer
      Read_Index  : Buffer_Range_T  := Buffer_Range_T'First;
      Write_Index : Buffer_Range_T  := Buffer_Range_T'First;

-- True when indexes contains a good value
      Good_Values : Boolean         := False;
   end record;

end Byte_Array_Buffer;

