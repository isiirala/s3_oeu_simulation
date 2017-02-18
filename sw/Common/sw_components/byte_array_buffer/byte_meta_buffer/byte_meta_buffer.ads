
with Basic_Types_I;
with Byte_Array_Buffer;

generic

   Meta_Buffer_Len    : in Basic_Types_I.Unsigned_32_T;
   -- Byte length for metadata buffer

   Data_Buffer_Len    : in Basic_Types_I.Unsigned_32_T;
   -- Byte length for data buffer

   User_Meta_Byte_Len : in Basic_Types_I.Unsigned_32_T;
   -- Byte length of the user metadata

   Bytes_For_Data_Len : in  Basic_Types_I.Byte_Length_T   :=
     Basic_Types_I.Two_Bytes;
   -- Number of bytes used to hold the data length in the private metadata.
   -- The maximum data length to store with a single Insert operation must fit
   -- in the following number of bytes

   Use_Protection     : in Boolean                        := False;
   -- When it is activated the read and write routines are executed in mutual exclusion

package Byte_Meta_Buffer is

   use type Basic_Types_I.Unsigned_32_T;

   Max_Byte_Per_Operation_C : constant Basic_Types_I.Unsigned_32_T :=
     Basic_Types_I.Byte_Length_To_Max_Len_C(Bytes_For_Data_Len);


   subtype Meta_Raw_T is Basic_Types_I.Byte_Array_T (1 ..
     User_Meta_Byte_Len);
   Null_Meta_Raw_C : constant Meta_Raw_T := (others => 0);


-- Return results of the operations. The Result_Meta/Data_Full/Empty come from
-- a corresponding operation in Meta/Data structure.
-- The result Unsynchronized means that MetaData buffer and Data buffer are
-- not synchronized when any data is inserted/retrieved in one buffer but the
-- corresponding one is not inserted/ retrieved from the other.
-- Result_Data_Too_Long is used when the data to insert is longer than the max
-- length allowed.
-- Result_Data_Too_Short is used in the retrieve operation, when the length of
-- the parameter buffer for the data is not enought to store the data
   type Buffer_Result_T is (Result_Ok, Result_Data_Full,
     Result_Data_Empty, Result_Meta_Full, Result_Meta_Empty,
     Result_Unsynchronized, Result_Data_Too_Long, Result_Data_Too_Short,
     Result_Internal_Error);

   type Buffer_Result_To_Str_T is array (Buffer_Result_T)
     of Basic_Types_I.String_30_T;
   Buffer_Result_To_Str_C : constant Buffer_Result_To_Str_T :=
     (Result_Ok             => "Ok result                     ",
      Result_Data_Full      => "Data buffer is full           ",
      Result_Data_Empty     => "Data buffer is empty          ",
      Result_Meta_Full      => "Meta buffer is full           ",
      Result_Meta_Empty     => "Meta buffer is empty          ",
      Result_Unsynchronized => "Data&MetaBuffers unsynchronize",
      Result_Data_Too_Long  => "Data to insert is too long    ",
      Result_Data_Too_Short => "Data to retrieve is too short ",
      Result_Internal_Error => "An internal error             ");

-- Instantation of generic childs
   package Meta_Buff is new Byte_Array_Buffer(Meta_Buffer_Len);
   package Data_Buff is new Byte_Array_Buffer(Data_Buffer_Len);


   type Buffer_Record_T is tagged limited private;

   type Buffer_T is access all Buffer_Record_T'Class;


   procedure New_Buffer(Buffer : out Buffer_T);

   procedure Initialize(Buffer : access Buffer_Record_T'Class);


   procedure Insert
     (Buffer   : access Buffer_Record_T'Class;
      Meta_Raw : in Meta_Raw_T;
      Data_Raw : in Basic_Types_I.Byte_Array_T;
      Result   : out Buffer_Result_T);


   procedure Retrieve
     (Buffer     : access Buffer_Record_T'Class;
      Data_Raw   : in out Basic_Types_I.Byte_Array_T;
      Last_Index : out Basic_Types_I.Unsigned_32_T;
      Meta_Raw   : out Meta_Raw_T;
      Result     : out Buffer_Result_T);

   function Get_Num_Items(Buffer     : access Buffer_Record_T'Class)
     return Basic_Types_I.Unsigned_32_T;


private

   type Buffer_Record_T is tagged limited record
      Meta_Buffer : Meta_Buff.Buffer_T;
      Data_Buffer : Data_Buff.Buffer_T;
   end record;

end Byte_Meta_Buffer;
