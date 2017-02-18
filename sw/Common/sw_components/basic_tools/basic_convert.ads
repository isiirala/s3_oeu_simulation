
with Basic_Types_I;

package Basic_Convert is



   procedure Byte_Swap
     (Message   : in out Basic_Types_I.Uint8_Array_Nc_T);


   function Extract_Num_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Uint32_T;
   function Extract_Num_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Int32_T;
   function Extract_Num_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Float_T;
   function Extract_Cuc_Swap
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Cuc_Time_T;
   function Extract_Cuc
     (Bytes   : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Cuc_Time_T;

   procedure Pack_Cuc
     (Value : in Basic_Types_I.Cuc_Time_T;
      Bytes : in out Basic_Types_I.Byte_Array_T);

   function Str_To_Byte_Array
     (Str        : in Basic_Types_I.String_T) return Basic_Types_I.Byte_Array_T;

   function Byte_Array_To_Str
     (Byte_Array : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.String_T;
   -- Convert an array of bytes into a string overloaping memories

   procedure Byte_Array_To_Str
     (Byte_Array : in Basic_Types_I.Byte_Array_T;
      Str        : in out Basic_Types_I.String_T;
      Str_Len    : in out Basic_Types_I.Data_32_Len_T);
   -- Write each byte of the byte array as hexadecimal in the output string.
   -- Each byte is separated with an space



   function Byte_8_Array_To_Bits (Bytes : in Basic_Types_I.Byte_8_Array_T)
     return Basic_Types_I.Array_64_Bits_T;



end Basic_Convert;
