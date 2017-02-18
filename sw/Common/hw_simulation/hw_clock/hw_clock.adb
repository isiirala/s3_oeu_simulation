

with Ada.Calendar.Conversions;
with Ada.Exceptions;
with Interfaces.C;

with Basic_Time;

package body Hw_Clock is


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   procedure Local_Debug
     (Clock      : in Clock_T;
      Str        : in String)
   is
   begin

      if not Basic_Types_I.Is_Null_Debug_Proc (Clock.Debug_Proc) then
         Clock.Debug_Proc ("[Hw_Clock]" & Str);
      end if;
   end Local_Debug;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Init
     (Debug_Proc : in Basic_Types_I.Debug_Proc_T;
      Clock      : in out Clock_T)
   is
   begin
      Clock.Time_0     := Ada.Real_Time.Clock;
      Clock.Debug_Proc := Debug_Proc;
      Clock.Is_Init    := True;
   end Init;


   procedure Set_Time
     (Time   : in Basic_Types_I.Cuc_Time_T;
      Clock  : in out Clock_T)
   is
      use type Ada.Real_Time.Time;

      Num_Secs     : Interfaces.C.Long          := 0;
      Num_Nsecs    : Interfaces.C.Long          := 0;
      Durantion    : Duration                   := 0.0;
      Span         : Ada.Real_Time.Time_Span    := Ada.Real_Time.Time_Span_Zero;
   begin

      Num_Secs     := Interfaces.C.Long (Time.Coarse_Time);

-- Convert the CUC fine into Nano seconds
      Num_Nsecs    := Interfaces.C.Long
        (Basic_Time.Cuc_Fine_To_Nano_Secs (Time.Fine_Time));

      Durantion    := Ada.Calendar.Conversions.To_Duration
        (Tv_Sec  => Num_Secs,
         Tv_Nsec => Num_Nsecs);

      Span         := Ada.Real_Time.To_Time_Span (Durantion);
      Clock.Time_0 := Ada.Real_Time.Clock - Span;

   exception
      when Event : others =>
         Local_Debug
           (Clock => Clock,
            Str   => ".Set_Time Except: " &
               Ada.Exceptions.Exception_Information (Event));
   end Set_Time;


   function Get_Time
     (Clock  : in Clock_T) return Basic_Types_I.Cuc_Time_T
   is
      use type Ada.Real_Time.Time;
      use type Interfaces.C.Long;

      Span       : Ada.Real_Time.Time_Span    := Ada.Real_Time.Time_Span_Zero;
      Durantion  : Duration                   := 0.0;
      Num_Secs   : Interfaces.C.Long          := 0;
      Num_Nsecs  : Interfaces.C.Long          := 0;
      Result     : Basic_Types_I.Cuc_Time_T   := Basic_Types_I.Null_Cuc_Time_C;
   begin

      begin
         Span      := Ada.Real_Time.Clock - Clock.Time_0;
         Durantion := Ada.Real_Time.To_Duration (Span);

--  Duration to struct timespec conversion
         Ada.Calendar.Conversions.To_Struct_Timespec
           (D       => Durantion,
            tv_sec  => Num_Secs,
            tv_nsec => Num_Nsecs);

         Result.Coarse_Time := Basic_Types_I.Coarse_Time_T (Num_Secs);

-- Convert number of nano seconds into CUC Fine Time
         Result.Fine_Time   := Basic_Time.Nano_Secs_To_Cuc_Fine
           (Basic_Types_I.Uint32_T (Num_Nsecs));

--         if not Basic_Types_I.Is_Null_Debug_Proc (Clock.Debug_Proc) then
--            Clock.Debug_Proc
--              ("[Hw_Clock.Get_Time]Fine_Flt: " &
--                Basic_Types_I.Float_T'Image (Fine_Flt) &
--                " Cuc_Fine: " & Basic_Types_I.Fine_Time_T'Image (Result.Fine_Time) &
--                " Num_Nsecs: " & Interfaces.C.Long'Image (Num_Nsecs));
--         end if;

      exception
         when Event : others =>
            Local_Debug
              (Clock => Clock,
               Str   => "Get_Time Except: " &
                 Ada.Exceptions.Exception_Information (Event));
      end;

      return Result;
   end Get_Time;


   function Get_Time_Msb_1_Zero
     (Clock  : in Clock_T) return Basic_Types_I.Cuc_Time_T
   is
      use type Basic_Types_I.Coarse_Time_T;

      Coarse_Mask_C   : constant Basic_Types_I.Coarse_Time_T  := 16#00_FF_FF_FF#;

      Local_Cuc       : Basic_Types_I.Cuc_Time_T              := Get_Time (Clock);
   begin

      Local_Cuc.Coarse_Time := Local_Cuc.Coarse_Time and Coarse_Mask_C;
      return Local_Cuc;
   end Get_Time_Msb_1_Zero;


end Hw_Clock;

