

with Basic_Types_1553;
with Basic_Types_I;
with Bus_1553_Pus.Bc;
with If_Bus_1553_Pus;


package Bus_1553_Pus.Rt_Sa is

   type Bus_1553_Pus_Rt_Sa_Record_T is new Bus_1553_Pus_Record_T and
     If_Bus_1553_Pus.If_Bus_1553_Pus_Sa_T with private;

   type Bus_1553_Pus_Rt_Sa_T is access all Bus_1553_Pus_Rt_Sa_Record_T'Class;

   procedure Create_New
     (Sa_Id             : in Basic_Types_1553.Sa_Id_T;
      Frames_Before_Int : in Basic_Types_I.Unsigned_32_T;
      Sa                : out Bus_1553_Pus_Rt_Sa_T);
   procedure Initialize
     (Sa                : access Bus_1553_Pus_Rt_Sa_Record_T'Class;
      Sa_Id             : in Basic_Types_1553.Sa_Id_T;
      Frames_Before_Int : in Basic_Types_I.Unsigned_32_T);

--   procedure Set_Data
--     (Sa       : in out Bus_1553_Pus_Rt_Sa_T;
--      Data     : in Sa_Data_T;
--      Used_Len : in Sa_Data_Range_T);



   procedure Append_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Data          : in Basic_Types_I.Byte_Array_T;
      Frames_Latch  : out Boolean;
      Result        : out Basic_Types_I.Unsigned_32_T);
   -- Apend data in the SA buffer. Frames_Latch is active if frames limit is reached.
   -- The frames limit is not related with the length of the SA buffer.
   -- If Result /= OK the data is not appended to the SA buffer

   procedure Append_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Ptr_Data      : in System.Address;
      Dw_N          : in Basic_Types_I.Unsigned_32_T;
      Frames_Latch  : out Boolean;
      Result        : out Basic_Types_I.Unsigned_32_T);
   -- Apend data in the SA buffer. Frames_Latch is active if frames limit is reached.
   -- The frames limit is not related with the length of the SA buffer.
   -- If Result /= OK the data is not appended to the SA buffer

   procedure Set_Data
     (Sa            : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Data          : in Basic_Types_I.Byte_Array_T;
      Result        : out Basic_Types_I.Unsigned_32_T);
   -- Overwrite the data of the SA starting from first frame. Used to TX of time message




--   procedure Get_Data
--     (Sa       : in Bus_1553_Pus_Rt_Sa_T;
--      Data     : in out Sa_Data_T;
--      Used_Len : out Sa_Data_Range_T);

   procedure Retrieve_Data
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Data      : in out Basic_Types_1553.Sa_Data_Buff_T;
      Last_I    : out Basic_Types_1553.Sa_Data_Range_T;
      Empty     : out Boolean);

   procedure Retrieve_All_Data
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Ptr_Data  : in System.Address;
      Dw_N      : out Basic_Types_I.Unsigned_32_T);

   procedure Retrieve_Data
     (Sa                : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Rt_Id             : in Basic_Types_1553.Rt_Id_T;
      Copy_Sa_Data_Proc : in If_Bus_1553_Pus.Copy_Sa_Data_Routine_T;
      Bytes_Count       : out Basic_Types_I.Unsigned_32_T);


   procedure Retrieve_First_Frame
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Frame     : in out Basic_Types_1553.Sa_Data_Frame_T);


   procedure Set_As_Empty
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T);


   function Get_Ptr_To_Data
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T) return System.Address;

   function Get_Last_Index
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_1553.Sa_Data_Range_T;

   function Is_Data_Empty
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T) return Boolean;
   -- Return True if internal data buffer is empty

   function Get_Frames_Before_Int
     (Sa        : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_I.Uint32_T;
   -- Return the number of input frames configured to generate the latch interrupt to
   -- the receiver user

   function Get_Id
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_1553.Sa_Id_T;

-- --------------------------------------------------------------------------------------
-- Rountines not declared in the interface (begin)

   function Get_Nun_Pus_Tc
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T)
   return Basic_Types_I.Unsigned_32_T;

   procedure Retrieve_First_Pus_Tc
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Tc_Data  : in out Basic_Types_I.Byte_Array_T;
      Last_I   : out Basic_Types_I.Unsigned_32_T);

   procedure Retrieve_First_Pus_Tc
     (Sa       : not null access Bus_1553_Pus_Rt_Sa_Record_T;
      Ptr_Data : in System.Address;
      Bytes_N  : out Basic_Types_I.Unsigned_32_T);

-- Rountines not declared in the interface (end)
-- --------------------------------------------------------------------------------------


private


   type Bus_1553_Pus_Rt_Sa_Record_T is new Bus_1553_Pus_Record_T and
     If_Bus_1553_Pus.If_Bus_1553_Pus_Sa_T with record

      Sa_Id             : Basic_Types_1553.Sa_Id_T;
      -- Id number of the SA for debugging purposes

      Sa_Data           : Basic_Types_1553.Sa_Data_Buff_T;
      -- Data buffer of the SA

      First_I           : Basic_Types_1553.Sa_Data_Range_T;
      -- First used index in the Sa_Data array.

      Last_I            : Basic_Types_1553.Sa_Data_Range_T;
      -- Last used index in the Sa_Data array. When 1 the SA could be empty

      Current_Frames_N  : Basic_Types_1553.Frame_Range_Ne_T;
      -- Number of frames held in this SA. When 0 the SA is empty

      Frames_Before_Int : Basic_Types_1553.Frame_Range_Ne_T;
      -- Number of 1553 frames before interrupt. If 0 no generate any interrupt

   end record;

end Bus_1553_Pus.Rt_Sa;

