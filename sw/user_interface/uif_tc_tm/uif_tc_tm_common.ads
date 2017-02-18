

with Glib;


with Gtk.Box;
with Gtk.Combo_Box_Text;
with Gtk.Gentry;
with Gtk.Grid;
with Gtk.Notebook;
with Gtk.Widget;

with Basic_Types_I;
with Basic_Types_1553;
with Pus_Format_Types_I;
with Test_Params_I;

with Wdgt_Common;
with Wdgt_Tc_Tm_Page;

package Uif_Tc_Tm_Common is



   type Services_T is    (Tm_1, Tc_3, Tc_5, Tc_6, Tc_9, Tc_12, Tc_17, Tc_128, Tc_129,
     Tc_130);

   type Sub_Srv_1_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tm_1_1 .. Basic_Types_1553.Tm_1_8;

   type Sub_Srv_3_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_3_1 .. Basic_Types_1553.Tm_3_25;

   type Sub_Srv_5_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tm_5_1 .. Basic_Types_1553.Tc_5_6;

   type Sub_Srv_6_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_6_2 .. Basic_Types_1553.Tm_6_10;

   type Sub_Srv_9_T is  new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_9_130 .. Basic_Types_1553.Tm_9_132;

   type Sub_Srv_12_T is  new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_12_1 .. Basic_Types_1553.Tc_12_132;

   type Sub_Srv_128_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_128_128 .. Basic_Types_1553.Tm_128_130;

   type Sub_Srv_129_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_129_128 .. Basic_Types_1553.Tm_129_130;

   type Sub_Srv_130_T is new Basic_Types_1553.Tc_Tm_Id_T range
     Basic_Types_1553.Tc_130_128 .. Basic_Types_1553.Tm_130_130;


   type Page_Notebook_Services is record
      Tc_Page    : Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Page     : Basic_Types_1553.Tc_Tm_Id_T;
   end record;
   type Notebook_Page_Config_T is array (Glib.Gint range <>) of Page_Notebook_Services;

   type Notebook_Page_Wdgt_T is array (Glib.Gint range <>)
     of Wdgt_Tc_Tm_Page.Frame_Tc_Tm_Page;




   Tc_Raw_Building    : Basic_Types_I.Byte_Array_T
     (1 .. Basic_Types_1553.Max_Tc_Block_Len_C)      := (others => 0);
   Tc_Raw_Building_Len : Basic_Types_I.Data_32_Len_T :=
     Basic_Types_I.Data_32_Len_Empty_C;


   Not_Received_Label_C   : constant string          := "<<Not Received>>";



   procedure Create_Wdgts_Pages
     (Page_Config : in Notebook_Page_Config_T;
      Notebook    : not null access Gtk.Notebook.Gtk_Notebook_Record'Class;
      Page_Wdgts  : out Notebook_Page_Wdgt_T);




   function Srv_To_Title (Srv  : in Services_T) return String;


   function Srv_To_Summary (Srv  : in Services_T) return String;


--   procedure Create_Main_Titles
--     (Grid_Tc      : access Gtk.Grid.Gtk_Grid_Record'Class;
--      Tc_Title     : in String;
--      Tc_Descript  : in String;
--      Grid_Tm      : access Gtk.Grid.Gtk_Grid_Record'Class;
--      Tm_Title     : in String;
 --     Tm_Descript  : in String);


   procedure Create_A_Title_Line
     (The_Grid    : access Gtk.Grid.Gtk_Grid_Record'Class;
      Label_Title : in String;
      Grid_Left   : in Glib.Gint;
      Grid_Top    : in Glib.Gint;
      Grid_Width  : in Glib.Gint   := 1;
      Grid_Height : in Glib.Gint   := 1);


   procedure Create_A_Param_Line
     (The_Grid    : access Gtk.Grid.Gtk_Grid_Record'Class;
      Param       : in Test_Params_I.Param_T;
      Line_Widget : access Gtk.Widget.Gtk_Widget_Record'Class;
      Grid_Left   : in Glib.Gint;
      Grid_Top    : in Glib.Gint;
      Grid_Width  : in Glib.Gint   := 1;
      Grid_Height : in Glib.Gint   := 1);

   procedure Create_Butt_Append_Tc
     (The_Grid       : access Gtk.Grid.Gtk_Grid_Record'Class;
      Grid_Left      : in Glib.Gint;
      Grid_Top       : in Glib.Gint;
      Append_Handler : in Wdgt_Common.Widget_Handler.Simple_Handler;
      Send_Handler   : in Wdgt_Common.Widget_Handler.Simple_Handler);

   procedure Create_Butt_Append_Tm
     (The_Grid       : access Gtk.Grid.Gtk_Grid_Record'Class;
      Grid_Left      : in Glib.Gint;
      Grid_Top       : in Glib.Gint;
      Append_Handler : in Wdgt_Common.Widget_Handler.Simple_Handler);



--     procedure Create_A_Sub_Srv_Page
--       (Notebook    : access Gtk.Notebook.Gtk_Notebook_Record'Class;
--        Title       : in String;
--        Title_Info  : in String;
--  --      Tc_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
--  --      Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
--        Vbox_Tc     : out Gtk.Box.Gtk_Box;
--        Vbox_Tm     : out Gtk.Box.Gtk_Box);

   procedure Send_A_Tc
     (Raw_Tc  : in Basic_Types_I.Byte_Array_T);

-----------------------------------------------------------------------------------------
-- Functions creating widgets inserted in the sub services pages (Begin)
   function New_Combo_Oeu_Mode return Gtk.Combo_Box_Text.Gtk_Combo_Box_Text;

   function New_Entry
     (Initial_Value : in Glib.Gint;
      Read_Only     : in Boolean) return Gtk.Gentry.Gtk_Entry;

-- Functions creating widgets inserted in the sub services pages (End)
-----------------------------------------------------------------------------------------


   procedure Build_Page_Not_Implemented
     (The_Grid    : access Gtk.Grid.Gtk_Grid_Record'Class;
      Grid_Top    : in Glib.Gint);


   function Num_To_Page (Page  : Glib.Gint) return Uif_Tc_Tm_Common.Services_T;


end Uif_Tc_Tm_Common;

