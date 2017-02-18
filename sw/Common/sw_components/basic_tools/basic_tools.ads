-- ****************************************************************************
--  Project             : S3 OEU SIMULATION
--  Unit Name           : Basic_Tools
--  Unit Type           : Package specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/12/12 15:33:39 $
--  Revision            : $Revision: 1.2 $
--  Function            : Basic types and constants used in the OEU ICM APSW
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv
-- ****************************************************************************

with Basic_Types_I;
with Basic_Types_1553;


package Basic_Tools is



   procedure Decrement
     (Number : in out Basic_Types_I.Uint32_T;
      Count  : in Basic_Types_I.Uint32_T := 1);


   function "&"
     (Left  : Basic_Types_I.String_T;
      Right : Basic_Types_I.String_T) return Basic_Types_I.String_T;
   function "&"
     (Left  : Basic_Types_I.String_T;
      Right : String) return Basic_Types_I.String_T;

   function "&"
     (Left  : String;
      Right : Basic_Types_I.String_100_Str_T) return String;

   function To_String
     (Str : Basic_Types_I.String_T;
      Len : Basic_Types_I.Data_32_Len_T) return String;

   procedure Div
     (Dividend  : in Basic_Types_I.Uint32_T;
      Divisor   : in Basic_Types_I.Uint32_T;
      Quotient  : out Basic_Types_I.Uint32_T;
      Remainder : out Basic_Types_I.Uint32_T);


   Append_Overflow_Ex          : Exception;
   First_Free_Ex               : exception;

  procedure Append
     (Annex            : in Basic_Types_I.Byte_Array_T;
      Buff_Data        : in out Basic_Types_I.Byte_Array_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);
   -- Append Annex to Buff_Data. Buff_Len is updated with the last used index.

   procedure Append
     (Annex            : in Basic_Types_I.String_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);
   -- Append Annex to Buff_Data. Buff_Len is updated with the last used index.

   procedure Append_Str
     (Annex            : in String;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);



   procedure Append
     (Annex            : in Basic_Types_I.String_T;
      Annex_Len        : in Basic_Types_I.Data_32_Len_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);




   procedure Append
     (Num              : in Basic_Types_I.Uint32_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T;
      Base             : in Integer := 10);
   -- Convert Num to string (in the specified base) and append the result to Buff_Data.
   -- Buff_Len is updated with the last used index.

   procedure Append
     (Num              : in Basic_Types_I.Uint64_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T;
      Base             : in Integer := 10);

   procedure Append
     (Num              : in Basic_Types_I.Int32_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T;
      Base             : in Integer := 10);

   procedure Append
     (Num              : in Basic_Types_I.Float_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);


   procedure Append_Nl
     (Annex            : in Basic_Types_I.String_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);
   -- Append Annex plus a new-line character to Buff_Data.
   -- Buff_Len is updated with the last used index.

   procedure Append_Base_16
     (Num              : in Basic_Types_I.Uint8_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);

   procedure Append_Base_16
     (Nums             : in Basic_Types_I.Byte_Array_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T);

   function First_Free
     (Data_Len         : Basic_Types_I.Data_32_Len_T;
      Buffer_First     : Basic_Types_I.Array_Index_T;
      Buffer_Last      : Basic_Types_I.Array_Index_T)
   return Basic_Types_I.Array_Index_T;
   -- Return the first free array index of Data_Len param where it is possible insert

   procedure Increment
     (Count            : in Basic_Types_I.Uint32_T;
      Buffer_First     : in Basic_Types_I.Array_Index_T;
      Data_Len         : in out Basic_Types_I.Data_32_Len_T);
   -- Increment the Data_Len param to reflect new items inserted in an array

--   function Next_Index_To_Use (Buff_Len : Basic_Types_I.Data_32_Len_T)
--     return Basic_Types_I.Array_Index_T;


--   procedure Byte_To_String_Base_16
--     (Num              : in Basic_Types_I.Uint8_T;
--      Str              : in out Basic_Types_I.String_T);

--   procedure Uint_To_String
--     (Num        : in Basic_Types_I.Uint32_T;
--      Str        : in out Basic_Types_I.String_T;
--      Last_Index : out Basic_Types_I.Uint32_T;
--      Base       : in Integer := 10);


   function Equal
     (Str1      : in Basic_Types_I.String_T;
      Str1_Len  : in Basic_Types_I.Data_32_Len_T;
      Str2      : in Basic_Types_I.String_T;
      Str2_Len  : in Basic_Types_I.Data_32_Len_T
--      Trim_Case : in Boolean    := False
      ) return Boolean;

   function Equal
     (Literal  : in String;
      Str      : in Basic_Types_I.String_T;
      Str_Len  : in Basic_Types_I.Data_32_Len_T) return Boolean;


   function Two_Bytes_To_Uint32
     (Bytes  : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Unsigned_32_T;

   function Two_Bytes_To_U16 (Data : in Basic_Types_I.Uint8_Array_Nc_T) return
     Basic_Types_I.Uint16_T;


--   function Get_Bit_Range_From_Unsigned_16
--     (Value : in Basic_Types_I.Unsigned_16_T;
--      Msb   : in Basic_Types_I.Range_16_Bits_T;
--      Lsb   : in Basic_Types_I.Range_16_Bits_T)
--   return Basic_Types_I.Unsigned_16_T;





end Basic_Tools;

