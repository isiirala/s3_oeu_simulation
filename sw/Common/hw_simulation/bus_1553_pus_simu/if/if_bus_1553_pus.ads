
with System;

with Basic_Types_1553;
with Basic_Types_I;

with Bus_1553_Pus_Types;

package If_Bus_1553_Pus is



-- --------------------------------------------------------------------------------------
--  Sub Address interface (SA)
-- --------------------------------------------------------------------------------------

   type If_Bus_1553_Pus_Sa_T is limited interface;
   type Acc_Bus_1553_Pus_Sa_T is access all
     If_Bus_1553_Pus_Sa_T'Class;


   type Copy_Sa_Data_Routine_T is access procedure
     (Rt_Id      : in Basic_Types_1553.Rt_Id_T;
      Sa_Id      : in Basic_Types_1553.Sa_Id_T;
      Sa_Data    : in Basic_Types_I.Byte_Array_T);


   procedure Append_Data
     (Sa            : not null access If_Bus_1553_Pus_Sa_T;
      Data          : in Basic_Types_I.Byte_Array_T;
      Frames_Latch  : out Boolean;
      Result        : out Basic_Types_I.Unsigned_32_T)
   is abstract;
   -- Apend data in the SA buffer. Frames_Latch is active if frames limit is reached.
   -- The frames limit is not related with the length of the SA buffer.
   -- If Result /= OK the data is not appended to the SA buffer

   procedure Append_Data
     (Sa            : not null access If_Bus_1553_Pus_Sa_T;
      Ptr_Data      : in System.Address;
      Dw_N          : in Basic_Types_I.Unsigned_32_T;
      Frames_Latch  : out Boolean;
      Result        : out Basic_Types_I.Unsigned_32_T)
   is abstract;
   -- Apend data in the SA buffer. Frames_Latch is active if frames limit is reached.
   -- The frames limit is not related with the length of the SA buffer.
   -- If Result /= OK the data is not appended to the SA buffer

   procedure Retrieve_Data
     (Sa        : not null access If_Bus_1553_Pus_Sa_T;
      Data      : in out Basic_Types_1553.Sa_Data_Buff_T;
      Last_I    : out Basic_Types_1553.Sa_Data_Range_T;
      Empty     : out Boolean)
   is abstract;

   procedure Retrieve_All_Data
     (Sa        : not null access If_Bus_1553_Pus_Sa_T;
      Ptr_Data  : in System.Address;
      Dw_N      : out Basic_Types_I.Unsigned_32_T)
   is abstract;

   procedure Retrieve_Data
     (Sa                : not null access If_Bus_1553_Pus_Sa_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Copy_Sa_Data_Proc : in Copy_Sa_Data_Routine_T;
      Bytes_Count       : out Basic_Types_I.Unsigned_32_T)
   is abstract;

   procedure Retrieve_First_Frame
     (Sa        : not null access If_Bus_1553_Pus_Sa_T;
      Frame     : in out Basic_Types_1553.Sa_Data_Frame_T)
   is abstract;


   procedure Set_As_Empty
     (Sa        : not null access If_Bus_1553_Pus_Sa_T)
   is abstract;


   function Get_Ptr_To_Data
     (Sa        : not null access If_Bus_1553_Pus_Sa_T) return System.Address
   is abstract;

   function Get_Last_Index
     (Sa        : not null access If_Bus_1553_Pus_Sa_T)
     return Basic_Types_1553.Sa_Data_Range_T
   is abstract;


   function Is_Data_Empty
     (Sa        : not null access If_Bus_1553_Pus_Sa_T) return Boolean
   is abstract;
   -- Return True if internal data buffer is empty

   function Get_Frames_Before_Int
     (Sa        : not null access If_Bus_1553_Pus_Sa_T) return Basic_Types_I.Uint32_T
   is abstract;
   -- Return the number of input frames configured to generate the latch interrupt to
   -- the receiver user

   function Get_Id
     (Sa       : not null access If_Bus_1553_Pus_Sa_T) return Basic_Types_1553.Sa_Id_T
   is abstract;








