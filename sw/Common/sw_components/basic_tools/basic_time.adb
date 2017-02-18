


package body Basic_Time is

-- ======================================================================================
-- %% Type and constant declarations
-- ======================================================================================

   Micr_To_Seconds_C     : constant Basic_Types_I.Float_T     := 0.000_001;
   Seconds_To_Micr_C     : constant Basic_Types_I.Float_T     := 1_000_000.0;

   Nseconds_To_Sec_C     : constant Basic_Types_I.Float_T     := 0.000_000_001;
   Sec_To_Nseconds_C     : constant Basic_Types_I.Float_T     := 1_000_000_000.0;


-- 0,000 000 001     nanosecond   ns
-- 0,000 001         microsecond  µs
-- 0,001             millisecond  ms
-- 0.01              centisecond  cs
-- 1.0               second       s

-- The CUC fine time uses zero to three octets of fine code elements result in a
-- resolution of, respectively:
-- 1 second;
-- 2^-8 second (about 4 ms);       2^-8 = 0,00390625
-- 2^-16 second (about 15 µs);
-- or 2^-24 second (about 60 ns).


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   function Micro_Secs_To_Cuc_Fine
     (Micr_Secs  : Basic_Types_I.Uint32_T) return Basic_Types_I.Fine_Time_T
   is
      use type Basic_Types_I.Float_T;

      Seconds_To_Cuc_Fine_C : constant Basic_Types_I.Float_T     := 2.0 ** (24);

      Tmp_Flt      : Basic_Types_I.Float_T           := 0.0;
      Result_Val   : Basic_Types_I.Fine_Time_T       := 0;
   begin

-- Convert input microseconds to seconds and then to CUC fine tiem
      Tmp_Flt    := Basic_Types_I.Float_T (Micr_Secs) * Micr_To_Seconds_C;
      Result_Val := Basic_Types_I.Fine_Time_T (Tmp_Flt * Seconds_To_Cuc_Fine_C);
      return Result_Val;
   end Micro_Secs_To_Cuc_Fine;

   function Nano_Secs_To_Cuc_Fine
     (Nano_Secs  : Basic_Types_I.Uint32_T) return Basic_Types_I.Fine_Time_T
   is
      use type Basic_Types_I.Float_T;

      Seconds_To_Cuc_Fine_Time_C : constant Basic_Types_I.Float_T     := 2.0 ** 24;

      Tmp_Flt      : Basic_Types_I.Float_T           := 0.0;
      Result_Val   : Basic_Types_I.Fine_Time_T       := 0;
   begin


-- Convert number of nano seconds into seconds
      Tmp_Flt    := Basic_Types_I.Float_T (Nano_Secs) * Nseconds_To_Sec_C;

-- Convert the number of seconds into cuc fine time
      Tmp_Flt    := Tmp_Flt * Seconds_To_Cuc_Fine_Time_C;
      Result_Val := Basic_Types_I.Fine_Time_T (Tmp_Flt);

      return Result_Val;
   end Nano_Secs_To_Cuc_Fine;





   function Cuc_Fine_To_Micro_Secs
     (Cuc_Fine  : Basic_Types_I.Fine_Time_T) return Basic_Types_I.Uint32_T
   is
      use type Basic_Types_I.Float_T;

      Cuc_Fine_To_Seconds_C : constant Basic_Types_I.Float_T     := 2.0 ** (-24);

      Tmp_Flt      : Basic_Types_I.Float_T           := 0.0;
      Result_Val   : Basic_Types_I.Uint32_T          := 0;
   begin

-- The CUC fine time is converted into seconds and then into microseconds
      Tmp_Flt  := Basic_Types_I.Float_T (Cuc_Fine) * Cuc_Fine_To_Seconds_C;
      Tmp_Flt  := Tmp_Flt * Seconds_To_Micr_C;

      Result_Val := Basic_Types_I.Uint32_T (Tmp_Flt);
      return Result_Val;
   end Cuc_Fine_To_Micro_Secs;


   function Cuc_Fine_To_Nano_Secs
     (Cuc_Fine  : Basic_Types_I.Fine_Time_T) return Basic_Types_I.Uint32_T
   is
      use type Basic_Types_I.Float_T;

      Cuc_Fine_To_Seconds_C : constant Basic_Types_I.Float_T     := 2.0 ** (-24);

      Tmp_Flt      : Basic_Types_I.Float_T           := 0.0;
      Result_Val   : Basic_Types_I.Uint32_T          := 0;
   begin

-- The CUC fine time is converted into seconds and then into nanoseconds
      Tmp_Flt  := Basic_Types_I.Float_T (Cuc_Fine) * Cuc_Fine_To_Seconds_C;
      Tmp_Flt  := Tmp_Flt * Sec_To_Nseconds_C;

      Result_Val := Basic_Types_I.Uint32_T (Tmp_Flt);
      return Result_Val;
   end Cuc_Fine_To_Nano_Secs;


   function Date_To_Coarse
     (Days      : Basic_Types_I.Uint32_T;
      Hours     : Basic_Types_I.Uint32_T;
      Minuts    : Basic_Types_I.Uint32_T;
      Seconds   : Basic_Types_I.Uint32_T)
   return Basic_Types_I.Coarse_Time_T
   is
      use type Basic_Types_I.Uint32_T;
      use type Basic_Types_I.Coarse_Time_T;

      Result     : Basic_Types_I.Coarse_Time_T           := 0;
   begin

      Result := Basic_Types_I.Coarse_Time_T (Days * 24 * 60 * 60);
      Result := Result + Basic_Types_I.Coarse_Time_T (Hours * 60 * 60);
      Result := Result + Basic_Types_I.Coarse_Time_T (Minuts * 60);
      Result := Result + Basic_Types_I.Coarse_Time_T (Seconds);
      return Result;
   end Date_To_Coarse;

   function Cuc_Coarse_To_Micro_Secs
     (Cuc_Coarse  : Basic_Types_I.Coarse_Time_T) return Basic_Types_I.Uint64_T
   is
      use type Basic_Types_I.Uint64_T;

      Result  : Basic_Types_I.Uint64_T   := Basic_Types_I.Uint64_T (Cuc_Coarse) *
        1_000_000;
   begin
      return Result;
   end Cuc_Coarse_To_Micro_Secs;

end Basic_Time;

