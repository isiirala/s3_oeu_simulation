

with Gtk.Box;

with Gtk.Grid;
--with Gtk.GEntry;
with Gtk.Combo_Box_Text;
with Gtk.Label;
with Gtk.Widget;

with Basic_Convert;
with Basic_Tools;
with Basic_Types_I;
--with Basic_Types_1553;
with Debug_Log;
with Pus_Format_I;
with Pus_Format_Types_I;
with Test_Params_Types_I;
with Uif_Tc_Tm_Common;
with Basic_Types_Gtk;



package body Uif_Tc_Tm_128 is

   subtype Notebook_Id_T is Glib.Gint range 0 .. 1;
   -- Two Notebook pages:
   --      0 => TC(128,128)
   --      1 => TC(128,129)   TM(128,130)

   Notebook_128_C       : constant  Notebook_Id_T    := 0;
   Notebook_129_C       : constant  Notebook_Id_T    := 1;

   subtype Page_Config_T is Uif_Tc_Tm_Common.Notebook_Page_Config_T
     (Notebook_Id_T'Range);
   subtype Page_Wdgt_T is Uif_Tc_Tm_Common.Notebook_Page_Wdgt_T (Notebook_Id_T'Range);

   Page_Config_C       : constant Page_Config_T                 :=
     (0 => (Basic_Types_1553.Tc_128_128, Basic_Types_1553.Tc_Tm_None),
      1 => (Basic_Types_1553.Tc_128_129, Basic_Types_1553.Tm_128_130));


   Tm_128_130_N_Params_C   : constant Basic_Types_I.Uint32_T    :=
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tm_128_130);

   Tc_128_Params       : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tc_128_128));
   Tc_128_Params_Len   : Basic_Types_I.Data_32_Len_T            :=
     Basic_Types_I.Data_32_Len_Empty_C;
   Tc_129_Params       : Test_Params_I.Array_Params_T (1 ..
     Pus_Format_Types_I.Tc_Tm_Id_To_Num_Params_C (Basic_Types_1553.Tc_128_129));
   Tc_129_Params_Len   : Basic_Types_I.Data_32_Len_T            :=
     Basic_Types_I.Data_32_Len_Empty_C;
   -- Parameters of the TCs built in this PUS service

   Tc_128_128_Mode_Id  : Gtk.Combo_Box_Text.Gtk_Combo_Box_Text      := Null;

   Tm_Params           : Test_Params_I.Array_Params_T (1 .. Tm_128_130_N_Params_C);
   Tm_Params_Len       : Basic_Types_I.Data_32_Len_T            :=
     Basic_Types_I.Data_32_Len_Empty_C;
   -- Parameters of the TMs received in this PUS service

   Tm_Params_Labels    : Basic_Types_Gtk.Array_Labels_T
     (1 ..Tm_128_130_N_Params_C)                                := (others => null);
   -- Gtk labels that show the TM parameters

   Page_Wdgts          : Page_Wdgt_T                            := (others => null);


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

--   function Sub_Srv_128_To_Title (Sub_Srv : in Uif_Tc_Tm_Common.Sub_Srv_128_T)
--   return String
--   -- Convert the Sub Service Type to the short identifier like TC(x,y)
--   is
--      use type Uif_Tc_Tm_Common.Sub_Srv_128_T;
--   begin
--      case Sub_Srv is
--         when Uif_Tc_Tm_Common.Tc_128_128   => return "TC(128,128)";
--         when Uif_Tc_Tm_Common.Tc_128_129   => return "TC(128,129)";
--         when Uif_Tc_Tm_Common.Tm_128_130   => return "TM(128,130)";
--      end case;
--   end Sub_Srv_128_To_Title;