-- --------------------------------------------------------------------------------------
--  RT for BC interface
-- --------------------------------------------------------------------------------------

   type If_Bus_1553_Pus_Rt_For_Bc_T  is limited interface;
   type Acc_Bus_1553_Pus_Rt_For_Bc_T is access all If_Bus_1553_Pus_Rt_For_Bc_T'Class;


   procedure Rt_For_Bc_Set_Data_Rx
     (Rt_For_Bc : not null access If_Bus_1553_Pus_Rt_For_Bc_T;
      Sa_Id     : in Basic_Types_1553.Sa_Id_T;
      Ptr_Data  : in System.Address;
      Dw_N      : in Basic_Types_I.Unsigned_32_T;
      Result    : out Basic_Types_I.Unsigned_32_T)
   is abstract;

   procedure Rt_For_Bc_Get_Data_Tx
     (Rt_For_Bc         : not null access If_Bus_1553_Pus_Rt_For_Bc_T;
      Sa_Id             : in Basic_Types_1553.Sa_Id_T;
      Copy_Sa_Data_Proc : in Copy_Sa_Data_Routine_T;
      Bytes_Count       : out Basic_Types_I.Unsigned_32_T)
   is abstract;


   procedure Rt_For_Bc_Get_First_Frame_Tx
     (Rt_For_Bc : not null access If_Bus_1553_Pus_Rt_For_Bc_T;
      Sa_Id     : in Basic_Types_1553.Sa_Id_T;
      Frame     : in out Basic_Types_1553.Sa_Data_Frame_T)
   is abstract;



   procedure Rt_For_Bc_Send_Mode_Code
     (Rt_For_Bc         : not null access If_Bus_1553_Pus_Rt_For_Bc_T;
      Mc_Vector         : in Basic_Types_I.Unsigned_32_T)
   is abstract;

   procedure Rt_For_Bc_Send_Pps
     (Rt_For_Bc         : not null access If_Bus_1553_Pus_Rt_For_Bc_T)
   is abstract;

   procedure Rt_For_Bc_Time_Distribution
     (Rt_For_Bc         : not null access If_Bus_1553_Pus_Rt_For_Bc_T;
      Raw_Time          : in Basic_Types_1553.Raw_Time_Msg_T;
      Error             : out Boolean)
   is abstract;



-- --------------------------------------------------------------------------------------
--  BC for RT interface
-- --------------------------------------------------------------------------------------

   type If_Bus_1553_Pus_Bc_For_Rt_T is limited interface;
   type Acc_Bus_1553_Pus_Bc_For_Rt_T is access all
     If_Bus_1553_Pus_Bc_For_Rt_T'Class;

   procedure Bc_For_Rt_Declare_Rt
     (Bc_For_Rt         : not null access If_Bus_1553_Pus_Bc_For_Rt_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Rt                : in Acc_Bus_1553_Pus_Rt_For_Bc_T)
