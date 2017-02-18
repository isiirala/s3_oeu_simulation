
with Basic_Types_I;

package Debug_Log is

   procedure Init;
   procedure Do_Log (Str : in String);
   procedure Do_Log_Same_Line (Str : in String);
   function U32_To_Str (U32 : in Basic_Types_I.Unsigned_32_T) return String;
   function U8_To_Str (U8 : in Basic_Types_I.Unsigned_8_T) return String;
   procedure Flush;
   procedure Set_Flush_Each_Log (Status : in Boolean);

end Debug_Log;
