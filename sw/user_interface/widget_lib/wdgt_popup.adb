


with Ada.Exceptions;
with Interfaces.C.Strings;

with Gtkada.Types;   use Gtkada.Types;
with Gdk.Color;          
with Glib.Object;    --use Glib.Object;
with Gtk.Alignment;      
with Gtk.Event_Box; 
with Gtk.Handlers;
with Gtk.Style;  
with Gtk.Style_Context;
with Gtk.Hbutton_Box;
with Gtk.Vbutton_Box;
with Pango.Font;     

with Debug_Log;
with Wdgt_Common;


package body Wdgt_Popup is


   package Popup_Gint_Handler is new Gtk.Handlers.User_Callback(
     Widget_Type => Popup_Wdt_Record,
     User_Type   => Glib.Gint);

  type Popup_And_Selection is record
      Popup     : access Popup_Wdt_Record'Class; --Button_Popup; 
      Selection : Glib.Gint; 
   end record;
   type Popup_And_Selection_Access is access Popup_And_Selection;


   package Button_Handler is new Gtk.Handlers.User_Callback(
     Widget_Type => Gtk.Button.Gtk_Button_Record,
     User_Type   => Popup_And_Selection);

   package Menu_Item_Handler is new Gtk.Handlers.User_Callback(
     Widget_Type => Gtk.Menu_Item.Gtk_Menu_Item_Record,
     User_Type   => Popup_And_Selection);


   Popup_Signals_C           : constant Gtkada.Types.chars_ptr_array    :=
     (1 => Interfaces.C.Strings.New_String (String (Signal_Menu_Item_Selected)));

   Popup_Class_Record        : Glib.Object.Ada_Gobject_Class            :=
     Glib.Object.Uninitialized_Class;



-- Private subprograms declaration
   function User_Config_To_Widget_Config (User_Config : Popup_Config_List) 
     return Wdt_Config_List_Access;
   procedure Click_Button_CB 
     (Button : access Gtk.Button.Gtk_Button_Record'Class; -- Popup       : access Button_Popup_Record'Class;
      User_Data   : in Popup_And_Selection);
   procedure Click_Menu_Item_CB 
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      User_Data : in Popup_And_Selection);
  

   procedure Gtk_New 
     (Popup            : out Popup_Wdt;
      Label            : in Glib.UTF8_String;
      Config           : in Popup_Config_List;
      Relief           : in Gtk.Enums.Gtk_Relief_Style := Gtk.Enums.Relief_None) 
   is
   begin
      Popup := new Popup_Wdt_Record;
      Initialize (Popup, Label, Config, Relief);
   end Gtk_New;



   procedure Initialize 
     (Popup            : access Popup_Wdt_Record'Class;
      Label            : in Glib.UTF8_String;
      Config           : in Popup_Config_List;
      Relief           : in Gtk.Enums.Gtk_Relief_Style := Gtk.Enums.Relief_None) 
   is
      use type Glib.Object.Ada_Gobject_Class;
   
   
      Signal_Params_C      : constant Glib.Object.Signal_Parameter_Types :=
        (1 => (1 => Glib.GType_Int, 2 => Glib.GType_None));
   
   begin

      Debug_Log.Do_Log (" Popup.Initialize begin ");

      Popup.Wdt_Config := User_Config_To_Widget_Config (Config);

      if Popup_Class_Record = Glib.Object.Uninitialized_Class then

         Glib.Object.Initialize_Class_Record
           (Ancestor     => Gtk.Box.Get_Type,
            Signals      => Popup_Signals_C,
            Class_Record => Popup_Class_Record,
            Type_Name    => "Gmv_Widget_Popup",
            Parameters   => Signal_Params_C);
      end if;
      Glib.Object.G_New (Popup, Popup_Class_Record);

-- Initialize current composition widget. It is built in the previous Gtk_New procedure

-- Init the inherited box.    Initialize parent Ada fields
      Gtk.Box.Initialize
        (Box         => Popup, 
         Orientation => Gtk.Enums.Orientation_Horizontal, 
         Spacing     => 1);


      Gtk.Button.Gtk_New(Popup.Button, Label);
      
-- Config this new button calling the inherited subprograms
      Gtk.Button.Set_Relief(Popup.Button, Relief);


      Pack_Start (Popup, Popup.Button,
        Expand => True, Fill => True, Padding => 1);



--      Popup_Gint_Handler
      Button_Handler.Connect(
        Widget      => Popup.Button,
        Name        => "clicked",
        Cb          => Click_Button_CB'Access,
        User_Data   => (Popup, 0));

      Debug_Log.Do_Log (" Popup.Initialize end ");


   exception
      when Excep : others =>
         Debug_Log.Do_Log ("Popup Exception: " & 
           Ada.Exceptions.Exception_Name(Excep) & " " &
           Ada.Exceptions.Exception_Message(Excep));

   end Initialize;








-- -----------------------------------------------------------------------------
-- %Private Subprograms%
-- -----------------------------------------------------------------------------

   function User_Config_To_Widget_Config (User_Config : Popup_Config_List) 
     return Wdt_Config_List_Access is
      Num_Entries_C  : Positive := User_Config'Length;
      Wdt_List : Wdt_Config_List(1 .. Num_Entries_C);
   begin

      for I in 1 .. Num_Entries_C loop
--         Widget_List(I).Callback     := User_Config(I).Callback;
         Wdt_List(I).Label        := User_Config(I).Label;
--         Widget_List(I).Slot_Object  := User_Config(I).Slot_Object
         Wdt_List(I).Menu_Item    := null;
      end loop;

      return new Wdt_Config_List'(Wdt_List);
   end User_Config_To_Widget_Config;



   procedure Click_Button_CB(
    -- Popup       : access Button_Popup_Record'Class;
     Button : access Gtk.Button.Gtk_Button_Record'Class;
     User_Data   : in Popup_And_Selection) is
--      pragma
      Menu : Gtk.Menu.Gtk_Menu;
      Menu_Item : Gtk.Menu_Item.Gtk_Menu_Item;
   begin
      Gtk.Menu.Gtk_New (Menu);
      for I in User_Data.Popup.Wdt_Config'Range loop
         Gtk.Menu_Item.Gtk_New (Menu_Item, 
           User_Data.Popup.Wdt_Config(I).Label.all);
         Gtk.Menu.Append (Menu, Menu_Item);       
         Menu_Item_Handler.Connect
           (Widget      => Menu_Item,
            Name        => Gtk.Menu_Item.Signal_Activate,
            Cb          => Click_Menu_Item_CB'Access,
            User_Data   => (User_Data.Popup, Glib.Gint(I)));
         
      end loop;
      
      Gtk.Menu.Show_All (Menu);
      Gtk.Menu.Popup
        (Menu  => Menu,
         Parent_Menu_Shell => null,
         Parent_Menu_Item  => null,
         Func              => null,
         Button            => 1,
         Activate_Time     => 0);
   end Click_Button_CB;


   procedure Click_Menu_Item_CB 
     (Menu_Item : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class;
      User_Data : in Popup_And_Selection) is

   begin
   
      Popup_Gint_Handler.Emit_By_Name
        (Object   => User_Data.Popup,
         Name     => Signal_Menu_Item_Selected,
         Param    => User_Data.Selection);
   
   end Click_Menu_Item_CB;






end Wdgt_Popup;


