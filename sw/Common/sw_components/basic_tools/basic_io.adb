

with Ada.Characters.Latin_1;
with Ada.Text_IO;


package body Basic_Io is

-- ============================================================================
-- %% Type and constant declarations
-- ============================================================================



-- ============================================================================
-- %% Internal operations
-- ============================================================================


-- ============================================================================
-- %% Provided operations
-- ============================================================================

   procedure Empty is
   begin
      null;
   end Empty;


-- Append Sub_Str in Str(Index .. Index + Sub_Str'Length)
--     procedure Append
--       (Sub_Str : in Basic_Types_I.String_T;
--        Str     : in out Basic_Types_I.String_T;
--        Index   : in out Basic_Types_I.Uint32_T)
--     is
--        use type Basic_Types_I.Uint32_T;
--
--        Sub_Str_Len  : Basic_Types_I.Uint32_T  := Sub_Str'Length;
--        F_Str        : Basic_Types_I.Uint32_T  := Str'First;
--        L_Str        : Basic_Types_I.Uint32_T  := Str'Last;
--        Index_End    : Basic_Types_I.Uint32_T  := Index + Sub_Str_Len - 1;
--
--     begin
--
--        if (Index >= F_Str) and (Index_End <= L_Str) then
--           Str (Index .. Index_End) := Sub_Str;
--           Index := Index_End + 1;
--        end if;
--
--     end Append;
--
--
--     procedure Append_Nl
--       (Sub_Str : in Basic_Types_I.String_T;
--        Str     : in out Basic_Types_I.String_T;
--        Index   : in out Basic_Types_I.Uint32_T)
--     is
--        use type Basic_Types_I.Uint32_T;
--
--        Sub_Str_Len  : Basic_Types_I.Uint32_T                        :=
--          Sub_Str'Length;
--        New_Sub_Str  : Basic_Types_I.String_T (1 .. Sub_Str_Len + 2) :=
--          (others => ' ');
--     begin
--
--        New_Sub_Str (1 .. Sub_Str_Len)                := Sub_Str;
--        New_Sub_Str (Sub_Str_Len + 1 .. Sub_Str_Len + 2)  :=
--          (Ada.Characters.Latin_1.CR,
--           Ada.Characters.Latin_1.LF);
--
--        Append
--          (Sub_Str => New_Sub_Str,
--           Str     => Str,
--           Index   => Index);
--     end Append_Nl;


--     procedure Append
--       (Num      : in Basic_Types_I.Uint32_T;
--        Str      : in out Basic_Types_I.String_T;
--        Index    : in out Basic_Types_I.Uint32_T;
--        Base     : in Integer := 10)
--     is
--
--        Str_Local     : Basic_Types_I.String_T (1 .. 32) := (others => ' ');
--        Last_I        : Basic_Types_I.Uint32_T           := 32;
--     begin
--
--        Uint_To_String
--          (Num        => Num,
--           Str        => Str_Local,
--           Last_Index => Last_I,
--           Base       => Base);
--
--        Append
--          (Sub_Str => Str_Local (1 .. Last_I),
--           Str     => Str,
--           Index   => Index);
--     end Append;







end Basic_Io;
