
with System;


with Basic_Types_1553;
with Basic_Types_I;
with If_Bus_1553_Pus;
--with If_Bus_1553_Pus_Bc_For_Rt;
--with If_Bus_1553_Pus_Bc_For_User;

package Bus_1553_Pus.Bc is


   Max_Bytes_In_Sa_C   : constant := 1024;

   type Bus_1553_Pus_Bc_Record_T is new Bus_1553_Pus_Record_T and
     If_Bus_1553_Pus.If_Bus_1553_Pus_Bc_T  with private;

   type Bus_1553_Pus_Bc_T is access all Bus_1553_Pus_Bc_Record_T'Class;


-- BC Error codes
--   Ok_Result_C            : constant Basic_Types_I.Unsigned_32_T := 0;

-- The user command to use a RT that is disconnected
--   Fail_Rt_Disconnected_C : constant Basic_Types_I.Unsigned_32_T := 100;

-- The SA info in the Transfer Request message does not match with data
-- received in the SA
--   Fail_Trans_Request_C   : constant Basic_Types_I.Unsigned_32_T := 101;


   procedure Create_New
     (Bc          : out Bus_1553_Pus_Bc_T;
      Bus_Id      : in Basic_Types_I.Uint32_T;
      Bus_Title   : in Basic_Types_I.String_10_T);
   procedure Initialize
     (Bc          : not null access Bus_1553_Pus_Bc_Record_T'Class;
      Bus_Id      : in Basic_Types_I.Uint32_T;
      Bus_Title   : in Basic_Types_I.String_10_T);


--   procedure Bc_For_User_Init
--     (Bc_For_User   : in Bus_1553_Pus_Bc_Record_T;
--      Result        : out Basic_Types_I.Unsigned_32_T);


   procedure Bc_For_User_Set_Transaction
     (Bc          : not null access Bus_1553_Pus_Bc_Record_T;
      Sa_Id       : in Basic_Types_I.Unsigned_32_T;
      Tx_Or_Rx    : in Boolean;
      Msg_N       : in Basic_Types_I.Unsigned_32_T;
      Result      : out Basic_Types_I.Unsigned_32_T);

   procedure Bc_For_User_Set_Data_Tx
     (Bc         : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id      : in Basic_Types_1553.Rt_Id_T;
      Sa_Id      : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data   : in System.Address;
      Dw_N       : in Basic_Types_I.Unsigned_32_T;
      Result     : out Basic_Types_I.Unsigned_32_T);
