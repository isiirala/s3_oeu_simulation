
with Gtk.Box;
with Gtk.Frame;
with Gtk.Grid;



package Wdgt_Tc_Tm_Page is


   Border_Widths_C    : constant                     := 1;


   type Frame_Tc_Tm_Page_Record is new Gtk.Frame.Gtk_Frame_Record with
      record
        Main_V_Box   : Gtk.Box.Gtk_Box;
        H_Box1       : Gtk.Box.Gtk_Box;
--        Tc_Box       : Gtk.Box.Gtk_Box;
        Tc_Grid      : Gtk.Grid.Gtk_Grid;
--        Tm_Box       : Gtk.Box.Gtk_Box;
        Tm_Grid      : Gtk.Grid.Gtk_Grid;

-- Label and Menu boxes to insert this page in a NoteBook
        Label_Box    : Gtk.Box.Gtk_Box;
--        Menu_Box     : Gtk.Box.Gtk_Box;
   end record;

   type Frame_Tc_Tm_Page is access all Frame_Tc_Tm_Page_Record'Class;


   procedure Gtk_New
     (Tc_Tm_Page          : out Frame_Tc_Tm_Page;
      Title               : in String;
      Tc_Title_1          : in String;
      Tc_Title_2          : in String;
      Tm_Title_1          : in String;
      Tm_Title_2          : in String);

   procedure Initialize
     (Tc_Tm_Page          : access Frame_Tc_Tm_Page_Record'Class;
      Title               : in String;
      Tc_Title_1          : in String;
      Tc_Title_2          : in String;
      Tm_Title_1          : in String;
      Tm_Title_2          : in String);






end Wdgt_Tc_Tm_Page;
