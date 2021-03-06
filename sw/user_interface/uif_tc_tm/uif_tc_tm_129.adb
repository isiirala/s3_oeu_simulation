
with Uif_Tc_Tm_Common;

with Basic_Types_I;

package body Uif_Tc_Tm_129 is

   subtype Notebook_Id_T is Glib.Gint range 0 .. 1;
   -- 2 Notebook pages:
   --      0 => TC(129,128)
   --      1 => TC(129,129)     TM(129,130)

   Notebook_128_C       : constant  Notebook_Id_T    := 0;
   Notebook_129_C       : constant  Notebook_Id_T    := 1;

   subtype Page_Config_T is Uif_Tc_Tm_Common.Notebook_Page_Config_T
     (Notebook_Id_T'Range);
   subtype Page_Wdgt_T is Uif_Tc_Tm_Common.Notebook_Page_Wdgt_T (Notebook_Id_T'Range);

   Page_Config_C       : constant Page_Config_T                 :=
     (0 => (Basic_Types_1553.Tc_129_128,    Basic_Types_1553.Tc_Tm_None),
      1 => (Basic_Types_1553.Tc_129_129,    Basic_Types_1553.Tm_129_130));

   Page_Wdgts          : Page_Wdgt_T                            := (others => null);

-- ======================================================================================
-- %% Internal operations
-- ======================================================================================
   procedure Build_Tc_129_128 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented
        (Page_Wdgts (Notebook_128_C).Tc_Grid, 0);
   end Build_Tc_129_128;

   procedure Build_Tc_129_129 is
   begin
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented
        (Page_Wdgts (Notebook_129_C).Tc_Grid, 0);
      Uif_Tc_Tm_Common.Build_Page_Not_Implemented
        (Page_Wdgts (Notebook_129_C).Tm_Grid, 0);
   end Build_Tc_129_129;



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

      Build_Tc_129_128;
      Build_Tc_129_129;
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


end Uif_Tc_Tm_129;


