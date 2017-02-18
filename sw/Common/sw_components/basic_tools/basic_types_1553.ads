

with Basic_Types_I;

package Basic_Types_1553 is

   use type Basic_Types_I.Unsigned_32_T;

   Max_Tc_Len_C       : constant Basic_Types_I.Unsigned_32_T  := 226;
   -- Maximum bytes length of a TC.

   Max_Tm_Len_C       : constant Basic_Types_I.Unsigned_32_T  := 1024;
   -- Maximum bytes length of a TM.

   Max_Tc_Block_Len_C : constant Basic_Types_I.Unsigned_32_T  := 5248; --2260;
   -- Maximum bytes length of a TC block. A TC burst can be 8 TCs of maximum length,
   -- but ICM SW accepts 82 frames.

   Max_Tm_Block_Len_C : constant Basic_Types_I.Unsigned_32_T  := 1024;
   -- Maximum bytes length of a TM block. A TM block can be of 1024 b like a maximum TM

   Max_Sa_Byte_Len_C  : constant Basic_Types_I.Unsigned_32_T  :=
     Max_Tc_Block_Len_C;
   -- Maximum bytes length to hold the bigest TC or TM

   Rt_Limit_C        : constant Basic_Types_I.Unsigned_32_T  := 31;
   Sa_Limit_C        : constant Basic_Types_I.Unsigned_32_T  := 31;
   Mc_Limit_C        : constant Basic_Types_I.Unsigned_32_T  := 31;

   Dw_Per_Frame_C    : constant Basic_Types_I.Unsigned_32_T  := 32;
   -- Number of data words (16 bits) in a 1553 frame

   Bytes_Per_Frame_C : constant Basic_Types_I.Unsigned_32_T  := 64;
   -- Number of bytes in a 1553 frame

   Max_Sa_Frames_C    : constant Basic_Types_I.Unsigned_32_T  :=
     Max_Tc_Block_Len_C / Bytes_Per_Frame_C;
   -- Maximum number of 1553 frames of the bigest message: 5248 / 64 = 82
   --   (2260 / 64 = 36)


-- TODO: tratar de usar tipos mod para ahorrar las rutinas de incrementar/decrementar

-- type Rt_Id_T is mod Rt_Limit_C;
   subtype Rt_Id_T is Basic_Types_I.Unsigned_32_T range 0 .. Rt_Limit_C;

