

Package body Basic_Types_Gtk is


   function String_100_Str_To_Utf8_String
     (Str : in Basic_Types_I.String_100_Str_T) return Glib.UTF8_String
   is
   begin

      return Glib.UTF8_String (Str.Str (1 .. Str.Last_I));
   end String_100_Str_To_Utf8_String;





--     function Font_Configured
--       (Font_Conf  : in Font_Config_T) return Boolean
--     is
--        use type Ada.Strings.Unbounded.Unbounded_String;
--
--     begin
--        if Font_Conf.Name =
--          Ada.Strings.Unbounded.Null_Unbounded_String then
--           return False;
--        else
--           return True;
--        end if;
--     end Font_Configured;


   function Str_Null
     (Str  : in Ada.Strings.Unbounded.Unbounded_String) return Boolean
   is
      use type Ada.Strings.Unbounded.Unbounded_String;
   begin
      return (Str = Ada.Strings.Unbounded.Null_Unbounded_String);
   end Str_Null;


   function Font_Range_To_Tag_Str (I  : in Font_Config_Range_T) return String
   is
      Result  : String (1 .. 6)  := "Tag_  ";
      Num_Str : String           := Font_Config_Range_T'Image (I);
   begin
      Result (5)  := Num_Str (2);
      if I >= 10 then
         Result (6)  := Num_Str (3);
      end if;
      return Result;
   end Font_Range_To_Tag_Str;


end Basic_Types_Gtk;
