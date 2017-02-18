
with Gtk.Label;
with Gtk.Widget;


with Basic_Types_Gtk;
with Basic_Types_I;
with Pus_Format_I;
with Pus_Format_Types_I;
with Uif_Tc_Tm_Common;
--with Test_Params_I;

package body Uif_Tc_Tm_5 is

   subtype Notebook_Id_T is Glib.Gint range 0 .. 5;
   -- 5 Notebook pages:
   --      0 =>             TM(5,1)
   --      1 =>             TM(5,2)
   --      2 =>             TM(5,3)
   --      3 =>             TM(5,4)
   --      4 => TC(5,5)
   --      5 => TC(5,6)

   Notebook_1_C       : constant  Notebook_Id_T    := 0;
   Notebook_2_C       : constant  Notebook_Id_T    := 1;
   Notebook_3_C       : constant  Notebook_Id_T    := 2;
   Notebook_4_C       : constant  Notebook_Id_T    := 3;
   Notebook_5_C       : constant  Notebook_Id_T    := 4;
   Notebook_6_C       : constant  Notebook_Id_T    := 5;

   subtype Page_Config_T is Uif_Tc_Tm_Common.Notebook_Page_Config_T
     (Notebook_Id_T'Range);
   subtype Page_Wdgt_T is Uif_Tc_Tm_Common.Notebook_Page_Wdgt_T (Notebook_Id_T'Range);


   Page_Config_C       : constant Page_Config_T                 :=
     (0 => (Basic_Types_1553.Tc_Tm_None, Basic_Types_1553.Tm_5_1),
      1 => (Basic_Types_1553.Tc_Tm_None, Basic_Types_1553.Tm_5_2),
      2 => (Basic_Types_1553.Tc_Tm_None, Basic_Types_1553.Tm_5_3),
      3 => (Basic_Types_1553.Tc_Tm_None, Basic_Types_1553.Tm_5_4),
      4 => (Basic_Types_1553.Tc_5_5,     Basic_Types_1553.Tc_Tm_None),
      5 => (Basic_Types_1553.Tc_5_6,     Basic_Types_1553.Tc_Tm_None));

   Tm_5_X_N_Params_C   : constant Basic_Types_I.Uint32_T    :=
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_5_1);


   Tm1_Params           : Test_Params_I.Array_Params_T (1 .. Tm_5_X_N_Params_C);
   Tm1_Params_Len       : Basic_Types_I.Data_32_Len_T            :=
     Basic_Types_I.Data_32_Len_Empty_C;
   -- Parameters of the TMs received in this PUS service

   Tm1_Params_Labels    : Basic_Types_Gtk.Array_Labels_T
     (1 ..Tm_5_X_N_Params_C)                                    := (others => null);
   -- Gtk labels that show the TM parameters


   Page_Wdgts          : Page_Wdgt_T                            := (others => null);


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   procedure Insert_Tm_5_1
     (Button : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
   begin

      null;

   end Insert_Tm_5_1;


   procedure Build_Tm_5_1 is
   begin

      Gtk.Label.Gtk_New (Tm1_Params_Labels (1), Uif_Tc_Tm_Common.Not_Received_Label_C);
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_1_C).Tm_Grid,
         Param       => Tm1_Params (1),
         Line_Widget => Tm1_Params_Labels (1),
         Grid_Left   => 0,
         Grid_Top    => 0);
      Gtk.Label.Gtk_New (Tm1_Params_Labels (2), Uif_Tc_Tm_Common.Not_Received_Label_C);
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_1_C).Tm_Grid,
         Param       => Tm1_Params (2),
         Line_Widget => Tm1_Params_Labels (2),
         Grid_Left   => 0,
         Grid_Top    => 1);
      Gtk.Label.Gtk_New (Tm1_Params_Labels (3), Uif_Tc_Tm_Common.Not_Received_Label_C);
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_1_C).Tm_Grid,
         Param       => Tm1_Params (3),
         Line_Widget => Tm1_Params_Labels (3),
         Grid_Left   => 0,
         Grid_Top    => 2);

      Uif_Tc_Tm_Common.Create_Butt_Append_Tm
        (The_Grid       => Page_Wdgts (Notebook_1_C).Tm_Grid,
         Grid_Left      => 0,
         Grid_Top       => 3,
         Append_Handler => Insert_Tm_5_1'Access);



-- Update labels of the UIF with the values received from the simulation
-- 22 una rutina de common para actualizar una lista de etiquetas con una lista de parametros

      if not Tm1_Params_Len.Data_Empty then
         if not Test_Params_I.Is_Value_Str_Empty (Tm1_Params (1)) then
            Tm1_Params_Labels (1).Set_Label
              (Test_Params_I.Get_Value_As_Str (Tm1_Params (1)));
         end if;
         if not Test_Params_I.Is_Value_Str_Empty (Tm1_Params (2)) then
            Tm1_Params_Labels (2).Set_Label
              (Test_Params_I.Get_Value_As_Str (Tm1_Params (2)));
         end if;
         if not Test_Params_I.Is_Value_Str_Empty (Tm1_Params (3)) then
            Tm1_Params_Labels (3).Set_Label
              (Test_Params_I.Get_Value_As_Str (Tm1_Params (3)));
         end if;
      end if;
   end Build_Tm_5_1;
   procedure Build_Tm_5_2 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_2_C).Tm_Grid, 0);
   end Build_Tm_5_2;
   procedure Build_Tm_5_3 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_3_C).Tm_Grid, 0);
   end Build_Tm_5_3;
   procedure Build_Tm_5_4 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_4_C).Tm_Grid, 0);
   end Build_Tm_5_4;
   procedure Build_Tc_5_5 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_5_C).Tc_Grid, 0);
   end Build_Tc_5_5;
   procedure Build_Tc_5_6 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_6_C).Tc_Grid, 0);
   end Build_Tc_5_6;



