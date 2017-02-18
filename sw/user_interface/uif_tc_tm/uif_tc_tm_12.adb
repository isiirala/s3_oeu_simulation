

with Gtk.Box;


with Uif_Tc_Tm_Common;

with Basic_Types_I;

package body Uif_Tc_Tm_12 is


   subtype Notebook_Id_T is Glib.Gint range 0 .. 6;
   -- 7 Notebook pages:
   --      0 => TC(12,1)
   --      1 => TC(12,2)
   --      2 => TC(12,7)
   --      3 => TC(12,8)    TM(12,9)
   --      4 =>             TM(12,12)
   --      5 => TC(12,131)
   --      6 => TC(12,132)

   Notebook_1_C       : constant  Notebook_Id_T    := 0;
   Notebook_2_C       : constant  Notebook_Id_T    := 1;
   Notebook_7_C       : constant  Notebook_Id_T    := 2;
   Notebook_8_C       : constant  Notebook_Id_T    := 3;
   Notebook_12_C      : constant  Notebook_Id_T    := 4;
   Notebook_131_C     : constant  Notebook_Id_T    := 5;
   Notebook_132_C     : constant  Notebook_Id_T    := 6;

   subtype Page_Config_T is Uif_Tc_Tm_Common.Notebook_Page_Config_T
     (Notebook_Id_T'Range);
   subtype Page_Wdgt_T is Uif_Tc_Tm_Common.Notebook_Page_Wdgt_T (Notebook_Id_T'Range);

   Page_Config_C       : constant Page_Config_T                 :=
     (0 => (Basic_Types_1553.Tc_12_1,    Basic_Types_1553.Tc_Tm_None),
      1 => (Basic_Types_1553.Tc_12_2,    Basic_Types_1553.Tc_Tm_None),
      2 => (Basic_Types_1553.Tc_12_7,    Basic_Types_1553.Tc_Tm_None),
      3 => (Basic_Types_1553.Tc_12_8,    Basic_Types_1553.Tm_12_9),
      4 => (Basic_Types_1553.Tc_Tm_None, Basic_Types_1553.Tm_12_12),
      5 => (Basic_Types_1553.Tc_12_131,  Basic_Types_1553.Tc_Tm_None),
      6 => (Basic_Types_1553.Tc_12_132,  Basic_Types_1553.Tc_Tm_None));


   Page_Wdgts          : Page_Wdgt_T                            := (others => null);


-- ======================================================================================
-- %% Internal operations
-- ======================================================================================


   procedure Build_Tc_12_1 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_1_C).Tc_Grid, 0);
   end Build_Tc_12_1;
   procedure Build_Tc_12_2 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_2_C).Tc_Grid, 0);
   end Build_Tc_12_2;
   procedure Build_Tc_12_7 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_7_C).Tc_Grid, 0);
   end Build_Tc_12_7;
   procedure Build_Tc_12_8 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_8_C).Tc_Grid, 0);
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented (Page_Wdgts (Notebook_8_C).Tm_Grid, 0);
   end Build_Tc_12_8;
   procedure Build_Tc_12_12 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented
        (Page_Wdgts (Notebook_12_C).Tm_Grid,
         1);
   end Build_Tc_12_12;
   procedure Build_Tc_12_131 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented
        (Page_Wdgts (Notebook_131_C).Tc_Grid,
         1);
   end Build_Tc_12_131;
   procedure Build_Tc_12_132 is
   begin

      Uif_Tc_Tm_Common.Build_Page_Not_Implemented
        (Page_Wdgts (Notebook_132_C).Tc_Grid,
         1);
   end Build_Tc_12_132;



--     function Sub_Srv_12_To_Title (Sub_Srv : in Uif_Tc_Tm_Common.Sub_Srv_12_T)
--     return String
--     -- Convert the Sub Service Type to the short identifier like TC(x,y)
--     is
--        use type Uif_Tc_Tm_Common.Sub_Srv_12_T;
--     begin
--        case Sub_Srv is
--           when Uif_Tc_Tm_Common.Tc_12_1    => return "TC(12,1)";
--           when Uif_Tc_Tm_Common.Tc_12_2    => return "TC(12,2)";
--           when Uif_Tc_Tm_Common.Tc_12_7    => return "TC(12,7)";
--           when Uif_Tc_Tm_Common.Tc_12_8    => return "TC(12,8)";
--           when Uif_Tc_Tm_Common.Tm_12_9    => return "TM(12,9)";
--           when Uif_Tc_Tm_Common.Tm_12_12   => return "TM(12,12)";
--           when Uif_Tc_Tm_Common.Tc_12_131  => return "TC(12,131)";
--           when Uif_Tc_Tm_Common.Tc_12_132  => return "TC(12,132)";
--        end case;
--     end Sub_Srv_12_To_Title;
--
--     function Sub_Srv_12_To_Summary (Sub_Srv : in Uif_Tc_Tm_Common.Sub_Srv_12_T)
--     return String
--     -- Convert the Sub Service Type to the description of the External ICD document
--     is
--        use type Uif_Tc_Tm_Common.Sub_Srv_128_T;
--     begin
--        case Sub_Srv is
--           when Uif_Tc_Tm_Common.Tc_12_1    => return "Enable monitoring of parameters";
--           when Uif_Tc_Tm_Common.Tc_12_2    => return "Disable monitoring of parameters";
--           when Uif_Tc_Tm_Common.Tc_12_7    => return "Modify info parameters checking";
--           when Uif_Tc_Tm_Common.Tc_12_8    => return "Ask for current monitoring list";
--           when Uif_Tc_Tm_Common.Tm_12_9    => return "Report of current monitoring list";
--           when Uif_Tc_Tm_Common.Tm_12_12   => return "Report of check transition";
--           when Uif_Tc_Tm_Common.Tc_12_131  => return "Modify the value #REP";
--           when Uif_Tc_Tm_Common.Tc_12_132  => return "Modify the parameter validity";
--        end case;
--     end Sub_Srv_12_To_Summary;




-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Create_Sub_Srv_Pages
     (Sub_Srv_Notebook : not null access Gtk.Notebook.Gtk_Notebook_Record'Class)
   is
   begin


-- --------------------------------------------------------------------------------------
-- Create sub-Services pages  (begin)

      Uif_Tc_Tm_Common.Create_Wdgts_Pages
        (Page_Config  => Page_Config_C,
         Notebook     => Sub_Srv_Notebook,
         Page_Wdgts   => Page_Wdgts);

      Build_Tc_12_1;
      Build_Tc_12_2;
      Build_Tc_12_7;
      Build_Tc_12_8;
      Build_Tc_12_12;
      Build_Tc_12_131;
      Build_Tc_12_132;


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



end Uif_Tc_Tm_12;

