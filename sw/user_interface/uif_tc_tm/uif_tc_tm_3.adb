

with Gtk.Box;


with Basic_Types_I;

with Pus_Format_Types_I;
with Uif_Tc_Tm_Common;


package body Uif_Tc_Tm_3 is


   subtype Notebook_Id_T is Glib.Gint range 0 .. 5;
   -- 6 Notebook pages:
   --      0 => TC(3,1)
   --      1 => TC(3,3)
   --      2 => TC(3,5)
   --      3 => TC(3,6)
   --      4 => TC(3,9)     TM(3,10)
   --      5 =>             TM(3,25)

   Notebook_1_C       : constant  Notebook_Id_T    := 0;
   Notebook_3_C       : constant  Notebook_Id_T    := 1;
   Notebook_5_C       : constant  Notebook_Id_T    := 2;
   Notebook_6_C       : constant  Notebook_Id_T    := 3;
   Notebook_9_C       : constant  Notebook_Id_T    := 4;
   Notebook_25_C      : constant  Notebook_Id_T    := 5;

   subtype Page_Config_T is Uif_Tc_Tm_Common.Notebook_Page_Config_T
     (Notebook_Id_T'Range);
   subtype Page_Wdgt_T is Uif_Tc_Tm_Common.Notebook_Page_Wdgt_T (Notebook_Id_T'Range);

   Page_Config_C       : constant Page_Config_T                 :=
     (0 => (Basic_Types_1553.Tc_3_1,     Basic_Types_1553.Tc_Tm_None),
      1 => (Basic_Types_1553.Tc_3_3,     Basic_Types_1553.Tc_Tm_None),
      2 => (Basic_Types_1553.Tc_3_5,     Basic_Types_1553.Tc_Tm_None),
      3 => (Basic_Types_1553.Tc_3_6,     Basic_Types_1553.Tc_Tm_None),
      4 => (Basic_Types_1553.Tc_3_9,     Basic_Types_1553.Tm_3_10),
      5 => (Basic_Types_1553.Tc_Tm_None, Basic_Types_1553.Tm_3_25));


   Page_Wdgts          : Page_Wdgt_T                            := (others => null);


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================


--     function Sub_Srv_3_To_Title (Sub_Srv : in Uif_Tc_Tm_Common.Sub_Srv_3_T)
--     return String
--     is
--        use type Uif_Tc_Tm_Common.Sub_Srv_3_T;
--     begin
--        case Sub_Srv is
--           when Uif_Tc_Tm_Common.Tc_3_1   => return "TC(3,1)";
--           when Uif_Tc_Tm_Common.Tc_3_3   => return "TC(3,3)";
--           when Uif_Tc_Tm_Common.Tc_3_5   => return "TC(3,5)";
--           when Uif_Tc_Tm_Common.Tc_3_6   => return "TC(3,6)";
--           when Uif_Tc_Tm_Common.Tc_3_9   => return "TC(3,9)";
--           when Uif_Tc_Tm_Common.Tm_3_10  => return "TM(3,10)";
--           when Uif_Tc_Tm_Common.Tm_3_25  => return "TM(3,25)";
--        end case;
--     end Sub_Srv_3_To_Title;
--
--     function Sub_Srv_3_To_Summary (Sub_Srv : in Uif_Tc_Tm_Common.Sub_Srv_3_T)
--     return String
--     is
--        use type Uif_Tc_Tm_Common.Sub_Srv_3_T;
--     begin
--        case Sub_Srv is
--           when Uif_Tc_Tm_Common.Tc_3_1   => return "Define new HK report";
--           when Uif_Tc_Tm_Common.Tc_3_3   => return "Clear HK report definition";
--           when Uif_Tc_Tm_Common.Tc_3_5   => return "Enable HK report generation";
--           when Uif_Tc_Tm_Common.Tc_3_6   => return "Disable HK report generation";
--           when Uif_Tc_Tm_Common.Tc_3_9   => return "Report HK definition";
--           when Uif_Tc_Tm_Common.Tm_3_10  => return ".tbc.";
--           when Uif_Tc_Tm_Common.Tm_3_25  => return "HK report";
--        end case;
--     end Sub_Srv_3_To_Summary;

   procedure Build_Tc_3_1 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_1_C).Tc_Grid, 0);
   end Build_Tc_3_1;
   procedure Build_Tc_3_3 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_3_C).Tc_Grid, 0);
   end Build_Tc_3_3;
   procedure Build_Tc_3_5 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_5_C).Tc_Grid, 0);
   end Build_Tc_3_5;
   procedure Build_Tc_3_6 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_6_C).Tc_Grid, 0);
   end Build_Tc_3_6;
   procedure Build_Tc_3_9 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_9_C).Tc_Grid, 0);
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_9_C).Tm_Grid, 0);
   end Build_Tc_3_9;
   procedure Build_Tm_3_25 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_25_C).Tm_Grid, 0);
   end Build_Tm_3_25;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================


   procedure Create_Sub_Srv_Pages
     (Sub_Srv_Notebook : not null access Gtk.Notebook.Gtk_Notebook_Record'Class)
   is
      Vbox_Tc        : Gtk.Box.Gtk_Box     := Null;
      Vbox_Tm        : Gtk.Box.Gtk_Box     := Null;
   begin

-- --------------------------------------------------------------------------------------
-- Create sub-Services pages  (begin)

      Uif_Tc_Tm_Common.Create_Wdgts_Pages
        (Page_Config  => Page_Config_C,
         Notebook     => Sub_Srv_Notebook,
         Page_Wdgts   => Page_Wdgts);

      Build_Tc_3_1;
      Build_Tc_3_3;
      Build_Tc_3_5;
      Build_Tc_3_6;
      Build_Tc_3_9;
      Build_Tm_3_25;

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


end Uif_Tc_Tm_3;

