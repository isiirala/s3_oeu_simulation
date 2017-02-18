-- ****************************************************************************
--  Project             : S3 OEU SIMULATION
--  Unit Name           : Basic_Tools
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/12/12 15:33:39 $
--  Revision            : $Revision: 1.2 $
--  Function            : Basic types and constants used in the OEU ICM APSW
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv
-- ****************************************************************************

with Ada.Characters.Latin_1;
with Ada.Text_IO;

package body Basic_Tools is


-- ============================================================================
-- %% Type and constant declarations
-- ============================================================================

   package Int_Io is new Ada.Text_IO.Integer_IO(Integer);
   package Uint_32_Io is new Ada.Text_IO.Modular_IO(Basic_Types_I.Uint32_T);
   package Uint_64_Io is new Ada.Text_IO.Modular_IO(Basic_Types_I.Uint64_T);
   package Int_32_Io is new Ada.Text_IO.Integer_IO(Basic_Types_I.Int32_T);
   package Flt_32_Io is new Ada.Text_IO.Float_IO(Basic_Types_I.Float_T);


   subtype String_1_3_T    is Basic_Types_I.String_T (1 .. 3);
   subtype String_1_40_T   is Basic_Types_I.String_T (1 .. 40);




-- ============================================================================
-- %% Internal operations
-- ============================================================================

   procedure Byte_To_String_Base_16
     (Num    : in Basic_Types_I.Uint8_T;
      Str    : out String_1_3_T)
   is
      use type Basic_Types_I.Uint8_T;
      use type Basic_Types_I.Uint32_T;

      Base_16_C   : constant                         := 16;
      Space_C     : constant Character               := ' ';
      First_Index : Basic_Types_I.Uint32_T           := String_1_3_T'First;
      Last_Index  : Basic_Types_I.Uint32_T           := String_1_3_T'Last;
      Str_Local   : Basic_Types_I.String_T (1 .. 6)  := (others => Space_C);
   begin

      Int_Io.Put
        (To   => String (Str_Local),
         Item => Integer (Num),
         Base => Base_16_C);
      if Num >= Base_16_C then
         Str (First_Index .. First_Index + 1) := Str_Local (4 .. 5);
      else
         Str (First_Index)     := '0';
         Str (First_Index + 1) := Str_Local (5);
      end if;
      Str (First_Index + 2) := Space_C;
   end Byte_To_String_Base_16;


   procedure Trim_Str_Num
     (Str_In           : in String_1_40_T;
      Base             : in Integer;
      Str_Out          : out String_1_40_T;
      Last_Index       : out Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;

      Space_C       : constant Character                       := ' ';
      Base_C        : constant Character                       := '#';
      Str_Len_C     : constant Basic_Types_I.Uint32_T          := String_1_40_T'Length;
      Str_Last_C    : constant Basic_Types_I.Uint32_T          := String_1_40_T'Last;
--      Local_Begin_C : constant Basic_Types_I.Uint32_T          := 1;
--      Local_End_C   : constant Basic_Types_I.Uint32_T          := 33;
      Str_First_C   : constant Basic_Types_I.Uint32_T          := String_1_40_T'First;
      Str_J         : Basic_Types_I.Uint32_T                   := 0;
      Local_I       : Basic_Types_I.Uint32_T                   := String_1_40_T'First; --Local_Begin_C;
      Local_J       : Basic_Types_I.Uint32_T                   := String_1_40_T'Last; --Local_End_C;
      Local_Len     : Basic_Types_I.Uint32_T                   := 0;
   begin

      Last_Index := Str_First_C;

-- Skip empty spaces at the beginning
      loop
         exit when (Str_In (Local_I) /= Space_C) or (Local_I >= Str_Last_C);
         Local_I := Local_I + 1;
      end loop;

      if Base /= 10 then

-- Skip base info
         loop
            exit when (Str_In (Local_I) = Base_C) or
              (Local_I >= Str_Last_C);
            Local_I := Local_I + 1;
         end loop;
         if Str_In (Local_I) = Base_C then
            Local_I := Local_I + 1;
         end if;
      end if;

      if Base /= 10 then
-- Skip last #
         Local_J := Str_Last_C - 1;
      end if;

      Local_Len := (Local_J - Local_I) + 1;
      if Str_Len_C >= Local_Len then
         Str_J := (Str_First_C + Local_Len) - 1;
         Str_Out (Str_First_C .. Str_J) := Str_In (Local_I .. Local_J);
         Last_Index := Str_J;
      end if;

   end Trim_Str_Num;


   procedure Uint32_To_String
     (Num              : in Basic_Types_I.Uint32_T;
      Str              : out String_1_40_T;
      Last_Index       : out Basic_Types_I.Uint32_T;
      Base             : in Integer := 10)
   is
--      use type Basic_Types_I.Uint32_T;

--      Space_C       : constant Character                       := ' ';
--      Base_C        : constant Character                       := '#';
--      Str_Len_C     : constant Basic_Types_I.Uint32_T          := String_1_40_T'Length;
--      Local_Begin_C : constant Basic_Types_I.Uint32_T          := 1;
--      Local_End_C   : constant Basic_Types_I.Uint32_T          := 33;
--      Str_First_C   : constant Basic_Types_I.Uint32_T          := String_1_40_T'First;
--      Str_J         : Basic_Types_I.Uint32_T                   := 0;
--      Local_I       : Basic_Types_I.Uint32_T                   := Local_Begin_C;
--      Local_J       : Basic_Types_I.Uint32_T                   := Local_End_C;
--      Local_Len     : Basic_Types_I.Uint32_T                   := 0;
      Str_Local     : String_1_40_T                            := (others => ' ');
   begin

      Uint_32_Io.Put
        (To         => String (Str_Local),
         Item       => Num,
         Base       => Base);

      Trim_Str_Num
        (Str_In     => Str_Local,
         Base       => Base,
         Str_Out    => Str,
         Last_Index => Last_Index);

--  -- Skip empty spaces at the beginning
--        loop
--           exit when (Str_Local (Local_I) /= Space_C) or (Local_I >= Local_End_C);
--           Local_I := Local_I + 1;
--        end loop;
--
--        if Base /= 10 then
--
--  -- Skip base info
--           loop
--              exit when (Str_Local (Local_I) = Base_C) or
--                (Local_I >= Local_End_C);
--              Local_I := Local_I + 1;
--           end loop;
--           if Str_Local (Local_I) = Base_C then
--              Local_I := Local_I + 1;
--           end if;
--        end if;
--
--        if Base /= 10 then
--  -- Skip last #
--           Local_J := Local_End_C - 1;
--        end if;
--
--        Local_Len := (Local_J - Local_I) + 1;
--        if Str_Len_C >= Local_Len then
--           Str_J := (Str_First_C + Local_Len) - 1;
--           Str (Str_First_C .. Str_J) := Str_Local (Local_I .. Local_J);
--           Last_Index := Str_J;
--        end if;

   end Uint32_To_String;


   procedure Uint64_To_String
     (Num              : in Basic_Types_I.Uint64_T;
      Str              : out String_1_40_T;
      Last_Index       : out Basic_Types_I.Uint32_T;
      Base             : in Integer := 10)
   is
      Str_Local     : String_1_40_T                            := (others => ' ');
   begin

      Uint_64_Io.Put
        (To         => String (Str_Local),
         Item       => Num,
         Base       => Base);

      Trim_Str_Num
        (Str_In     => Str_Local,
         Base       => Base,
         Str_Out    => Str,
         Last_Index => Last_Index);
   end Uint64_To_String;

   procedure Int32_To_String
     (Num              : in Basic_Types_I.Int32_T;
      Str              : out String_1_40_T;
      Last_Index       : out Basic_Types_I.Uint32_T;
      Base             : in Integer := 10)
   is
      Str_Local     : String_1_40_T                            := (others => ' ');
   begin

      Int_32_Io.Put
        (To         => String (Str_Local),
         Item       => Num,
         Base       => Base);

      Trim_Str_Num
        (Str_In     => Str_Local,
         Base       => Base,
         Str_Out    => Str,
         Last_Index => Last_Index);
   end Int32_To_String;

   procedure Flt32_To_String
     (Num              : in Basic_Types_I.Float_T;
      Str              : out String_1_40_T;
      Last_Index       : out Basic_Types_I.Uint32_T)
   is
      Str_Local     : String_1_40_T                            := (others => ' ');
   begin

      Flt_32_Io.Put
        (To         => String (Str_Local),
         Item       => Num);

      Trim_Str_Num
        (Str_In     => Str_Local,
         Base       => 10,
         Str_Out    => Str,
         Last_Index => Last_Index);
   end Flt32_To_String;

-- ============================================================================
-- %% Provided operations
-- ============================================================================

   procedure Decrement
     (Number : in out Basic_Types_I.Uint32_T;
      Count  : in Basic_Types_I.Uint32_T := 1)
   is
      use type Basic_Types_I.Uint32_T;
   begin
      if (Number - Count) >= 0 then
         Number := Number - Count;
      else
         Number := 0;
      end if;
   end Decrement;






















   function "&"
     (Left  : Basic_Types_I.String_T;
      Right : Basic_Types_I.String_T) return Basic_Types_I.String_T
   is
      use type Basic_Types_I.Uint32_T;

      L_First_C   : constant Basic_Types_I.Uint32_T  := Left'First;
      L_Last_C    : constant Basic_Types_I.Uint32_T  := Left'Last;
      L_Len_C     : constant Basic_Types_I.Uint32_T  := Left'Length;

      R_Len_C     : constant Basic_Types_I.Uint32_T  := Right'Length;
      Result_Ret  : Basic_Types_I.String_T (L_First_C .. L_Last_C + R_Len_C) :=
        (others => ' ');
   begin
      Result_Ret (L_First_C .. L_Last_C) := Left;
      Result_Ret (L_Last_C + 1 .. L_Last_C + R_Len_C) := Right;
      return Result_Ret;
   end "&";

   function "&"
     (Left  : Basic_Types_I.String_T;
      Right : String) return Basic_Types_I.String_T
   is
      use type Basic_Types_I.Uint32_T;

      L_First_C   : constant Basic_Types_I.Uint32_T  := Left'First;
      L_Last_C    : constant Basic_Types_I.Uint32_T  := Left'Last;
      L_Len_C     : constant Basic_Types_I.Uint32_T  := Left'Length;

      R_Len_C     : constant Basic_Types_I.Uint32_T  := Right'Length;
      Result_Ret  : Basic_Types_I.String_T (L_First_C .. L_Last_C + R_Len_C) :=
        (others => ' ');
   begin
      Result_Ret (L_First_C .. L_Last_C) := Left;
      Result_Ret (L_Last_C + 1 .. L_Last_C + R_Len_C) := Basic_Types_I.String_T
        (Right);
      return Result_Ret;
   end "&";

   function "&"
     (Left  : String;
      Right : Basic_Types_I.String_100_Str_T) return String
   is
      use type Basic_Types_I.Uint32_T;

      L_First_C      : constant Integer  := Left'First;
      L_Last_C       : constant Integer  := Left'Last;
      Result_Last_C  : constant Integer  := L_Last_C + Integer (Right.Last_I);

      Result_Ret     : String (L_First_C .. Result_Last_C) :=
        (others => ' ');
   begin
      Result_Ret (L_First_C .. L_Last_C)         := Left;
      Result_Ret (L_Last_C + 1 .. Result_Last_C) :=
        String (Right.Str (1 .. Right.Last_I));
      return Result_Ret;
   end "&";


   function To_String
     (Str : Basic_Types_I.String_T;
      Len : Basic_Types_I.Data_32_Len_T) return String
   is
   begin

      if Len.Data_Empty then
         return "";
      else
         return String (Str (Str'First .. Len.Last_Used));
      end if;
   end To_String;




   procedure Div
     (Dividend  : in Basic_Types_I.Uint32_T;
      Divisor   : in Basic_Types_I.Uint32_T;
      Quotient  : out Basic_Types_I.Uint32_T;
      Remainder : out Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;

   begin

      Quotient  := Dividend / Divisor;

-- As the input types are unsigned the operator to calculate the remainder can be both
-- mod or rem, because the only difference between them is the source of the sign
      Remainder := Dividend mod Divisor;
   end Div;





--     procedure Append
--       (Annex            : in Basic_Types_I.Byte_Array_T;
--        Buff_Empty       : in Boolean;
--        Last_Index_Limit : in Basic_Types_I.Uint32_T;
--        Buff_Whole       : in out Basic_Types_I.Byte_Array_T;
--        Last_Index       : in out Basic_Types_I.Uint32_T)
--     is
--        use type Basic_Types_I.Uint32_T;
--
--        Last_Index_C      : constant Basic_Types_I.Uint32_T := Last_Index;
--        -- Local copy of the Last_Index parameter
--
--        Annex_Len_C       : constant Basic_Types_I.Uint32_T := Annex'Length;
--        -- Byte length of the annext to append
--
--        Free_Bytes        : Basic_Types_I.Uint32_T          := Last_Index_Limit;
--        -- Free bytes in the buffer when it is empty
--
--        First_Index       : Basic_Types_I.Uint32_T          := Last_Index_C;
--        -- First index to write when buffer is empty
--
--     begin
--
--  --      Last_Index := 0;
--
--        if (Last_Index < Last_Index_Limit) and then (Annex_Len_C > 0) then
--  -- If current Last_Index of the buffer can grow and the Annex contains something
--
--           if not Buff_Empty then
--  -- Correct values of free bytes and first index when buffer is not empty
--              Free_Bytes  := Last_Index_Limit - Last_Index_C;
--              First_Index := Last_Index_C + 1;
--           end if;
--
--           if Annex_Len_C <= Free_Bytes then
--  -- If there is room for the annex
--
--              Last_Index := First_Index + Annex_Len_C - 1;
--
--              Buff_Whole (First_Index .. Last_Index) := Annex;
--
--           end if;
--        end if;
--     end Append;


   procedure Append
     (Annex            : in Basic_Types_I.Byte_Array_T;
      Buff_Data        : in out Basic_Types_I.Byte_Array_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_I.Uint32_T;

      Annex_Len_C       : constant Basic_Types_I.Uint32_T  := Annex'Length;
      -- Byte length of the annext to append

      Buff_F_C          : constant Basic_Types_I.Uint32_T  := Buff_Data'First;
      Buff_L_C          : constant Basic_Types_I.Uint32_T  := Buff_Data'Last;

      Free_Bytes        : Basic_Types_I.Uint32_T           := Buff_L_C - Buff_F_C + 1;
      -- Free bytes in the buffer when it is empty

      First_Index       : Basic_Types_I.Uint32_T           := Buff_F_C;
      -- First index of the buffer to write, with the value when it is empty

   begin

-- If Annex is empty do nothing
      if Annex_Len_C > 0 then

         if Buff_Len.Data_Empty then
-- If flag says "empty" set the index at the first position
            Buff_Len.Last_Used := Buff_F_C;
         else
-- Correct values of free bytes and first index when buffer is not empty
            Free_Bytes  := Buff_L_C - Buff_Len.Last_Used;
            First_Index := Buff_Len.Last_Used + 1;
         end if;

         if Annex_Len_C <= Free_Bytes then
-- If there is room for the annex append it

            Buff_Len.Last_Used  := First_Index + Annex_Len_C - 1;
            Buff_Data (First_Index .. Buff_Len.Last_Used) := Annex;
            Buff_Len.Data_Empty := False;

         else
            raise Append_Overflow_Ex;
         end if;
      end if;
   end Append;




--     procedure Append
--       (Annex            : in Basic_Types_I.String_T;
--        Buff_Empty       : in Boolean;
--        Last_Index_Limit : in Basic_Types_I.Uint32_T;
--        Buff_Whole       : in out Basic_Types_I.String_T;
--        Last_Index       : in out Basic_Types_I.Uint32_T)
--     is
--        use type Basic_Types_I.Uint32_T;
--
--        Last_Index_C      : constant Basic_Types_I.Uint32_T := Last_Index;
--        -- Local copy of the Last_Index parameter
--
--        Annex_Len_C       : constant Basic_Types_I.Uint32_T := Annex'Length;
--        -- Byte length of the annext to append
--
--        Free_Bytes        : Basic_Types_I.Uint32_T          := Last_Index_Limit;
--        -- Free bytes in the buffer when it is empty
--
--        First_Index       : Basic_Types_I.Uint32_T          := Last_Index_C;
--        -- First index to write when buffer is empty
--
--     begin
--
--  --      Last_Index := 0;
--
--        if (Last_Index_C < Last_Index_Limit) and then (Annex_Len_C > 0) then
--  -- If current Last_Index of the buffer can grow and the Annex contains something
--
--           if not Buff_Empty then
--  -- Correct values of free bytes and first index when buffer is not empty
--              Free_Bytes  := Last_Index_Limit - Last_Index_C;
--              First_Index := Last_Index_C + 1;
--           end if;
--
--           if Annex_Len_C <= Free_Bytes then
--  -- If there is room for the annex
--
--              Last_Index := First_Index + Annex_Len_C - 1;
--
--              Buff_Whole (First_Index .. Last_Index) := Annex;
--
--           end if;
--        end if;
--     end Append;

   procedure Append
     (Annex            : in Basic_Types_I.String_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_I.Uint32_T;

      Annex_Len_C       : constant Basic_Types_I.Uint32_T  := Annex'Length;
      -- Byte length of the annext to append

      Buff_F_C          : constant Basic_Types_I.Uint32_T  := Buff_Data'First;
      Buff_L_C          : constant Basic_Types_I.Uint32_T  := Buff_Data'Last;

      Free_Bytes        : Basic_Types_I.Uint32_T           := Buff_L_C - Buff_F_C + 1;
      -- Free bytes in the buffer when it is empty

      First_Index       : Basic_Types_I.Uint32_T           := Buff_F_C;
      -- First index of the buffer to write, with the value when it is empty

   begin

-- If Annex is empty do nothing
      if Annex_Len_C > 0 then

         if Buff_Len.Data_Empty then
-- If flag says "empty" set the index at the first position
            Buff_Len.Last_Used := Buff_F_C;
         else
-- Correct values of free bytes and first index when buffer is not empty
            Free_Bytes  := Buff_L_C - Buff_Len.Last_Used;
            First_Index := Buff_Len.Last_Used + 1;
         end if;

         if Annex_Len_C <= Free_Bytes then
-- If there is room for the annex append it

            Buff_Len.Last_Used  := First_Index + Annex_Len_C - 1;
            Buff_Data (First_Index .. Buff_Len.Last_Used) := Annex;
            Buff_Len.Data_Empty := False;

         else
            raise Append_Overflow_Ex;
         end if;
      end if;
   end Append;

   procedure Append_Str
     (Annex            : in String;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      Annex_Local      : Basic_Types_I.String_T (1 .. Annex'Length) :=
        Basic_Types_I.String_T (Annex (Annex'First .. Annex'Last));
   begin
      Append
        (Annex     => Annex_Local,
         Buff_Data => Buff_Data,
         Buff_Len  => Buff_Len);
   end Append_Str;



   procedure Append
     (Annex            : in Basic_Types_I.String_T;
      Annex_Len        : in Basic_Types_I.Data_32_Len_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
   begin

      if not Annex_Len.Data_Empty then
         Append
           (Annex     => Annex (Annex'First .. Annex_Len.Last_Used),
            Buff_Data => Buff_Data,
            Buff_Len  => Buff_Len);
      end if;
   end Append;



   procedure Append
     (Num              : in Basic_Types_I.Uint32_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T;
      Base             : in Integer := 10)
   is

      Str_Local     : String_1_40_T                    := (others => ' ');
      Last_I        : Basic_Types_I.Uint32_T           := 0;
   begin

      Uint32_To_String
        (Num        => Num,
         Str        => Str_Local,
         Last_Index => Last_I,
         Base       => Base);

      Append
        (Annex      => Str_Local (1 .. Last_I),
         Buff_Data  => Buff_Data,
         Buff_Len   => Buff_Len);
   end Append;


   procedure Append
     (Num              : in Basic_Types_I.Uint64_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T;
      Base             : in Integer := 10)
   is
      Str_Local     : String_1_40_T                    := (others => ' ');
      Last_I        : Basic_Types_I.Uint32_T           := 0;
   begin

      Uint64_To_String
        (Num        => Num,
         Str        => Str_Local,
         Last_Index => Last_I,
         Base       => Base);

      Append
        (Annex      => Str_Local (1 .. Last_I),
         Buff_Data  => Buff_Data,
         Buff_Len   => Buff_Len);
   end Append;

   procedure Append
     (Num              : in Basic_Types_I.Int32_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T;
      Base             : in Integer := 10)
   is
      Str_Local     : String_1_40_T                    := (others => ' ');
      Last_I        : Basic_Types_I.Uint32_T           := 0;
   begin

      Int32_To_String
        (Num        => Num,
         Str        => Str_Local,
         Last_Index => Last_I,
         Base       => Base);

      Append
        (Annex      => Str_Local (1 .. Last_I),
         Buff_Data  => Buff_Data,
         Buff_Len   => Buff_Len);
   end Append;

   procedure Append
     (Num              : in Basic_Types_I.Float_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      Str_Local     : String_1_40_T                    := (others => ' ');
      Last_I        : Basic_Types_I.Uint32_T           := 0;
   begin

      Flt32_To_String
        (Num        => Num,
         Str        => Str_Local,
         Last_Index => Last_I);

      Append
        (Annex      => Str_Local (1 .. Last_I),
         Buff_Data  => Buff_Data,
         Buff_Len   => Buff_Len);
   end Append;


   procedure Append_Nl
     (Annex            : in Basic_Types_I.String_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      Annex_Nl_C  : constant Basic_Types_I.String_T (1 .. 2) :=
        (Ada.Characters.Latin_1.Cr, Ada.Characters.Latin_1.Lf);

   begin

      Append
        (Annex     => Annex,
         Buff_Data => Buff_Data,
         Buff_Len  => Buff_Len);
      Append
        (Annex     => Annex_Nl_C,
         Buff_Data => Buff_Data,
         Buff_Len  => Buff_Len);
   end Append_Nl;




   procedure Append_Base_16
     (Num              : in Basic_Types_I.Uint8_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      Str_Local   : String_1_3_T  := (others => ' ');
   begin

      Byte_To_String_Base_16
        (Num  => Num,
         Str  => Str_Local);

      Append
       (Annex      => Str_Local,
        Buff_Data  => Buff_Data,
        Buff_Len   => Buff_Len);
   end Append_Base_16;

   procedure Append_Base_16
     (Nums             : in Basic_Types_I.Byte_Array_T;
      Buff_Data        : in out Basic_Types_I.String_T;
      Buff_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_I.Uint32_T;
   begin

      for I in Nums'Range loop

         Append_Base_16
           (Num            => Nums (I),
            Buff_Data      => Buff_Data,
            Buff_Len       => Buff_Len);

         if I < Nums'Last then
            Append_Str
              (Annex      => " ",
               Buff_Data  => Buff_Data,
               Buff_Len   => Buff_Len);
         end if;
      end loop;
   end Append_Base_16;


   function First_Free
     (Data_Len         : Basic_Types_I.Data_32_Len_T;
      Buffer_First     : Basic_Types_I.Array_Index_T;
      Buffer_Last      : Basic_Types_I.Array_Index_T)
   return Basic_Types_I.Array_Index_T
   is
      use type Basic_Types_I.Uint32_T;

      Result : Basic_Types_I.Array_Index_T   :=  0;
   begin

      if Data_Len.Data_Empty then
         Result := Buffer_First;
      else
         if Data_Len.Last_Used + 1 > Buffer_Last then
            raise First_Free_Ex;
         else
            Result := Data_Len.Last_Used + 1;
        end if;
      end if;

      return Result;
   end First_Free;

   procedure Increment
     (Count            : in Basic_Types_I.Uint32_T;
      Buffer_First     : in Basic_Types_I.Array_Index_T;
      Data_Len         : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_I.Uint32_T;
   begin

      if Data_Len.Data_Empty then
         Data_Len.Last_Used  := Buffer_First + Count - 1;
         Data_Len.Data_Empty := False;
      else
         Data_Len.Last_Used  := Data_Len.Last_Used + Count;
      end if;
   end Increment;





-- NO SE PUEDE USAR ESTA FUNCION PORQUE EN EL CASO DE QUE DATA_EMPY DIGA QUE ESTA VACÍO
-- EL INDICE A USAR DEBE SER EL PRIMERO DEL ARRAY (ARRAY'FIRST) NO EL PRIMERO DEL
-- TIPO ARRAY_INDEX_T
--   function Next_Index_To_Use (Buff_Len : Basic_Types_I.Data_32_Len_T)
--     return Basic_Types_I.Array_Index_T
--   is
--      use type Basic_Types_I.Array_Index_T;
--   begin
--      if Buff_Len.Data_Empty then
--         return Basic_Types_I.Array_Index_T'First;
--      else
--         return Buff_Len.Last_Used + 1;
 --     end if;
--   end Next_Index_To_Use;


   function Equal
     (Str1      : in Basic_Types_I.String_T;
      Str1_Len  : in Basic_Types_I.Data_32_Len_T;
      Str2      : in Basic_Types_I.String_T;
      Str2_Len  : in Basic_Types_I.Data_32_Len_T
--      Trim_Case : in Boolean    := False
      ) return Boolean
   is
      use type Basic_Types_I.Uint32_T;
      use type Basic_Types_I.String_T;

      Str1_F_C      : constant Basic_Types_I.Uint32_T              := Str1'First;
      Str2_F_C      : constant Basic_Types_I.Uint32_T              := Str2'First;

      Result        : Boolean                                      := False;
      Used_Len1     : Basic_Types_I.Uint32_T                       := 0;
      Used_Len2     : Basic_Types_I.Uint32_T                       := 0;
   begin

      if Str1_Len.Data_Empty and Str2_Len.Data_Empty then
         Result := True;
      elsif (not Str1_Len.Data_Empty) and (not Str2_Len.Data_Empty) then
         Used_Len1 := Str1_Len.Last_Used - Str1_F_C + 1;
         Used_Len2 := Str2_Len.Last_Used - Str2_F_C + 1;

         if Used_Len1 = Used_Len2 then
            Result := ( Str1 (Str1_F_C .. Str1_Len.Last_Used) =
              Str2 (Str2_F_C .. Str2_Len.Last_Used) );
         end if;
      end if;
      return Result;
   end Equal;


   function Equal
     (Literal  : in String;
      Str      : in Basic_Types_I.String_T;
      Str_Len  : in Basic_Types_I.Data_32_Len_T) return Boolean
   is
      use type Basic_Types_I.Uint32_T;

      Literal_Len_C   : constant Basic_Types_I.Uint32_T  :=
        Basic_Types_I.Uint32_T (Literal'Length);
      Literal_F_C     : constant Integer                 := Literal'First;
      Literal_L_C     : constant Integer                 := Literal'Last;

      Str_Literal     : Basic_Types_I.String_T (1 .. Literal_Len_C) :=
        Basic_Types_I.String_T (Literal (Literal_F_C .. Literal_L_C));
      Str_Literal_Len : Basic_Types_I.Data_32_Len_T                 :=
        Basic_Types_I.Data_32_Len_Empty_C;
   begin

      if Literal_Len_C > 0 then
         Str_Literal_Len.Data_Empty := False;
         Str_Literal_Len.Last_Used  := Basic_Types_I.Uint32_T (Literal_L_C) -
           Basic_Types_I.Uint32_T (Literal_F_C) + 1;
      end if;
      return Equal
        (Str1      => Str_Literal,
         Str1_Len  => Str_Literal_Len,
         Str2      => Str,
         Str2_Len  => Str_Len);

   end Equal;








   function Two_Bytes_To_Uint32
     (Bytes  : in Basic_Types_I.Byte_Array_T) return Basic_Types_I.Unsigned_32_T
   is
      use type Basic_Types_I.Unsigned_32_T;

      First_C     : constant Basic_Types_I.Unsigned_32_T  := Bytes'First;
      Last_C      : constant Basic_Types_I.Unsigned_32_T  := Bytes'Last;

      Array_4Bytes : Basic_Types_I.Array_4_Bytes_T       := (others => 0);
      Local_Uint32 : Basic_Types_I.Unsigned_32_T;
      for Local_Uint32'Address use Array_4Bytes'Address;
   begin

      if Last_C >= (First_C + 1) then
         Array_4Bytes (2) := Bytes (First_C);
         Array_4Bytes (1) := Bytes (First_C + 1);
      end if;
      return Local_Uint32;
   end Two_Bytes_To_Uint32;


   function Two_Bytes_To_U16 (Data : in Basic_Types_I.Uint8_Array_Nc_T) return
     Basic_Types_I.Uint16_T
   is
      use type Basic_Types_I.Uint32_T;

      Data_Local   : Basic_Types_I.Uint8_Array_Nc_T (1 .. 2) :=
        Data (Data'First .. Data'First + 1);
      Uint16_Local : Basic_Types_I.Uint16_T;
      for Uint16_Local'Address use Data_Local'Address;
   begin
      return Uint16_Local;
   end Two_Bytes_To_U16;








end Basic_Tools;

