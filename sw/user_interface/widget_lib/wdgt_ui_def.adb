

with Glib.Error;



package body Wdgt_Ui_Def is





   Debug_Proc      : Basic_Types_I.Debug_Proc_T    := null;





-- --------------------------------------------------------------------------------------
-- Main_Menu (begin)
   Main_Menu_C   : constant Glib.UTF8_String    :=
  "<?xml version=""1.0"" encoding=""UTF-8""?>" &
  "<!-- Generated with glade 3.16.1 -->" &
  "<interface>" &
  "<requires lib=""gtk+"" version=""3.10""/>" &
  "<object class=""GtkImage"" id=""image1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-missing-image</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image10"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-media-pause</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image11"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-about</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image12"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-quit</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-info</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image3"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-info</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image4"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-info</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image5"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-home</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image6"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-help</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image7"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-save</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image8"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-page-setup</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image9"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-connect</property>" &
  "</object>" &
  "<object class=""GtkMenuBar"" id=""MainMenuBar"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemFile"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_File</property>" &
  "<property name=""use_underline"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menuFile"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""DumpToFileLogs"">" &
  "<property name=""label"">File Dump Execution Logs</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image7</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menu5"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkCheckMenuItem"" id=""chkFileAppExeLog"">" &
  "<property name=""name"">App</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">Application Execution Log</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""active"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckMenuItem"" id=""chkFileDump1553"">" &
  "<property name=""name"">1553</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">OEU 1553 Bus High level log</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""active"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckMenuItem"" id=""chkFileDumpIcm"">" &
  "<property name=""name"">Icm</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">ICM SW Execution Log</property>" &
  "<property name=""use_underline"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckMenuItem"" id=""chkFileDumpDpm"">" &
  "<property name=""name"">Dpm</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">DPM Simulation Execution Log</property>" &
  "<property name=""use_underline"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckMenuItem"" id=""chkFileDumpPcdm"">" &
  "<property name=""name"">Pcdm</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">PCDM Simulation Execution Log</property>" &
  "<property name=""use_underline"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""ConfigExeLogs"">" &
  "<property name=""label"" translatable=""yes"">Config Execution Logs</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image8</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkSeparatorMenuItem"" id=""separatormenuitem1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MainQuit"">" &
  "<property name=""label"">Quit</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image12</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemSimulation"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_Simulation</property>" &
  "<property name=""use_underline"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menuSimulation"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""SwitchOnOEU"">" &
  "<property name=""label"" translatable=""yes"">Switch On OEU Simulation</property>" &
  "<property name=""name"">SwitchOnOEU</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image9</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkSeparatorMenuItem"" id=""menuitem15"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""PauseOEU"">" &
  "<property name=""label"" translatable=""yes"">Pause OEU</property>" &
  "<property name=""name"">PauseOEU</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image10</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkSeparatorMenuItem"" id=""menuitem16"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemView"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_View</property>" &
  "<property name=""use_underline"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemTest"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_Test</property>" &
  "<property name=""use_underline"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemHelp"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_Help</property>" &
  "<property name=""use_underline"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menuHelp"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""UserManual"">" &
  "<property name=""label"" translatable=""yes"">User Manual</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image6</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkSeparatorMenuItem"" id=""menuitem11"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""HelpLinks"">" &
  "<property name=""label"" translatable=""yes"">Links</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image1</property>" &
  "<property name=""use_stock"">False</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menu4"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""HelpLinkAdaCore"">" &
  "<property name=""label"" translatable=""yes"">Free AdaCORE resources</property>" &
  "<property name=""name"">AdaCore</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image2</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""HelpLinkGtk3"">" &
  "<property name=""label"" translatable=""yes"">GTK 3 Documentation</property>" &
  "<property name=""name"">Gtk3</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image3</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""HelpLinkGtkAdaBinding"">" &
  "<property name=""label"" translatable=""yes"">GTK Ada Binding Documentation</property>" &
  "<property name=""name"">AdaBinding</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image4</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""HelpLinkGmv"">" &
  "<property name=""label"" translatable=""yes"">GMV Home</property>" &
  "<property name=""name"">Gmv</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image5</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkSeparatorMenuItem"" id=""menuitem5"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""HelpAbout"">" &
  "<property name=""label"">About</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""image"">image11</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</interface>";

-- Main_Menu (end)
-- --------------------------------------------------------------------------------------


