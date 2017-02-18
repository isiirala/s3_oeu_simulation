

with Ada.Calendar;

with Basic_Types_1553;
with Basic_Types_I;
--with Bus_1553_Pus_Types;


package Smu_Data is


-- -------------------------------------------------------------------------------------
-- Constants and types related with the SMU-OEU 1553 Bus link
-- -------------------------------------------------------------------------------------
   use type Basic_Types_I.Uint32_T;

   Max_Tm_Block_In_Buffer_C     : constant   := 50;
   --  Max number of TM Blocks in the buffer

   Max_Tm_Block_Bytes_C         : constant   := (Basic_Types_1553.Max_Tm_Len_C * 2);
   -- Max byte length of a TM Block: 512 * 2

   Max_Log_Str_C                : constant   := (Max_Tm_Block_Bytes_C * 5) + 100;
   -- Maximum length of a 1553 log message


-- --------------------------------------------------------------------------------------
-- Constants and types related with the METADATA of SMU log
-- --------------------------------------------------------------------------------------

   Log_Meta_Bit_Len_C   : constant   := 8;
   Log_Meta_Byte_Len_C  : constant   := 1;

   type Log_Tag_T is (Tag_Raw, Tag_Decoded, Tag_Info, Tag_Summary);
   -- Different tags of log texts to write in the SMU 1553 log,
   -- the text widget will assign gtk text tags to each one:
   --   Raw: Raw bytes of the transmitted data
   --   Decoded: The decodification of the message
   --   Info: time tag and type of block: TC or TM.
   --   Summary: TC/TM(serv,sub-ser)

   for Log_Tag_T'Size use Log_Meta_Bit_Len_C;

   type Log_Metadata_T is record
      Tag : Log_Tag_T;

   end record;
   -- Type of metadata info to escort log data, at the moment there is only the text tag

   pragma pack (Log_Metadata_T);
   for Log_Metadata_T'Size use Log_Meta_Bit_Len_C;

   Log_Metadata_Default_C     : constant Log_Metadata_T     :=
     (Tag => Tag_Raw);


-- --------------------------------------------------------------------------------------
-- Constants and types related with the DATA of SMU log
-- --------------------------------------------------------------------------------------

   type Log_Data_T is record
      Str          : Basic_Types_I.String_T (1 .. Max_Log_Str_C);
      Last_Index   : Basic_Types_I.Uint32_T;
      Metadata     : Log_Metadata_T;
   end record;
   -- Struct to hold any part of a message of the SMU log with the same tag


-- --------------------------------------------------------------------------------------
-- Constants and types related with the METADATA of SMU TC buffer
-- --------------------------------------------------------------------------------------
   Tc_Buffer_Meta_Bit_Len_C   : constant   := 72;
   Tc_Buffer_Meta_Byte_Len_C  : constant   := 9;

   type Tc_Buffer_Metadata_T is record
      Sa_Id        : Basic_Types_I.Uint8_T;
      -- SA where send the TC
      Time_Tag     : Ada.Calendar.Time;
      -- Time tag when BC transmit the TC

   end record;
   -- Type of metadata info to escort each TC in the SMU TC buffer to send all RTs

   pragma pack (Tc_Buffer_Metadata_T);
   for Tc_Buffer_Metadata_T'Size use Tc_Buffer_Meta_Bit_Len_C;

   Tc_Buffer_Metadata_Default_C     : constant Tc_Buffer_Metadata_T     :=
     (Sa_Id => 0, Time_Tag => Ada.Calendar.Clock);

-- --------------------------------------------------------------------------------------
-- Constants and types related with the DATA of SMU TC buffer
-- --------------------------------------------------------------------------------------

   type Tc_Buffer_Data_T is record
      Tc_Block   : Basic_Types_I.Byte_Array_T (1 .. Basic_Types_1553.Max_Tc_Block_Len_C);
      Last_Index : Basic_Types_I.Uint32_T;
      Metadata   : Tc_Buffer_Metadata_T;
   end record;
   -- Struct to store a TC block read from the SMU TC buffer

   Empty_Tc_Buffer_Data_C : constant Tc_Buffer_Data_T :=
     (Tc_Block   => (others => 0),
      Last_Index => 0,
      Metadata   => Tc_Buffer_Metadata_Default_C);


end Smu_Data;

