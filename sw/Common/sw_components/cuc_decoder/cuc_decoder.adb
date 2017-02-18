
with Ada.Exceptions;

with Basic_Tools;
with Basic_Time;

package body Cuc_Decoder is



   type Days_At_Begin_Year_T is record
      Leap_Year   : Boolean;
      Year        : Basic_Types_I.Uint16_T;
      First_Day   : Basic_Types_I.Uint32_T;
   end record;

   Empty_Days_At_Begin_Year_C  : constant Days_At_Begin_Year_T := (False, 0, 0);

   Limit_Array_Days_C       : constant Basic_Types_I.Uint32_T  := 137;
   type Array_Days_For_Year_T is array (1 .. Limit_Array_Days_C) of
     Days_At_Begin_Year_T;

-- Number of days at begging of each year
   Days_For_Year_C          : constant Array_Days_For_Year_T :=
     ((False, 1958, 0    ),
      (False, 1959, 366  ),
      (True,  1960, 731  ),
      (False, 1961, 1097 ),
      (False, 1962, 1462 ),
      (False, 1963, 1827 ),
      (True,  1964, 2192 ),
      (False, 1965, 2558 ),
      (False, 1966, 2923 ),
      (False, 1967, 3288 ),
      (True,  1968, 3653 ),
      (False, 1969, 4019 ),
      (False, 1970, 4384 ),
      (False, 1971, 4749 ),
      (True,  1972, 5114 ),
      (False, 1973, 5480 ),
      (False, 1974, 5845 ),
      (False, 1975, 6210 ),
      (True,  1976, 6575 ),
      (False, 1977, 6941 ),
      (False, 1978, 7306 ),
      (False, 1979, 7671 ),
      (True,  1980, 8036 ),
      (False, 1981, 8402 ),
      (False, 1982, 8767 ),
      (False, 1983, 9132 ),
      (True,  1984, 9497 ),
      (False, 1985, 9863 ),
      (False, 1986, 10228),
      (False, 1987, 10593),
      (True,  1988, 10958),
      (False, 1989, 11324),
      (False, 1990, 11689),
      (False, 1991, 12054),
      (True,  1992, 12419),
      (False, 1993, 12785),
      (False, 1994, 13150),
      (False, 1995, 13515),
      (True,  1996, 13880),
      (False, 1997, 14246),
      (False, 1998, 14611),
      (False, 1999, 14976),
      (True,  2000, 15341),
      (False, 2001, 15707),
      (False, 2002, 16072),
      (False, 2003, 16437),
      (True,  2004, 16802),
      (False, 2005, 17168),
      (False, 2006, 17533),
      (False, 2007, 17898),
      (True,  2008, 18263),
      (False, 2009, 18629),
      (False, 2010, 18994),
      (False, 2011, 19359),
      (True,  2012, 19724),
      (False, 2013, 20090),
      (False, 2014, 20455),
      (False, 2015, 20820),
      (True,  2016, 21185),
      (False, 2017, 21551),
      (False, 2018, 21916),
      (False, 2019, 22281),
      (True,  2020, 22646),
      (False, 2021, 23012),
      (False, 2022, 23377),
      (False, 2023, 23742),
      (True,  2024, 24107),
      (False, 2025, 24473),
      (False, 2026, 24838),
      (False, 2027, 25203),
      (True,  2028, 25568),
      (False, 2029, 25934),
      (False, 2030, 26299),
      (False, 2031, 26664),
      (True,  2032, 27029),
      (False, 2033, 27395),
      (False, 2034, 27760),
      (False, 2035, 28125),
      (True,  2036, 28490),
      (False, 2037, 28856),
      (False, 2038, 29221),
      (False, 2039, 29586),
      (True,  2040, 29951),
      (False, 2041, 30317),
      (False, 2042, 30682),
      (False, 2043, 31047),
      (True,  2044, 31412),
      (False, 2045, 31778),
      (False, 2046, 32143),
      (False, 2047, 32508),
      (True,  2048, 32873),
      (False, 2049, 33239),
      (False, 2050, 33604),
      (False, 2051, 33969),
      (True,  2052, 34334),
      (False, 2053, 34700),
      (False, 2054, 35065),
      (False, 2055, 35430),
      (True,  2056, 35795),
      (False, 2057, 36161),
      (False, 2058, 36526),
      (False, 2059, 36891),
      (True,  2060, 37256),
      (False, 2061, 37622),
      (False, 2062, 37987),
      (False, 2063, 38352),
      (True,  2064, 38717),
      (False, 2065, 39083),
      (False, 2066, 39448),
      (False, 2067, 39813),
      (True,  2068, 40178),
      (False, 2069, 40544),
      (False, 2070, 40909),
      (False, 2071, 41274),
      (True,  2072, 41639),
      (False, 2073, 42005),
      (False, 2074, 42370),
      (False, 2075, 42735),
      (True,  2076, 43100),
      (False, 2077, 43466),
      (False, 2078, 43831),
      (False, 2079, 44196),
      (True,  2080, 44561),
      (False, 2081, 44927),
      (False, 2082, 45292),
      (False, 2083, 45657),
      (True,  2084, 46022),
      (False, 2085, 46388),
      (False, 2086, 46753),
      (False, 2087, 47118),
      (True,  2088, 47483),
      (False, 2089, 47849),
      (False, 2090, 48214),
      (False, 2091, 48579),
      (True,  2092, 48944),
      (False, 2093, 49310),
      (False, 2094, 49675));


   Limit_Array_Months_C       : constant Basic_Types_I.Uint32_T  := 12;
   type Array_Days_For_Month_T is array (1 .. Limit_Array_Months_C) of
     Basic_Types_I.Uint16_T;

   Days_For_Month_C      : constant Array_Days_For_Month_T   :=
     (0, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335);

   Days_For_Month_Leap_C : constant Array_Days_For_Month_T   :=
     (0, 32, 61, 92, 122, 153, 183, 214, 245, 275, 306, 336);


   Debug_Proc      : Basic_Types_I.Debug_Proc_T         := null;

