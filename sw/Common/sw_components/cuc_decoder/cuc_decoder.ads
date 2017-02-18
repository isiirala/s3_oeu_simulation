
with Ada.Calendar;

with Basic_Types_I;


package Cuc_Decoder is


   procedure Init
     (Ext_Debug_Proc : in Basic_Types_I.Debug_Proc_T);



   procedure Decode_Cuc
     (Cuc_Time   : in Basic_Types_I.Cuc_Time_T;
      Year       : out Basic_Types_I.Uint16_T;
      Month      : out Basic_Types_I.Uint16_T;
      Day        : out Basic_Types_I.Uint16_T;
      Day_Year   : out Basic_Types_I.Uint16_T;
      Hour       : out Basic_Types_I.Uint16_T;
      Min        : out Basic_Types_I.Uint16_T;
      Secs       : out Basic_Types_I.Uint16_T;
      Micr_Secs  : out Basic_Types_I.Uint32_T);
-- **************************************************************************************
-- PURPOSE: A time value in CUC format is converted to human calendar and clock values
-- **************************************************************************************


   procedure Code_Cuc
     (Year       : in Basic_Types_I.Uint16_T;
      Month      : in Basic_Types_I.Uint16_T;
      Day        : in Basic_Types_I.Uint16_T;
      Hour       : in Basic_Types_I.Uint16_T;
      Min        : in Basic_Types_I.Uint16_T;
      Secs       : in Basic_Types_I.Uint16_T;
      Micr_Secs  : in Basic_Types_I.Uint32_T;
      Cuc_Time   : out Basic_Types_I.Cuc_Time_T);
-- **************************************************************************************
-- PURPOSE: A calendar time value is converted in CUC format
-- **************************************************************************************

   function Time_To_Cuc (Time  : Ada.Calendar.Time) return Basic_Types_I.Cuc_Time_T;
-- **************************************************************************************
-- PURPOSE: An Ada.Calendar.Time value is converted in CUC format
-- **************************************************************************************

end Cuc_Decoder;
