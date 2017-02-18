
with Ada.Exceptions;


with Bc_Smu_Oeu;
with Debug_Log;
with Pus;
with Smu_1553_Log;


package body Smu_1553_Handler is

-- TODO: SI EL BUFFER DEL LOG SE DESBORDA HAY QUE PONER UN MENSAJE DE ERROR EN EL LOG Y EN EL PROPIO LOG
-- TODO: Falta Poll_Request

-- Stepts of the handler of the 1553 bus taking into account that it is called
-- each 125 ms to implement a bus cycle of 1 second (8 operations)
   type Bc_Steps_T is (Step_Empty_1, Step_Transmit, Step_Mc_Send, Step_Retrieve,
     Step_Empty_2, Step_Ack, Step_Time, Step_Poll_Request);


   Oeu_Step             : Bc_Steps_T                 := Bc_Steps_T'First;
   -- Step to execute in the internal scheduler implemented in the Do_Step procedure


   procedure Do_Init is
   begin
      null;
   end Do_Init;


   procedure Do_Step
     (First_Part_Cycle : in Boolean;
      One_Second_Cycle : in Boolean)
   --************************************************************************************
   --  IMPLEMENTATION:
   --   This routine is called each 125/2 ms: for each 1553 bus sub-frame it is called
   --   twice. The job of the 1553 scheduler handler is divided into two parts. At the
   --   first part of the cycle the routine sends the Synchronization With Data Word
   --   mode code and the PPS, in the second part of the cycle the routine implements
   --   the rest of job for the 1553 pus protocol as follows:

   --  0      125       250       375       500       625       750       875      1000
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
   -- --------------------------------------------------------------------------------
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    |- Poll
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |    |    request
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |    |- S. W D.W.
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |    |    |    |    |- Send time mess
   --  |   |   |    |    |    |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |    |    |    |- Send S. With D.W.
   --  |   |   |    |    |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |    |    |- Send Transfer Ack message
   --  |   |   |    |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |    |- Send S. With D.W.
   --  |   |   |    |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |    |- empty
   --  |   |   |    |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |    |- Send S. With D.W.
   --  |   |   |    |    |    |    |    |
   --  |   |   |    |    |    |    |    |- Retrieve TMs
   --  |   |   |    |    |    |    |
   --  |   |   |    |    |    |    |- Send S. With D.W.
   --  |   |   |    |    |    |
   --  |   |   |    |    |    |- Send Mode Codes
   --  |   |   |    |    |
   --  |   |   |    |    |- Send S. With D.W.
   --  |   |   |    |
   --  |   |   |    |- Transmit TCs
   --  |   |   |
   --  |   |   |- Send S. With D.W.
   --  |   |
   --  |   |- empty
   --  |
   --  |- Send Sync With Data Word
   --  |- Send PPS
   --
   --
   --************************************************************************************
   is
      use type Basic_Types_I.Unsigned_32_T;

      Bytes_Limit_Rx_C      : constant Basic_Types_I.Unsigned_32_T := 1000;
      Bytes_Limit_Tx_C      : constant Basic_Types_I.Unsigned_32_T := 1000;
      Num_Tm_Block_Decode_C : constant Basic_Types_I.Unsigned_32_T := 5;

      Actual_Bytes_Rx       : Basic_Types_I.Unsigned_32_T          := 0;
      Actual_Bytes_Tx       : Basic_Types_I.Unsigned_32_T          := 0;
   begin

      if First_Part_Cycle then
-- First part of the cycle, used to send the Synchronized with Data Word Mode Code
-- and possible PPS
         Bc_Smu_Oeu.Send_Sync_With_Data_Word;

         if One_Second_Cycle then
-- In the first part of the cycle, send PPS signal each second
            Bc_Smu_Oeu.Send_Pps;
         end if;

      else

-- Second part of the cycle, used to do the corresponding 1553 action cycle
         case Oeu_Step is
            when Step_Empty_1  => Oeu_Step := Step_Transmit;

            when Step_Transmit =>

-- Transmit TCs from TC buffers to the RTs. Send to each RT the max number of TCs that
-- can receive in a second cycle. For example OEU can receive up to 10 TCs
               Bc_Smu_Oeu.Transmit_Tcs;

               Oeu_Step := Step_Mc_Send;

            when Step_Mc_Send  =>

               Oeu_Step := Step_Retrieve;

            when Step_Retrieve =>

-- Receive TMs (complete TMs until reach the words limit) in input buffer
               Bc_Smu_Oeu.Do_Retrieve_Tm
                 (Limit_Bytes  => Bytes_Limit_Rx_C,
                  Actual_Bytes => Actual_Bytes_Rx);

               if Actual_Bytes_Rx > 0 then
                  Debug_Log.Do_Log("Smu_1553_Handler.Do_Step/Retrieved ActualBytes:" &
                    Basic_Types_I.Unsigned_32_T'Image (Actual_Bytes_Rx));
               end if;
               Oeu_Step := Step_Empty_2;

            when Step_Empty_2 => Oeu_Step := Step_Ack;

            when Step_Ack =>

-- Send Transfer Ack message about the retrieved TMs
               Bc_Smu_Oeu.Ack_Retrieved_Tms;

-- Decode received TMs in the SMU 1553 log
               Smu_1553_Log.Decode_Tms (Num_Tm_Block_Decode_C);
--               Debug_Log.Do_Log("Smu_1553_Handler.Do_Step/Ack");

               Oeu_Step := Step_Time;

            when Step_Time =>
--22
               Bc_Smu_Oeu.Time_Distribution;
               Oeu_Step := Step_Poll_Request;

            when Step_Poll_Request =>
--22
-- Get the Transfer Requests Messages from the RTs


               Oeu_Step := Step_Empty_1;

         end case;
      end if;
   exception
      when Event : others =>
         Debug_Log.Do_Log("[smu_1553_handler Do_Step] Except: " &
           Ada.Exceptions.Exception_Information (Event));
   end Do_Step;



end Smu_1553_Handler;