--***************************************************************************************
-- PURPOSE: The BC simulation uses this procedure to send a new TC block to a RT
-- PARAMS:
--***************************************************************************************

   procedure Bc_For_User_Retrieve -- _Rt
     (Bc                : not null access Bus_1553_Pus_Bc_Record_T;
--      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Limit       : in Basic_Types_I.Unsigned_32_T;
      Bytes_Actual      : out Basic_Types_I.Unsigned_32_T;
      Result            : out Basic_Types_I.Unsigned_32_T);
   --************************************************************************************
   -- PURPOSE: Retrieve TM blocks of a RT. The TM data is copied using an access
   --   procedure.
   --   The retrieval means that the RT TM has been transmitted from the RT to the BC
   -- PARAMETERS:
   --   Bc: BC tagged type
   --   Rt_Id: Id of the RT to do TM Retrieve
   --   Copy_Sa_Data_Proc : Access procedure to copy the TM block of an output SA
   --   Bytes_Limit: When the amount of data bytes read in current RT reaches this limit
   --     the retrieval is stopped.
   --   Bytes_Actual: Actual number of bytes retrieved, because the TM blocks are
   --     retrieved completed
   --   Result: Error condition
   --************************************************************************************

   procedure Bc_For_User_Send_Transfer_Ack
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T);
   --************************************************************************************
   -- PURPOSE: Send the corresponding Transfer ACK Message to all RT
   -- PARAMETERS:
   --   Bc: BC tagged type
   --************************************************************************************

   procedure Bc_For_User_Send_Mode_Code
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id     : in Basic_Types_1553.Rt_Id_T;
      Mc_Vector : in Basic_Types_I.Unsigned_32_T);
   --************************************************************************************
   -- PURPOSE: Send a 1553 Mode Code to a RT
   -- PARAMETERS:
   --   Bc        : BC tagged type
   --   Rt_Id     : Id of the RT to do send the MC
   --   Mc_Vector : Array of bits with the MC to send
   --************************************************************************************

   procedure Bc_For_User_Send_Pps
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id     : in Basic_Types_1553.Rt_Id_T);
   --************************************************************************************
   -- PURPOSE: Send the PPS signal to a RT
   -- PARAMETERS:
   --   Bc        : BC tagged type
   --   Rt_Id     : Id of the RT to do send the PPS
   --************************************************************************************

   procedure Bc_For_User_Time_Distribution
     (Bc            : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id         : in Basic_Types_1553.Rt_Id_T;
      Raw_Time_Msg  : in Basic_Types_1553.Raw_Time_Msg_T);



   procedure Bc_For_Rt_Declare_Rt
     (Bc                : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Rt                : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Rt_For_Bc_T);

   procedure Bc_For_Rt_Set_Data_Tx
     (Bc        : not null access Bus_1553_Pus_Bc_Record_T;
      Rt_Id     : in Basic_Types_1553.Rt_Id_T;
      Sa        : not null access If_Bus_1553_Pus.If_Bus_1553_Pus_Sa_T'Class);
   --************************************************************************************
   -- PURPOSE: A RT use this routine to inform to the BC that a new message is in the
   --   output SA
   --************************************************************************************

private


--   type Rt_Sa_T is record
--      Used       : Boolean;
--      Ptr_Data   : System.Address;
--      Dw_N       : Basic_Types_I.Unsigned_32_T;
--   end record;
--   type Rt_Arr_Sa_T is array (Basic_Types_1553.Sa_Id_T'Range) of Rt_Sa_T;



   type Rt_T is record
      Used                        : Boolean;

--      Write_Input_Sa_Cb : Bus_1553_Pus_Types.Write_Input_Sa_Cb_T;

-- TODO: ESTAS SAs SON TODAS DE RECEPCIÓN, NO? PORQUE LAS DE TX SE MANDAN DIRECTAMENTE A LOS RT, NO?
--      Sa_Data       : Rt_Arr_Sa_T;
      Last_Sa_Rx                  : Bus_1553_Pus_Types.Sa_Tm_Transfer_T;
      Trans_Request               : Bus_1553_Pus_Types.Trans_Request_T;
      Trans_Ack                   : Bus_1553_Pus_Types.Trans_Ack_T;
      Trans_Ack_Empty             : Boolean;
      Trans_Ack_Empty_Transmitted : Boolean;

      Acc_Rt                      : If_Bus_1553_Pus.Acc_Bus_1553_Pus_Rt_For_Bc_T;
      -- Access to the RT object to transmit messages and MC

   end record;
   type Rt_Addr_T is access Rt_T;
   type Rt_Arr_T is array (Basic_Types_1553.Rt_Id_T'Range) of Rt_T;




   type Bus_1553_Pus_Bc_Record_T is new Bus_1553_Pus_Record_T and
     If_Bus_1553_Pus.If_Bus_1553_Pus_Bc_T with record

      Bus_Id            : Basic_Types_I.Uint32_T;
      -- Idenfifier of the 1553 Bus

      Bus_Title         : Basic_Types_I.String_10_T;
      -- Text title of the 1553 Bus

      Rt_Data           : Rt_Arr_T;
      -- Array of data for each RT

      Rt_Last_Retrieve  : Basic_Types_1553.Rt_Id_T;
      -- Last RT used in the last Retrieve TM operation

   end record;


end Bus_1553_Pus.Bc;

