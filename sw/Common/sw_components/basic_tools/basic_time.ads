
with Basic_Types_I;

package Basic_Time is



   function Micro_Secs_To_Cuc_Fine
     (Micr_Secs  : Basic_Types_I.Uint32_T) return Basic_Types_I.Fine_Time_T;

   function Nano_Secs_To_Cuc_Fine
     (Nano_Secs  : Basic_Types_I.Uint32_T) return Basic_Types_I.Fine_Time_T;


   function Cuc_Fine_To_Micro_Secs
     (Cuc_Fine  : Basic_Types_I.Fine_Time_T) return Basic_Types_I.Uint32_T;

   function Cuc_Fine_To_Nano_Secs
     (Cuc_Fine  : Basic_Types_I.Fine_Time_T) return Basic_Types_I.Uint32_T;


   function Date_To_Coarse
     (Days      : Basic_Types_I.Uint32_T;
      Hours     : Basic_Types_I.Uint32_T;
      Minuts    : Basic_Types_I.Uint32_T;
      Seconds   : Basic_Types_I.Uint32_T)
   return Basic_Types_I.Coarse_Time_T;


   function Cuc_Coarse_To_Micro_Secs
     (Cuc_Coarse  : Basic_Types_I.Coarse_Time_T) return Basic_Types_I.Uint64_T;


end Basic_Time;