Logs_Config_C  : constant Glib.UTF8_String  :=
  "<?xml version=""1.0"" encoding=""UTF-8""?>" &
  "<!-- Generated with glade 3.16.1 -->" &
  "<interface>" &
  "<requires lib=""gtk+"" version=""3.10""/>" &
  "<object class=""GtkAction"" id=""action1""/>" &
  "<object class=""GtkWindow"" id=""window1"">" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""window_position"">center</property>" &
  "<property name=""destroy_with_parent"">True</property>" &
  "<property name=""icon_name"">document-page-setup</property>" &
  "<child>" &
  "<object class=""GtkBox"" id=""box1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""orientation"">vertical</property>" &
  "<child>" &
  "<object class=""GtkNotebook"" id=""nbLogFile"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<child>" &
  "<object class=""GtkGrid"" id=""grid1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""margin_left"">4</property>" &
  "<property name=""margin_right"">4</property>" &
  "<property name=""row_spacing"">1</property>" &
  "<property name=""column_spacing"">1</property>" &
  "<child>" &
  "<object class=""GtkFrame"" id=""frame1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""margin_top"">1</property>" &
  "<property name=""margin_bottom"">3</property>" &
  "<property name=""label_xalign"">0</property>" &
  "<child>" &
  "<object class=""GtkAlignment"" id=""alignment1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""left_padding"">12</property>" &
  "<child>" &
  "<object class=""GtkGrid"" id=""grid2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkCheckButton"" id=""Chb1553_DecodeTc"">" &
  "<property name=""label"" translatable=""yes"">Show TC decodifications</property>" &
  "<property name=""name"">Chb1553_DecodeTc</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">False</property>" &
  "<property name=""margin_right"">10</property>" &
  "<property name=""xalign"">0</property>" &
  "<property name=""active"">True</property>" &
  "<property name=""draw_indicator"">True</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">0</property>" &
  "<property name=""width"">2</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckButton"" id=""Chb1553_DecodeTm"">" &
  "<property name=""label"" translatable=""yes"">Show TM decodifications</property>" &
  "<property name=""name"">Chb1553_DecodeTm</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">False</property>" &
  "<property name=""margin_right"">10</property>" &
  "<property name=""xalign"">0</property>" &
  "<property name=""active"">True</property>" &
  "<property name=""draw_indicator"">True</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">2</property>" &
  "<property name=""width"">2</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckButton"" id=""Chb1553_DecodeTcComplete"">" &
  "<property name=""label"" translatable=""yes"">Show whole TC decodification</property>" &
  "<property name=""name"">Chb1553_DecodeTc</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">False</property>" &
  "<property name=""margin_left"">25</property>" &
  "<property name=""margin_right"">10</property>" &
  "<property name=""xalign"">0</property>" &
  "<property name=""yalign"">0.54000002145767212</property>" &
  "<property name=""draw_indicator"">True</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">1</property>" &
  "<property name=""width"">2</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkCheckButton"" id=""Chb1553_DecodeTmComplete"">" &
  "<property name=""label"" translatable=""yes"">Show whole TM decodification</property>" &
  "<property name=""name"">Chb1553_DecodeTm</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">False</property>" &
  "<property name=""margin_left"">25</property>" &
  "<property name=""margin_right"">10</property>" &
  "<property name=""xalign"">0</property>" &
  "<property name=""draw_indicator"">True</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">3</property>" &
  "<property name=""width"">2</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child type=""label"">" &
  "<object class=""GtkLabel"" id=""label1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">Decodification options</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">0</property>" &
  "<property name=""width"">1</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""tab_expand"">True</property>" &
  "</packing>" &
  "</child>" &
  "<child type=""tab"">" &
  "<object class=""GtkLabel"" id=""nbLabel1553"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""margin_left"">5</property>" &
  "<property name=""margin_right"">5</property>" &
  "<property name=""label"" translatable=""yes"">SMU 1553 Log</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""tab_fill"">False</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkGrid"" id=""grid3"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""margin_left"">4</property>" &
  "<property name=""margin_right"">4</property>" &
  "<property name=""row_spacing"">1</property>" &
  "<property name=""column_spacing"">1</property>" &
  "<child>" &
  "<object class=""GtkGrid"" id=""grid4"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkFrame"" id=""frame2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""margin_top"">1</property>" &
  "<property name=""margin_bottom"">3</property>" &
  "<property name=""label_xalign"">0</property>" &
  "<child>" &
  "<object class=""GtkAlignment"" id=""alignment2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""left_padding"">12</property>" &
  "<child>" &
  "<object class=""GtkCheckButton"" id=""ChbIcm_RespectLineEnds"">" &
  "<property name=""label"" translatable=""yes"">Respect the line ends</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">False</property>" &
  "<property name=""margin_right"">10</property>" &
  "<property name=""xalign"">0</property>" &
  "<property name=""active"">True</property>" &
  "<property name=""draw_indicator"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child type=""label"">" &
  "<object class=""GtkLabel"" id=""label2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">Wrap lines</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">0</property>" &
  "<property name=""width"">1</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""left_attach"">0</property>" &
  "<property name=""top_attach"">0</property>" &
  "<property name=""width"">1</property>" &
  "<property name=""height"">1</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""position"">1</property>" &
  "<property name=""tab_fill"">False</property>" &
  "</packing>" &
  "</child>" &
  "<child type=""tab"">" &
  "<object class=""GtkLabel"" id=""nbLabelIcm"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">ICM SW Log</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""position"">1</property>" &
  "<property name=""tab_fill"">False</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<placeholder/>" &
  "</child>" &
  "<child type=""tab"">" &
  "<placeholder/>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">True</property>" &
  "<property name=""position"">0</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkBox"" id=""box2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""margin_left"">8</property>" &
  "<property name=""margin_right"">8</property>" &
  "<property name=""spacing"">8</property>" &
  "<property name=""homogeneous"">True</property>" &
  "<child>" &
  "<placeholder/>" &
  "</child>" &
  "<child>" &
  "<placeholder/>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkButton"" id=""btAccept"">" &
  "<property name=""label"" translatable=""yes"">Accept</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">True</property>" &
  "<property name=""margin_top"">1</property>" &
  "<property name=""margin_bottom"">3</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">False</property>" &
  "<property name=""position"">2</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkButton"" id=""btCancel"">" &
  "<property name=""label"" translatable=""yes"">Cancel</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""receives_default"">True</property>" &
  "<property name=""margin_top"">1</property>" &
  "<property name=""margin_bottom"">3</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">False</property>" &
  "<property name=""position"">3</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">False</property>" &
  "<property name=""padding"">3</property>" &
  "<property name=""position"">1</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</interface>";