-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   procedure Local_Debug (Str : in String)
   is
   begin

      if not Basic_Types_I.Is_Null_Debug_Proc (Debug_Proc) then
         Debug_Proc ("[Cuc_Decoder]" & Str);
      end if;
   end Local_Debug;


   procedure Decode_Year
     (N_Days               : in Basic_Types_I.Uint32_T;
      Days_At_Begin        : out Days_At_Begin_Year_T;
      Days_From_Year_Begin : out Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;

      Index_Year     : Basic_Types_I.Uint32_T    := 1;
      Days_Found     : Boolean                   := False;
   begin

      Days_At_Begin        := Empty_Days_At_Begin_Year_C;
      Days_From_Year_Begin := 0;

      loop
         if N_Days = Days_For_Year_C (Index_Year).First_Day then
            Days_Found := True;
         elsif N_Days < Days_For_Year_C (Index_Year).First_Day then
            Days_Found := True;
            Index_Year := Index_Year - 1;
         end if;

         exit when Days_Found;
         exit when Index_Year = Limit_Array_Days_C;
         Index_Year := Index_Year + 1;
      end loop;

      if Index_Year > 0 then

         Days_At_Begin        := Days_For_Year_C (Index_Year);

         Days_From_Year_Begin := N_Days - Days_For_Year_C (Index_Year).First_Day;
      end if;

   end Decode_Year;

   procedure Decode_Day
     (Days_From_Year_Begin : in Basic_Types_I.Uint32_T;
      Days_At_Begin        : in Days_At_Begin_Year_T;
      Month                : out Basic_Types_I.Uint16_T;
      Day                  : out Basic_Types_I.Uint16_T)
   is
      use type Basic_Types_I.Uint16_T;
      use type Basic_Types_I.Uint32_T;

      Index_Month     : Basic_Types_I.Uint32_T    := 1;
      Day_Found       : Boolean                   := False;
      Days_For_Month  : Basic_Types_I.Uint16_T    := 0;

   begin

      Month := 0;
      Day   := 0;

      loop

         if Days_At_Begin.Leap_Year then
            Days_For_Month := Days_For_Month_Leap_C (Index_Month);
         else
            Days_For_Month := Days_For_Month_C (Index_Month);
         end if;

         if Days_From_Year_Begin = Basic_Types_I.Uint32_T (Days_For_Month) then
            Day_Found   := True;
         elsif Days_From_Year_Begin < Basic_Types_I.Uint32_T (Days_For_Month) then
            Day_Found   := True;
            Index_Month := Index_Month - 1;
         end if;

         exit when Day_Found;
         exit when Index_Month = Limit_Array_Months_C;
         Index_Month := Index_Month + 1;
      end loop;

      Month := Basic_Types_I.Uint16_T (Index_Month);
      if Days_At_Begin.Leap_Year then
         Day   :=  Basic_Types_I.Uint16_T (Days_From_Year_Begin) -
           Days_For_Month_Leap_C (Index_Month) + 1;
      else
         Day   :=  Basic_Types_I.Uint16_T (Days_From_Year_Begin) -
           Days_For_Month_C (Index_Month) + 1;
      end if;
   end Decode_Day;


   procedure Year_To_Days
     (Year        : in Basic_Types_I.Uint16_T;
      Num_Days    : out Basic_Types_I.Uint32_T;
      Is_Leap     : out Boolean)
   is
      use type Basic_Types_I.Uint16_T;

      Found             : Boolean                     := False;
   begin
      Num_Days    := 0;
      Is_Leap     := False;

      for I in 1 .. Limit_Array_Days_C loop
         if Days_For_Year_C (I).Year = Year then
            Num_Days := Days_For_Year_C (I).First_Day;
            Is_Leap  := Days_For_Year_C (I).Leap_Year;
            Found    := True;
         end if;
      end loop;

      if not Found then
         Local_Debug (".Year_To_Days: Wrong Year value: " &
           Basic_Types_I.Uint16_T'Image (Year));
      end if;
   end Year_To_Days;

   procedure Month_To_Days
     (Month       : in Basic_Types_I.Uint16_T;
      Is_Leap     : in Boolean;
      Num_Days    : in out Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint16_T;
      use type Basic_Types_I.Uint32_T;

      Local_Month  : Basic_Types_I.Uint32_T      := Basic_Types_I.Uint32_T (Month);
   begin

      if Month <= 12 then
         if Is_Leap then

            Num_Days := Num_Days + Basic_Types_I.Uint32_T
              (Days_For_Month_Leap_C (Local_Month));

         else

            Num_Days := Num_Days + Basic_Types_I.Uint32_T
              (Days_For_Month_C (Local_Month));

         end if;
      else
         Local_Debug (".Month_To_Days: Wrong Month value: " &
           Basic_Types_I.Uint16_T'Image (Month));
      end if;

   end Month_To_Days;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Init
     (Ext_Debug_Proc : in Basic_Types_I.Debug_Proc_T)
   is
   begin
      Debug_Proc := Ext_Debug_Proc;
   end Init;


   procedure Decode_Cuc
     (Cuc_Time   : in Basic_Types_I.Cuc_Time_T;
      Year       : out Basic_Types_I.Uint16_T;
      Month      : out Basic_Types_I.Uint16_T;
      Day        : out Basic_Types_I.Uint16_T;
      Day_Year   : out Basic_Types_I.Uint16_T;
      Hour       : out Basic_Types_I.Uint16_T;
      Min        : out Basic_Types_I.Uint16_T;
      Secs       : out Basic_Types_I.Uint16_T;
      Micr_Secs  : out Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;
      use type Basic_Types_I.Uint16_T;

      N_Minuts       : Basic_Types_I.Uint32_T          := 0;
      Rest_Seconds   : Basic_Types_I.Uint32_T          := 0;
      -- Rest of the last minute: number of remained seconds
      N_Hours        : Basic_Types_I.Uint32_T          := 0;
      Rest_Minutes   : Basic_Types_I.Uint32_T          := 0;
      -- Rest of the last hour: number of remained minutes
      N_Days         : Basic_Types_I.Uint32_T          := 0;
      Rest_Hours     : Basic_Types_I.Uint32_T          := 0;
      -- Rest of the last day: number of remained hours

      Days_At_Begin        : Days_At_Begin_Year_T      := Empty_Days_At_Begin_Year_C;
      Days_From_Year_Begin : Basic_Types_I.Uint32_T    := 0;
   begin

      Year       := 0;
      Month      := 0;
      Day        := 0;
      Day_Year   := 0;
      Hour       := 0;
      Min        := 0;
      Secs       := 0;
      Micr_Secs  := 0;

-- Get number of minuts
      Basic_Tools.Div
        (Dividend  => Basic_Types_I.Uint32_T (Cuc_Time.Coarse_Time),
         Divisor   => 60,
         Quotient  => N_Minuts,
         Remainder => Rest_Seconds);

-- Get number of hours
      Basic_Tools.Div
        (Dividend  => N_Minuts,
         Divisor   => 60,
         Quotient  => N_Hours,
         Remainder => Rest_Minutes);

-- Get number of days
      Basic_Tools.Div
        (Dividend  => N_Hours,
         Divisor   => 24,
         Quotient  => N_Days,
         Remainder => Rest_Hours);

--         Local_Debug ("Decode_Cuc. Coarse:" &
--           Basic_Types_I.Uint32_T'Image (Basic_Types_I.Uint32_T (Cuc_Time.Coarse_Time)) &
--           " N_Minuts:" & Basic_Types_I.Uint32_T'Image (N_Minuts) &
--           " Rest_Seconds:" & Basic_Types_I.Uint32_T'Image (Rest_Seconds) &
--           " N_Hours:" & Basic_Types_I.Uint32_T'Image (N_Hours) &
--           " Rest_Minutes:" & Basic_Types_I.Uint32_T'Image (Rest_Minutes) &
--           " N_Days:" & Basic_Types_I.Uint32_T'Image (N_Days) &
--           " Rest_Hours:" & Basic_Types_I.Uint32_T'Image (Rest_Hours));

-- Decode the year
      Decode_Year
        (N_Days               => N_Days,
         Days_At_Begin        => Days_At_Begin,
         Days_From_Year_Begin => Days_From_Year_Begin);
      Year         := Days_At_Begin.Year;
      Day_Year     := Basic_Types_I.Uint16_T (Days_From_Year_Begin);

-- Decode the day
      Decode_Day
        (Days_From_Year_Begin => Days_From_Year_Begin,
         Days_At_Begin        => Days_At_Begin,
         Month                => Month,
         Day                  => Day);

--         Local_Debug ("Year:" &
--           Basic_Types_I.Uint16_T'Image (Year) &
--           " Day_Year:" & Basic_Types_I.Uint16_T'Image (Day_Year) &
--           " Month:" & Basic_Types_I.Uint16_T'Image (Month) &
--           " Day:" & Basic_Types_I.Uint16_T'Image (Day));

-- Decode the hour, minuts and seconds
      Hour      := Basic_Types_I.Uint16_T (Rest_Hours);
      Min       := Basic_Types_I.Uint16_T (Rest_Minutes);
      Secs      := Basic_Types_I.Uint16_T (Rest_Seconds);

-- The CUC fine time is converted into microseconds
      Micr_Secs := Basic_Time.Cuc_Fine_To_Micro_Secs (Cuc_Time.Fine_Time);

--         Local_Debug ("[Cuc_Decoder.Decode_Cuc]Fine: " &
--           Basic_Types_I.Fine_Time_T'Image (Cuc_Time.Fine_Time) &
--           " Micr_Secs: " & Basic_Types_I.Uint32_T'Image (Micr_Secs));

   exception
      when Event : others =>
         Local_Debug (".Decode_Cuc Except: " &
           Ada.Exceptions.Exception_Information (Event));
   end Decode_Cuc;


   procedure Code_Cuc
     (Year       : in Basic_Types_I.Uint16_T;
      Month      : in Basic_Types_I.Uint16_T;
      Day        : in Basic_Types_I.Uint16_T;
      Hour       : in Basic_Types_I.Uint16_T;
      Min        : in Basic_Types_I.Uint16_T;
      Secs       : in Basic_Types_I.Uint16_T;
      Micr_Secs  : in Basic_Types_I.Uint32_T;
      Cuc_Time   : out Basic_Types_I.Cuc_Time_T)
   is
      use type Basic_Types_I.Uint32_T;
      use type Basic_Types_I.Uint16_T;

      Num_Days     : Basic_Types_I.Uint32_T          := 0;
      Leap_Year    : Boolean                         := False;
   begin
      Cuc_Time := Basic_Types_I.Null_Cuc_Time_C;

-- Convert year into days in current epoch
      Year_To_Days
        (Year     => Year,
         Num_Days => Num_Days,
         Is_Leap  => Leap_Year);

-- Convert month into days in current epoch
      Month_To_Days
        (Month    => Month,
         Is_Leap  => Leap_Year,
         Num_Days => Num_Days);

-- Add the day of the month
      Num_Days := Num_Days + Basic_Types_I.Uint32_T ((Day - 1));

-- Conver number of days, h, m & s into seconds
      Cuc_Time.Coarse_Time := Basic_Time.Date_To_Coarse
        (Days      => Num_Days,
         Hours     => Basic_Types_I.Uint32_T (Hour),
         Minuts    => Basic_Types_I.Uint32_T (Min),
         Seconds   => Basic_Types_I.Uint32_T (Secs));

-- Convert input microseconds to CUC fine tiem
      Cuc_Time.Fine_Time   := Basic_Time.Micro_Secs_To_Cuc_Fine (Micr_Secs);

   exception
      when Event : others =>
         Local_Debug (".Code_Cuc Except: " &
           Ada.Exceptions.Exception_Information (Event));
   end Code_Cuc;

   function Time_To_Cuc
     (Time       : in Ada.Calendar.Time) return Basic_Types_I.Cuc_Time_T
   is

      Year           : Ada.Calendar.Year_Number      := Ada.Calendar.Year_Number'First;
      Month          : Ada.Calendar.Month_Number     := Ada.Calendar.Month_Number'First;
      Day            : Ada.Calendar.Day_Number       := Ada.Calendar.Day_Number'First;
      Seconds        : Ada.Calendar.Day_Duration     := Ada.Calendar.Day_Duration'First;
      N_Minuts       : Basic_Types_I.Uint32_T        := 0;
      Rest_Seconds   : Basic_Types_I.Uint32_T        := 0;
      N_Hours        : Basic_Types_I.Uint32_T        := 0;
      Rest_Minutes   : Basic_Types_I.Uint32_T        := 0;
      Result_Cuc     : Basic_Types_I.Cuc_Time_T      := Basic_Types_I.Null_Cuc_Time_C;
   begin

-- Split input Calendar time into year, month, day and seconds duration in a day
      Ada.Calendar.Split
        (Date    => Time,
         Year    => Year,
         Month   => Month,
         Day     => Day,
         Seconds => Seconds);

-- Get number of minuts
      Basic_Tools.Div
        (Dividend  => Basic_Types_I.Uint32_T (Seconds),
         Divisor   => 60,
         Quotient  => N_Minuts,
         Remainder => Rest_Seconds);

-- Get number of hours
      Basic_Tools.Div
        (Dividend  => N_Minuts,
         Divisor   => 60,
         Quotient  => N_Hours,
         Remainder => Rest_Minutes);

      Code_Cuc
        (Year      => Basic_Types_I.Uint16_T (Year),
         Month     => Basic_Types_I.Uint16_T (Month),
         Day       => Basic_Types_I.Uint16_T (Day),
         Hour      => Basic_Types_I.Uint16_T (N_Hours),
         Min       => Basic_Types_I.Uint16_T (Rest_Minutes),
         Secs      => Basic_Types_I.Uint16_T (Rest_Seconds),
         Micr_Secs => 0,
         Cuc_Time  => Result_Cuc);

      return Result_Cuc;
   end Time_To_Cuc;




end Cuc_Decoder;

