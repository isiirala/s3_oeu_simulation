
with Basic_Types_1553;
with Basic_Tools;
with Debug_Log;
with Pus_Format_Types_I;

package body Smu_Params_Store is


   Tm_1_2       : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_1_2));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_1_2_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;

   Tm_1_4       : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_1_4));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_1_4_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;

   Tm_1_8       : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_1_8));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_1_8_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;

   Tm_3_25_Sid_1 : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_3_25));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_3_25_Sid_1_Len : Basic_Types_I.Data_32_Len_T := Basic_Types_I.Data_32_Len_Empty_C;

   Tm_3_25_Sid_2 : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_3_25));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_3_25_Sid_2_Len : Basic_Types_I.Data_32_Len_T := Basic_Types_I.Data_32_Len_Empty_C;

   Tm_5_1     : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_5_1));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_5_1_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;
   Tm_5_2     : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_5_2));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_5_2_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;
   Tm_5_3     : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_5_3));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_5_3_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;
   Tm_5_4     : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_5_4));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_5_4_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;

--     Tm_6_6     : Basic_Types_I.String_T
--       (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C) := (others => ' ');
--     Tm_6_6_Len : Basic_Types_I.Data_32_Len_T          :=
--       Basic_Types_I.Data_32_Len_Empty_C;
--
--     Tm_6_10      : Basic_Types_I.String_T (1 .. 200) := (others => ' ');
--     Tm_6_10_Len  : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;
--     Tm_9_132     : Basic_Types_I.String_T (1 .. 200) := (others => ' ');
--     Tm_9_132_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;
--
--     Tm_12_9      : Basic_Types_I.String_T
--       (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C) := (others => ' ');
--     Tm_12_9_Len  : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;
--     Tm_12_12     : Basic_Types_I.String_T
--       (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C) := (others => ' ');
--     Tm_12_12_Len : Basic_Types_I.Data_32_Len_T       := Basic_Types_I.Data_32_Len_Empty_C;

--   Tm_17_2        : Basic_Types_I.String_T (1 .. 200) := (others => ' ');
--   Tm_17_2_Len    : Basic_Types_I.Data_32_Len_T       :=
--     Basic_Types_I.Data_32_Len_Empty_C;
   Tm_128_130     : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_128_130));
--   := (others => Basic_Types_1553.Param_Empty_C);
   Tm_128_130_Len : Basic_Types_I.Data_32_Len_T    := Basic_Types_I.Data_32_Len_Empty_C;

--     Tm_129_130     : Basic_Types_I.String_T
--       (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C) := (others => ' ');
--     Tm_129_130_Len : Basic_Types_I.Data_32_Len_T          :=
--       Basic_Types_I.Data_32_Len_Empty_C;
--     Tm_130_130     : Basic_Types_I.String_T
--       (1 .. Basic_Types_1553.Max_Tm_Data_Decoded_C) := (others => ' ');
--     Tm_130_130_Len : Basic_Types_I.Data_32_Len_T          :=
--       Basic_Types_I.Data_32_Len_Empty_C;



   procedure Store_Hk
     (Params         : in Test_Params_I.Array_Params_T;
      Params_Len     : in Basic_Types_I.Data_32_Len_T)
   is

   begin

-- TBC
--      if Basic_Tools.Equal
--        (Literal  => "SID1",
--         Str      => Params (Params'First).Name,
--         Str_Len  => Params (Params'First).Name_Len) then
null;
--end if;

   end Store_Hk;














   procedure Store
     (Tc_Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
      Params         : in Test_Params_I.Array_Params_T;
      Params_Len     : in Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_1553.Tc_Tm_Id_T;
   begin

-- Copy input parameters decoded into the corresponding internal buffer.
-- The previous value is deleted before because at the moment only one value is stored

      if not Params_Len.Data_Empty then

         case (Tc_Tm_Id) is
            when Basic_Types_1553.Tm_1_2 =>
               Tm_1_2_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_1_2,
                  Buff_Len  => Tm_1_2_Len);
            when Basic_Types_1553.Tm_1_4 =>
               Tm_1_4_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_1_4,
                  Buff_Len  => Tm_1_4_Len);
            when Basic_Types_1553.Tm_1_8 =>
               Tm_1_8_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_1_8,
                  Buff_Len  => Tm_1_8_Len);
            when Basic_Types_1553.Tm_3_25 =>
               Store_Hk
                 (Params     => Params,
                  Params_Len => Params_Len);
            when Basic_Types_1553.Tm_5_1 =>
               Tm_5_1_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_5_1,
                  Buff_Len  => Tm_5_1_Len);
            when Basic_Types_1553.Tm_5_2 =>
               Tm_5_2_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_5_2,
                  Buff_Len  => Tm_5_2_Len);
            when Basic_Types_1553.Tm_5_3 =>
               Tm_5_3_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_5_3,
                  Buff_Len  => Tm_5_3_Len);
            when Basic_Types_1553.Tm_5_4 =>
               Tm_5_4_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_5_4,
                  Buff_Len  => Tm_5_4_Len);
