
with Ada.Characters.Latin_1;
with Ada.Exceptions;
with Ada.Strings.Unbounded;
with Ada.Text_IO; --.Modular_IO;

--with Wdgt_Images.Bytes_Io.File_Type;

with Uif_Configs;

package body Wdgt_Images is


   type Images_To_Bool_T is array (Images_T'Range) of Boolean;



   Images_From_File_C   : Images_To_Bool_T         :=
     (Book_Open        => False,
      Book_Closed      => False,
      About_Dialog     => True,
      Arrows_Down_Mini => True,
      Cartoon_Dpm      => True,
      Cartoon_Icm      => True,
      Cartoon_Pcdm     => True,
      Cartoon_Smu      => True,
      Envelope_Mini    => True,
      Gmv_Mini         => True,
      Oeu              => True,
      Oeu_Icon         => True,
      Megaphone_Mini   => True,
      Connect_Mini     => True,
      Unconnect_Mini   => True
      );


   Debug_Proc      : Basic_Types_I.Debug_Proc_T    := null;


   package Uint8_Io is new Ada.Text_IO.Modular_IO (Basic_Types_I.Uint8_T);

-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   function Get_Quotes_B return String is
   begin
      return "";
--      return """";
   end Get_Quotes_B;
   function Get_Quotes_E return String is
   begin
      return "";
--      return """," & Ada.Characters.Latin_1.LF;
   end Get_Quotes_E;


   procedure Local_Debug
     (Str        : in String;
      Is_Error   : in Boolean := False)
   is
   begin

      if Is_Error then
         if not Basic_Types_I.Is_Null_Debug_Proc (Debug_Proc) then
            Debug_Proc ("[Wdgt_Images]" & Str);
         end if;
      end if;
   end Local_Debug;

   function Get_Local (Image   : Images_T) return
     Interfaces.C.Strings.Chars_Ptr_Array is separate;
   -- Returns the XPM buffer stored in the SW data


   function Read_Pixel_Matrix
     (File_Handler   : Bytes_Io.File_Type;
      Header         : Header_T) return Basic_Types_I.Byte_Array_2_T
   is
      N_Rows_C      : constant Basic_Types_I.Uint32_T     :=
        Basic_Types_I.Uint32_T (Header.Rows);
      N_Columns_C   : constant Basic_Types_I.Uint32_T     :=
        Basic_Types_I.Uint32_T (Header.Columns);

      Matrix     : Basic_Types_I.Byte_Array_2_T (1 .. N_Rows_C, 1 .. N_Columns_C) :=
        (others => (others => 0));
   begin

--      Local_Debug (".Read_Pixel_Matrix CodedPixelMatrix read begin");
--      Local_Debug ("N_Rows_C:" & Basic_Types_I.Uint32_T'Image (N_Rows_C));
--      Local_Debug ("N_Columns_C:" & Basic_Types_I.Uint32_T'Image (N_Columns_C));

      for I in 1 .. N_Rows_C loop
         for J in 1 .. N_Columns_C loop
            Bytes_Io.Read
              (File => File_Handler,
               Item => Matrix (I, J));

         end loop;
      end loop;
      Local_Debug (".Read_Pixel_Matrix CodedPixelMatrix read end");

      return Matrix;
   end Read_Pixel_Matrix;


   function Build_Name_Color
     (Color_Name : Basic_Types_I.Uint8_T;
      Color_Num  : Basic_Types_I.Uint8_T) return String
   -- Used to copy the name of the color when it is used instead of the RGB number
   is
      use type Basic_Types_I.Uint8_T;

      Result    : Basic_Types_I.String_30_T            := Name_Colors_C
        (Basic_Types_I.Array_Index_T (Color_Name));
      I_Str     : Natural                              := 0;
      Num_Str   : String (1 .. 4)                      := (others => ' ');
      I_Num_Str : Natural                              := 0;
   begin

-- Get in I_Str the end of the color name
      for I in Basic_Types_I.String_30_T'Range loop
         if Result (I) = ' ' then
            I_Str := I;
            exit;
         end if;
      end loop;


      if Color_Num /= Basic_Types_I.Uint8_T'Last then
         Uint8_Io.Put
            (To   => Num_Str,
             Item => Color_Num);

-- Copy in Result after the color name the digits of the number
         for I in Num_Str'Range loop
            if Num_Str (I) /= ' ' then
               Result (I_Str) := Num_Str (I);
               I_Str := I_Str + 1;
            end if;
         end loop;
      end if;

-- Locate the last used character to return the result without spaces
      for I in Basic_Types_I.String_30_T'Range loop
         if Result (I) = ' ' then
            I_Str := I;
            exit;
         end if;
      end loop;

      return String (Result (1 .. (I_Str - 1)));
   end Build_Name_Color;


   function Get_From_File (Image   : Images_T) return
     Interfaces.C.Strings.Chars_Ptr_Array
   is
      use type Basic_Types_I.Uint16_T;
      use type Basic_Types_I.Byte_Array_T;

      File_Handler    : Bytes_Io.File_Type;

      Header          : Header_T                    := Empty_Header_C;
      Header_Bytes    : Header_Bytes_T              := (others => 0);
      Colors          : Array_Color_Lines_T
        (Basic_Types_I.Uint8_T'Range)               :=
        (others => Wdgt_Images.Empty_Color_Line_C);
      Color_Bytes     : Color_Line_Bytes_T          := (others => 0);

   begin

      Local_Debug (".Get_From_File: " & Images_T'Image (Image));

-- Open the file with the coded image
      Bytes_Io.Open
        (File => File_Handler,
         Mode => Bytes_Io.In_File,
         Name => Ada.Strings.Unbounded.To_String (Uif_Configs.Dir_Images_C) &
           String (Img_To_Coded_File_C (Image)));

-- Read the header
      for I in Header_Bytes_T'Range loop
         Bytes_Io.Read
           (File => File_Handler,
            Item => Header_Bytes (I));
      end loop;
      Header := Bytes_To_Header (Header_Bytes);

-- Check that the header of the image is correct: Check const magic id and image id
      if (Header.Magic (1 .. 9) /= Empty_Header_C.Magic (1 .. 9)) or else
        (Header.Id /= Images_Id_C (Image)) then

         Local_Debug ("ERROR checking image header ", True);
--           Basic_Types_I.Uint8_T'Image (Header.Magic (1)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (2)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (3)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (4)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (5)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (6)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (7)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (8)) & " " &
--           Basic_Types_I.Uint8_T'Image (Header.Magic (9)) & " " &
--           Basic_Types_I.Uint16_T'Image (Header.Id) & " ");
         return Empty_Chars_Ptr_Array_C;
      end if;

      Local_Debug (".Get_From_File CodedHeader read ");

-- Read the list of colors
      for J in Basic_Types_I.Uint8_T'Range loop
         for I in Color_Line_Bytes_T'Range loop
            Bytes_Io.Read
              (File => File_Handler,
               Item => Color_Bytes (I));
         end loop;
         Colors (J) := Bytes_To_Color_Line (Color_Bytes);
         exit when (Basic_Types_I.Uint16_T (J) + 1) >= Header.Colors;
      end loop;
      Local_Debug (".Get_From_File CodedColors read ");

-- Read the pixel matrix
      declare
         use type Basic_Types_I.Uint8_T;
         use type Basic_Types_I.Uint32_T;
         use type Interfaces.C.Size_T;

         Result_Lines_C  : constant Interfaces.C.Size_T        :=
           (1 + Interfaces.C.Size_T (Header.Colors) +
            Interfaces.C.Size_T (Header.Rows));

         subtype Lines_Range_T is Interfaces.C.Size_T range 1 .. Result_Lines_C;

         Matrix_Img    : Basic_Types_I.Byte_Array_2_T          :=
           Read_Pixel_Matrix (File_Handler, Header);

         Result_Xpm     : Interfaces.C.Strings.Chars_Ptr_Array
           (Lines_Range_T'Range) := (others => Interfaces.C.Strings.Null_Ptr);

         N_Columns_Str  : String := Basic_Types_I.Uint16_T'Image (Header.Columns);
         N_Rows_Str     : String := Basic_Types_I.Uint16_T'Image (Header.Rows);
         N_Colors_Str   : String := Basic_Types_I.Uint16_T'Image (Header.Colors);
         N_C_Per_P_Str  : String := Basic_Types_I.Uint8_T'Image (Header.Chars_Per_Pixel);

         I             : Lines_Range_T                         := Lines_Range_T'First;
         Counter       : Basic_Types_I.Uint8_T                 := 0;
         Counter_16    : Basic_Types_I.Uint16_T                := 1;

         function Get_Color_Chars (Counter  : Basic_Types_I.Uint8_T) return String
         is
            Str_1     : String (1 .. 1)  := (others => Colors (Counter).Chars (1));
            Str_2     : String (1 .. 2)  := String (Colors (Counter).Chars (1 .. 2));
         begin
            if Header.Chars_Per_Pixel = 1 then
               return Str_1;
            else
               return Str_2;
            end if;
         end Get_Color_Chars;

         function Get_Color_Id (Counter   : Basic_Types_I.Uint8_T) return String
         is
            N1_Str  : String (1 .. 6) := (others => ' ');
            N2_Str  : String (1 .. 6) := (others => ' ');
            N3_Str  : String (1 .. 6) := (others => ' ');
            N4_Str  : String (1 .. 6) := (others => ' ');
            N5_Str  : String (1 .. 6) := (others => ' ');
            N6_Str  : String (1 .. 6) := (others => ' ');
         begin

 -- Convert the RGB codes to strings in hexadecimal. Inser a 0 to the left to assert
 -- the respresentation of each byte with two digits.   16#xy#  _16#x#
 --                                                     123456  123456
            Uint8_Io.Put
              (To   => N1_Str,
               Item => Colors (Counter).Color_Val (1),
               Base => 16);
--            Local_Debug ("N1_Str: " & N1_Str);
            if Colors (Counter).Color_Val (1) < 16 then
               N1_Str (4) := '0';
            end if;
            Uint8_Io.Put
              (To   => N2_Str,
               Item => Colors (Counter).Color_Val (2),
               Base => 16);
            if Colors (Counter).Color_Val (2) < 16 then
               N2_Str (4) := '0';
            end if;
            Uint8_Io.Put
              (To   => N3_Str,
               Item => Colors (Counter).Color_Val (3),
               Base => 16);
            if Colors (Counter).Color_Val (3) < 16 then
               N3_Str (4) := '0';
            end if;

            Uint8_Io.Put
              (To   => N4_Str,
               Item => Colors (Counter).Color_Val (4),
               Base => 16);
            if Colors (Counter).Color_Val (4) < 16 then
               N4_Str (4) := '0';
            end if;
            Uint8_Io.Put
              (To   => N5_Str,
               Item => Colors (Counter).Color_Val (5),
               Base => 16);
            if Colors (Counter).Color_Val (5) < 16 then
               N5_Str (4) := '0';
            end if;
            Uint8_Io.Put
              (To   => N6_Str,
               Item => Colors (Counter).Color_Val (6),
               Base => 16);
            if Colors (Counter).Color_Val (6) < 16 then
               N6_Str (4) := '0';
            end if;

            if Colors (Counter).Numeric_Color = 1 then
-- The color is codified with the RGB numbers of one byte (two characters) each
               return "#" & N1_Str (4 .. 5) & N2_Str (4 .. 5) & N3_Str (4 .. 5);

            elsif Colors (Counter).Numeric_Color = 2 then
-- The color is codified with the RGB numbers of two byte (four characters) each
               return "#" & N1_Str (4 .. 5) & N2_Str (4 .. 5) & N3_Str (4 .. 5) &
                 N4_Str (4 .. 5) & N5_Str (4 .. 5) & N6_Str (4 .. 5);

            else
-- The color is codified with a name of color an optional number. for ex: gray150
               return Build_Name_Color
                 (Colors (Counter).Color_Val (1), Colors (Counter).Color_Val (2));
            end if;
         end Get_Color_Id;

         function Get_Pixel_Line_Chars (Line_I : Basic_Types_I.Uint16_T) return String
         is
            Line_Limit_C   : constant Natural              :=
               Natural (Header.Columns) * Natural (Header.Chars_Per_Pixel);
            subtype Line_Range_T is Natural range 1 .. Line_Limit_C;

            Result         : String (1 .. Line_Limit_C)    := (others => ' ');
            I_Pixel_Result : Line_Range_T                  := Line_Range_T'First;
            I_Pixel_Line   : Basic_Types_I.Array_Index_T   := 1;
         begin

            loop
               Result (I_Pixel_Result) := Colors (Matrix_Img
                 (Basic_Types_I.Array_Index_T (Line_I), I_Pixel_Line)).Chars (1);

               exit when I_Pixel_Result >= Line_Range_T'Last;
               I_Pixel_Result := I_Pixel_Result + 1;

               if Header.Chars_Per_Pixel = 2 then
                  Result (I_Pixel_Result) := Colors (Matrix_Img
                    (Basic_Types_I.Array_Index_T (Line_I), I_Pixel_Line)).Chars (2);

                  exit when I_Pixel_Result >= Line_Range_T'Last;
                  I_Pixel_Result := I_Pixel_Result + 1;
               end if;
               I_Pixel_Line := I_Pixel_Line + 1;
            end loop;
            return Result;
         end Get_Pixel_Line_Chars;

      begin

         Local_Debug (".Get_From_File PixelMatrix read ");

--Xpm_Image (0) := Interfaces.C.Strings.New_String ("/*    */" &
--           Ada.Characters.Latin_1.LF);

-- Generate the XPM header and write at the first line of the output string
--          Xpm_Image
         Result_Xpm (I) := Interfaces.C.Strings.New_String (Get_Quotes_B &
           N_Columns_Str (2 .. N_Columns_Str'Length) &
           N_Rows_Str & N_Colors_Str & N_C_Per_P_Str & Get_Quotes_E);
         Local_Debug (".Get_From_File Clear header generated: " & Get_Quotes_B &
           N_Columns_Str (2 .. N_Columns_Str'Length) &
           N_Rows_Str & N_Colors_Str & N_C_Per_P_Str & Get_Quotes_E);

-- Generate the list of colors in XPM format
         I := I + 1;
         loop
--          Xpm_Image
            Result_Xpm (I) := Interfaces.C.Strings.New_String (Get_Quotes_B &
              Get_Color_Chars (Counter) & " c " & Get_Color_Id (Counter) & Get_Quotes_E);

            I := I + 1;
            exit when Counter = Basic_Types_I.Uint8_T'Last;
            Counter := Counter + 1;
            exit when Basic_Types_I.Uint16_T (Counter) >= Header.Colors;
         end loop;
         Local_Debug (".Get_From_File Clear colors generated ");

-- Generate the XPM pixel matrix
         loop
--          Xpm_Image
            Result_Xpm (I) := Interfaces.C.Strings.New_String (Get_Quotes_B &
              Get_Pixel_Line_Chars (Counter_16) & Get_Quotes_E);

            Counter_16 := Counter_16 + 1;
            exit when Counter_16 > Header.Rows;
            I := I + 1;
         end loop;
         Local_Debug (".Get_From_File Clear pixel matrix generated ");

         Bytes_Io.Close (File_Handler);
         return Result_Xpm; --Empty_Chars_Ptr_Array_C; --Xpm_Image (1 .. (I - 1)); --Empty_Chars_Ptr_Array_C; --Result;
      end;


--      return Empty_Chars_Ptr_Array_C;

   exception
      when Event : others =>
         Local_Debug (".Get_From_File Except: " &
               Ada.Exceptions.Exception_Information (Event), True);
         return Empty_Chars_Ptr_Array_C;
   end Get_From_File;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Init (Debug_Routine  : in Basic_Types_I.Debug_Proc_T)
   is
   begin
      Debug_Proc  := Debug_Routine;
   end Init;



   function Get_Image_Xpm (Image  : Images_T) return Gdk.Pixbuf.Gdk_Pixbuf
--     Interfaces.C.Strings.Chars_Ptr_Array
   is
      use type Gdk.Pixbuf.Gdk_Pixbuf;

      Pixbuf    : Gdk.Pixbuf.Gdk_Pixbuf            :=
        Gdk.Pixbuf.Null_Pixbuf;
   begin

      if Images_From_File_C (Image) then
         Pixbuf := Gdk.Pixbuf.Gdk_New_From_Xpm_Data (Get_From_File (Image));
      else
         Pixbuf := Gdk.Pixbuf.Gdk_New_From_Xpm_Data (Get_Local (Image));
      end if;

      if Pixbuf = Gdk.Pixbuf.Null_Pixbuf then
         Local_Debug (".Get_Image_Xpm ERROR generating image from file", True);
      end if;
      return Pixbuf;
   end Get_Image_Xpm;


   function Get_Image_Xpm (Image  : Images_T) return
     Interfaces.C.Strings.Chars_Ptr_Array
   is

      Pixbuf    : Gdk.Pixbuf.Gdk_Pixbuf            :=
        Gdk.Pixbuf.Null_Pixbuf;
   begin

      if Images_From_File_C (Image) then
         return Get_From_File (Image);
      else
         return Get_Local (Image);
      end if;

   end Get_Image_Xpm;



end Wdgt_Images;

