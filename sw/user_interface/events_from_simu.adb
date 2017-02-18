

with Debug_Log;

package body Events_From_Simu is


   type Target_Cb_T is record
     Enabled       : Boolean;
     Cb            : Receiver_Cb;
--     User_Num      : Basic_Types_I.Uint32_T;
   end record;




   type Array_Cb_T is array (N_Receivers_T'Range) of Target_Cb_T;

   type Receiver_T is record
     Empty         : Boolean;
     N_Cb          : N_Receivers_T;
     Array_Cb      : Array_Cb_T;
   end record;


   type Array_Receivers_T is array (Event_T'Range) of Receiver_T;


   Array_Receivers    : Array_Receivers_T       := (others =>
     (Empty     => True,
      N_Cb      => N_Receivers_T'First,
      Array_Cb  => (others => (Enabled   => False, Cb => null)))); --, User_Num => 0))));

--  User_Counter     : Basic_Types_I.Uint32_T    :=  0;



   procedure Create_Receiver
     (Event_Id    : in Event_T;
      User_Cb     : in Receiver_Cb;
      Receiver_Id : out Receiver_Id_T)
   is
--      use type Basic_Types_I.Uint8_T;
      use type Basic_Types_I.Uint32_T;

   begin

      if Array_Receivers (Event_Id).N_Cb < N_Receivers_T'Last then

--         User_Counter := User_Counter + 1;
         if Array_Receivers (Event_Id).Empty then
            Array_Receivers (Event_Id).Empty := False;
            Array_Receivers (Event_Id).N_Cb  := N_Receivers_T'First;
         else
            Array_Receivers (Event_Id).N_Cb  := Array_Receivers (Event_Id).N_Cb + 1;
         end if;
         Array_Receivers (Event_Id).Array_Cb (Array_Receivers (Event_Id).N_Cb) :=
           (Enabled     => True,
            Cb          => User_Cb); --,
--            User_Num    => User_Counter);

         Receiver_Id :=
           (Empty        => False,
            Event        => Event_Id,
            Receiver_Num => Array_Receivers (Event_Id).N_Cb);
      else
         Debug_Log.Do_Log (" [Events_From_Simu.Set_Receiver]Error: Receivers Overflow!");
         Receiver_Id := Null_Receiver_Id_C;
      end if;
   end Create_Receiver;

   procedure Pause_Receiver
     (Receiver_Id : in Receiver_Id_T)
   is
--      use type Basic_Types_I.Uint8_T;
      use type Basic_Types_I.Uint32_T;

--      R : N_Receivers_T  := N_Receivers_T'First;
   begin

      if not Receiver_Id.Empty then
         Array_Receivers (Receiver_Id.Event).Array_Cb
           (Receiver_Id.Receiver_Num).Enabled := False;
--           loop
--              if Array_Receivers (Receiver_Id.Event).Array_Cb (R).User_Num =
--                Receiver_Id.User_Num then
--                 Array_Receivers (Receiver_Id.Event).Array_Cb (R).Enabled := False;
--                 exit;
--              end if;
--              exit when (R >= Array_Receivers (Receiver_Id.Event).N_Cb) or
--                (R = N_Receivers_T'Last);
--              R := R + 1;
--           end loop;
      end if;
   end Pause_Receiver;

   procedure Resume_Receiver
     (Receiver_Id : in Receiver_Id_T)
   is
--      use type Basic_Types_I.Uint8_T;
      use type Basic_Types_I.Uint32_T;

      R : N_Receivers_T  := N_Receivers_T'First;
   begin

      if not Receiver_Id.Empty then
         Array_Receivers (Receiver_Id.Event).Array_Cb
           (Receiver_Id.Receiver_Num).Enabled := True;

--        if Receiver_Id.User_Num > 0 then
--           loop
--              if Array_Receivers (Receiver_Id.Event).Array_Cb (R).User_Num =
--                Receiver_Id.User_Num then
--                 Array_Receivers (Receiver_Id.Event).Array_Cb (R).Enabled := True;
--                 exit;
--              end if;
--              exit when (R >= Array_Receivers (Receiver_Id.Event).N_Cb) or
--                (R = N_Receivers_T'Last);
--              R := R + 1;
--           end loop;
      end if;
   end Resume_Receiver;


   procedure Activate
     (Event_Id    : in Event_T;
      User_Data1  : in Basic_Types_I.Uint32_T;
      User_Data2  : in Basic_Types_I.Uint32_T)
   is
      use type Basic_Types_I.Uint32_T;

      R : N_Receivers_T  := N_Receivers_T'First;
   begin

      if Array_Receivers (Event_Id).N_Cb > 0 then
         loop
            if Array_Receivers (Event_Id).Array_Cb (R).Enabled then
               Array_Receivers (Event_Id).Array_Cb (R).Cb
                 (Event_Id, User_Data1, User_Data2);
            end if;
            exit when (R >= Array_Receivers (Event_Id).N_Cb) or (R = N_Receivers_T'Last);
            R := R + 1;
         end loop;
      end if;
   end Activate;


end Events_From_Simu;
