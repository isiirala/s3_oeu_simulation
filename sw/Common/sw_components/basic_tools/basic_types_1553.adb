

with Basic_Convert;

package body Basic_Types_1553 is



   function To_Raw_Time_Msg (Time_Val  : Basic_Types_I.Cuc_Time_T) return Raw_Time_Msg_T
   is
      Raw_Msg    :  Raw_Time_Msg_T   := (others => 0);

   begin

      Raw_Msg (2) := Raw_Time_P_Field_C;

      Basic_Convert.Pack_Cuc (Time_Val, Raw_Msg (3 .. 9));

      return Raw_Msg;
   end To_Raw_Time_Msg;




   function Int_To_Tc_Tm_Id (Raw_Val : in Basic_Types_I.Uint16_T) return Tc_Tm_Id_T
   is
   begin

      case Raw_Val is
--      when 0    => return Tc_Tm_None;
      when 101 => return Tm_1_1;
      when 102 => return Tm_1_2;
      when 103 => return Tm_1_4;
      when 104 => return Tm_1_7;
      when 105 => return Tm_1_8;
      when 106 => return Tc_3_1;
      when 107 => return Tc_3_3;
      when 108 => return Tc_3_5;
      when 109 => return Tc_3_6;
      when 110 => return Tc_3_9;
      when 111 => return Tm_3_10;
      when 112 => return Tm_3_25;
      when 113 => return Tm_5_1;
      when 114 => return Tm_5_2;
      when 115 => return Tm_5_3;
      when 116 => return Tm_5_4;
      when 117 => return Tc_5_5;
      when 118 => return Tc_5_6;
      when 119 => return Tc_6_2;
      when 120 => return Tc_6_5;
      when 121 => return Tm_6_6;
      when 122 => return Tc_6_9;
      when 123 => return Tm_6_10;
      when 124 => return Tc_9_130;
      when 125 => return Tc_9_131;
      when 126 => return Tm_9_132;
      when 127 => return Tc_12_1;
      when 128 => return Tc_12_2;
      when 129 => return Tc_12_7;
      when 130 => return Tc_12_8;
      when 131 => return Tm_12_9;
      when 132 => return Tm_12_12;
      when 133 => return Tc_12_131;
      when 134 => return Tc_12_132;
      when 135 => return Tc_17_1;
      when 136 => return Tm_17_2;
      when 137 => return Tc_128_128;
      when 138 => return Tc_128_129;
      when 139 => return Tm_128_130;
      when 140 => return Tc_129_128;
      when 141 => return Tc_129_129;
      when 142 => return Tm_129_130;
      when 143 => return Tc_130_128;
      when 144 => return Tc_130_129;
      when 145 => return Tm_130_130;
      when others  => return Tc_Tm_None;
      end case;
   end Int_To_Tc_Tm_Id;


   function Tc_Tm_Id_To_Str (Srv_Id  : Tc_Tm_Id_T) return String
   is
   begin
      case Srv_Id is
         when Tc_Tm_None  => return "TC_TM_Unknow";
         when Tm_1_1      => return "TM(1,1)";
         when Tm_1_2      => return "TM(1,2)";
         when Tm_1_4      => return "TM(1,4)";
         when Tm_1_7      => return "TM(1,7)";
         when Tm_1_8      => return "TM(1,8)";
         when Tc_3_1      => return "TC(3,1)";
         when Tc_3_3      => return "TC(3,3)";
         when Tc_3_5      => return "TC(3,5)";
         when Tc_3_6      => return "TC(3,6)";
         when Tc_3_9      => return "TC(3,9)";
         when Tm_3_10     => return "TM(3,10)";
         when Tm_3_25     => return "TM(3,25)";
         when Tm_5_1      => return "TM(5,1)";
         when Tm_5_2      => return "TM(5,2)";
         when Tm_5_3      => return "TM(5,3)";
         when Tm_5_4      => return "TM(5,4)";
         when Tc_5_5      => return "TC(5,5)";
         when Tc_5_6      => return "TC(5,6)";
         when Tc_6_2      => return "TC(6,2)";
         when Tc_6_5      => return "TC(6,5)";
         when Tm_6_6      => return "TM(6,6)";
         when Tc_6_9      => return "TC(6,9)";
         when Tm_6_10     => return "TM(6,10)";
         when Tc_9_130    => return "TC(9,130)";
         when Tc_9_131    => return "TC(9,131)";
         when Tm_9_132    => return "TM(9,132)";
         when Tc_12_1     => return "TC(12,1)";
         when Tc_12_2     => return "TC(12,2)";
         when Tc_12_7     => return "TC(12,7)";
         when Tc_12_8     => return "TC(12,8)";
         when Tm_12_9     => return "TM(12,9)";
         when Tm_12_12    => return "TM(12,12)";
         when Tc_12_131   => return "TC(12,131)";
         when Tc_12_132   => return "TC(12,132)";
         when Tc_17_1     => return "TC(17,1)";
         when Tm_17_2     => return "TM(17,2)";
         when Tc_128_128  => return "TC(128,128)";
         when Tc_128_129  => return "TC(128,129)";
         when Tm_128_130  => return "TM(128,130)";
         when Tc_129_128  => return "TC(129,128)";
         when Tc_129_129  => return "TC(129,129)";
         when Tm_129_130  => return "TM(129,130)";
         when Tc_130_128  => return "TC(130,128)";
         when Tc_130_129  => return "TC(130,129)";
         when Tm_130_130  => return "TM(130,130)";
      end case;
   end Tc_Tm_Id_To_Str;


   function Tc_Tm_Id_To_Descript (Srv_Id  : Tc_Tm_Id_T) return String is
   begin

      case Srv_Id is
         when Tc_Tm_None  => return "TC_TM_Unknow";
         when Tm_1_1      => return "TC acceptance report ""Success""";
         when Tm_1_2      => return "TC acceptance report ""Failure""";
         when Tm_1_4      => return "TC execution start report ""Failure""";
         when Tm_1_7      => return "TC execution complete report ""Success""";
         when Tm_1_8      => return "TC execution complete report ""Failure""";
         when Tc_3_1      => return "Define new HK report";
         when Tc_3_3      => return "Clear HK report definition";
         when Tc_3_5      => return "Enable HK report generation";
         when Tc_3_6      => return "Disable HK report generation";
         when Tc_3_9      => return "Report HK definition";
         when Tm_3_10     => return "HK parameter definition report";
         when Tm_3_25     => return "HK parameter report";
         when Tm_5_1      => return "Report of normal events";
         when Tm_5_2      => return "Report of low severity events";
         when Tm_5_3      => return "Report of medium severity events";
         when Tm_5_4      => return "Report of high severity events";
         when Tc_5_5      => return "Enable event report generation";
         when Tc_5_6      => return "Disable event report generation";
         when Tc_6_2      => return "Load memory using absolute address";
         when Tc_6_5      => return "Dump memory using absolute address";
         when Tm_6_6      => return "Report of memory dump using absolute address";
         when Tc_6_9      => return "Check memory using absolute address";
         when Tm_6_10     => return "Report of memory check using absolute address";
         when Tc_9_130    => return "Update local time";
         when Tc_9_131    => return "Get local time verification report";
         when Tm_9_132    => return "Local time verification report";
         when Tc_12_1     => return "Enable monitoring of parameters";
         when Tc_12_2     => return "Disable monitoring of parameters";
         when Tc_12_7     => return "Modify info parameters checking";
         when Tc_12_8     => return "Ask for current monitoring list";
         when Tm_12_9     => return "Report of current monitoring list";
         when Tm_12_12    => return "Report of check transition";
         when Tc_12_131   => return "Modify the value #REP";
         when Tc_12_132   => return "Modify the parameter validity";
         when Tc_17_1     => return "Perform connection test";
         when Tm_17_2     => return "Connection test report";
         when Tc_128_128  => return "Command function mode";
         when Tc_128_129  => return "Report the current function mode";
         when Tm_128_130  => return "Current mode report";
         when Tc_129_128  => return "Set Instruction or function parameter";
         when Tc_129_129  => return "Report the function parameter value";
         when Tm_129_130  => return "Function parameters value report";
         when Tc_130_128  => return "Set Equipment configuration";
         when Tc_130_129  => return "Get the Equipment configuration";
         when Tm_130_130  => return "Equipment configuration report";
      end case;
   end Tc_Tm_Id_To_Descript;




end Basic_Types_1553;
