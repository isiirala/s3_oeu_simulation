
with Ada.Calendar;
with Ada.Directories;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

with Basic_Tools;
with Oeu_Simu_Types;
with Uif_Configs;


package body Debug_Log is


   protected Obj_Prot is
      procedure Flush_Prot;
      procedure Init_Prot;
      procedure Do_Log_Prot (Str : in String);
      procedure Do_Log_Same_Line_Prot (Str : in String);
      procedure Set_Flush_Each_Log_Prot (Status : in Boolean);
      function Is_Init_Prot return Boolean;
   private

--      pragma Priority (
--        Oeu_Simu_Sched_Params.Fifo_String_Buffer_C.Ceiling_Priority);

      File            : Ada.Text_IO.File_Type;
      Obj_Init        : Boolean                  := False;
      Flush_Each_Log  : Boolean                  := True;
   end Obj_Prot;

   protected body Obj_Prot is

      procedure Init_Prot
      is
      begin
         Ada.Text_IO.Create
           (File => File,
            Mode => Ada.Text_IO.Out_File,
            Name => Ada.Strings.Unbounded.To_String (Uif_Configs.Dir_Exe_Logs) & "\" &
             Ada.Strings.Unbounded.To_String (Uif_Configs.Subdir_Current_Logs) & "\" &
             Ada.Strings.Unbounded.To_String
             (Uif_Configs.Arr_Logs_File_Name (Oeu_Simu_Types.Log_App_Exe)),
           Form => "");
--         Ada.Text_IO.Put(File, "Init debug");
         Ada.Text_IO.Put_Line (File, "Init App execution debug log");
         Obj_Init := True;
      end Init_Prot;

      procedure Do_Log_Prot (Str : in String) is
      begin
         if Obj_Init then
            Ada.Text_IO.Put (File, Str);
            Ada.Text_IO.Put_Line (File, "");
            if Flush_Each_Log then
               Ada.Text_IO.Flush (File);
            end if;
         end if;
      end Do_Log_Prot;

      procedure Do_Log_Same_Line_Prot (Str : in String) is
      begin
         if Obj_Init then
            Ada.Text_IO.Put (File, Str);

            if Flush_Each_Log then
               Ada.Text_IO.Flush (File);
            end if;
         end if;
      end Do_Log_Same_Line_Prot;

      procedure Flush_Prot is
      begin
         if Obj_Init then
            Ada.Text_IO.Flush (File);
         end if;
      end Flush_Prot;

      procedure Set_Flush_Each_Log_Prot (Status : in Boolean) is
      begin
         Flush_Each_Log := Status;
      end Set_Flush_Each_Log_Prot;

      function Is_Init_Prot return Boolean is
      begin
         return Obj_Init;
      end Is_Init_Prot;
   end Obj_Prot;


-- TODO: LLEVAR A UN COMUN
   function Create_Timestamp return String
   is

      Now            : Ada.Calendar.Time            := Ada.Calendar.Clock;
      Year           : Ada.Calendar.Year_Number     := Ada.Calendar.Year (Now);
      Month          : Ada.Calendar.Month_Number    := Ada.Calendar.Month (Now);
      Day            : Ada.Calendar.Day_Number      := Ada.Calendar.Day (Now);
      Seconds        : Ada.Calendar.Day_Duration    := Ada.Calendar.Seconds (Now);
      N_Minuts       : Basic_Types_I.Uint32_T       := 0;
      Rest_Seconds   : Basic_Types_I.Uint32_T       := 0;
      N_Hours        : Basic_Types_I.Uint32_T       := 0;
      Rest_Minutes   : Basic_Types_I.Uint32_T       := 0;
      Sub_Dir_Name   : String (1 .. 31)             := "OeuSimuLogs_" &
