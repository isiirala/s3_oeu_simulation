
with Ada.Characters.Latin_1;
with Ada.Exceptions;
with GNAT.Calendar.Time_IO;



with Basic_Convert;
with Basic_Tools;
with Bc_Smu_Oeu;
with Byte_Meta_Buffer;
with Cuc_Decoder;
with Debug_Log;
with Pus;
with Pus_Format_I;
with Pus_Format_Types_I;
with Pus_Types_I;
with Smu_1553_Types;
with Smu_Params_Store;
with Uif_Configs;

package body Smu_1553_Log is


   package Pkg_Log_Buffer is new Byte_Meta_Buffer
     (Meta_Buffer_Len    => 2 ** 8,
      Data_Buffer_Len    => 2 ** 17,
      User_Meta_Byte_Len => Smu_Data.Log_Meta_Byte_Len_C,
      Bytes_For_Data_Len => Basic_Types_I.Two_Bytes,
      Use_Protection     => True);


   Uif_Log_Buffer       : Pkg_Log_Buffer.Buffer_T;
   -- Buffer to hold the log traces of the messages sent through the 1553 bus

   Uif_Log_Buffer_Built : Boolean := False;
   -- Boolean to say if the Buffer to hold the 1553 log traces are built

   Uif_Log_Buffer_Error : Boolean := False;
   -- Boolean to say if the Buffer to hold the 1553 log traces is in error (may be full)

   Smu_Log_Meta_Decoded : Pkg_Log_Buffer.Meta_Raw_T  := Pkg_Log_Buffer.Null_Meta_Raw_C;
   Smu_Log_Meta_Info    : Pkg_Log_Buffer.Meta_Raw_T  := Pkg_Log_Buffer.Null_Meta_Raw_C;
   Smu_Log_Meta_Summary : Pkg_Log_Buffer.Meta_Raw_T  := Pkg_Log_Buffer.Null_Meta_Raw_C;
   Smu_Log_Meta_Raw     : Pkg_Log_Buffer.Meta_Raw_T  := Pkg_Log_Buffer.Null_Meta_Raw_C;
   -- Different types of metadata i.e. different types of text blocks to insert in the
   -- 1553 log buffer

   First_Log_Trace      : Boolean                    := False;
   -- To write in the log a carro return always except in the first log trace

--   Tm_Data_Decoded      : Basic_Types_I.String_T
--     (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C)    := (others => ' ');
--   Tm_Data_Deco_Len     : Basic_Types_I.Data_32_Len_T :=
--     Basic_Types_I.Data_32_Len_Empty_C;

   Tc_Params_Decoding     : Test_Params_I.Array_Params_T
     (1 .. Basic_Types_1553.Max_Tc_Tm_Params_C);
--   := (others => Basic_Types_1553.Param_Empty_C);
   -- Parameters of the current TC decoding. NOT USED

   Tc_Params_Decoding_Len : Basic_Types_I.Data_32_Len_T :=
     Basic_Types_I.Data_32_Len_Empty_C;
   -- Used length of array Tc_Params_Decoding

   Tm_Params_Decoding     : Test_Params_I.Array_Params_T
     (1 .. Basic_Types_1553.Max_Tc_Tm_Params_C);
