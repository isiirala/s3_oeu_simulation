-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Log
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Text to log execution of a SW with control buttons
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  19/03/2014 : Initial version
-- ****************************************************************************

with Ada.Strings.Unbounded;

with Glib;

with Gtk.Box;  
with Gtk.Frame; 
with Gtk.Enums;
with Gtk.Label;
with Gtk.Menu_Item;
with Gtk.Scrolled_Window;
with Gtk.Text_View;
with Gtk.Text_Tag;
with Gtk.Text_Buffer;
with Gtk.Text_Tag_Table;

with Basic_Types_Gtk;

with Wdgt_Buttons;
with Wdgt_Popup;


package Wdgt_Log is


   type User_Config_T is record
      Frame_Label         : Ada.Strings.Unbounded.Unbounded_String;
      Frame_Shadow        : Gtk.Enums.Gtk_Shadow_Type;
      Frame_Border_Width  : Glib.Guint;
      Default_Font        : Basic_Types_Gtk.Font_Config_T;
      Editable            : Boolean;
      Text_Wrap_Mode      : Gtk.Enums.Gtk_Wrap_Mode;
   end record;
   
   User_Config_Default_C  : constant User_Config_T := 
     (Frame_Label         => Ada.Strings.Unbounded.Null_Unbounded_String,
      Frame_Shadow        => Gtk.Enums.Shadow_None,
      Frame_Border_Width  => 0,
      Default_Font        => Basic_Types_Gtk.Font_Config_Default_C,
      Editable            => False,
      Text_Wrap_Mode      => Gtk.Enums.Wrap_None);
     

--   type Font_Labels_T is Array (Basic_Types_Gtk.Font_Confg_Range_T'Range) of 
--     Ada.Strings.Unbounded.Unbounded_String;


   type Tag_Used_T is record
      Tag  : Gtk.Text_Tag.Gtk_Text_Tag;
      Used : Boolean;
   end record;


   type Tags_Buffer_T is Array (Basic_Types_Gtk.Font_Config_Range_T'Range) of 
     Tag_Used_T;

--   Empty_Tags_C   : constant Tags_T   := (others => Gtk.Text_Tag.);

   type Frame_Log_Record is new Gtk.Frame.Gtk_Frame_Record with
      record
        V_Box        : Gtk.Box.Gtk_Box;
--        Title        : Gtk.Menu_Item.Gtk_Menu_Item;
        
        Buffer       : Gtk.Text_Buffer.Gtk_Text_Buffer;
        Tags         : Gtk.Text_Tag_Table.Gtk_Text_Tag_Table;
        Tags_Buffer  : Tags_Buffer_T;
        View         : Gtk.Text_View.Gtk_Text_View;
        Scrolled     : Gtk.Scrolled_Window.Gtk_Scrolled_Window;

        Current_Line_Len     : Integer;
        
        
--        Button_Popup   : Wdgt_Popup.Popup_Wdt;
        Title          : Gtk.Label.Gtk_Label;
        
--        Buttons_Line : Buttons.Frame_Buttons;
--        Widget_Config   : Widget_Config_List_Access;
      end record;
      
   type Frame_Log is access all Frame_Log_Record'Class;


   procedure Gtk_New 
     (Title            : in String;
      Config           : in User_Config_T;
      Font_Tags_Config : in Basic_Types_Gtk.Font_Configs_T;
      Log              : out Frame_Log);
      
   procedure Initialize 
     (Log              : not null access Frame_Log_Record'Class;
      Title            : in String;
      Config           : in User_Config_T;
      Font_Tags_Config : in Basic_Types_Gtk.Font_Configs_T);



   procedure Write_Char
     (Log         : not null access Frame_Log_Record;
      Char        : in Character;
      Font_Tag    : in Basic_Types_Gtk.Font_Config_Range_Neutral_T :=
        Basic_Types_Gtk.Font_Config_Range_Neutral_Empty_C);


   procedure Write_Str
     (Log         : not null access Frame_Log_Record;
      Str         : in Glib.UTF8_String;
      Font_Tag    : in Basic_Types_Gtk.Font_Config_Range_Neutral_T :=
        Basic_Types_Gtk.Font_Config_Range_Neutral_Empty_C);



   Init_Error     : exception;
   -- Exception error detected in the initialisation of the LOG widget:
   --   - An error in the configuration parameters
   --   - An exception error detected during the initialisation process

   Use_Error      : exception;
   -- Exception error detected in the LOG widget after the initialisation
   --   - An error in an input parameter
   --   - An exception error detected when executing a provided operation

   Callback_Error : exception;
   -- Exception error detected during a callback of the LOG widget


end Wdgt_Log;