-- type Sa_Id_T is mod Sa_Limit_C;
   subtype Sa_Id_T is Basic_Types_I.Unsigned_32_T range 0 .. Sa_Limit_C;

   subtype Mc_Id_T is Basic_Types_I.Unsigned_32_T range 0 .. Sa_Limit_C;

   subtype Frame_Byte_Range_T is Basic_Types_I.Unsigned_32_T
     range 1 .. Bytes_Per_Frame_C;
   -- Byte range inside a data frame

   subtype Frame_Range_Ne_T is Basic_Types_I.Unsigned_32_T range 0 .. Max_Sa_Frames_C;
   -- Range of frames of the bigest used message including 0 (Neutral element)

   subtype Sa_Data_Range_T is Basic_Types_I.Unsigned_32_T range 1 .. Max_Sa_Byte_Len_C;

   subtype Sa_Data_Buff_T is Basic_Types_I.Byte_Array_T (Sa_Data_Range_T'Range);
   -- Array of bytes to hold max data length in the biggest SA

   subtype Sa_Data_Frame_T is Basic_Types_I.Byte_Array_T (Frame_Byte_Range_T'Range);
   -- Byte array that can hold a data frame

   Raw_Time_Msg_Len_C     : constant Basic_Types_I.Uint32_T   := 10;
   subtype Raw_Time_Msg_T is Basic_Types_I.Byte_Array_T (1 .. Raw_Time_Msg_Len_C);
   -- Array of bytes to hold the raw time message for the broadcast time distribution
   Raw_Time_P_Field_C : constant Basic_Types_I.Uint8_T    := 2#00101111#;
   -- P Field value in the raw time message

   function To_Raw_Time_Msg (Time_Val  : Basic_Types_I.Cuc_Time_T) return Raw_Time_Msg_T;
--***************************************************************************************
-- PURPOSE: Build a Raw Time Message for Broadcast time synchronization from the CUC
--   value
-- PARAMETERS:
--***************************************************************************************



-- -------------------------------------------------------------------------------------
-- Parameters
-- -------------------------------------------------------------------------------------

   type Tc_Tm_Id_T is
     (Tc_Tm_None,
      Tm_1_1, Tm_1_2, Tm_1_4, Tm_1_7, Tm_1_8,
      Tc_3_1, Tc_3_3, Tc_3_5, Tc_3_6, Tc_3_9, Tm_3_10, Tm_3_25,
      Tm_5_1, Tm_5_2, Tm_5_3, Tm_5_4, Tc_5_5, Tc_5_6,
      Tc_6_2, Tc_6_5, Tm_6_6, Tc_6_9, Tm_6_10,
      Tc_9_130, Tc_9_131, Tm_9_132,
      Tc_12_1, Tc_12_2, Tc_12_7, Tc_12_8, Tm_12_9, Tm_12_12, Tc_12_131, Tc_12_132,
      Tc_17_1, Tm_17_2,
      Tc_128_128, Tc_128_129, Tm_128_130,
      Tc_129_128, Tc_129_129, Tm_129_130,
      Tc_130_128, Tc_130_129, Tm_130_130);
   -- Identifier of TC/TM messages. There is a different value for each TC and TM

   type Tc_Tm_Id_To_Int_T is array (Tc_Tm_Id_T) of Basic_Types_I.Uint16_T;
   Tc_Tm_Id_To_Int_C   : constant Tc_Tm_Id_To_Int_T   :=
     (Tc_Tm_None  => 0,
      Tm_1_1      => 101,
      Tm_1_2      => 102,
      Tm_1_4      => 103,
      Tm_1_7      => 104,
      Tm_1_8      => 105,
      Tc_3_1      => 106,
      Tc_3_3      => 107,
      Tc_3_5      => 108,
      Tc_3_6      => 109,
      Tc_3_9      => 110,
      Tm_3_10     => 111,
      Tm_3_25     => 112,
      Tm_5_1      => 113,
      Tm_5_2      => 114,
      Tm_5_3      => 115,
      Tm_5_4      => 116,
      Tc_5_5      => 117,
      Tc_5_6      => 118,
      Tc_6_2      => 119,
      Tc_6_5      => 120,
      Tm_6_6      => 121,
      Tc_6_9      => 122,
      Tm_6_10     => 123,
      Tc_9_130    => 124,
      Tc_9_131    => 125,
      Tm_9_132    => 126,
      Tc_12_1     => 127,
      Tc_12_2     => 128,
      Tc_12_7     => 129,
      Tc_12_8     => 130,
      Tm_12_9     => 131,
      Tm_12_12    => 132,
      Tc_12_131   => 133,
      Tc_12_132   => 134,
      Tc_17_1     => 135,
      Tm_17_2     => 136,
      Tc_128_128  => 137,
      Tc_128_129  => 138,
      Tm_128_130  => 139,
      Tc_129_128  => 140,
      Tc_129_129  => 141,
      Tm_129_130  => 142,
      Tc_130_128  => 143,
      Tc_130_129  => 144,
      Tm_130_130  => 145);

   function Int_To_Tc_Tm_Id (Raw_Val : in Basic_Types_I.Uint16_T) return Tc_Tm_Id_T;

   function Tc_Tm_Id_To_Str (Srv_Id  : Tc_Tm_Id_T) return String;

   function Tc_Tm_Id_To_Descript (Srv_Id  : Tc_Tm_Id_T) return String;

   Max_Tc_Tm_Params_C     : constant Basic_Types_I.Uint32_T  := 160;
   -- Maximum number of parameters in a TC/TM. The HK SID 2 contains 145 parameters




end Basic_Types_1553;

