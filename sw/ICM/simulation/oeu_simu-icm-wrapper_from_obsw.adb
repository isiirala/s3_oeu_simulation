-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu.Icm.Wrapper_From_Obsw
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Routines to call/use the ICM UIF from OBSW
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************



with Glib;

--with Pus_Types_I;

--with Bus_1553_Simu;

--with Debug_Log;


package body Oeu_Simu.Icm.Wrapper_From_Obsw is


--   Ada.Strings.Unbounded;


--   procedure Init is
--   begin
--      Log_Buffer_Ptr := new Character'(Log_Buffer_Last_Index_C);
--   end Init;



   procedure obsw_debug_char (C : in Character) is
      Str : String(1 .. 1) := (others => ' ');
   begin

--      Debug_Log.Do_Log(" Oeu_Simu.Icm.Wrapper_From_Obsw.obsw_debug_char ");
--      Str(1) := C;
--      Write_Obsw_Log(Str);
null;
   end obsw_debug_char;

   procedure obsw_debug_str (Str : in String) is
   begin

--      Debug_Log.Do_Log(" Oeu_Simu.Icm.Wrapper_From_Obsw.obsw_debug_str ");
--      Debug_Log.Do_Log(" [From_Obsw]: " & Str);
--      Write_Obsw_Log(Str);
null;
   end obsw_debug_str;

--   procedure obsw_debug_1553_tm (Str : in String);

--   procedure obsw_debug_char (C : in Character) is
--   begin
----      Ada.Text_Io.Put (C);
--      If_Icm.Write_Char_In_Log(C);
--   end obsw_debug_char;
--   procedure obsw_debug_str (Str : in String) is
--   begin
--      If_Icm.Write_Str_In_Log(Str);
--   end obsw_debug_str;

--   procedure obsw_debug_1553_tm (Str : in String) is
--   begin
--      Main_Smu_Panel.Debug_1553_Str (Str);
--   end obsw_debug_1553_tm;





--     function obsw_bus_set_data_trans (
--       Sa_Id    : in Basic_Types_I.Unsigned_32_T;
--       Ptr_Data : in System.Address;
--       Dw_N     : in Basic_Types_I.Unsigned_32_T)
--       return Basic_Types_I.Unsigned_32_T is
--
--        use type Basic_Types_I.Unsigned_32_T;
--
--        Result_1553 : Basic_Types_I.Unsigned_32_T := 0;
--
--        Byte_Len_C  : constant Basic_Types_I.Unsigned_32_T := Dw_N * 2;
--        Local_Data : Pus_Types_I.Byte_Field_Nc_T (1 .. Byte_Len_C);
--        for Local_Data'Address use Ptr_Data;
--
--        Index_1  : Basic_Types_I.Unsigned_32_T := 1;
--        Index_2  : Basic_Types_I.Unsigned_32_T := 2;
--
--  --      Num_Mess_1553 : Basic_Types_I.Unsigned_8_T := 0;
--  --      Num_Word_Last_Mess : Basic_Types_I.Unsigned_8_T := 0;
--
--     begin
--
--        Write_Obsw_Log(" out SA: " & Basic_Types_I.Unsigned_32_T'Image(Sa_Id) &
--          " DwN: " & Basic_Types_I.Unsigned_32_T'Image(Dw_N));
--  --      Debug_Driver.Put_Text
--  --      Debug_Driver.Put_Unsig_32 (" out SA: ", Sa_Id);
--  --      Debug_Driver.Put_Unsig_32 (" DwN: ", Dw_N);
--
--
--  --      Out_Sa_Data (Out_Sa_Raw_To_Out_Sa(Sa_Id)) (1 .. Byte_Len_C) := Local_Data  (1 .. Byte_Len_C);
--
--
--
--        if Sa_Id = 15 then
--  --         If_Icm.Write_Str_In_Log (" outSA15 ");
--  --         for I in 1 .. 12 loop
--  --            If_Icm.Write_Str_In_Log (" " & Integer'Image(Integer(I)) & ":");
--  --            If_Icm.Write_Str_In_Log (" " & Integer'Image(Integer(Local_Data(Index_1))) & ","); -- Out_Sa_Data(Out_Sa_15)(Index_1))) & ",");
--  --            If_Icm.Write_Str_In_Log (Integer'Image(Integer(Local_Data(Index_2))) & " "); --Out_Sa_Data(Out_Sa_15)(Index_2))) & " ");
--  --            Index_1 := Index_1 + 2;
--  --            Index_2 := Index_2 + 2;
--  --         end loop;
--  null;
--        end if;
--
--        if Sa_Id = 3 then
--  --         If_Icm.Write_Str_In_Log (" outSA3 ");
--  null;
--  --         Main_Smu_Panel.Debug_1553_Str (Icm_1553_Decoder.Decode_Event (Ptr_Data, Byte_Len_C) & ASCII.LF);
--
--  --         for I in 1 .. 12 loop
--  --            Index_1 := Basic_Types_I.Unsigned_32_T (I * 2 - 1);
--  --            Index_2 := Basic_Types_I.Unsigned_32_T (I * 2);
--  --            If_Icm.Write_Str_In_Log (" " & Integer'Image(Integer(I)) & ":");
--  --            If_Icm.Write_Str_In_Log (" " & Integer'Image(Integer(Out_Sa_Data(Out_Sa_03)(Index_1))) & ",");
--  --            If_Icm.Write_Str_In_Log (Integer'Image(Integer(Out_Sa_Data(Out_Sa_03)(Index_2))) & " ");
--  --         end loop;
--        end if;
--
--
--  --      Bus_1553_Simu.Set_Data_Trans(
--  --        Sa_Id    => Sa_Id,
--  --        Ptr_Data => Ptr_Data,
--  --        Dw_N     => Dw_N,
--  --        Result   => Result_1553);
--
--        --TODO: return Result_1553;
--        return 16#04000001#;
--     end obsw_Bus_Set_Data_Trans;


end Oeu_Simu.Icm.Wrapper_From_Obsw;

