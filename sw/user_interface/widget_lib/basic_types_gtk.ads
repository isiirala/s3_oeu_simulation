
with Ada.Strings.Unbounded;

with Glib;

with Gtk.Label;

with Basic_Types_I;


Package Basic_Types_Gtk is


   type Array_Labels_T is array (Basic_Types_I.Array_Index_T range <>) of
     Gtk.Label.Gtk_Label;


   type Font_Config_T is record
      Name     : Ada.Strings.Unbounded.Unbounded_String;
      Color    : Ada.Strings.Unbounded.Unbounded_String;
      Bk_Color : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   Font_Config_Default_C     : constant Font_Config_T   :=
     (Name     => Ada.Strings.Unbounded.To_Unbounded_String ("Courier new 7"),
      Color    => Ada.Strings.Unbounded.To_Unbounded_String ("Black"),
      Bk_Color => Ada.Strings.Unbounded.Null_Unbounded_String);

   Font_Config_Empty_C     : constant Font_Config_T   :=
     (Name     => Ada.Strings.Unbounded.Null_Unbounded_String,
      Color    => Ada.Strings.Unbounded.Null_Unbounded_String,
      Bk_Color => Ada.Strings.Unbounded.Null_Unbounded_String);

   type Font_Config_Range_T is new Basic_Types_I.Uint32_T range 1 .. 10;
   type Font_Configs_T is Array (Font_Config_Range_T'Range) of Font_Config_T;

   Font_Configs_Empty_C   : constant Font_Configs_T  :=
     (others => Font_Config_Empty_C);

   type Font_Config_Range_Neutral_T is record
      Value           : Font_Config_Range_T;
      Neutral_Element : Boolean;
   end record;
   Font_Config_Range_Neutral_Empty_C : constant Font_Config_Range_Neutral_T :=
     (Value           => Font_Config_Range_T'First,
      Neutral_Element => True);

   function Font_Range_To_Tag_Str (I  : in Font_Config_Range_T) return String;



   function Str_Null
     (Str  : in Ada.Strings.Unbounded.Unbounded_String) return Boolean;


   function String_100_Str_To_Utf8_String
     (Str : in Basic_Types_I.String_100_Str_T) return Glib.UTF8_String;





end Basic_Types_Gtk;
