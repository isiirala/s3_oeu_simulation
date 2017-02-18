
with Ada.Calendar;

with Basic_Types_1553;
with Basic_Types_I;
with If_Bus_1553_Pus;
with Bus_1553_Pus_Types;
with Smu_Data;
with Smu_1553_Types;

package Bc_Smu_Oeu is





   procedure Init
     (Bc_Access_For_Rts : out If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T);


   procedure Do_Retrieve_Tm
     (Limit_Bytes  : in Basic_Types_I.Unsigned_32_T;
      Actual_Bytes : out Basic_Types_I.Unsigned_32_T);
   --************************************************************************************
   --  PURPOSE: Goes from one RT to another retrieving the TM blocks ready to be
   --    transmited to the BC. The RT are not informed that the TM block is transmitted
   --  PARAMETERS:
   --    Limit_Bytes: Number of bytes who is used to stop the retrieval when it is
   --      reached. But the TM blocks are whole retrieved
   --    Actual_Bytes: Actual number of bytes retrieved
   --************************************************************************************


   procedure Get_A_Tm_Block
     (Tm_Block_Data  : in out Smu_1553_Types.Tm_Block_Container_T;
      Last_Index     : out Basic_Types_I.Unsigned_32_T;
      Tm_Block_Info  : out Smu_1553_Types.Tm_Block_Info_T);
   --************************************************************************************
   --  PURPOSE: Returns one TM block received from any RT
   --  PARAMETERS:
   --    Tm_Block_Data: Data of the TM block
   --    Last_Index: Last valid byte in the previous TM block buffer
   --    Tm_Block_Info: Extra information about the received TM Block
   --************************************************************************************

   procedure Ack_Retrieved_Tms;
   --************************************************************************************
   --  PURPOSE: Issue the Transfer ACK Message to all connected RTs.
   --    This message informs to the RTs about the TM blocks really transmitted (= read
   --    by current BC).
   --************************************************************************************


   procedure Transmit_Tcs;
   --************************************************************************************
   --  PURPOSE: Transmit TCs from TC Buffers to all connected RTs.
   --    This routine must be called each second.
   --    It sends to each RT up to the maximum number of TCs that can be received
   --    in one second.
   --************************************************************************************


   procedure Send_Sync_With_Data_Word;
   --************************************************************************************
   --  PURPOSE: Send Synchronization with Data Word to all connected RTs.
   --************************************************************************************

   procedure Send_Pps;
   --************************************************************************************
   --  PURPOSE: Send PPS signal to all connected RTs.
   --************************************************************************************

   procedure Time_Distribution;
   --************************************************************************************
   --  PURPOSE: Send time distribution message to all connected RTs. This is a raw
   --    message (not a PUS format message) with the CUC time of the current cycle, i.e.
   --    the RT must increment in one second before use it at the next cycle
   --************************************************************************************


end Bc_Smu_Oeu;

