
with Basic_Types_I;
with Oeu_Simu_Types;

package Dump_Logs is



   procedure Dump_To_File
     (Log    : in Oeu_Simu_Types.Log_T;
      Str    : in Basic_Types_I.String_T);

   procedure Dump_Same_Line_To_File
     (Log    : in Oeu_Simu_Types.Log_T;
      Str    : in Basic_Types_I.String_T);

   procedure Flush
     (Log    : in Oeu_Simu_Types.Log_T);

end Dump_Logs;
