
with Ada.Strings.Unbounded;

with Oeu_Simu_Sched_Params;

package Fifo_String_Buffer is


   protected type Obj_Buffer is
      procedure Write(Data : in String);
      procedure Read(Data : in out String; Actual_Len : out Natural);

   private

--      pragma Priority (
--        Oeu_Simu_Sched_Params.Fifo_String_Buffer_C.Ceiling_Priority);

      Data_Buffer   : Ada.Strings.Unbounded.Unbounded_String :=
        Ada.Strings.Unbounded.Null_Unbounded_String;
   end Obj_Buffer;

end Fifo_String_Buffer;