--     function Sub_Srv_To_Summary (Sub_Srv : in Uif_Tc_Tm_Common.Sub_Srv_128_T)
--     return String
--     -- Convert the Sub Service Type to the description of the External ICD document
--     is
--  --      use type Uif_Tc_Tm_Common.Sub_Srv_128_T;
--     begin
--        case Sub_Srv is
--           when Uif_Tc_Tm_Common.Tc_128_128   => return "Command function mode";
--           when Uif_Tc_Tm_Common.Tc_128_129   => return "Report the current function mode";
--           when Uif_Tc_Tm_Common.Tm_128_130   => return "Current mode report";
--        end case;
--     end Sub_Srv_To_Summary;


   procedure Append_Tc_128_128
     (Button : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
   begin

      null;
   end Append_Tc_128_128;

   procedure Send_Tc_128_128
     (Button : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
      Value          : Test_Params_Types_I.Param_Values_T   :=
        Test_Params_Types_I.Param_Val_Empty_C;
   begin

      Uif_Tc_Tm_Common.Tc_Raw_Building_Len := Basic_Types_I.Data_32_Len_Empty_C;

-- Update param 2 with the current value of the combo box of the selected OEU Mode
      Value.Value_Uint32 := Basic_Types_I.Uint32_T
        (Tc_128_128_Mode_Id.Get_Active);
      Value.Bytes_Len    := 4;
      Test_Params_I.Set_Value
        (Value          => Value,
         Convert_To_Str => False,
         Base           => 0,
         Parameter      => Tc_128_Params (2));

      Pus_Format_I.Build_Tc
        (Tc_Id        => Basic_Types_1553.Tc_128_128,
         Srv_Type     => 128,
         Srv_Sub_Type => 128,
         Params       => Tc_128_Params,
         Tc_Raw       => Uif_Tc_Tm_Common.Tc_Raw_Building,
         Tc_Raw_Len   => Uif_Tc_Tm_Common.Tc_Raw_Building_Len);

-- Debug the raw TC created
      declare
         Str_Tmp   : Basic_Types_I.String_T (1 .. 200) := (others => ' ');
         Len_Tmp   : Basic_Types_I.Data_32_Len_T       :=
           Basic_Types_I.Data_32_Len_Empty_C;
      begin

         Basic_Convert.Byte_Array_To_Str
           (Byte_Array => Uif_Tc_Tm_Common.Tc_Raw_Building
             (1 .. Uif_Tc_Tm_Common.Tc_Raw_Building_Len.Last_Used),
            Str        => Str_Tmp,
            Str_Len    => Len_Tmp);

         Debug_Log.Do_Log ("[Uif_Tc_Tm_128 User send TC(128,128): " &
           String (Str_Tmp (1 .. Len_Tmp.Last_Used)));
      end;

      Uif_Tc_Tm_Common.Send_A_Tc
        (Raw_Tc => Uif_Tc_Tm_Common.Tc_Raw_Building
          (1 .. Uif_Tc_Tm_Common.Tc_Raw_Building_Len.Last_Used));
   end Send_Tc_128_128;

   procedure Append_Tc_128_129
     (Button : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
   begin

      null;

   end Append_Tc_128_129;

   procedure Insert_Tm_128_130
     (Button : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
   begin

      null;

   end Insert_Tm_128_130;




   procedure Send_Tc_128_129
     (Button : access Gtk.Widget.Gtk_Widget_Record'Class)
   is
   begin

      Uif_Tc_Tm_Common.Tc_Raw_Building_Len := Basic_Types_I.Data_32_Len_Empty_C;

      Pus_Format_I.Build_Tc
        (Tc_Id        => Basic_Types_1553.Tc_128_129,
         Srv_Type     => 128,
         Srv_Sub_Type => 129,
         Params       => Tc_129_Params,
         Tc_Raw       => Uif_Tc_Tm_Common.Tc_Raw_Building,
         Tc_Raw_Len   => Uif_Tc_Tm_Common.Tc_Raw_Building_Len);

-- Debug the raw TC created
      declare
         Str_Tmp   : Basic_Types_I.String_T (1 .. 200) := (others => ' ');
         Len_Tmp   : Basic_Types_I.Data_32_Len_T       :=
           Basic_Types_I.Data_32_Len_Empty_C;
      begin

         Basic_Convert.Byte_Array_To_Str
           (Byte_Array => Uif_Tc_Tm_Common.Tc_Raw_Building
             (1 .. Uif_Tc_Tm_Common.Tc_Raw_Building_Len.Last_Used),
            Str        => Str_Tmp,
            Str_Len    => Len_Tmp);
         Debug_Log.Do_Log ("[Uif_Tc_Tm_128 User send TC(128,129): " &
           String (Str_Tmp (1 .. Len_Tmp.Last_Used)));
      end;

      Uif_Tc_Tm_Common.Send_A_Tc
        (Raw_Tc => Uif_Tc_Tm_Common.Tc_Raw_Building
          (1 .. Uif_Tc_Tm_Common.Tc_Raw_Building_Len.Last_Used));

   end Send_Tc_128_129;


   procedure Build_Tc_128_128
--     (Vbox_Tc        : in Gtk.Box.Gtk_Box;
--      Vbox_Tm        : in Gtk.Box.Gtk_Box)
   is

   begin

      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_128_C).Tc_Grid,
         Param       => Tc_128_Params (1),
         Line_Widget => Uif_Tc_Tm_Common.New_Entry
           (Initial_Value => 0,
            Read_Only     => True),
         Grid_Left   => 0,
         Grid_Top    => 0);


      Tc_128_128_Mode_Id := Uif_Tc_Tm_Common.New_Combo_Oeu_Mode;
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_128_C).Tc_Grid,
         Param       => Tc_128_Params (2),
         Line_Widget => Tc_128_128_Mode_Id,
         Grid_Left   => 0,
         Grid_Top    => 1);

      Uif_Tc_Tm_Common.Create_Butt_Append_Tc
        (The_Grid       => Page_Wdgts (Notebook_128_C).Tc_Grid,
         Grid_Left      => 0,
         Grid_Top       => 2,
         Append_Handler => Append_Tc_128_128'Access,
         Send_Handler   => Send_Tc_128_128'Access);

   end Build_Tc_128_128;

   procedure Build_Tc_128_129
--     (Vbox_Tc        : in Gtk.Box.Gtk_Box;
--      Vbox_Tm        : in Gtk.Box.Gtk_Box)
   is
--      Tc_Grid        : Gtk.Grid.Gtk_Grid                      := Null;
--      Tm_Grid        : Gtk.Grid.Gtk_Grid                      := Null;
--      Line_Label     : Gtk.Label.Gtk_Label                    := Null;
   begin

--      Gtk.Grid.Gtk_New (Tc_Grid);
--      Tc_Grid.Set_Border_Width (Uif_Tc_Tm_Common.Border_Widths_C);

--      Gtk.Box.Pack_Start
--        (In_Box  => Vbox_Tc,
--         Child   => Tc_Grid,
--         Expand  => False,
--         Fill    => False,
--         Padding =>  0);
--      Gtk.Grid.Gtk_New (Tm_Grid);
--      Tm_Grid.Set_Border_Width (Uif_Tc_Tm_Common.Border_Widths_C);

--      Gtk.Box.Pack_Start
--        (In_Box  => Vbox_Tm,
--         Child   => Tm_Grid,
--         Expand  => False,
--         Fill    => False,
--         Padding =>  0);


-- TC
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_129_C).Tc_Grid,
         Param       => Tc_129_Params (1),
         Line_Widget => Uif_Tc_Tm_Common.New_Entry
           (Initial_Value => 0,
            Read_Only     => True),
         Grid_Left   => 0,
         Grid_Top    => 0);

      Uif_Tc_Tm_Common.Create_Butt_Append_Tc
        (The_Grid       => Page_Wdgts (Notebook_129_C).Tc_Grid,
         Grid_Left      => 0,
         Grid_Top       => 1,
         Append_Handler => Append_Tc_128_129'Access,
         Send_Handler   => Send_Tc_128_129'Access);

-- TM

--      Uif_Tc_Tm_Common.Create_A_Title_Line
--        (The_Grid    => Tm_Grid,
--         Label_Title => "    Last parameters from TM(128,130):    ",
--         Grid_Left   => 0,
--         Grid_Top    => 0);

      Gtk.Label.Gtk_New (Tm_Params_Labels (1), Uif_Tc_Tm_Common.Not_Received_Label_C);
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_129_C).Tm_Grid,
         Param       => Tm_Params (1),
         Line_Widget => Tm_Params_Labels (1),
         Grid_Left   => 0,
         Grid_Top    => 0);

      Gtk.Label.Gtk_New (Tm_Params_Labels (2), Uif_Tc_Tm_Common.Not_Received_Label_C);
      Uif_Tc_Tm_Common.Create_A_Param_Line
        (The_Grid    => Page_Wdgts (Notebook_129_C).Tm_Grid,
         Param       => Tm_Params (2),
         Line_Widget => Tm_Params_Labels (2),
         Grid_Left   => 0,
         Grid_Top    => 1);

      Uif_Tc_Tm_Common.Create_Butt_Append_Tm
        (The_Grid       => Page_Wdgts (Notebook_129_C).Tm_Grid,
         Grid_Left      => 0,
         Grid_Top       => 2,
         Append_Handler => Insert_Tm_128_130'Access);



-- Update labels of the UIF with the values received from the simulation
-- 22 una rutina de common para actualizar una lista de etiquetas con una lista de parametros

      if not Tm_Params_Len.Data_Empty then
         if not Test_Params_I.Is_Value_Str_Empty (Tm_Params (1)) then
            Tm_Params_Labels (1).Set_Label
              (Test_Params_I.Get_Value_As_Str (Tm_Params (1)));
         end if;
         if not Test_Params_I.Is_Value_Str_Empty (Tm_Params (2)) then
            Tm_Params_Labels (2).Set_Label
              (Test_Params_I.Get_Value_As_Str (Tm_Params (2)));
         end if;
      end if;

   end Build_Tc_128_129;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================


   procedure Create_Sub_Srv_Pages
     (Sub_Srv_Notebook : not null access Gtk.Notebook.Gtk_Notebook_Record'Class)
   is

--      Vbox_Tc        : Gtk.Box.Gtk_Box        := Null;
--      Vbox_Tm        : Gtk.Box.Gtk_Box        := Null;
   begin

-- --------------------------------------------------------------------------------------
-- Parameters of TC(128,128) and TC(128,129)   (begin)

      Tc_128_Params_Len := Basic_Types_I.Data_32_Len_Empty_C;
      Pus_Format_I.Get_Empty_Params
        (Message_Id     => Basic_Types_1553.Tc_128_128,
         Params         => Tc_128_Params,
         Params_Len     => Tc_128_Params_Len);
      Test_Params_I.Set_Value
        (Value          =>
          (Bytes_Len      => 4,
           Option         => Test_Params_Types_I.Val_Numeric,
           Value_Uint32   => 0,
           Value_Int32    => 0,
           Value_Uint64   => 0,
           Value_Flt32    => 0.0),
         Convert_To_Str => True,
         Base           => 10,
         Parameter      => Tc_128_Params (1));
      -- TC(128,128) parameters: EquipId (constant fixed to 0) and ModeId

      Tc_129_Params_Len := Basic_Types_I.Data_32_Len_Empty_C;
      Pus_Format_I.Get_Empty_Params
        (Message_Id     => Basic_Types_1553.Tc_128_129,
         Params         => Tc_129_Params,
         Params_Len     => Tc_129_Params_Len);
      Test_Params_I.Set_Value
        (Value          =>
          (Bytes_Len      => 4,
           Option         => Test_Params_Types_I.Val_Numeric,
           Value_Uint32   => 0,
           Value_Int32    => 0,
           Value_Uint64   => 0,
           Value_Flt32    => 0.0),
         Convert_To_Str => True,
         Base           => 10,
         Parameter      => Tc_129_Params (1));
      -- TC(128,129) parameters: EquipId (constant fixed to 0)

-- Parameters of TC(128,128) and TC(128,129)   (end)
-- --------------------------------------------------------------------------------------

-- Parameters of TM(128,130):
      Tm_Params_Len := Basic_Types_I.Data_32_Len_Empty_C;
      Pus_Format_I.Get_Empty_Params
        (Message_Id     => Basic_Types_1553.Tm_128_130,
         Params         => Tm_Params,
         Params_Len     => Tm_Params_Len);

-- --------------------------------------------------------------------------------------
-- Create sub-Services pages  (begin)

      Uif_Tc_Tm_Common.Create_Wdgts_Pages
        (Page_Config  => Page_Config_C,
         Notebook     => Sub_Srv_Notebook,
         Page_Wdgts   => Page_Wdgts);
      Build_Tc_128_128;
      Build_Tc_128_129;



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
         Info   => "Uif_Tc_Tm_128.Update_Tm_Params");

-- Copy values to the local array of parameters
      Test_Params_I.Copy_Values
        (Params_From  => Params (Params'First .. Params_Len.Last_Used),
         Params_To    => Tm_Params (1 .. Tm_128_130_N_Params_C));

-- Copy the updated params to the local variables
--      Tm_Params_Len := Basic_Types_I.Data_32_Len_Empty_C;
--      Test_Params_I.Append
--        (Annex     => Params (Params'First .. Params'First + Tm_128_130_N_Params_C - 1),
--         Buff_Data => Tm_Params,
--         Buff_Len  => Tm_Params_Len);

-- Update labels of the UIF
      Tm_Params_Labels (1).Set_Label
        (Test_Params_I.Get_Value_As_Str (Tm_Params (1)));
      Tm_Params_Labels (2).Set_Label
        (Test_Params_I.Get_Value_As_Str (Tm_Params (2)));

   end Update_Tm_Params;




end Uif_Tc_Tm_128;