--      Write_Input_Sa_Cb : in Bus_1553_Pus_Types.Write_Input_Sa_Cb_T)
   is abstract;


   procedure Bc_For_Rt_Set_Data_Tx
     (Bc_For_Rt : not null access If_Bus_1553_Pus_Bc_For_Rt_T;
      Rt_Id     : in Basic_Types_1553.Rt_Id_T;
      Sa        : not null access If_Bus_1553_Pus_Sa_T'Class)
   is abstract;
   --************************************************************************************
   -- PURPOSE: Interface of BC for RT. A RT use this routine to inform to the BC that
   --   a new message is in the output SA
   --************************************************************************************


-- --------------------------------------------------------------------------------------
--  BC for User interface
-- --------------------------------------------------------------------------------------

   type If_Bus_1553_Pus_Bc_For_User_T is limited interface;
--   type Bus_1553_Pus_Bc_For_User_T is access all
--     If_Bus_1553_Pus_Bc_For_User_T'Class;

--   procedure Bc_For_User_Init(
--     Bc_For_User   : in Bus_1553_Pus_Bc_For_User_T;
--     Result        : out Basic_Types_I.Unsigned_32_T) is abstract;

   procedure Bc_For_User_Set_Transaction(
--     Bc_For_User   : in If_Bus_1553_Pus_Bc_For_User_T;
     Bc            : not null access If_Bus_1553_Pus_Bc_For_User_T;
     Sa_Id         : in Basic_Types_I.Unsigned_32_T;
     Tx_Or_Rx      : in Boolean;
     Msg_N         : in Basic_Types_I.Unsigned_32_T;
     Result        : out Basic_Types_I.Unsigned_32_T) is abstract;

   procedure Bc_For_User_Set_Data_Tx(
--     Bc_For_User   : in If_Bus_1553_Pus_Bc_For_User_T;
     Bc            : not null access If_Bus_1553_Pus_Bc_For_User_T;
     Rt_Id         : in Basic_Types_1553.Rt_Id_T;
     Sa_Id         : in Basic_Types_I.Unsigned_32_T;
     Ptr_Data      : in System.Address;
     Dw_N          : in Basic_Types_I.Unsigned_32_T;
     Result        : out Basic_Types_I.Unsigned_32_T) is abstract;

   procedure Bc_For_User_Retrieve -- _Rt
     (Bc                : not null access If_Bus_1553_Pus_Bc_For_User_T;
--      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Copy_Sa_Data_Proc : in Copy_Sa_Data_Routine_T;
      Bytes_Limit       : in Basic_Types_I.Unsigned_32_T;
      Bytes_Actual      : out Basic_Types_I.Unsigned_32_T;
      Result            : out Basic_Types_I.Unsigned_32_T) is abstract;


   procedure Bc_For_User_Send_Transfer_Ack
     (Bc                : not null access If_Bus_1553_Pus_Bc_For_User_T) is abstract;

   procedure Bc_For_User_Send_Mode_Code
     (Bc                : not null access If_Bus_1553_Pus_Bc_For_User_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Mc_Vector         : in Basic_Types_I.Unsigned_32_T) is abstract;

   procedure Bc_For_User_Send_Pps
     (Bc                : not null access If_Bus_1553_Pus_Bc_For_User_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T) is abstract;

   procedure Bc_For_User_Time_Distribution
     (Bc                : not null access If_Bus_1553_Pus_Bc_For_User_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Raw_Time_Msg      : in Basic_Types_1553.Raw_Time_Msg_T) is abstract;

   type If_Bus_1553_Pus_Bc_T is limited interface and
     If_Bus_1553_Pus_Bc_For_Rt_T and
     If_Bus_1553_Pus_Bc_For_User_T;



-- --------------------------------------------------------------------------------------
--  RT for User interface
-- --------------------------------------------------------------------------------------

   type If_Bus_1553_Pus_Rt_For_User_T is limited interface;
--   type Bus_1553_Pus_Rt_For_User_T is access all
--     If_Bus_1553_Pus_Rt_For_User_T'Class;


--   procedure Rt_For_User_Init
--     (Rt_Id         : in Basic_Types_1553.Rt_Id_T;
--      Bc_For_Rt_If  : in If_Bus_1553_Pus_Bc_For_Rt.Bus_1553_Pus_Bc_For_Rt_T;
--      Rt_For_User   : in out If_Bus_1553_Pus_Rt_For_User_T;
--      Result        : out Basic_Types_I.Unsigned_32_T) is abstract;

   procedure Rt_For_User_Set_Transaction
     (Rt            : not null access If_Bus_1553_Pus_Rt_For_User_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Tx_Or_Rx      : in Boolean;
      Msg_N         : in Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T) is abstract;

   procedure Rt_For_User_Set_Data_Tx
     (Rt            : not null access If_Bus_1553_Pus_Rt_For_User_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data      : in System.Address;
      Dw_N          : in Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T) is abstract;


   procedure Rt_For_User_Get_Data_Rx
     (Rt            : not null access If_Bus_1553_Pus_Rt_For_User_T;
      Sa_Raw_Id     : in Basic_Types_I.Unsigned_32_T;
      Ptr_Data      : in System.Address;
      Dw_N          : out Basic_Types_I.Unsigned_32_T;
      Result        : out Basic_Types_I.Unsigned_32_T) is abstract;


   type If_Bus_1553_Pus_Rt_T is limited interface and
     If_Bus_1553_Pus_Rt_For_Bc_T and
     If_Bus_1553_Pus_Rt_For_User_T;



end If_Bus_1553_Pus;
