


package body Basic_Types_I is


   function Is_Null_Callback (Callback  : Callback_T) return Boolean
   is
   begin
      return (Callback = null);
   end Is_Null_Callback;


   function Is_Null_Debug_Proc (Debug_Proc  : Debug_Proc_T) return Boolean
   is
   begin
      return (Debug_Proc = null);
   end Is_Null_Debug_Proc;


end Basic_Types_I;
