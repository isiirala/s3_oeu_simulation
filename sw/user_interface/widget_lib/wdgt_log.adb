

with Ada.Exceptions;

with Glib;
with Glib.Values;
with Gdk.Color;     
with Gdk.Rectangle;
with Gdk.Rgba;


with Gtk;
with Gtk.Adjustment;
with Gtk.Alignment;      
with Gtk.Button;
with Gtk.Event_Box;
with Gtk.Handlers;
with Gtk.Image;
with Gtk.Layout;
with Gtk.Main;
with Gtk.Menu;
with Gtk.Menu_Item;
with Gtk.Overlay;
with Glib.Object;
with Gtk.Style;   
with Gtk.Text_Iter;
with Gdk.Threads;
with Gtk.Hbutton_Box;
with Gtk.Vbutton_Box;
with Gtk.Widget;
with Pango.Font;     

--with Basic_Types_I;
with Basic_Tools;

with Debug_Log;
with Basic_Types_Gtk;
with Wdgt_Colors;
with Wdgt_Fonts;

package body Wdgt_Log is

--   package Button_Handler is new Gtk.Handlers.Callback (Gtk.Button.Gtk_Button_Record);




-- -----------------------------------------------------------------------------
-- Widgets 
-- -----------------------------------------------------------------------------
-- TRATAR DE CAMBIAR A ARRAY/structura que el usuario pueda configurar.
-- QUE EL POPUP MANTENGA UN BOOLEAN PARA CADA OPCION Y MUESTRE LA ETIQUETA CORRESPONDIENTE
   Config_B_Id         : constant                  := 1; 
   Config_B_Label      : aliased Glib.UTF8_String  := "Config";
   Save_B_Id           : constant                  := 2; 
   Save_B_Label        : aliased Glib.UTF8_String  := "Save";
   Clear_B_Id          : constant                  := 3;
   Clear_B_Label       : aliased Glib.UTF8_String  := "Clear";
   Connect_B_Id        : constant                  := 4; 
   Connect_B_Label_C   : aliased Glib.UTF8_String  := "Connect";  
   Connect_B_Label_D   : aliased Glib.UTF8_String  := "Disconnect";
   Enlarge_B_Id        : constant                  := 5;
   Enlarge_B_Label_E   : aliased Glib.UTF8_String  := "Enlarge";
   Enlarge_B_Label_R   : aliased Glib.UTF8_String  := "Reduce";



   package Popup_Handler is new Gtk.Handlers.User_Callback(
     Widget_Type => Wdgt_Popup.Popup_Wdt_Record,
     User_Type   => Frame_Log);



-- ======================================================================================
-- %% Internal operations
-- ======================================================================================


-- -----------------------------------------------------------------------------
-- Private subprograms declaration
-- -----------------------------------------------------------------------------
   procedure Config_B_CB(Wdg: access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class; Log : Frame_Log);--  Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Save_B_CB(Log : access Frame_Log_Record'Class);--  Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Clear_B_CB(Log : access Frame_Log_Record'Class);--  Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Connect_B_CB(Log : access Frame_Log_Record'Class);--  Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Enlarge_B_CB(Log : access Frame_Log_Record'Class);--  Button : access Gtk.Button.Gtk_Button_Record'Class);
  
   procedure Popup_Menu_CB
     (Widget : access Wdgt_Popup.Popup_Wdt_Record'Class;
      Params : Glib.Values.GValues;
      Log    : Frame_Log);
 
  
--   function Allowed_Char (C : in Character) return Boolean;
  
--   package Menu_Item_Log_Handler is new Gtk.Handlers.User_Callback(
--     Widget_Type => Gtk.Menu_Item.Gtk_Menu_Item_Record,
--     User_Type   => Frame_Log);
  
  
  

   procedure Config_B_CB(Wdg: access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class; Log : Frame_Log) is
     
