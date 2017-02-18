-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu.Pcdm
--  Unit Type           : Package body
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Builder of PCDM User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************
with Ada.Strings.Unbounded;
with System;

with Gtk.Box;

--with Gdk.Threads;

with Gtk;                --use Gtk;
with Gtk.Button;         --use Gtk.Button;
with Gtk.Enums;          --use Gtk.Enums;
with Gtk.Handlers;       --use Gtk.Handlers;
with Gtk.Widget;         --use Gtk.Widget;
with Gtk.Frame;          --use Gtk.Frame;
with Glib.Values;
with Gtk.Alignment;      --use Gtk.Alignment;
--with Gtk.Scrolled_Window; --use Gtk.Scrolled_Window;
--with Gtk.Text_View;   --use Gtk.Text_View;
--with Gtk.Text_Tag_Table; --use Gtk.Text_Tag_Table;
--with Gtk.Text_Tag;    --use Gtk.Text_Tag;
--with Gtk.Text_Iter;   --use Gtk.Text_Iter;
--with Gtk.Text_Buffer; --use Gtk.Text_Buffer;
--with Pango.Font;      --use Pango.Font;

with Gtk.Enums;       --use Gtk.Enums;

with Pango.Font;      --use Pango.Font;
with Gtk.Label;     --use Gtk.Label;
with Gtk.Stock;
with Gtk.Style;         --use Gtk.Style;
with Gtk.Image;         -- use Gtk.Image;
with Gtk.Hbutton_Box;   --  use Gtk.Hbutton_Box;
with Gtk.Container;

with Basic_Types_Gtk;
with Wdgt_Buttons;
with Wdgt_Colors;
with Wdgt_Common;
with Wdgt_Images;
with Wdgt_Image_Title; 
with Wdgt_Log;

package body UIF_Oeu_Simu.Pcdm is


-- -----------------------------------------------------------------------------
-- Widgets 
-- -----------------------------------------------------------------------------

   Buttons_Column     : Wdgt_Buttons.Frame_Buttons;
   
--   Send_Tc_B_Id            : constant            := 1; 
--   Send_Tc_B_Label         : aliased String      := "Send TC";
   Config_B_Id             : constant            := 1; 
   Config_B_Label          : aliased String      := "Config";
   Config_B_Img            : Gtk.Image.Gtk_Image;
--   Main_Pwr_B_Id           : constant            := 3; 
--   Main_Pwr_B_Label_On     : aliased  String     := "Switch On OEU";
--   Main_Pwr_B_Label_Off    : aliased  String     := "Switch Off OEU";
   
   
   Title              : Wdgt_Image_Title.Frame_Image_Title;

   Exe_Log            : Wdgt_Log.Frame_Log;

   Uif_Built           : Boolean                   := False;

-- -----------------------------------------------------------------------------
-- Private subprograms declaration
-- -----------------------------------------------------------------------------
   procedure Send_Tc_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);
   procedure Config_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class);
--   procedure Main_Pwr_B_Handler (
--     Button : access Gtk.Button.Gtk_Button_Record'Class);






   Border_Frame           : Gtk.Frame.Gtk_Frame;
   V_Box                  : Gtk.Box.Gtk_Box;
   


	  
  
   procedure Build is 
--     Base_Box : in out Gtk.Box.Gtk_Box) is
   
   begin

-- Build used images
      Config_B_Img            := Gtk.Image.Gtk_Image_New_From_Icon_Name 
        (Icon_Name => Gtk.Stock.Stock_Page_Setup,
         Size      => Gtk.Enums.Icon_Size_Menu);

-- Frame and Box for SMU
      Gtk.Frame.Gtk_New (
        Frame  => Border_Frame); 
--        Label =>"Border");

      Gtk.Box.Gtk_New_VBox (
        Box         => V_Box,
        Homogeneous => False,
        Spacing     => 2);

      Gtk.Frame.Add (Border_Frame, V_Box);
      Gtk.Box.Pack_Start
        (In_Box  => Oeu_H_Box, 
         Child   => Border_Frame, 
         Expand  => True, 
         Fill    => True, 
         Padding => 0);
      
        Wdgt_Image_Title.Gtk_New (
          Image_Title   => Title,
          Image         => Gtk.Image.Gtk_Image_New_From_Pixbuf
            (Wdgt_Images.Get_Image_Xpm (Wdgt_Images.Cartoon_Pcdm)), 
          Title         => " PCDM ", -- & ASCII.LF & "controls",
          Title_Pos     => Gtk.Enums.Pos_Right,
          Title_Color   => Wdgt_Colors.Pcdm_1,
          Frame_Shadow  => Gtk.Enums.Shadow_None); --Shadow_Etched_In);

      Title.Set_Tooltip_Text ("PCDM: OEU Power Conditioning & Distribution Module." & 
        ASCII.LF & "It controls power lines and the motor calibration of cameras");


        Gtk.Box.Pack_Start(V_Box, Title, Expand => False, Fill => False, Padding => 0);
      
      
      Wdgt_Buttons.Gtk_New (
        Buttons      => Buttons_Column, 
        
        Horizontal   => True,
        Config       => (
--          Send_Tc_B_Id  => (Send_Tc_B_Label'Access, Send_Tc_B_Handler'Access), 
          Config_B_Id   => 
            (Config_B_Label'Access, Config_B_Handler'Access, Config_B_Img,
              Ada.Strings.Unbounded.To_Unbounded_String ("")))
--          Main_Pwr_B_Id => (Main_Pwr_B_Label_On'Access, Main_Pwr_B_Handler'Access))
        
--        Frame_Label   => "Frame Buttons",
--        Frame_Shadow  => Gtk.Enums.Shadow_Etched_In
        );
-- TODO: Use Config button
      Buttons_Column.Widget_Config (Config_B_Id).Button.Set_Sensitive (False);

      Gtk.Box.Pack_Start
        (In_Box  => Title.V2_Box, 
         Child   => Buttons_Column, 
         Expand  => False, 
         Fill    => False, 
         Padding => 0);

      
        Wdgt_Log.Gtk_New 
          (Title            => "PCDM simulation execution log:",
           Config           => Wdgt_Log.User_Config_Default_C,
           Font_Tags_Config => Basic_Types_Gtk.Font_Configs_Empty_C,
           Log              => Exe_Log);
        Gtk.Box.Pack_Start(V_Box, Exe_Log, Expand => True, Fill => True, Padding => 0);
      
      Uif_Built := True;
   end Build;
   
   procedure Destroy is
   begin
      null;
   end Destroy;
   
   
 

   procedure Send_Tc_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
      Wdgt_Log.Write_Str (Exe_Log, "Send TC");

   end Send_Tc_B_Handler;

   procedure Config_B_Handler (
     Button : access Gtk.Button.Gtk_Button_Record'Class) is
   begin
      null;
      Wdgt_Log.Write_Str (Exe_Log, "Config");
   end Config_B_Handler;

--     procedure Main_Pwr_B_Handler (
--       Button : access Gtk.Button.Gtk_Button_Record'Class) is
--     begin
--    
--        if Gtk.Button.Get_Label(Button) = Main_Pwr_B_Label_On then
--           Gtk.Button.Set_Label(Button, Main_Pwr_B_Label_Off);
--  --         Log.Write_Str (Exe_Log, "Pwr Off");
--  
--        else
--           Gtk.Button.Set_Label(Button, Main_Pwr_B_Label_On);
--  --         Log.Write_Str (Exe_Log, "Pwr On");
--        end if;
--     end Main_Pwr_B_Handler;

 


end UIF_Oeu_Simu.Pcdm;
