
with Ada.Exceptions;


with Basic_Types_1553;
with Basic_Types_I;
with Bus_1553_Pus_Types;
with Bus_1553_Pus.Rt;
with Debug_Log;
with Epica_Types;

package body Bus_Rt_Icm is





   Rt_Nominal   : Bus_1553_Pus.Rt.Bus_1553_Pus_Rt_T         := Null;
   Rt_Redundant : Bus_1553_Pus.Rt.Bus_1553_Pus_Rt_T         := Null;

   function Result_To_Obsw
     (Result : in Basic_Types_I.Unsigned_32_T)
   return Lib_Icm_Sw_If_Types.Uint32_T is
      use type Basic_Types_I.Unsigned_32_T;
   begin
      if Result >= Bus_1553_Pus_Types.Ko_Invalid_Sa_Status_C then
         return Lib_Icm_Sw_If_Types.Uint32_T (Bus_1553_Pus_Types.Ko_Internal_If_C);
      else
         return Lib_Icm_Sw_If_Types.Uint32_T (Result);
      end if;
   end Result_To_Obsw;





   procedure Init
     (Bc_Access   : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T)
   is
      use type Basic_Types_I.Unsigned_32_T;

      Result       : Basic_Types_I.Unsigned_32_T          := 0;
   begin

      Bus_1553_Pus.Rt.Create_New
        (Rt_Id     => 2,
         Bc_Access => Bc_Access,
         Rt        => Rt_Nominal,
         Result    => Result);

      if Result /= Bus_1553_Pus_Types.Ok_Result_C then
         Debug_Log.Do_Log ("[Bus_RT_ICM] Error creating Bus 1553 Nominal RT: " &
           Basic_Types_I.Unsigned_32_T'Image (Result));
      end if;

      Bus_1553_Pus.Rt.Create_New
        (Rt_Id     => 18,
         Bc_Access => Bc_Access,
         Rt        => Rt_Redundant,
         Result    => Result);

      if Result /= Bus_1553_Pus_Types.Ok_Result_C then
         Debug_Log.Do_Log ("[Bus_RT_ICM] Error creating Bus 1553 Redundant RT: " &
           Basic_Types_I.Unsigned_32_T'Image (Result));
      end if;
   end Init;

   procedure Connect_Interrupt_Routines
     (Ic1_Handler : in Lib_Icm_Sw_If_Types.Ic1_Handler_T;
      Ic2_Handler : in Lib_Icm_Sw_If_Types.Ic2_Handler_T)
   is
      use type Bus_1553_Pus.Rt.Bus_1553_Pus_Rt_T;
   begin

      if Rt_Nominal /= Null then
         Rt_Nominal.Set_Interrupt_Routines
           (Ic1_Handler  => Ic1_Handler,
            Ic2_Handler  => Ic2_Handler);
      else
         Debug_Log.Do_Log
           (" [Bus_RT_ICM.Connect_Interrupt_Routines]Warning Rt_Nominal=Null ");
      end if;

      if Rt_Redundant /= Null then
         Rt_Redundant.Set_Interrupt_Routines
           (Ic1_Handler  => Ic1_Handler,
            Ic2_Handler  => Ic2_Handler);
      else
         Debug_Log.Do_Log
           (" [Bus_RT_ICM.Connect_Interrupt_Routines]Warning Rt_Redundant=Null ");
      end if;
   end Connect_Interrupt_Routines;


   procedure Bus_1553_Init_Sa_Raw
     (Sa_Id     : in Lib_Icm_Sw_If_Types.Uint32_T;
      Tx_Or_Rx  : in Boolean;
      Msg_N     : in Lib_Icm_Sw_If_Types.Uint32_T;
      Result    : out Lib_Icm_Sw_If_Types.Uint32_T)
   is
      use type Basic_Types_I.Unsigned_32_T;
      Rt_Result : Basic_Types_I.Unsigned_32_T := 0;
   begin

      Result := Result_To_Obsw (Bus_1553_Pus_Types.Ok_Result_C);

--      Debug_Log.Do_Log("[Bus_Rt_Icm Bus_1553_Init_Sa_Raw]. Sa_Id:" &
--        Lib_Icm_Sw_If_Types.U32_T'Image(Sa_Id) & " Tx:" &
--        Boolean'Image(Tx_Or_Rx) & " Msg_N:" &
--        Lib_Icm_Sw_If_Types.U32_T'Image(Msg_N));

      Bus_1553_Pus.Rt.Rt_For_User_Set_Transaction
        (Sa_Raw_Id   => Basic_Types_I.Unsigned_32_T (Sa_Id),
         Tx_Or_Rx    => Tx_Or_Rx,
         Msg_N       => Basic_Types_I.Unsigned_32_T (Msg_N),
         Rt          => Rt_Nominal,
         Result      => Rt_Result);
       if Rt_Result /= Bus_1553_Pus_Types.Ok_Result_C then
          Result := Lib_Icm_Sw_If_Types.Uint32_T (Rt_Result);
       else
          Bus_1553_Pus.Rt.Rt_For_User_Set_Transaction
            (Sa_Raw_Id   => Basic_Types_I.Unsigned_32_T (Sa_Id),
             Tx_Or_Rx    => Tx_Or_Rx,
             Msg_N       => Basic_Types_I.Unsigned_32_T (Msg_N),
             Rt          => Rt_Redundant,
             Result      => Rt_Result);
          if Rt_Result /= Bus_1553_Pus_Types.Ok_Result_C then
             Result := Lib_Icm_Sw_If_Types.Uint32_T (Rt_Result);
          end if;
       end if;
   end Bus_1553_Init_Sa_Raw;

   procedure Bus_1553_Tx_Sa_Raw
     (Sa_Id    : in Lib_Icm_Sw_If_Types.Uint32_T;
      Ptr_Data : in System.Address;
      Dw_N     : in Lib_Icm_Sw_If_Types.Uint32_T;
      Result   : out Lib_Icm_Sw_If_Types.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;

      Local_Result : Basic_Types_I.Uint32_T := 0;
   begin

--      Debug_Log.Do_Log("[Bus_Rt_Icm.Bus_1553_Tx_Sa_Raw]. Sa_Id:" &
--        Lib_Icm_Sw_If_Types.Uint32_T'Image (Sa_Id) & " Dw_N:" &
--        Lib_Icm_Sw_If_Types.Uint32_T'Image (Dw_N));
-- TODO: usar Nominal o redundante en función de un parametro de usuario
      Bus_1553_Pus.Rt.Rt_For_User_Set_Data_Tx
        (Rt          => Rt_Nominal,
         Sa_Raw_Id   => Basic_Types_I.Unsigned_32_T (Sa_Id),
         Ptr_Data    => Ptr_Data,
         Dw_N        => Basic_Types_I.Unsigned_32_T (Dw_N),
         Result      => Local_Result);


      if Local_Result /= Bus_1553_Pus_Types.Ok_Result_C then
         Debug_Log.Do_Log
           ("[Bus_Rt_Icm Bus_1553_Tx_Sa_Raw]. Error in Set_Data_Tx Resul: " &
             Basic_Types_I.Uint32_T'Image(Local_Result));
      end if;

      Result := Result_To_Obsw (Local_Result);
   end Bus_1553_Tx_Sa_Raw;


   procedure Bus_1553_Rx_Sa_Raw
     (Sa_Id    : in Lib_Icm_Sw_If_Types.Uint32_T;
      Ptr_Data : in System.Address;
      Dw_N     : out Lib_Icm_Sw_If_Types.Uint32_T;
      Result   : out Lib_Icm_Sw_If_Types.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;

      Local_Dw_N   : Basic_Types_I.Unsigned_32_T  := 0;
      Local_Result : Basic_Types_I.Uint32_T       := 0;
   begin

-- TODO: usar Nominal o redundante en función de un parametro de usuario. ¿Un checkbox en el
-- widget donde se construya el TC
      Bus_1553_Pus.Rt.Rt_For_User_Get_Data_Rx
        (Rt          => Rt_Nominal,
         Sa_Raw_Id   => Basic_Types_I.Unsigned_32_T (Sa_Id),
         Ptr_Data    => Ptr_Data,
         Dw_N        => Local_Dw_N,
         Result      => Local_Result);

      Dw_N   := Lib_Icm_Sw_If_Types.Uint32_T (Local_Dw_N);
      Result := Lib_Icm_Sw_If_Types.Uint32_T (Local_Result);

--      Debug_Log.Do_Log("[Bus_Rt_Icm Bus_1553_Rx_Sa_Raw]. Sa_Id:" &
--        Lib_Icm_Sw_If_Types.Uint32_T'Image(Sa_Id) & " Dw_N:" &
--        Lib_Icm_Sw_If_Types.Uint32_T'Image(Dw_N));

      if Local_Result /= Bus_1553_Pus_Types.Ok_Result_C then
         Debug_Log.Do_Log
           ("[Bus_Rt_Icm Bus_1553_Tx_Sa_Raw]. Error in Set_Data_Tx Resul: " &
             Basic_Types_I.Uint32_T'Image(Local_Result));
      end if;
   end Bus_1553_Rx_Sa_Raw;

   procedure Bus_1553_Pus_Rx_Sa_Info
     (Sa_Id_Raw : in Lib_Icm_Sw_If_Types.Uint32_T;
      Tc_N      : out Lib_Icm_Sw_If_Types.Uint32_T)
   is
      Local_Tc_N : Basic_Types_I.Unsigned_32_T    := 0;
      Sa_Id      : Basic_Types_1553.Sa_Id_T       := Basic_Types_1553.Sa_Id_T'First;
   begin

      Tc_N  := 0;
      Sa_Id := Basic_Types_1553.Sa_Id_T (Sa_Id_Raw);

      Rt_Nominal.Get_Rx_Sa_Info
        (Sa_Id => Sa_Id,
         Tc_N  => Local_Tc_N);

      Tc_N := Lib_Icm_Sw_If_Types.Uint32_T (Local_Tc_N);

   exception
      when Event : others =>
         Debug_Log.Do_Log ("[Bus_Rt_Icm Bus_1553_Pus_Rx_Sa_Info]Except: " &
           Ada.Exceptions.Exception_Information (Event));

   end Bus_1553_Pus_Rx_Sa_Info;

   procedure Bus_1553_Pus_Rx_Sa_First_Tc
     (Sa_Id_Raw : in Lib_Icm_Sw_If_Types.Uint32_T;
      Data_Addr : in System.Address;
      Bytes_N   : out Lib_Icm_Sw_If_Types.Uint32_T)
   is
      Sa_Id          : Basic_Types_1553.Sa_Id_T       := Basic_Types_1553.Sa_Id_T'First;
      Last_I         : Basic_Types_I.Unsigned_32_T    := 0;
      Local_Bytes_N  : Basic_Types_I.Unsigned_32_T    := 0;
   begin

      Bytes_N := 0;
      Sa_Id := Basic_Types_1553.Sa_Id_T (Sa_Id_Raw);

      Rt_Nominal.Get_Rx_Sa_First_Tc
        (Sa_Id     => Sa_Id,
         Ptr_Data  => Data_Addr,
         Bytes_N   => Local_Bytes_N);

      Bytes_N := Lib_Icm_Sw_If_Types.Uint32_T (Local_Bytes_N);

   exception
      when Event : others =>
         Debug_Log.Do_Log ("[Bus_Rt_Icm Bus_1553_Pus_Rx_Sa_First_Tc]Except: " &
           Ada.Exceptions.Exception_Information (Event));

   end Bus_1553_Pus_Rx_Sa_First_Tc;

   procedure Bus_1553_Pus_Sa_Reset
     (Sa_Id_Raw : in Lib_Icm_Sw_If_Types.Uint32_T)
   is
      Sa_Id : Basic_Types_1553.Sa_Id_T := Basic_Types_1553.Sa_Id_T'First;
   begin

      Sa_Id := Basic_Types_1553.Sa_Id_T (Sa_Id_Raw);
      Rt_Nominal.Reset_Sa
        (Sa_Id    => Sa_Id);

   exception
      when Event : others =>
         Debug_Log.Do_Log ("[Bus_Rt_Icm Bus_1553_Pus_Sa_Reset]Except: " &
           Ada.Exceptions.Exception_Information (Event));
   end Bus_1553_Pus_Sa_Reset;


end Bus_Rt_Icm;

