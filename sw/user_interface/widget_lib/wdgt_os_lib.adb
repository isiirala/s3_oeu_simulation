

with GNAT.OS_Lib;

package body Wdgt_Os_Lib is


   function Open_Link
      (URI   : String) return Boolean
   is
      Prog_Name_C       : constant String            := "cmd.exe";
      Arguments         : GNAT.OS_Lib.Argument_List  :=
        (1 => new String'("cmd.exe"),
         2 => new String'("/C START " & URI));
      Ret_Val           : Integer                    := 0;
--      Spawn_Result      : Boolean                    := False;
   begin

      GNAT.OS_Lib.Normalize_Arguments (Arguments);

      Ret_Val := GNAT.OS_Lib.Spawn
        (Program_Name  => Prog_Name_C,
         Args          => Arguments);
   --  This is a non blocking call. The Process_Id of the spawned process is
   --  returned. Parameters are to be used as in Spawn. If Invalid_Pid is
   --  returned the program could not be spawned.

--      GNAT.OS_Lib.Spawn
--        (Program_Name => "cmd.exe",
--         Args         => Arguments,
--         Output_File  => "c:\ada_spawn_result.txt",
--         Success      => Spawn_Result,
--         Return_Code  => Ret_Val);

--      Debug_Log.Do_Log ("[AboutDialog] Url clicked: " & URI);
--      Debug_Log.Do_Log (" success: " & Boolean'Image (Spawn_Result) & " Ret_Code: " &
--        Integer'Image (Ret_Val));


-- TODO: FREE ARGUMENTS



      return True; --(Ret_Val /= 0);
   end Open_Link;




end Wdgt_Os_Lib;
