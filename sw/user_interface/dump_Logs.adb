
with Ada.Characters.Latin_1;
with Ada.Exceptions;
with Ada.Text_IO;
with Ada.Strings.Unbounded;

with Debug_Log;
with Uif_Configs;

package body Dump_Logs is


   type Arr_File_T is array (Oeu_Simu_Types.Log_T'Range) of Ada.Text_IO.File_Type;



   protected Obj_Prot is
      procedure Do_Log_Prot
        (Log    : in Oeu_Simu_Types.Log_T;
         Str    : in Basic_Types_I.String_T);
      procedure Do_Log_Same_Line_Prot
        (Log    : in Oeu_Simu_Types.Log_T;
         Str    : in Basic_Types_I.String_T);
      procedure Flush_Prot
        (Log    : in Oeu_Simu_Types.Log_T);


   private

      procedure Create_Prot
        (Log    : in Oeu_Simu_Types.Log_T);

      procedure Write_In_File
        (Log    : in Oeu_Simu_Types.Log_T;
         Str    : in Basic_Types_I.String_T);

--      pragma Priority (
--        Oeu_Simu_Sched_Params.Fifo_String_Buffer_C.Ceiling_Priority);

      Arr_File           : Arr_File_T;
      -- Array of file descriptors

      Arr_File_Created   : Oeu_Simu_Types.Arr_Bool_Log_T := (others => False);
      -- Bool array to know what file is created or not

      Arr_File_Error     : Oeu_Simu_Types.Arr_Bool_Log_T := (others => False);
      -- Bool array to know if it is possible to use this file

   end Obj_Prot;

   protected body Obj_Prot is


      procedure Do_Log_Prot
        (Log    : in Oeu_Simu_Types.Log_T;
         Str    : in Basic_Types_I.String_T)
      is
      begin
         if not Arr_File_Error (Log) then
            if not Arr_File_Created (Log) then
               Create_Prot (Log);
            end if;

            if Arr_File_Created (Log) then
--               Ada.Text_IO.Put (Arr_File (Log), Str);
               Write_In_File (Log, Str);
               Ada.Text_IO.Put_Line (Arr_File (Log), "");
               Ada.Text_IO.Flush (Arr_File (Log));
            end if;
         end if;
      end Do_Log_Prot;

      procedure Do_Log_Same_Line_Prot
        (Log    : in Oeu_Simu_Types.Log_T;
         Str    : in Basic_Types_I.String_T)
      is
      begin
         if not Arr_File_Error (Log) then
            if not Arr_File_Created (Log) then
               Create_Prot (Log);
            end if;

            if Arr_File_Created (Log) then
--               Ada.Text_IO.Put (Arr_File (Log), Str);
               Write_In_File (Log, Str);
               Ada.Text_IO.Flush (Arr_File (Log));
            end if;
         end if;
      end Do_Log_Same_Line_Prot;

      procedure Flush_Prot
        (Log    : in Oeu_Simu_Types.Log_T) is
      begin
         if not Arr_File_Error (Log) then
            if Arr_File_Created (Log) then
               Ada.Text_IO.Flush (Arr_File (Log));
            end if;
         end if;
      end Flush_Prot;

      procedure Create_Prot
        (Log          : in Oeu_Simu_Types.Log_T)
      is
      begin

         Ada.Text_IO.Create
           (File => Arr_File (Log),
            Mode => Ada.Text_IO.Out_File,
            Name => Ada.Strings.Unbounded.To_String (Uif_Configs.Dir_Exe_Logs) &
             Ada.Strings.Unbounded.To_String (Uif_Configs.Subdir_Current_Logs) & "\" &
             Ada.Strings.Unbounded.To_String (Uif_Configs.Arr_Logs_File_Name (Log)),
           Form => "");
          Arr_File_Created (Log) := True;
          Arr_File_Error (Log)   := False;
--         Ada.Text_IO.Put(File, "Init debug");
--         Ada.Text_IO.Put_Line(File, "");
      exception
         when Excep : others =>
            Arr_File_Error (Log) := True;
            Debug_Log.Do_Log ("[Dump_Logs.Create_Prot]Except: " &
              Ada.Exceptions.Exception_Name(Excep) & " " &
              Ada.Exceptions.Exception_Message(Excep));
      end Create_Prot;

      procedure Write_In_File
        (Log    : in Oeu_Simu_Types.Log_T;
         Str    : in Basic_Types_I.String_T)
      is
         use type Basic_Types_I.Uint32_T;

         Cr_Char_C : constant Character               := Ada.Characters.Latin_1.CR;
         Lf_Char_C : constant Character               := Ada.Characters.Latin_1.LF;
         Len_C     : constant Basic_Types_I.Uint32_T  := Str'Length;

         I         : Basic_Types_I.Uint32_T           := Str'First;
      begin

         while I <= Len_C loop

-- Change sequences of "CarroReturn, Line fed" to CarroReturn
            if (I + 1) <= Len_C and then
              Str (I) = Cr_Char_C and then
              Str (I + 1) = Lf_Char_C then

               Ada.Text_IO.Put (Arr_File (Log), Cr_Char_C);
               I := I + 2;
            else
               Ada.Text_IO.Put (Arr_File (Log), Str (I));
               I := I + 1;
            end if;
         end loop;

      end Write_In_File;

   end Obj_Prot;




   procedure Dump_To_File
     (Log    : in Oeu_Simu_Types.Log_T;
      Str    : in Basic_Types_I.String_T)
   is
   begin
     if Str'Length > 0 then
        Obj_Prot.Do_Log_Prot (Log, Str);
     end if;
   end Dump_To_File;

   procedure Dump_Same_Line_To_File
     (Log    : in Oeu_Simu_Types.Log_T;
      Str    : in Basic_Types_I.String_T)
   is
   begin
      if Str'Length > 0 then
         Obj_Prot.Do_Log_Same_Line_Prot (Log, Str);
      end if;
   end Dump_Same_Line_To_File;

   procedure Flush
     (Log    : in Oeu_Simu_Types.Log_T) is
   begin
      Obj_Prot.Flush_Prot (Log);
   end Flush;

end Dump_Logs;