--   := (others => Basic_Types_1553.Param_Empty_C);
   -- Parameters of the current TM decoding

   Tm_Params_Decoding_Len : Basic_Types_I.Data_32_Len_T :=
     Basic_Types_I.Data_32_Len_Empty_C;
   -- Used length of the array Tm_Params_Decoding


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================


   function Log_Meta_To_Raw (Meta : in Smu_Data.Log_Metadata_T)
     return Pkg_Log_Buffer.Meta_Raw_T
   is
      Local_Meta : Smu_Data.Log_Metadata_T   := Meta;
      Local_Raw  : Pkg_Log_Buffer.Meta_Raw_T;
      for Local_Raw'Address use Local_Meta'Address;
   begin
      return Local_Raw;
   end Log_Meta_To_Raw;

   function Raw_To_Log_Meta (Raw_Meta : in Pkg_Log_Buffer.Meta_Raw_T)
     return Smu_Data.Log_Metadata_T
   is
      Local_Raw  : Pkg_Log_Buffer.Meta_Raw_T         := Raw_Meta;
      Local_Meta : Smu_Data.Log_Metadata_T;
      for Local_Meta'Address use Local_Raw'Address;
   begin
      return Local_Meta;
   end Raw_To_Log_Meta;



   procedure Log_Buff_Append
     (Meta_Raw : in Pkg_Log_Buffer.Meta_Raw_T;
      Data_Str : in Basic_Types_I.String_T;
      Data_Len : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Pkg_Log_Buffer.Buffer_Result_T;
      use type Basic_Types_I.Uint32_T;

      Buffer_Result        : Pkg_Log_Buffer.Buffer_Result_T :=
        Pkg_Log_Buffer.Buffer_Result_T'First;
   begin

-- Does not insert in the log buffer if it is not initialised or there was an error
-- with it, the error flag is cleared when read data from buffer, because the most
-- probable error is Buffer-Full
      if (not Uif_Log_Buffer_Error) and then Uif_Log_Buffer_Built then

-- Insert the log string in the Log Buffer with the provided Tag
         Pkg_Log_Buffer.Insert
           (Buffer   => Uif_Log_Buffer,
            Meta_Raw => Meta_Raw,
            Data_Raw => Basic_Convert.Str_To_Byte_Array
              (Data_Str (Data_Str'First .. Data_Len.Last_Used)),
            Result   => Buffer_Result);

         if Buffer_Result /= Pkg_Log_Buffer.Result_Ok then

            Debug_Log.Do_Log ("SMU_1553_Log.Log_Buff_Append. " &
              "Error inserting in 1553 Log Buffer. " & String (
              Pkg_Log_Buffer.Buffer_Result_To_Str_C (Buffer_Result)
              ));

            Uif_Log_Buffer_Error := True;
         end if;
      end if;

-- Reset length to write another string
      Data_Len := Basic_Types_I.Data_32_Len_Empty_C;

   end Log_Buff_Append;


   procedure Log_Tm_Block_Prologue
     (Tm_Block_Info   : in Smu_1553_Types.Tm_Block_Info_T)
   is
      Info_Str_C      : constant Basic_Types_I.String_T (1 .. 6)  :=
        ('I','N','F','O', Ada.Characters.Latin_1.Ht, Ada.Characters.Latin_1.Ht);

      Prolog_Str   : Basic_Types_I.String_T (1 .. 500)          := (others => ' ');
      Prolog_Len   : Basic_Types_I.Data_32_Len_T                :=
        Basic_Types_I.Data_32_Len_Empty_C;

   begin

      if First_Log_Trace then
         First_Log_Trace := False;
      else
         Basic_Tools.Append_Nl
           (Annex     => " ",
            Buff_Data => Prolog_Str,
            Buff_Len  => Prolog_Len);
      end if;

      Basic_Tools.Append
        (Annex     => Info_Str_C,
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

      Basic_Tools.Append
        (Annex     => Basic_Types_I.String_T (GNAT.Calendar.Time_IO.Image
           (Date    => Tm_Block_Info.Time_Tag,
            Picture => "(%j)%T.%e")),
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

      Basic_Tools.Append_Str
        (Annex     => ": TM_BLOCK:",
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

-- Insert the log string in the Log Buffer with the Tag INFO
      Log_Buff_Append
        (Meta_Raw => Smu_Log_Meta_Info,
         Data_Str => Prolog_Str,
         Data_Len => Prolog_Len);

   end Log_Tm_Block_Prologue;


   procedure Log_Tm_Prologue
     (Tm_Data_Field_Header : in Pus.Data_Field_Header_T)
   is
      Tm_Pus_Str_C    : constant Basic_Types_I.String_T (1 .. 8)   :=
        (Ada.Characters.Latin_1.Ht, 'T', 'M', '_', 'P', 'U', 'S', '(');
      Tm_Pus_End_Str_C : constant Basic_Types_I.String_T (1 .. 4)  :=
        (')', ':', ' ', ' ');

      Prolog_Str   : Basic_Types_I.String_T (1 .. 100)          := (others => ' ');
      Prolog_Len   : Basic_Types_I.Data_32_Len_T                :=
        Basic_Types_I.Data_32_Len_Empty_C;

   begin

-- The log of each TM must start with a NL to be written in a new line
      Basic_Tools.Append_Nl
        (Annex     => " ",
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

      Basic_Tools.Append
        (Annex     => Tm_Pus_Str_C,
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);
      Basic_Tools.Append
        (Num       => Basic_Types_I.Uint32_T
           (Tm_Data_Field_Header.Service_Type),
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);
      Basic_Tools.Append_Str
        (Annex     => ",",
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);
      Basic_Tools.Append
        (Num       => Basic_Types_I.Uint32_T
          (Tm_Data_Field_Header.Service_Subtype),
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);
      Basic_Tools.Append
        (Annex     => Tm_Pus_End_Str_C,
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

--      Debug_Log.Do_Log(" SMU 1553 log: " & String (Prologue_Str (1 .. Prologue_I)));

-- Insert the log string in the Log Buffer with the Tag Summary
      Log_Buff_Append
        (Meta_Raw => Smu_Log_Meta_Summary,
         Data_Str => Prolog_Str,
         Data_Len => Prolog_Len);
   end Log_Tm_Prologue;

   procedure Log_Tc_Date_Prologue
     (Tc_Metadata  : in Smu_Data.Tc_Buffer_Metadata_T)
   is
      Info_Str_C      : constant Basic_Types_I.String_T (1 .. 6)  :=
        ('I','N','F','O', Ada.Characters.Latin_1.Ht, Ada.Characters.Latin_1.Ht);

      Prolog_Str   : Basic_Types_I.String_T (1 .. 300)          := (others => ' ');
      Prolog_Len   : Basic_Types_I.Data_32_Len_T                :=
        Basic_Types_I.Data_32_Len_Empty_C;

   begin

      if First_Log_Trace then
         First_Log_Trace := False;
      else
         Basic_Tools.Append_Nl
           (Annex    => " ",
            Buff_Data => Prolog_Str,
            Buff_Len  => Prolog_Len);
      end if;

      Basic_Tools.Append
        (Annex     => Info_Str_C,
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

      Basic_Tools.Append
        (Annex    => Basic_Types_I.String_T (GNAT.Calendar.Time_IO.Image
           (Date    => Tc_Metadata.Time_Tag,
            Picture => "(%j)%T.%e: ")),
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

--      Debug_Log.Do_Log(" Log_Tc_Prologue: " & String (Prologue_Str (1 .. Prologue_I)));

-- Insert the log string in the Log Buffer with the Tag INFO
      Log_Buff_Append
        (Meta_Raw => Smu_Log_Meta_Info,
         Data_Str => Prolog_Str,
         Data_Len => Prolog_Len);

   end Log_Tc_Date_Prologue;


   procedure Log_Tc_Pus_Prologue
     (Tc_Metadata  : in Smu_Data.Tc_Buffer_Metadata_T;
      Tc_Info      : in Pus_Types_I.Tc_Info_T;
      Tc_Format_Ok : in Boolean)
   is
      Prolog_Str   : Basic_Types_I.String_T (1 .. 500)          := (others => ' ');
      Prolog_Len   : Basic_Types_I.Data_32_Len_T                :=
        Basic_Types_I.Data_32_Len_Empty_C;
   begin

      Log_Tc_Date_Prologue
        (Tc_Metadata  => Tc_Metadata);

      Basic_Tools.Append_Str
        (Annex     => "TC_PUS:(",
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);
--      Debug_Log.Do_Log(" Log_Tc_Prologue: " & String (Prologue_Str (1 .. Prologue_I)));

      if Tc_Format_Ok then
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Tc_Info.Service_Type),
            Buff_Data => Prolog_Str,
            Buff_Len  => Prolog_Len);
--      Debug_Log.Do_Log(" Log_Tc_Prologue: " & String (Prologue_Str (1 .. Prologue_I)));
         Basic_Tools.Append_Str
           (Annex     => ",",
            Buff_Data => Prolog_Str,
            Buff_Len  => Prolog_Len);
--      Debug_Log.Do_Log(" Log_Tc_Prologue: " & String (Prologue_Str (1 .. Prologue_I)));
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Tc_Info.Service_Subtype),
            Buff_Data => Prolog_Str,
            Buff_Len  => Prolog_Len);
      end if;

--      Debug_Log.Do_Log(" Log_Tc_Prologue: " & String (Prologue_Str (1 .. Prologue_I)));
      Basic_Tools.Append_Str
        (Annex     => "):  ",
         Buff_Data => Prolog_Str,
         Buff_Len  => Prolog_Len);

--      Debug_Log.Do_Log(" Log_Tc_Prologue: " & String (Prologue_Str (1 .. Prologue_I)));

-- Insert the log string in the Log Buffer with the Tag Summary
      Log_Buff_Append
        (Meta_Raw => Smu_Log_Meta_Summary,
         Data_Str => Prolog_Str,
         Data_Len => Prolog_Len);
   end Log_Tc_Pus_Prologue;



   procedure Log_Time_Broadcast
     (Tc_Metadata  : in Smu_Data.Tc_Buffer_Metadata_T;
      Tc_Block     : in Basic_Types_I.Byte_Array_T;
      Fit          : out Boolean)
   is
      use type Basic_Types_I.Cuc_Time_T;
      use type Basic_Types_I.Uint16_T;

      Info_Str_C      : constant Basic_Types_I.String_T (1 .. 21)  :=
        ('C','U','C','_','T','i','m','e',':',' ','P','P','S','_','t','i','m','e',' ',
         '=',' ');
      Sep_1_Str_C     : constant Basic_Types_I.String_T (1 .. 1)  := (others => '/');
      Sep_2_Str_C     : constant Basic_Types_I.String_T (1 .. 1)  := (others => ' ');
      Sep_3_Str_C     : constant Basic_Types_I.String_T (1 .. 1)  := (others => ':');
      Sep_4_Str_C     : constant Basic_Types_I.String_T (1 .. 1)  :=
        (others => Ada.Characters.Latin_1.HT);
      Zero_Str_C      : constant Basic_Types_I.String_T (1 .. 1)  := (others => '0');

      Broadcast_Time  : Basic_Types_I.Cuc_Time_T                  :=
        Basic_Types_I.Null_Cuc_Time_C;
      Raw_Block_Str   : Basic_Types_I.String_T (1 .. 200)         := (others => ' ');
      Raw_Block_Len   : Basic_Types_I.Data_32_Len_T               :=
        Basic_Types_I.Data_32_Len_Empty_C;
      Cuc_Decoded     : array (1 .. 7) of Basic_Types_I.Uint16_T  := (others => 0);
      Micr_Seconds    : Basic_Types_I.Uint32_T  := 0;
   begin

      Fit := False;

      Log_Tc_Date_Prologue (Tc_Metadata);

      Pus_Format_I.Get_Time_Broadcast_From_Raw
        (Tc_Block       => Tc_Block,
         Time_Val       => Broadcast_Time);

      if Broadcast_Time /= Basic_Types_I.Null_Cuc_Time_C then
         Fit := True;

         Basic_Tools.Append
           (Annex     => Info_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);

         Cuc_Decoder.Decode_Cuc
           (Cuc_Time  => Broadcast_Time,
            Year      => Cuc_Decoded (1),
            Month     => Cuc_Decoded (2),
            Day       => Cuc_Decoded (3),
            Day_Year  => Cuc_Decoded (4),
            Hour      => Cuc_Decoded (5),
            Min       => Cuc_Decoded (6),
            Secs      => Cuc_Decoded (7),
            Micr_Secs => Micr_Seconds);

-- Append Year
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Cuc_Decoded (1)),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
         Basic_Tools.Append
           (Annex     => Sep_1_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
-- Append Month
         if Cuc_Decoded (2) < 10 then
            Basic_Tools.Append
              (Annex     => Zero_Str_C,
               Buff_Data => Raw_Block_Str,
               Buff_Len  => Raw_Block_Len);
         end if;
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Cuc_Decoded (2)),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
         Basic_Tools.Append
           (Annex     => Sep_1_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
-- Append Day
         if Cuc_Decoded (3) < 10 then
            Basic_Tools.Append
              (Annex     => Zero_Str_C,
               Buff_Data => Raw_Block_Str,
               Buff_Len  => Raw_Block_Len);
         end if;
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Cuc_Decoded (3)),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
         Basic_Tools.Append
           (Annex     => Sep_2_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
-- Append Hour
         if Cuc_Decoded (5) < 10 then
            Basic_Tools.Append
              (Annex     => Zero_Str_C,
               Buff_Data => Raw_Block_Str,
               Buff_Len  => Raw_Block_Len);
         end if;
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Cuc_Decoded (5)),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
         Basic_Tools.Append
           (Annex     => Sep_3_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
-- Append Minutes
         if Cuc_Decoded (6) < 10 then
            Basic_Tools.Append
              (Annex     => Zero_Str_C,
               Buff_Data => Raw_Block_Str,
               Buff_Len  => Raw_Block_Len);
         end if;
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Cuc_Decoded (6)),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
         Basic_Tools.Append
           (Annex     => Sep_3_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
-- Append Seconds
         if Cuc_Decoded (7) < 10 then
            Basic_Tools.Append
              (Annex     => Zero_Str_C,
               Buff_Data => Raw_Block_Str,
               Buff_Len  => Raw_Block_Len);
         end if;
         Basic_Tools.Append
           (Num       => Basic_Types_I.Uint32_T (Cuc_Decoded (7)),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);

         Basic_Tools.Append
           (Annex     => Sep_4_Str_C,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
         Basic_Tools.Append
           (Num       => Micr_Seconds,
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);


-- Insert the Broadcast time decoded in the Log Buffer with the Tag Summary
         Log_Buff_Append
           (Meta_Raw => Smu_Log_Meta_Summary,
            Data_Str => Raw_Block_Str,
            Data_Len => Raw_Block_Len);

      else
         Debug_Log.Do_Log ("SMU_1553_Log.Log_Time_Broadcast Invalid CUC time");
      end if;
   end Log_Time_Broadcast;


   procedure Log_Tc_Raw
     (Tc_Raw        : in Basic_Types_I.Byte_Array_T;
      Verify_Result : in Pus_Format_Types_I.Tc_Verify_Status_T)
   is
      use type Pus_Format_Types_I.Tc_Verify_Status_T;
      use type Basic_Types_I.String_T;

      Raw_Block_Str   : Basic_Types_I.String_T
        (1 .. Smu_Data.Max_Log_Str_C)                     := (others => ' ');
      Raw_Block_Len   : Basic_Types_I.Data_32_Len_T       :=
        Basic_Types_I.Data_32_Len_Empty_C;
   begin

-- Write raw bytes of the TC in hexadecimal
      for I in Tc_Raw'Range loop
         Basic_Tools.Append_Base_16
           (Num       => Tc_Raw (I),
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
      end loop;

-- If the TC has wrong checksum write this information
      if Verify_Result /= Pus_Format_Types_I.Tc_Verify_Success then
         Basic_Tools.Append
           (Annex     => " (" & Basic_Types_I.String_T (
             Pus_Format_Types_I.Tc_Verify_Status_T'Image (Verify_Result)) & ")",
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
      else
         Basic_Tools.Append_Str
           (Annex     => " ",
            Buff_Data => Raw_Block_Str,
            Buff_Len  => Raw_Block_Len);
      end if;

-- Insert the raw TC bytes string in the Log Buffer with the Tag Raw
      Log_Buff_Append
        (Meta_Raw => Smu_Log_Meta_Raw,
         Data_Str => Raw_Block_Str,
         Data_Len => Raw_Block_Len);
   end Log_Tc_Raw;

   procedure Log_Tc_Decoded
     (Tc_Info         : in Pus_Types_I.Tc_Info_T;
      Packet_Header   : in Pus.Packet_Header_T;
      Tc_Df_Header    : in Pus_Format_Types_I.Tc_Df_Header_T;
      Tc_Df_Raw       : in Basic_Types_I.Byte_Array_T)
   is

      Deco_Block_Str   : Basic_Types_I.String_T
        (1 .. Smu_Data.Max_Log_Str_C)                     := (others => ' ');
      Deco_Block_Len   : Basic_Types_I.Data_32_Len_T      :=
        Basic_Types_I.Data_32_Len_Empty_C;

      Tc_Decoded       : Basic_Types_1553.Tc_Tm_Id_T      := Basic_Types_1553.Tc_Tm_None;
      Info_To_Show     : Pus_Format_Types_I.Log_Info_T    :=
        Pus_Format_Types_I.Log_Minimum;
   begin

      if Uif_Configs.Smu_1553_Decode_Tcs then

         Tc_Params_Decoding_Len := Basic_Types_I.Data_32_Len_Empty_C;

         if Uif_Configs.Smu_1553_Decode_Tcs_Full then
            Info_To_Show := Pus_Format_Types_I.Log_Complete;
         end if;

-- Decode the TC
         Pus_Format_I.Decode_Tc
           (Packet_Header  => Packet_Header,
            Tc_Df_Header   => Tc_Df_Header,
            Tc_Info        => Tc_Info,
            Tc_Df          => Tc_Df_Raw,
            Log_Type       => Info_To_Show,
            Block_Str      => Deco_Block_Str,
            Block_Len      => Deco_Block_Len,
            Params         => Tc_Params_Decoding,
            Params_Len     => Tc_Params_Decoding_Len,
            Tc_Id          => Tc_Decoded);

-- Insert the string TC decoded in the string Log Buffer with the Tag Decoded
         Log_Buff_Append
           (Meta_Raw => Smu_Log_Meta_Decoded,
            Data_Str => Deco_Block_Str,
            Data_Len => Deco_Block_Len);
      end if;
   end Log_Tc_Decoded;





-- ======================================================================================
-- %% Provided operations
-- ======================================================================================



   procedure Init is
      Log_Meta  : Smu_Data.Log_Metadata_T :=
        (others => Smu_Data.Log_Tag_T'First);
   begin


      Pkg_Log_Buffer.New_Buffer (Uif_Log_Buffer);
      Uif_Log_Buffer_Built := True;

      Log_Meta.Tag         := Smu_Data.Tag_Decoded;
      Smu_Log_Meta_Decoded := Log_Meta_To_Raw (Log_Meta);
      Log_Meta.Tag         := Smu_Data.Tag_Info;
      Smu_Log_Meta_Info    := Log_Meta_To_Raw (Log_Meta);
      Log_Meta.Tag         := Smu_Data.Tag_Summary;
      Smu_Log_Meta_Summary := Log_Meta_To_Raw (Log_Meta);
      Log_Meta.Tag         := Smu_Data.Tag_Raw;
      Smu_Log_Meta_Raw     := Log_Meta_To_Raw (Log_Meta);



-- Initialise the CUC_Decoder package to convert CUC time value of broadcast time
-- message into human friendly format
      Cuc_Decoder.Init (Debug_Log.Do_Log'Access);

--   exception
--         when Init_Error     =>
--            raise;
--         when Excep : others =>
--            raise Init_Error with "Except received: " &
--              Ada.Exceptions.Exception_Name (Excep) & ". msg: " &
--              Ada.Exceptions.Exception_Message (Excep);

   end Init;




   procedure Decode_Tms
     (Max_Tm_Block  : in Basic_Types_I.Unsigned_32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
      use type Pus_Format_Types_I.Extract_Tm_Result_T;

      Tm_Block_Count  : Basic_Types_I.Uint32_T              := 0;
      Buff_Empty      : Boolean                             := False;
      Tm_Block        : Smu_1553_Types.Tm_Block_Container_T :=
        Smu_1553_Types.Null_Tm_Block_Container_C;
      Last_Index      : Basic_Types_I.Uint32_T              := 0;
      Tm_Block_Info   : Smu_1553_Types.Tm_Block_Info_T      :=
        Smu_1553_Types.Null_Tm_Block_Info_C;
      Raw_Block_Str   : Basic_Types_I.String_T
        (1 .. Smu_Data.Max_Log_Str_C)                       := (others => ' ');
      Raw_Block_Len   : Basic_Types_I.Data_32_Len_T         :=
        Basic_Types_I.Data_32_Len_Empty_C;
      Byte_Str        : Basic_Types_I.String_T (1 .. 3)     := (others => ' ');

      Tm_Packet_Header     : Pus.Packet_Header_T            :=
        Pus.Null_Packet_Header_C;
      Tm_Data_Field_Header : Pus.Data_Field_Header_T        :=
        Pus.Null_Data_Field_Header_C;
      Tm_Extract_Result    : Pus_Format_Types_I.Extract_Tm_Result_T  :=
        Pus_Format_Types_I.Extract_Tm_Result_T'First;

      Tm_Begin_Index       : Basic_Types_I.Uint32_T      := Tm_Block'First;
      Tm_End_Index         : Basic_Types_I.Uint32_T      := 0;
      Tm_Df_Begin          : Basic_Types_I.Uint32_T      := 0;
      Tm_Df_End            : Basic_Types_I.Uint32_T      := 0;

      Tm_Decoding_Id       : Basic_Types_1553.Tc_Tm_Id_T := Basic_Types_1553.Tc_Tm_None;

      Info_To_Show         : Pus_Format_Types_I.Log_Info_T  :=
        Pus_Format_Types_I.Log_Minimum;

   begin

      if Uif_Configs.Smu_1553_Decode_Tms_Full then
         Info_To_Show := Pus_Format_Types_I.Log_Complete;
      end if;

      loop

         Bc_Smu_Oeu.Get_A_Tm_Block
           (Tm_Block_Data  => Tm_Block,
            Last_Index     => Last_Index,
            Tm_Block_Info  => Tm_Block_Info);

         if Last_Index > 0 then

--            Debug_Log.Do_Log("SMU_1553_Log Decode_TMs TM received last_index:" &
--              Basic_Types_I.Uint32_T'Image (Last_Index));
--            for I in 1 .. Last_Index loop
--               Debug_Log.Do_Log (Basic_Types_I.Unsigned_8_T'Image (Tm_Block (I)) & " ");
--            end loop;

-- Insert in the 1553 log the prologue of TM block: "INFO      <time tag> TM_Block:"
            Log_Tm_Block_Prologue (Tm_Block_Info);

            Tm_Begin_Index  := Tm_Block'First;
            while Tm_Begin_Index < Last_Index loop

               Pus_Format_I.Next_Tm_From_Block
                 (Tm_Block          => Tm_Block (Tm_Begin_Index .. Last_Index),
                  Extract_Result    => Tm_Extract_Result,
                  Packet_Header     => Tm_Packet_Header,
                  Data_Field_Header => Tm_Data_Field_Header,
                  Df_Begin          => Tm_Df_Begin,
                  Df_End            => Tm_Df_End,
                  Tm_End            => Tm_End_Index);

               if Tm_Extract_Result /= Pus_Format_Types_I.Extract_Error then

-- Insert in the 1553 log the prologue of current TM: "TM_PUS(X,Y):"
                  Log_Tm_Prologue (Tm_Data_Field_Header);

-- Write raw bytes of the TM in hexadecimal
                  for I in Tm_Begin_Index .. Tm_End_Index loop
                     Basic_Tools.Append_Base_16
                       (Num       => Tm_Block (I),
                        Buff_Data => Raw_Block_Str,
                        Buff_Len  => Raw_Block_Len);
                  end loop;

-- If the TM has wrong checksum write this information
                  if Tm_Extract_Result = Pus_Format_Types_I.Extract_Ok_Bad_Cksum then
                     Basic_Tools.Append
                       (Annex     => " (checksum error)",
                        Buff_Data => Raw_Block_Str,
                        Buff_Len  => Raw_Block_Len);
                  end if;

--                  Uif_Log_Buffer.Write (String (Raw_Block_Str (1 .. Raw_Block_I)));

-- Insert the raw TM bytes string in the Log Buffer with the Tag Raw
                  Log_Buff_Append
                    (Meta_Raw => Smu_Log_Meta_Raw,
                     Data_Str => Raw_Block_Str,
                     Data_Len => Raw_Block_Len);

-- Reset the string raw block before insert the TM decoded
                  Raw_Block_Len          := Basic_Types_I.Data_32_Len_Empty_C;
                  Tm_Params_Decoding_Len := Basic_Types_I.Data_32_Len_Empty_C;

-- Decode the TM
                  Pus_Format_I.Decode_Tm
                    (Packet_Header     => Tm_Packet_Header,
                     Data_Field_Header => Tm_Data_Field_Header,
                     Tm_Df             => Tm_Block (Tm_Df_Begin .. Tm_Df_End),
                     Log_Type          => Info_To_Show,
                     Block_Str         => Raw_Block_Str,
                     Block_Len         => Raw_Block_Len,
                     Params            => Tm_Params_Decoding,
                     Params_Len        => Tm_Params_Decoding_Len,
                     Tm_Id             => Tm_Decoding_Id);

--                  Test_Params_I.Debug
--                    (Params => Tm_Params_Decoding
--                       (1 .. Tm_Params_Decoding_Len.Last_Used),
--                     Info   => "Smu_1553_Log.Decode_Tms Tm_Decoding");

                  if Uif_Configs.Smu_1553_Decode_Tms then

-- Insert the TM decoded in the Log Buffer with the Tag Decoded
                     Log_Buff_Append
                       (Meta_Raw => Smu_Log_Meta_Decoded,
                        Data_Str => Raw_Block_Str,
                        Data_Len => Raw_Block_Len);
                  end if;

-- Store the TM parameters of the decoded TM into the buffer
                  Smu_Params_Store.Store
                    (Tc_Tm_Id   => Tm_Decoding_Id,
                     Params     => Tm_Params_Decoding
                       (1 .. Tm_Params_Decoding_Len.Last_Used),
                     Params_Len => Tm_Params_Decoding_Len);

               else
--                  Uif_Log_Buffer.Write (" (error extracting TM from TM Block) ");
                  Raw_Block_Len := Basic_Types_I.Data_32_Len_Empty_C;
                  Basic_Tools.Append
                    (Annex     => " (error extracting TM from TM Block) ",
                     Buff_Data => Raw_Block_Str,
                     Buff_Len  => Raw_Block_Len);
                  Log_Buff_Append
                    (Meta_Raw => Smu_Log_Meta_Info,
                     Data_Str => Raw_Block_Str,
                     Data_Len => Raw_Block_Len);

-- Discard current TM block
                  Tm_Begin_Index   := Tm_Block'First;
                  Last_Index       := Tm_Block'First;

               end if;

               Tm_Block_Count := Tm_Block_Count + 1;
               Tm_Begin_Index := Tm_End_Index + 1;
            end loop;
         else
            Buff_Empty := True;
         end if;
         exit when Buff_Empty or (Tm_Block_Count >= Max_Tm_Block);
     end loop;

   exception
      when Event : others =>
         Debug_Log.Do_Log("[smu_1553_Log Decode_Tms] Except: " &
           Ada.Exceptions.Exception_Information (Event));

   end Decode_Tms;


   procedure Decode_Tc
     (Tc_Buffer       : in Smu_Data.Tc_Buffer_Data_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
      use type Pus_Format_Types_I.Tc_Verify_Status_T;

      Tc_Info              : Pus_Types_I.Tc_Info_T   :=
        Pus_Format_Types_I.Empy_Tc_Info_C;
      Packet_Header        : Pus.Packet_Header_T     :=
        Pus.Null_Packet_Header_C;
      Tc_Df_Header         : Pus_Format_Types_I.Tc_Df_Header_T :=
        Pus_Format_Types_I.Null_Tc_Df_Header_C;

      Tc_Begin_Index       : Basic_Types_I.Uint32_T  := Tc_Buffer.Tc_Block'First;
      Tc_Df_Begin          : Basic_Types_I.Uint32_T  := 0;
      Tc_Df_End            : Basic_Types_I.Uint32_T  := 0;
      Tc_End_Index         : Basic_Types_I.Uint32_T  := 0;
      Verify_Result        : Pus_Format_Types_I.Tc_Verify_Status_T :=
        Pus_Format_Types_I.Tc_Verify_Status_T'First;
      Is_Time_Broadcast    : Boolean                 := False;
   begin

      if Tc_Buffer.Last_Index > 0 then

         Pus_Format_I.Get_Tc_Info_From_Raw
           (Tc_Block       => Tc_Buffer.Tc_Block (1 .. Tc_Buffer.Last_Index),
            Tc_Info        => Tc_Info,
            Packet_Header  => Packet_Header,
            Tc_Df_Header   => Tc_Df_Header,
            Df_Begin       => Tc_Df_Begin,
            Df_End         => Tc_Df_End,
            Tc_End         => Tc_End_Index,
            Verify_Result  => Verify_Result);

--         Debug_Log.Do_Log ("SMU_1553_Log.Decode_Tc VerifyResult:" &
--           Pus_Format_Types_I.Tc_Verify_Status_T'Image (Verify_Result));

         if Verify_Result = Pus_Format_Types_I.Tc_Verify_Ko_Size then

            Log_Time_Broadcast
              (Tc_Metadata    => Tc_Buffer.Metadata,
               Tc_Block       => Tc_Buffer.Tc_Block (1 .. Tc_Buffer.Last_Index),
               Fit            => Is_Time_Broadcast);
         end if;

         if not Is_Time_Broadcast then

-- Insert in the 1553 log the prologue of TC: "INFO    time-tag: TC_PUS:(X,Y)"
            Log_Tc_Pus_Prologue
              (Tc_Metadata  => Tc_Buffer.Metadata,
               Tc_Info      => Tc_Info,
               Tc_Format_Ok => (Verify_Result = Pus_Format_Types_I.Tc_Verify_Success));

-- Insert in the 1553 log the raw TC: bytes in hexadecimal
            Log_Tc_Raw
              (Tc_Raw        => Tc_Buffer.Tc_Block (1 .. Tc_Buffer.Last_Index),
               Verify_Result => Verify_Result);

            if Verify_Result = Pus_Format_Types_I.Tc_Verify_Success then

-- Insert in the 1553 log the TC decoded
               Log_Tc_Decoded
                 (Tc_Info       => Tc_Info,
                  Packet_Header => Packet_Header,
                  Tc_Df_Header  => Tc_Df_Header,
                  Tc_Df_Raw     => Tc_Buffer.Tc_Block (Tc_Df_Begin .. Tc_Df_End));
            end if;
         end if;
      else
         Debug_Log.Do_Log ("SMU_1553_Log.Decode_Tc Error: Skip decode empty TC ");
      end if;
   end Decode_Tc;


   procedure Read_Tm_Params
     (Tm_Id         : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T)
   is

   begin

      Smu_Params_Store.Retrieve
        (Tc_Tm_Id    => Tm_Id,
         Params      => Tm_Params,
         Params_Len  => Tm_Params_Len);

   end Read_Tm_Params;



   procedure Read_Uif_Log
     (Log_Data  : in out Smu_Data.Log_Data_T)
   is
      use type Basic_Types_I.Uint32_T;
      use type Pkg_Log_Buffer.Buffer_Result_T;

      Metadata_Raw     : Pkg_Log_Buffer.Meta_Raw_T      :=
        Pkg_Log_Buffer.Null_Meta_Raw_C;
      Buffer_Result    : Pkg_Log_Buffer.Buffer_Result_T :=
        Pkg_Log_Buffer.Buffer_Result_T'First;
      Local_Last_Index : Basic_Types_I.Uint32_T         := 0;
      Data_Reading_Raw : Basic_Types_I.Byte_Array_T
        (1 .. Smu_Data.Max_Log_Str_C)                   := (others => 0);
   begin

      Log_Data.Last_Index := 0;
--      Log_Data.Str        := "";
      Log_Data.Metadata   := Smu_Data.Log_Metadata_Default_C;

      if Uif_Log_Buffer_Built then

         if Pkg_Log_Buffer.Get_Num_Items(Uif_Log_Buffer) > 0 then

-- Insert the log string in the Log Buffer with the provided Tag
            Pkg_Log_Buffer.Retrieve
              (Buffer     => Uif_Log_Buffer,
               Data_Raw   => Data_Reading_Raw,
               Last_Index => Local_Last_Index,
               Meta_Raw   => Metadata_Raw,
               Result     => Buffer_Result);

            if Buffer_Result /= Pkg_Log_Buffer.Result_Ok then

               Debug_Log.Do_Log ("SMU_1553_Log.Read_Uif_Log. " &
                 "Error retrieving from 1553 Log Buffer. " & String
                 (Pkg_Log_Buffer.Buffer_Result_To_Str_C (Buffer_Result)));

--            Uif_Log_Buffer_Error := True;
            else

               Log_Data.Str (1 .. Local_Last_Index) := Basic_Convert.Byte_Array_To_Str
                 (Data_Reading_Raw (1 .. Local_Last_Index));
               Log_Data.Last_Index := Local_Last_Index;
               Log_Data.Metadata   := Raw_To_Log_Meta (Metadata_Raw);

            end if;
         end if;
--         Uif_Log_Buffer.Read(Str, Actual_Len);

-- Reset internal error inserting in the 1553 log buffer, normally this flag is set
-- when the buffer is full
         Uif_Log_Buffer_Error := False;

      end if;

   end Read_Uif_Log;





end Smu_1553_Log;