--     User_Data : access Gtk.Widget.Gtk_Widget_Record'Class) is --Frame_Log_Record'Class) is --Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
--      Write_Str
--        (Log    => Log, 
--         Str    => "Config option selected", 
--         Font_I => 1);
   end Config_B_CB;
   procedure Save_B_CB(Log : access Frame_Log_Record'Class) is --Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
   end Save_B_CB;
   procedure Clear_B_CB(Log : access Frame_Log_Record'Class) is --Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
   end Clear_B_CB;
   procedure Connect_B_CB(Log : access Frame_Log_Record'Class) is --Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
   end Connect_B_CB;
   procedure Enlarge_B_CB(Log : access Frame_Log_Record'Class) is --Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
   end Enlarge_B_CB;


 

   procedure Popup_Menu_CB
     (Widget : access Wdgt_Popup.Popup_Wdt_Record'Class;
      Params : Glib.Values.GValues;
      Log    : Frame_Log) is
   begin
   
   null;
      Debug_Log.Do_Log (" Popup option selected and received in LOG ");
--      Write_A_Str(Log, " Popup option selected");

      exception
         when Excep : others =>
            Debug_Log.Do_Log ("Log Popup_Menu_CB Exception: " & Ada.Exceptions.Exception_Name(Excep) & " " &
              Ada.Exceptions.Exception_Message(Excep));


   end Popup_Menu_CB;



   function Allowed_Char (C : in Character) return Boolean is
      Limit_Character_C       : constant Character         :=
        Character'Val (30);
      Lf_Character_C       : constant Character         :=
        Character'Val (10);
      Tab_Character_C       : constant Character         :=
        Character'Val (11);
      Result : Boolean := False;
   begin
      if C > Limit_Character_C then
         Result := True;
      elsif (C = Lf_Character_C) or (C = Tab_Character_C) then
         Result := True;
      end if;
      return Result;
   end Allowed_Char;


   procedure Add_Text_Prot 
     (Log        : not null access Frame_Log_Record;
      Text       : in Glib.UTF8_String; 
      Font_Tag   : in Basic_Types_Gtk.Font_Config_Range_Neutral_T) 
   is
      use type Basic_Types_Gtk.Font_Config_Range_T;
      use type Glib.Gint;
      
      Start_Iter      : Gtk.Text_Iter.Gtk_Text_Iter    := Gtk.Text_Iter.Null_Text_Iter;
      Iter            : Gtk.Text_Iter.Gtk_Text_Iter    := Gtk.Text_Iter.Null_Text_Iter;
      End_Iter        : Gtk.Text_Iter.Gtk_Text_Iter    := Gtk.Text_Iter.Null_Text_Iter;
      Result          : Boolean                        := False;
      At_Last_Line    : Boolean                        := False;
      Scroll_Result   : Boolean                        := False;
      Visible_Rect    : Gdk.Rectangle.Gdk_Rectangle    := Gdk.Rectangle.Full_Area;
      Iter_Rect       : Gdk.Rectangle.Gdk_Rectangle    := Gdk.Rectangle.Full_Area;
   begin

-- Catch the GDK lock and write the text with the default font configuration
      Gdk.Threads.Enter;  
      Gtk.Text_Buffer.Get_End_Iter (Log.Buffer, Iter);


      Gtk.Text_Buffer.Insert (Log.Buffer, Iter, Text);


      Gtk.Text_Buffer.Get_End_Iter (Log.Buffer, End_Iter);


-- --------------------------------------------------------------------------------------
-- Determine whether user is at the end of the log (begin)
--  In this case move scroll down to remain showing the last position of the log

      Log.View.Get_Visible_Rect (Visible_Rect => Visible_Rect);
--      Debug_Log.Do_Log ( --  X, Y, Width, Height : aliased Gint;
--        " Visible_Rect X:" & Glib.Gint'Image (Visible_Rect.X) & 
--        " Y: " & Glib.Gint'Image (Visible_Rect.Y) &
--        " Width: " & Glib.Gint'Image (Visible_Rect.Width) & 
--        " Height: " & Glib.Gint'Image (Visible_Rect.Height));
      Log.View.Get_Iter_Location
        (Iter     => End_Iter,
         Location => Iter_Rect);
--      Debug_Log.Do_Log ( --  X, Y, Width, Height : aliased Gint;
--        " Iter_Rect X:" & Glib.Gint'Image (Iter_Rect.X) & 
--        " Y: " & Glib.Gint'Image (Iter_Rect.Y) &
--        " Width: " & Glib.Gint'Image (Iter_Rect.Width) & 
--        " Height: " & Glib.Gint'Image (Iter_Rect.Height));

      At_Last_Line := (Visible_Rect.Y <= Iter_Rect.Y) and 
       (Iter_Rect.Y <= (Visible_Rect.Y + Visible_Rect.Height + 50) );

-- Determine whether user is at the end of the log (end)
-- --------------------------------------------------------------------------------------


      if At_Last_Line then
      
-- Move scroll down to reamin showing the last position of the log  
         Scroll_Result := Log.View.Scroll_To_Iter 
           (Iter          => Iter,
            Within_Margin => 0.0,
            Use_Align     => True,
            Xalign        => 1.0,
            -- X align to the left
            Yalign        => 1.0);
      end if;


-- If an special text tag is required and it is correctly configured apply it to the 
-- just written text

      if (not Font_Tag.Neutral_Element) and then 
        Log.Tags_Buffer (Font_Tag.Value).Used  then

--         Debug_Log.Do_Log (" Add_Text_Prot SE VA A APLICAR ESTE TAG:" & 
--           Integer'Image (Integer (Font_Tag.Value)) & " " & 
--           Basic_Types_Gtk.Font_Range_To_Tag_Str (Font_Tag.Value));

         Start_Iter := Iter;
         Gtk.Text_Iter.Backward_Chars 
           (Iter   => Start_Iter, 
            Count  => Text'Length + 1, 
            Result => Result);
         
         if not Result then
            raise Use_Error with "Error calculating end iterator to apply text tag";
         end if;
         
         begin

            Gtk.Text_Buffer.Apply_Tag 
              (Buffer  => Log.Buffer, 
               Tag     => Log.Tags_Buffer (Font_Tag.Value).Tag,
               Start   => Start_Iter, 
               The_End => Iter);
               
         exception               
            when Excep : others =>
               
               Log.Tags_Buffer (Font_Tag.Value).Used := False;
               Debug_Log.Do_Log (
                 " Exception Applying tag (from now this tag is disabled):" & 
                 Ada.Exceptions.Exception_Name (Excep) & ". msg: " &
                 Ada.Exceptions.Exception_Message (Excep)); 
                  
               raise Use_Error with "Exception Applying tag: " & 
                 Ada.Exceptions.Exception_Name (Excep) & ". msg: " &
                 Ada.Exceptions.Exception_Message (Excep);      
         end;
      end if;
      Gdk.Threads.Leave;
      
   end Add_Text_Prot;


   procedure Init_One_Font_Tag
     (Log              : access Frame_Log_Record'Class;
      Font_Tags_Config : in Basic_Types_Gtk.Font_Configs_T;
      I                : in Basic_Types_Gtk.Font_Config_Range_T) 
   is
      Color             : Gdk.Rgba.Gdk_RGBA              := Gdk.Rgba.Null_RGBA;
      Bk_Color          : Gdk.Rgba.Gdk_RGBA              := Gdk.Rgba.Null_RGBA;
      Color_Success     : Boolean                        := False;
      Bk_Color_Success  : Boolean                        := False;
   begin

      if Basic_Types_Gtk.Str_Null (Font_Tags_Config (I).Name) and then
        Basic_Types_Gtk.Str_Null (Font_Tags_Config (I).Color) and then
        Basic_Types_Gtk.Str_Null (Font_Tags_Config (I).Bk_Color) then

-- If all parameters of the tag are empty the current tag is not configured
         Log.Tags_Buffer (I).Used := False;
      else

-- Create the new tag and try to add all configurations
-- Does not use the tag names, because 
-- Name => Basic_Types_Gtk.Font_Range_To_Tag_Str (I)); 
         Gtk.Text_Tag.Gtk_New 
           (Tag  => Log.Tags_Buffer (I).Tag);

         if not Basic_Types_Gtk.Str_Null (Font_Tags_Config (I).Name) then

-- Assign font to the tag
            Pango.Font.Set_Property 
              (Object  => Log.Tags_Buffer (I).Tag, 
               Name    => Gtk.Text_Tag.Font_Desc_Property, 
               Value   => Pango.Font.From_String 
                 (Ada.Strings.Unbounded.To_String (Font_Tags_Config (I).Name)));

         end if;

--            Debug_Log.Do_Log (" Log.Initialize: " & Title & " tag: " & 
--              Ada.Strings.Unbounded.To_String (Log.Font_Config(I).Tag_Name));
              
-- Parse the colors for the tag
         Gdk.Rgba.Parse (Color, Ada.Strings.Unbounded.To_String
           (Font_Tags_Config (I).Color), Color_Success);
         Gdk.Rgba.Parse (Bk_Color, Ada.Strings.Unbounded.To_String
           (Font_Tags_Config (I).Bk_Color), Bk_Color_Success);
              
         if Color_Success then

-- Assign font color to the tag
            Gdk.Rgba.Set_Property 
              (Object => Log.Tags_Buffer (I).Tag, 
               Name   => Gtk.Text_Tag.Foreground_Rgba_Property, 
               Value  => Color);

         elsif not Basic_Types_Gtk.Str_Null (Font_Tags_Config (I).Color) then
      
            raise Init_Error with "Invalid tag font color: " & 
              Ada.Strings.Unbounded.To_String (Font_Tags_Config (I).Color);
                 
         end if;

         if Bk_Color_Success then

-- Assign font background color to the tag
            Gdk.Rgba.Set_Property 
              (Object => Log.Tags_Buffer (I).Tag, 
               Name   => Gtk.Text_Tag.Background_Rgba_Property,
               Value  => Bk_Color);
               
         elsif not Basic_Types_Gtk.Str_Null (Font_Tags_Config (I).Bk_Color) then
      
            raise Init_Error with "Invalid tag font background color: " & 
              Ada.Strings.Unbounded.To_String (Font_Tags_Config (I).Bk_Color);
               
         end if;
             
-- Add tag to the tag table of the widget                    
         Gtk.Text_Tag_Table.Add (Log.Tags, Log.Tags_Buffer (I).Tag);

         Log.Tags_Buffer (I).Used := True;
      end if;
   end Init_One_Font_Tag;


   procedure Init_Tags_Font
     (Log              : access Frame_Log_Record'Class;
      Font_Tags_Config : in Basic_Types_Gtk.Font_Configs_T) 
   is
   begin
   
-- Create tag table of the text widget 
      Gtk.Text_Tag_Table.Gtk_New (Log.Tags);
     
      for I in Basic_Types_Gtk.Font_Config_Range_T'Range loop 

         declare
         
         begin

            Init_One_Font_Tag (Log, Font_Tags_Config, I);
            
         exception
            when Excep : others =>
               Log.Tags_Buffer (I).Used := False;
               
               Debug_Log.Do_Log (
                 " Log.Init_Tags_Font Unable to create this text tag. Font:" &
                 Ada.Strings.Unbounded.To_String (Font_Tags_Config (I).Name) & 
                 " Color:" &
                 Ada.Strings.Unbounded.To_String (Font_Tags_Config (I).Color) & 
                 " Bk_Color: " &
                 Ada.Strings.Unbounded.To_String (Font_Tags_Config (I).Bk_Color));
         end;   
      end loop;
   end Init_Tags_Font;
   
  
   procedure Init_Default_Font
     (Log              : access Frame_Log_Record'Class;
      Default_Font     : in Basic_Types_Gtk.Font_Config_T) 
   is
      use type Basic_Types_Gtk.Font_Config_Range_T;
   
      Color             : Gdk.Rgba.Gdk_RGBA              := Gdk.Rgba.Null_RGBA;
      Bk_Color          : Gdk.Rgba.Gdk_RGBA              := Gdk.Rgba.Null_RGBA;
      Color_Success     : Boolean                        := False;
      Bk_Color_Success  : Boolean                        := False;
      
   begin
                  
-- Configure the default font if its font name is not null
      if not Basic_Types_Gtk.Str_Null (Default_Font.Name) then
         Gtk.Text_View.Override_Font (Log.View, Pango.Font.From_String 
           (Ada.Strings.Unbounded.To_String (Default_Font.Name)));
      end if;

-- Parse the default colors (font and background) to use in the text view
      Gdk.Rgba.Parse (Color, Ada.Strings.Unbounded.To_String
        (Default_Font.Color), Color_Success);
      Gdk.Rgba.Parse (Bk_Color, Ada.Strings.Unbounded.To_String
        (Default_Font.Bk_Color), Bk_Color_Success);

-- Configure the default color for font in the text view, if its name is not null
      if Color_Success then
      
         Gtk.Text_View.Override_Color
           (Widget => Log.View,
            State  => Gtk.Enums.Gtk_State_Flag_Normal,
            Color  => Color); 
            
      elsif not Basic_Types_Gtk.Str_Null (Default_Font.Color) then
      
         raise Init_Error with "Invalid default font color: " & 
           Ada.Strings.Unbounded.To_String (Default_Font.Color);
           
      end if;
      
-- Configure the default background color in the text view, if its name is not null
      if Bk_Color_Success then
         
         Gtk.Text_View.Override_Background_Color
           (Widget => Log.View,
            State  => Gtk.Enums.Gtk_State_Flag_Normal,
            Color  => Bk_Color);
            
      elsif not Basic_Types_Gtk.Str_Null (Default_Font.Bk_Color) then
      
         raise Init_Error with "Invalid default font background color: " & 
           Ada.Strings.Unbounded.To_String (Default_Font.Bk_Color);
      
      end if;
        
   end Init_Default_Font;
  
  
  
-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Gtk_New 
    (Title            : in String;
     Config           : in User_Config_T;
     Font_Tags_Config : in Basic_Types_Gtk.Font_Configs_T;
     Log              : out Frame_Log) 
   is
   begin
      Log        := new Frame_Log_Record;
      Initialize (Log, Title, Config, Font_Tags_Config);
  end Gtk_New;

   procedure Initialize
     (Log              : not null access Frame_Log_Record'Class;
      Title            : in String;
      Config           : in User_Config_T;
      Font_Tags_Config : in Basic_Types_Gtk.Font_Configs_T) 
   is
--      use type Ada.Strings.Unbounded.Unbounded_String;
      use type Gtk.Menu_Item.Gtk_Menu_Item;

--      Title_Lab        : Gtk.Label.Gtk_Label;
   begin

--      Debug_Log.Do_Log (" Log.Init begin " & Title);

-- Initialize current composition widget. It is a new Frame, for this reason
-- can be handled like a normal GTK Frame
      Gtk.Frame.Initialize 
        (Frame => Log, 
         Label => Ada.Strings.Unbounded.To_String (Config.Frame_Label));
      
-- The Border Width of the frame is the space arround the border that separate this 
-- widget with the rest of window.
-- The border and shadow are configured calling inherited functions from Gtk.Frame
      Set_Border_Width 
        (Container    => Log, 
         Border_Width => Config.Frame_Border_Width);
      Set_Shadow_Type 
        (Frame        => Log, 
         The_Type     => Config.Frame_Shadow);


      Gtk.Box.Gtk_New_VBox (
        Box         => Log.V_Box,
        Homogeneous => False,
        Spacing     => 1);

      Add (Log, Log.V_Box);

--      Debug_Log.Do_Log (" Log.Initialize before call popup ");

--      Wdgt_Popup.Gtk_New(
--        Popup  => Log.Button_Popup, 
--        Label  => Title,
-- FALTA AÑADIR COORDENADAS COMO ENTRADAS Y QUE LAS DEVUELVA EN EL CB
-- PARA CUANDO TIENES UNA MATRIZ DE POPUPS
--        Config => (
--          Config_B_Id  => (Config_B_Label'Access, 0),
--          Save_B_Id    => (Save_B_Label'Access, 0),
--          Clear_B_Id   => (Clear_B_Label'Access, 0),
--          Connect_B_Id => (Connect_B_Label_D'Access, 0),
--          Enlarge_B_Id => (Enlarge_B_Label_E'Access, 0))
--      );

      Gtk.Label.Gtk_New
        (Label => Log.Title,
         Str   => Title);
  
--      Title_Lab.Set_Attributes 
--        (Attrs => Wdgt_Fonts.Get_Attributes (Wdgt_Fonts.F_Title5, Wdgt_Colors.Gray_1));
  
      Gtk.Box.Pack_Start 
        (In_Box  => Log.V_Box, 
         Child   => Log.Title, --  Button_Popup,
         Expand  => False, 
         Fill    => False, 
         Padding => 0);

--      Popup_Handler.Connect
--        (Widget    => Log.Button_Popup,
--         Name      => Wdgt_Popup.Signal_Menu_Item_Selected,
--         Cb        => Popup_Menu_CB'Access,
--         User_Data => Log);    

-- Initialize the font tags configured by user
      Init_Tags_Font
        (Log              => Log,
         Font_Tags_Config => Font_Tags_Config);

--  Create the Text_Buffer and the views
      Gtk.Text_Buffer.Gtk_New 
        (Buffer => Log.Buffer, 
         Table  => Log.Tags);
      Gtk.Text_View.Gtk_New 
        (View   => Log.View, 
         Buffer => Log.Buffer);

-- Initialize the default font attributes configured by user
      Init_Default_Font
        (Log              => Log,
         Default_Font     => Config.Default_Font);    

      
-- Set line end wrap, if the line end is set between chars or words
      Gtk.Text_View.Set_Wrap_Mode (Log.View, Config.Text_Wrap_Mode);


--  Create the scrolled frame
      Gtk.Scrolled_Window.Gtk_New (Log.Scrolled);
      Gtk.Scrolled_Window.Set_Policy
        (Scrolled_Window   => Log.Scrolled, 
         Hscrollbar_Policy => Gtk.Enums.Policy_Automatic, 
         Vscrollbar_Policy => Gtk.Enums.Policy_Automatic);

--  Insert the view in the scrolled frame
      Gtk.Scrolled_Window.Add (Log.Scrolled, Log.View);

--  Display and insert the scrolled frame in the box
      Gtk.Scrolled_Window.Show_All (Log.Scrolled);
      Gtk.Box.Pack_Start 
        (In_Box  => Log.V_Box, 
         Child   => Log.Scrolled, 
         Expand  => True, 
         Fill    => True, 
         Padding => 0);
	  
      Gtk.Text_View.Set_Editable (Log.View, Config.Editable);

      Log.View.Set_Cursor_Visible (Config.Editable);
      -- If editable show also the cursor

--      Log.View.Set_Vscroll_Policy
--        (Gtk.Enums.Scroll_Natural); --Scroll_Minimum);

    

--  Log_Text_Protected.Add_Text_Prot (" First line log " & ASCII.LF);
--      Gtk.Text_Buffer.Get_End_Iter (Log.Buffer, Iter);

      exception
         when Init_Error     =>
            raise;
         when Excep : others =>
            raise Init_Error with "Except received: " & 
              Ada.Exceptions.Exception_Name (Excep) & ". msg: " &
              Ada.Exceptions.Exception_Message (Excep);      
   end Initialize;







   procedure Write_Char
     (Log         : not null access Frame_Log_Record;
      Char        : in Character;
      Font_Tag    : in Basic_Types_Gtk.Font_Config_Range_Neutral_T :=
        Basic_Types_Gtk.Font_Config_Range_Neutral_Empty_C)
   is
      Str : String(1 .. 1);
   begin
      Str(1) := Char;
      Add_Text_Prot (Log, Str, Font_Tag);
   end Write_Char;

   procedure Write_Str
     (Log         : not null access Frame_Log_Record;
      Str         : in Glib.UTF8_String;
      Font_Tag    : in Basic_Types_Gtk.Font_Config_Range_Neutral_T :=
        Basic_Types_Gtk.Font_Config_Range_Neutral_Empty_C)
   is
   
      use type Basic_Types_Gtk.Font_Config_Range_Neutral_T;
   
   begin


--      if Font_Tag /= Basic_Types_Gtk.Font_Config_Range_Neutral_Empty_C then
--         Debug_Log.Do_Log(" Log.Write_A_Str Str: " & Str & 
--           " Con tag:<" & Integer'Image(Integer(Font_Tag.Value)) & ">");
--      end if;

      if Str'Length > 0 then
--         Debug_Log.Do_Log(" Write_A_Str:<" & Str & ">");
--         Debug_Log.Flush;
 
         Add_Text_Prot (Log, Str, Font_Tag);
      end if;
   end Write_Str;






end Wdgt_Log;


