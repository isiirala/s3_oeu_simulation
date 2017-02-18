

with Basic_Types_I;




-- Manage events generated by the simulation that are notified to the UIF
package Events_From_Simu is

   type Event_T is
     (Uif_Built,
      -- The UIF widgets can be used to be updated in accordance with the intial status
      -- of the simulation
      Main_Pwr_Switch
      -- Status of the main power switch
      );



   type Receiver_Cb is access procedure
     (Event_Id    : in Event_T;
      User_Data1  : in Basic_Types_I.Uint32_T;
      User_Data2  : in Basic_Types_I.Uint32_T);


   type Receiver_Id_T is private;

   Null_Receiver_Id_C   : constant Receiver_Id_T;

   procedure Create_Receiver
     (Event_Id    : in Event_T;
      User_Cb     : in Receiver_Cb;
      Receiver_Id : out Receiver_Id_T);

   procedure Pause_Receiver
     (Receiver_Id : in Receiver_Id_T);

   procedure Resume_Receiver
     (Receiver_Id : in Receiver_Id_T);


   procedure Activate
     (Event_Id    : in Event_T;
      User_Data1  : in Basic_Types_I.Uint32_T;
      User_Data2  : in Basic_Types_I.Uint32_T);


private

   subtype N_Receivers_T is Basic_Types_I.Uint32_T range 1 .. 20;
   -- Range of maximum receivers for each event


   type Receiver_Id_T is record
      Empty        : Boolean;
      Event        : Event_T;
      Receiver_Num : N_Receivers_T; --Basic_Types_I.Uint32_T;
   end record;


   Null_Receiver_Id_C     : constant Receiver_Id_T :=
     (Empty => True, Event  => Event_T'First, Receiver_Num => N_Receivers_T'First);

end Events_From_Simu;