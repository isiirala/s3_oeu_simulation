

package body Basic_String is


   function First_Index_Of_Char
     (Str     : Basic_Types_I.String_T;
      Char    : Character) return Basic_Types_I.Uint32_T
   is
      use type Basic_Types_I.Uint32_T;

      Str_First_C  : constant Basic_Types_I.Uint32_T   := Str'First;
      Str_Last_C   : constant Basic_Types_I.Uint32_T   := Str'Last;

      I_Str        : Basic_Types_I.Uint32_T            := Str_First_C;
      Result       : Basic_Types_I.Uint32_T            := 0;
   begin

      loop
         if Str (I_Str) = Char then
            Result := I_Str;
            exit;
         end if;
         I_Str := I_Str + 1;
         exit when I_Str > Str_Last_C;
      end loop;

      return Result;
   end First_Index_Of_Char;

   function Match_At_End
     (Str     : Basic_Types_I.String_T;
      Sub_Str : Basic_Types_I.String_T) return Boolean
   is
      use type Basic_Types_I.Uint32_T;
      use type Basic_Types_I.String_T;

      Str_Last_C    : constant Basic_Types_I.Uint32_T   := Str'Last;
      Str_Len_C     : constant Basic_Types_I.Uint32_T   := Str'Length;
      Sub_First_C   : constant Basic_Types_I.Uint32_T   := Sub_Str'First;
      Sub_Last_C    : constant Basic_Types_I.Uint32_T   := Sub_Str'Last;
      Sub_Len_C     : constant Basic_Types_I.Uint32_T   := Sub_Str'Length;

      I_Str_B       : Basic_Types_I.Uint32_T            := 0;
      Result        : Boolean                           := False;
   begin

      if (Str_Len_C >= Sub_Len_C) and (Sub_Len_C > 0) then

         I_Str_B := Str_Last_C - Sub_Len_C + 1;
         Result  := Str (I_Str_B .. Str_Last_C) = Sub_Str (Sub_First_C .. Sub_Last_C);

      end if;
      return Result;
   end Match_At_End;


--     function Equals
--       (Str1       : Basic_Types_I.String_T;
--        Str1_Begin : Basic_Types_I.Uint32_T;
--        Str1_End   : Basic_Types_I.Uint32_T;
--        Str2       : Basic_Types_I.String_T) return Boolean
--     is
--        use type Basic_Types_I.Uint32_T;
--  --      use type Basic_Types_I.String_T;
--
--        Str1_First_C  : constant Basic_Types_I.Uint32_T   := Str1'First;
--        Str1_Last_C   : constant Basic_Types_I.Uint32_T   := Str1'Last;
--
--
--        Result     : Boolean                  := False;
--
--     begin
--
--        if (Str1_Begin >= Str1_First_C) and (Str1_Begin < Str1_Last_C) then
--          if (Str1_End > Str1_First_C) and (Str1_End <= Str1_Last_C) then
--
--
--          end if;
--        end if;
--
--        return Result;
--     end Equals;




end Basic_String;