--              when Basic_Types_1553.Tm_6_6 =>
--                 Tm_6_6_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_6_6,
--                    Buff_Len  => Tm_6_6_Len);
--              when Basic_Types_1553.Tm_6_10 =>
--                 Tm_6_10_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_6_10,
--                    Buff_Len  => Tm_6_10_Len);
--              when Basic_Types_1553.Tm_9_132 =>
--                 Tm_9_132_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_9_132,
--                    Buff_Len  => Tm_9_132_Len);
--              when Basic_Types_1553.Tm_12_9 =>
--                 Tm_12_9_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_12_9,
--                    Buff_Len  => Tm_12_9_Len);
--              when Basic_Types_1553.Tm_12_12 =>
--                 Tm_12_12_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_12_12,
--                    Buff_Len  => Tm_12_12_Len);
--              when Basic_Types_1553.Tm_17_2 =>
--                 Tm_17_2_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_17_2,
--                    Buff_Len  => Tm_17_2_Len);
            when Basic_Types_1553.Tm_128_130 =>

               Test_Params_I.Debug
                 (Params => Params (Params'First .. Params_Len.Last_Used),
                  Info   => "Smu_Params_Store.Store TM(128,130)");

               Tm_128_130_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Test_Params_I.Append
                 (Annex     => Params (Params'First .. Params_Len.Last_Used),
                  Buff_Data => Tm_128_130,
                  Buff_Len  => Tm_128_130_Len);
--              when Basic_Types_1553.Tm_129_130 =>
--                 Tm_129_130_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_129_130,
--                    Buff_Len  => Tm_129_130_Len);
--              when Basic_Types_1553.Tm_130_130 =>
--                 Tm_130_130_Len := Basic_Types_I.Data_32_Len_Empty_C;
--                 Basic_Tools.Append
--                   (Annex     => Params (Params'First .. Params_Len.Last_Used),
--                    Buff_Data => Tm_130_130,
--                    Buff_Len  => Tm_130_130_Len);
            when others =>
               null;
         end case;
      end if;
   end Store;


   procedure Retrieve
     (Tc_Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
      Params         : in out Test_Params_I.Array_Params_T;
      Params_Len     : in out Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_1553.Tc_Tm_Id_T;

   begin
      case (Tc_Tm_Id) is
         when Basic_Types_1553.Tm_1_2 =>
            if not Tm_1_2_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_1_2 (1 .. Tm_1_2_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_1_2_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
         when Basic_Types_1553.Tm_1_4 =>
            if not Tm_1_4_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_1_4 (1 .. Tm_1_4_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_1_4_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
         when Basic_Types_1553.Tm_1_8 =>
            if not Tm_1_8_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_1_8 (1 .. Tm_1_8_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_1_8_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
--           when Basic_Types_1553.Tm_3_25 =>
--              if not Tm_3_25_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_3_25 (1 .. Tm_3_25_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_3_25_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
         when Basic_Types_1553.Tm_5_1 =>
            if not Tm_5_1_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_5_1 (1 .. Tm_5_1_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_5_1_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
         when Basic_Types_1553.Tm_5_2 =>
            if not Tm_5_2_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_5_2 (1 .. Tm_5_2_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_5_2_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
         when Basic_Types_1553.Tm_5_3 =>
            if not Tm_5_3_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_5_3 (1 .. Tm_5_3_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_5_3_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
         when Basic_Types_1553.Tm_5_4 =>
            if not Tm_5_4_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_5_4 (1 .. Tm_5_4_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_5_4_Len := Basic_Types_I.Data_32_Len_Empty_C;
            end if;
--           when Basic_Types_1553.Tm_6_6 =>
--              if not Tm_6_6_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_6_6 (1 .. Tm_6_6_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_6_6_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
--           when Basic_Types_1553.Tm_6_10 =>
--              if not Tm_6_10_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_6_10 (1 .. Tm_6_10_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_6_10_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
--           when Basic_Types_1553.Tm_9_132 =>
--              if not Tm_9_132_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_9_132 (1 .. Tm_9_132_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_9_132_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
--           when Basic_Types_1553.Tm_12_9 =>
--              if not Tm_12_9_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_12_9 (1 .. Tm_12_9_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_12_9_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
--           when Basic_Types_1553.Tm_12_12 =>
--              if not Tm_12_12_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_12_12 (1 .. Tm_12_12_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_12_12_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
--           when Basic_Types_1553.Tm_17_2 =>
--              if not Tm_17_2_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_17_2 (1 .. Tm_17_2_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_17_2_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
         when Basic_Types_1553.Tm_128_130 =>
--            Debug_Log.Do_Log("[Smu_Params_Store.Retrieve] Before retrieve TM(128,130)");
            if not Tm_128_130_Len.Data_Empty then
               Test_Params_I.Append
                 (Annex     => Tm_128_130 (1 .. Tm_128_130_Len.Last_Used),
                  Buff_Data => Params,
                  Buff_Len  => Params_Len);
               Tm_128_130_Len := Basic_Types_I.Data_32_Len_Empty_C;
               Debug_Log.Do_Log("Smu_Params_Store.Retrieve TM(128,130)");
            end if;
--           when Basic_Types_1553.Tm_129_130 =>
--              if not Tm_129_130_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_129_130 (1 .. Tm_129_130_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_129_130_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
--           when Basic_Types_1553.Tm_130_130 =>
--              if not Tm_130_130_Len.Data_Empty then
--                 Basic_Tools.Append
--                   (Annex     => Tm_130_130 (1 .. Tm_130_130_Len.Last_Used),
--                    Buff_Data => Tm_Data,
--                    Buff_Len  => Tm_Len);
--                 Tm_130_130_Len := Basic_Types_I.Data_32_Len_Empty_C;
--              end if;
         when others =>
            null;
      end case;

   end Retrieve;




end Smu_Params_Store;