--        Year_Str (2 .. Year_Str'Last) &
        "2016.00.00_00.00.00";
--       OeuSimuLogs_2016.11.06_23.40.00

   begin

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

      declare
         use type Basic_Types_I.Uint32_T;

         Year_Str       : String   := Year'Image;
         Month_Str      : String   := Month'Image;
         Day_Str        : String   := Day'Image;
         Hour_Str       : String   := N_Hours'Image;
         Mins_Str       : String   := Rest_Minutes'Image;
         Secs_Str       : String   := Rest_Seconds'Image;
      begin

         Sub_Dir_Name (13 .. 16) := Year_Str (2 .. Year_Str'Last);

         if Month < 10 then
            Sub_Dir_Name (19 .. 19) := Month_Str (2 .. 2);
         else
            Sub_Dir_Name (18 .. 19) := Month_Str (2 .. 3);
         end if;
         if Day < 10 then
            Sub_Dir_Name (22 .. 22) := Day_Str (2 .. 2);
         else
            Sub_Dir_Name (21 .. 22) := Day_Str (2 .. 3);
         end if;
         if N_Hours < 10 then
            Sub_Dir_Name (25 .. 25) := Hour_Str (2 .. 2);
         else
            Sub_Dir_Name (24 .. 25) := Hour_Str (2 .. 3);
         end if;
         if Rest_Minutes < 10 then
            Sub_Dir_Name (28 .. 28) := Mins_Str (2 .. 2);
         else
            Sub_Dir_Name (27 .. 28) := Mins_Str (2 .. 3);
         end if;
         if Rest_Seconds < 10 then
            Sub_Dir_Name (31 .. 31) := Secs_Str (2 .. 2);
         else
            Sub_Dir_Name (30 .. 31) := Secs_Str (2 .. 3);
         end if;
      end;

      return Sub_Dir_Name;
   end Create_Timestamp;




   procedure Init is

   begin

-- Try to create the first log directory. If it exists there is an error
      begin
         Ada.Directories.Create_Directory
           (Ada.Strings.Unbounded.To_String (Uif_Configs.Dir_Exe_Logs));
      exception
         when Excep : others =>
            null;
            -- The "exe_logs" directory exists, do nothing
      end;


      if not Uif_Configs.Rename_Subdir_Logs then

-- No create the subdirectory with the timestamp
         Uif_Configs.Subdir_Current_Logs :=
           Ada.Strings.Unbounded.To_Unbounded_String ("");

      else

-- Create the second subdirectory with the current date-hour

-- Save in Configs the name of the subdirectory with the current date-time where all
-- logs will be created in the current execution
         Uif_Configs.Subdir_Current_Logs :=
           Ada.Strings.Unbounded.To_Unbounded_String (Create_Timestamp);

         begin

            Ada.Directories.Create_Directory
              (Ada.Strings.Unbounded.To_String (Uif_Configs.Dir_Exe_Logs) &
               Ada.Strings.Unbounded.To_String (Uif_Configs.Subdir_Current_Logs));

         exception
            when Excep : others =>

-- If error creating log directory Save in Configs the empty name to use the father dir
               Uif_Configs.Subdir_Current_Logs :=
                 Ada.Strings.Unbounded.To_Unbounded_String ("");
         end;
      end if;
      Obj_Prot.Init_Prot;
   end Init;

   procedure Do_Log(str : in String) is
   begin

      if Uif_Configs.Active_Dump_Logs (Oeu_Simu_Types.Log_App_Exe) then
         Obj_Prot.Do_Log_Prot(str);

-- Make a flush in the file if it is necessary
--      Obj_Prot.Flush_Prot;
      end if;
   end Do_Log;

   procedure Do_Log_Same_Line(str : in String) is
   begin

      if Uif_Configs.Active_Dump_Logs (Oeu_Simu_Types.Log_App_Exe) then
         Obj_Prot.Do_Log_Same_Line_Prot(Str);
      end if;
   end Do_Log_Same_Line;

   function U32_To_Str (U32 : in Basic_Types_I.Unsigned_32_T) return String
   is
   begin
      return Basic_Types_I.Unsigned_32_T'Image (U32);
   end U32_To_Str;

   function U8_To_Str (U8 : in Basic_Types_I.Unsigned_8_T) return String
   is
   begin
      return Basic_Types_I.Unsigned_8_T'Image (U8);
   end U8_To_Str;

   procedure Flush is
   begin
      if Uif_Configs.Active_Dump_Logs (Oeu_Simu_Types.Log_App_Exe) then
         Obj_Prot.Flush_Prot;
      end if;
   end Flush;

   procedure Set_Flush_Each_Log (Status : in Boolean) is
   begin
      Obj_Prot.Set_Flush_Each_Log_Prot (Status);
   end Set_Flush_Each_Log;

end Debug_Log;