-- --------------------------------------------------------------------------------------

   tc_tm_tests_C  : constant Glib.UTF8_String  :=
  "<?xml version=""1.0"" encoding=""UTF-8""?>" &
  "<!-- Generated with glade 3.16.1 -->" &
  "<interface>" &
  "<requires lib=""gtk+"" version=""3.10""/>" &
  "<object class=""GtkImage"" id=""image1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-cut</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-copy</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image3"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-paste</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image4"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-new</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image5"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-open</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image6"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-save</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image7"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-save-as</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image8"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-quit</property>" &
  "</object>" &
  "<object class=""GtkImage"" id=""image9"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""stock"">gtk-execute</property>" &
  "</object>" &
  "<object class=""GtkFrame"" id=""Root_Frame"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""hexpand"">False</property>" &
  "<property name=""vexpand"">False</property>" &
  "<property name=""label_xalign"">0</property>" &
  "<property name=""shadow_type"">in</property>" &
  "<child>" &
  "<object class=""GtkAlignment"" id=""alignment1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""left_padding"">12</property>" &
  "<child>" &
  "<object class=""GtkBox"" id=""box1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""orientation"">vertical</property>" &
  "<child>" &
  "<object class=""GtkMenuBar"" id=""menubar1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemFile"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_File</property>" &
  "<property name=""use_underline"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menuFile"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemFileNew"">" &
  "<property name=""label"">_New Test</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image4</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemFileOpen"">" &
  "<property name=""label"">_Open Test</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image5</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemFileSave"">" &
  "<property name=""label"">_Save Test</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image6</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemFileSaveAs"">" &
  "<property name=""label"">S_ave Test As</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image7</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkSeparatorMenuItem"" id=""separatormenuitem1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemFileClose"">" &
  "<property name=""label"">_Close</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image8</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemEdit"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_Edit</property>" &
  "<property name=""use_underline"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menuEdit"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemEditCut"">" &
  "<property name=""label"">_Cut Instruction</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image1</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemEditCopy"">" &
  "<property name=""label"">C_opy Instruction</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image2</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemEditPaste"">" &
  "<property name=""label"">_Paste Instruction</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image3</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemTest"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_Test</property>" &
  "<property name=""use_underline"">True</property>" &
  "<child type=""submenu"">" &
  "<object class=""GtkMenu"" id=""menu1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkImageMenuItem"" id=""MenuItemTestRunTest"">" &
  "<property name=""label"" translatable=""yes"">Run Test</property>" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""action_name"">Deshabilitado</property>" &
  "<property name=""use_underline"">True</property>" &
  "<property name=""image"">image9</property>" &
  "<property name=""use_stock"">False</property>" &
  "<property name=""always_show_image"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkMenuItem"" id=""menuitemSimu"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes"">_Simulation</property>" &
  "<property name=""use_underline"">True</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">True</property>" &
  "<property name=""position"">0</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkBox"" id=""box2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkLabel"" id=""label2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label"" translatable=""yes""> Current test script:  </property>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">True</property>" &
  "<property name=""position"">0</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkLabel"" id=""label3"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""ypad"">4</property>" &
  "<property name=""label"" translatable=""yes""> noname.tst</property>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">True</property>" &
  "<property name=""position"">1</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">True</property>" &
  "<property name=""position"">1</property>" &
  "</packing>" &
  "</child>" &
  "<child>" &
  "<object class=""GtkScrolledWindow"" id=""scrolledwindow1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">True</property>" &
  "<property name=""shadow_type"">in</property>" &
  "<child>" &
  "<object class=""GtkViewport"" id=""viewport1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<child>" &
  "<object class=""GtkFrame"" id=""TableMainFrame"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""label_xalign"">0</property>" &
  "<property name=""shadow_type"">in</property>" &
  "<child>" &
  "<object class=""GtkAlignment"" id=""alignment2"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "<property name=""left_padding"">12</property>" &
  "<child>" &
  "<placeholder/>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child type=""label"">" &
  "<object class=""GtkLabel"" id=""label4"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "<packing>" &
  "<property name=""expand"">False</property>" &
  "<property name=""fill"">True</property>" &
  "<property name=""position"">2</property>" &
  "</packing>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "</child>" &
  "<child type=""label"">" &
  "<object class=""GtkLabel"" id=""label1"">" &
  "<property name=""visible"">True</property>" &
  "<property name=""can_focus"">False</property>" &
  "</object>" &
  "</child>" &
  "</object>" &
  "<object class=""GtkSizeGroup"" id=""sizegroup1"">" &
  "<widgets>" &
  "<widget name=""menuitemSimu""/>" &
  "</widgets>" &
  "</object>" &
  "</interface>";



