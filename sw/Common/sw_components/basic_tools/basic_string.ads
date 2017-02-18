

with Basic_Types_I;

package Basic_String is


   function First_Index_Of_Char
     (Str     : Basic_Types_I.String_T;
      Char    : Character) return Basic_Types_I.Uint32_T;

   function Match_At_End
     (Str     : Basic_Types_I.String_T;
      Sub_Str : Basic_Types_I.String_T) return Boolean;
   -- True if last characters of Str are equal to Sub_Str


--   function Equals
--     (Str1       : Basic_Types_I.String_T;
--      Str1_Begin : Basic_Types_I.Uint32_T;
--      Str1_End   : Basic_Types_I.Uint32_T;
--      Str2       : Basic_Types_I.String_T) return Boolean;

--   function Equals_No_Case
--     (Str1    : Basic_Types_I.String_T;
--      Str2    : Basic_Types_I.String_T) return Boolean;

end Basic_String;