-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Create_Sub_Srv_Pages
     (Sub_Srv_Notebook : not null access Gtk.Notebook.Gtk_Notebook_Record'Class)
   is
   begin

-- Parameters of TM(5,1):
      Tm1_Params_Len := Basic_Types_I.Data_32_Len_Empty_C;
      Pus_Format_I.Get_Empty_Params
        (Message_Id     => Basic_Types_1553.Tm_5_1,
         Params         => Tm1_Params,
         Params_Len     => Tm1_Params_Len);

-- --------------------------------------------------------------------------------------
-- Create sub-Services pages  (begin)
      Uif_Tc_Tm_Common.Create_Wdgts_Pages
        (Page_Config  => Page_Config_C,
         Notebook     => Sub_Srv_Notebook,
         Page_Wdgts   => Page_Wdgts);

      Build_Tm_5_1;
      Build_Tm_5_2;
      Build_Tm_5_3;
      Build_Tm_5_4;
      Build_Tc_5_5;
      Build_Tc_5_6;
-- Create sub-Services pages  (end)
-- --------------------------------------------------------------------------------------

   end Create_Sub_Srv_Pages;

   procedure Get_Message_Id_From_Index_Page
     (Sub_Page_Index   : in Glib.Gint;
      Tc_Id            : out Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Id            : out Basic_Types_1553.Tc_Tm_Id_T)
   is
      use type Glib.Gint;

   begin

      Tc_Id := Basic_Types_1553.Tc_Tm_None;
      Tm_Id := Basic_Types_1553.Tc_Tm_None;

      if Sub_Page_Index >= Notebook_Id_T'First and
        Sub_Page_Index <= Notebook_Id_T'Last then

         Tc_Id := Page_Config_C (Sub_Page_Index).Tc_Page;
         Tm_Id := Page_Config_C (Sub_Page_Index).Tm_Page;
      end if;
   end Get_Message_Id_From_Index_Page;

   procedure Update_Tm_Params
     (Params     : in Test_Params_I.Array_Params_T;
      Params_Len : in Basic_Types_I.Data_32_Len_T)
   is
      use type Basic_Types_I.Uint32_T;

   begin

      Test_Params_I.Debug
        (Params => Params (Params'First .. Params_Len.Last_Used),
         Info   => "Uif_Tc_Tm_5.Update_Tm_Params");

-- Copy values to the local array of parameters
      Test_Params_I.Copy_Values
        (Params_From  => Params (Params'First .. Params_Len.Last_Used),
         Params_To    => Tm1_Params (1 .. Tm_5_X_N_Params_C));

-- Update labels of the UIF
      Tm1_Params_Labels (1).Set_Label
        (Test_Params_I.Get_Value_As_Str (Tm1_Params (1)));
      Tm1_Params_Labels (2).Set_Label
        (Test_Params_I.Get_Value_As_Str (Tm1_Params (2)));
      Tm1_Params_Labels (3).Set_Label
        (Test_Params_I.Get_Value_As_Str (Tm1_Params (3)));

   end Update_Tm_Params;


end Uif_Tc_Tm_5;