-- ======================================================================================
-- %% Internal operations
-- ======================================================================================

   procedure Local_Debug
     (Str        : in String)
   is
   begin

      if not Basic_Types_I.Is_Null_Debug_Proc (Debug_Proc) then
         Debug_Proc ("[Wdgt_Ui_Def]" & Str);
      end if;
   end Local_Debug;


   function Get_Ui (Ui_Def : Ui_Def_T) return Glib.UTF8_String
   is

   begin

      case Ui_Def is
         when Main_Menu =>
            return Main_Menu_C;
         when Logs_Config =>
            return Logs_Config_C;
         when Tc_Tm_Test =>
            return Tc_Tm_Tests_C;
      end case;
   end Get_Ui;


-- ======================================================================================
-- %% Provided operations
-- ======================================================================================

   procedure Init (Debug_Routine  : in Basic_Types_I.Debug_Proc_T)
   is
   begin
      Debug_Proc  := Debug_Routine;
   end Init;

   function Get_Builder
--     (Builder : not null access Gtk.Builder.Gtk_Builder_Record;
      (Ui_Def  : in Ui_Def_T) return Gtk.Builder.Gtk_Builder
   is
      use type Glib.Guint;

      Builder  : Gtk.Builder.Gtk_Builder      := Gtk.Builder.Gtk_Builder_New;
      Success  : Glib.Guint                   := 0;
      Error    : aliased Glib.Error.GError;
   begin


      Success := Builder.Add_From_String
        (Buffer => Get_Ui (Ui_Def),
         Error  => Error'Access);
      if Success = 0 then
         Local_Debug (".Get_Builder Error parsing " & Ui_Def_T'Image (Ui_Def) &
           " Error detail: " & Glib.Error.Get_Message (Error));
      end if;
      return Builder;
   end Get_Builder;



end Wdgt_Ui_Def;

