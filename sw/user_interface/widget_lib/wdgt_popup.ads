-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Popup
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Special button with a popup menu
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  19/03/2014 : Initial version
-- ****************************************************************************

pragma Ada_2005;

with Glib;
with Gtk.Box;
with Gtk.Button;
with Gtk.Enums;
with Gtk.Menu;
with Gtk.Menu_Item;
with Gtk.Widget;

with Wdgt_Common;

package Wdgt_Popup is




   type Popup_Config is record
      Label        : Wdgt_Common.String_Access;
      Extra        : Glib.Guint;
   end record;
   type Popup_Config_List is array (Positive range <>) of Popup_Config;


   type Wdt_Config is record
      Label        : Wdgt_Common.String_Access;
      Menu_Item    : Gtk.Menu_Item.Gtk_Menu_Item;
--      Callback     : Common.Widget_Handler.Simple_Handler; --Button_Handler.Simple_Handler;
--      Slot_Object  : access Gtk.Widget.Gtk_Widget_Record'Class;
   end record;
   type Wdt_Config_List is array (Positive range <>) of Wdt_Config;   
   type Wdt_Config_List_Access is access Wdt_Config_List;


   type Popup_Wdt_Record is new Gtk.Widget.Gtk_Widget_Record with private; -- Gtk.Button.Gtk_Button_Record with

   type Popup_Wdt is access all Popup_Wdt_Record'Class;

   procedure Gtk_New 
     (Popup            : out Popup_Wdt;
      Label            : in Glib.UTF8_String;
      Config           : in Popup_Config_List;
      Relief           : in Gtk.Enums.Gtk_Relief_Style := Gtk.Enums.Relief_None);
     
   procedure Initialize 
     (Popup            : access Popup_Wdt_Record'Class; 
      Label            : in Glib.UTF8_String;
      Config           : in Popup_Config_List;
      Relief           : in Gtk.Enums.Gtk_Relief_Style := Gtk.Enums.Relief_None);



------------- 
-- Signals -- 
------------- 
 
   --  <signals> 
   --  The following new signals are defined for this widget: 
   -- 
   --  - "menu-item-selected" 
   --    Emitted when a menu item is selected  
   -- 
   --  </signals> 
 
   Signal_Menu_Item_Selected : constant Glib.Signal_Name := "menu_item_selected"; 

---------------- 
-- Properties -- 
---------------- 
   
private

   type Popup_Wdt_Record is new Gtk.Box.Gtk_Box_Record -- Gtk.Button.Gtk_Button_Record
   with record
      
      Wdt_Config      : Wdt_Config_List_Access;
      Button          : Gtk.Button.Gtk_Button;
      Menu            : Gtk.Menu.Gtk_Menu;

   end record;
   
   
   
end Wdgt_Popup;

