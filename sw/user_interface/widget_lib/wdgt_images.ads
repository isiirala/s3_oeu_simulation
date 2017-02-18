

with Ada.Direct_IO;
with Ada.Unchecked_Conversion;
with Interfaces.C.Strings;


with Gdk;
with Gdk.Pixbuf;

with Basic_Types_I;


package Wdgt_Images is


--   Max_Xpm_Lines_C     : constant                                   := 20_000;

   package Bytes_Io is
     new Ada.Direct_IO (Basic_Types_I.Uint8_T);


   Empty_Chars_Ptr_Array_C : Interfaces.C.Strings.Chars_Ptr_Array (1 .. 1) :=
     (others => Interfaces.C.Strings.Null_Ptr);


   type Images_T is
     (Book_Open, Book_Closed,
      About_Dialog, Arrows_Down_Mini,
      Cartoon_Dpm, Cartoon_Icm, Cartoon_Pcdm, Cartoon_Smu,
      Envelope_Mini, Gmv_Mini, Oeu, Oeu_Icon,
      Megaphone_Mini, Connect_Mini, Unconnect_Mini);


   type Img_To_File_Name_T is array (Images_T) of Basic_Types_I.String_30_T;
   -- Type to assign a relative file path to a used image

   type Img_To_U16_T is array (Images_T) of Basic_Types_I.Uint16_T;
   -- Type to assign a u16 number to a image

   type Header_T is record
      Magic           : Basic_Types_I.Byte_Array_T (1 .. 9);
      Chk             : Basic_Types_I.Uint16_T;
      Id              : Basic_Types_I.Uint16_T;
      Columns         : Basic_Types_I.Uint16_T;
      Rows            : Basic_Types_I.Uint16_T;
      Colors          : Basic_Types_I.Uint16_T;
      Chars_Per_Pixel : Basic_Types_I.Uint8_T;
   end record;
   pragma Pack (Header_T);

   Empty_Header_C   : constant Header_T :=
     (Magic           => (9,1,8,0,7,2,1,0,0),
      Chk             => 0,
      Id              => 0,
      Columns         => 0,
      Rows            => 0,
      Colors          => 0,
      Chars_Per_Pixel => 0);

   type Header_Bytes_T is new Basic_Types_I.Byte_Array_T (1 .. 20);

   function Header_To_Bytes is new Ada.Unchecked_Conversion
     (Source => Header_T,
      Target => Header_Bytes_T);
   function Bytes_To_Header is new Ada.Unchecked_Conversion
     (Source => Header_Bytes_T,
      Target => Header_T);


   type Color_Line_T is record
      Chars           : Basic_Types_I.String_T (1 .. 2);
      Numeric_Color   : Basic_Types_I.Uint8_T;
      Color_Val       : Basic_Types_I.Byte_Array_T (1 .. 6); --3);
   end record;
   pragma Pack (Color_Line_T);

   Empty_Color_Line_C  : constant  Color_Line_T  :=
     (Chars         => (others => ' '),
      Numeric_Color => 0,
      Color_Val     => (others => 0));

   type Color_Line_Bytes_T is new Basic_Types_I.Byte_Array_T (1 .. 9); --6);

   function Color_Line_To_Bytes is new Ada.Unchecked_Conversion
     (Source => Color_Line_T,
      Target => Color_Line_Bytes_T);
   function Bytes_To_Color_Line is new Ada.Unchecked_Conversion
     (Source => Color_Line_Bytes_T,
      Target => Color_Line_T);


   type Array_Color_Lines_T is array (Basic_Types_I.Uint8_T range <>) of
     Color_Line_T;


   Images_Id_C       : constant Img_To_U16_T                    :=
     (Book_Open         => 1,  Book_Closed   => 2,  About_Dialog => 3,
      Arrows_Down_Mini  => 4,  Cartoon_Dpm   => 5,  Cartoon_Icm  => 6,
      Cartoon_Pcdm      => 7,  Cartoon_Smu   => 8,
      Envelope_Mini     => 9,  Gmv_Mini      => 10, Oeu          => 11, Oeu_Icon => 12,
      Megaphone_Mini    => 13, Connect_Mini  => 14, Unconnect_Mini => 15
     );


   Name_Colors_C     : constant Basic_Types_I.Array_String_30_T :=
     ("aliceblue                     ",
      "antiquewhite                  ",
      "aquamarine                    ",
      "Azure                         ",
      "beige                         ",
      "Bisque                        ",
      "black                         ",
      "blanchedalmond                ",
      "blue                          ",
      "blueviolet                    ",
      "brown                         ",
      "burlywood                     ",
      "cadetblue                     ",
      "chartreuse                    ",
      "chocolate                     ",
      "coral                         ",
      "cornflowerblue                ",
      "cornsilk                      ",
      "crimson                       ",
      "cyan                          ",
      "darkgoldenrod                 ",
      "darkgreen                     ",
      "darkkhaki                     ",
      "darkolivegreen                ",
      "darkorange                    ",
      "darkorchid                    ",
      "darksalmon                    ",
      "darkseagreen                  ",
      "darkslateblue                 ",
      "darkslategray                 ",
      "darkslategrey                 ",
      "darkturquoise                 ",
      "darkviolet                    ",
      "deeppink                      ",
      "deepskyblue                   ",
      "DimGray                       ",
      "dimgrey                       ",
      "dodgerblue                    ",
      "firebrick                     ",
      "floralwhite                   ",
      "forestgreen                   ",
      "gainsboro                     ",
      "ghostwhite                    ",
      "gold                          ",
      "goldenrod                     ",
      "gray                          ",
      "green                         ",
      "greenyellow                   ",
      "grey                          ",
      "honeydew                      ",
      "hotpink                       ",
      "indianred                     ",
      "indigo                        ",
      "invis                         ",
      "ivory                         ",
      "khaki                         ",
      "lavender                      ",
      "lavenderblush                 ",
      "lawngreen                     ",
      "lemonchiffon                  ",
      "lightblue                     ",
      "lightcoral                    ",
      "lightcyan                     ",
      "lightgoldenrod                ",
      "lightgoldenrodyellow          ",
      "LightGray                     ",
      "lightgrey                     ",
      "lightpink                     ",
      "lightsalmon                   ",
      "lightseagreen                 ",
      "lightskyblue                  ",
      "lightslateblue                ",
      "lightslategray                ",
      "lightslategrey                ",
      "lightsteelblue                ",
      "lightyellow                   ",
      "limegreen                     ",
      "linen                         ",
      "magenta                       ",
      "maroon                        ",
      "mediumaquamarine              ",
      "mediumblue                    ",
      "mediumorchid                  ",
      "mediumpurple                  ",
      "mediumseagreen                ",
      "mediumslateblue               ",
      "mediumspringgreen             ",
      "mediumturquoise               ",
      "mediumvioletred               ",
      "midnightblue                  ",
      "mintcream                     ",
      "mistyrose                     ",
      "moccasin                      ",
      "navajowhite                   ",
      "navy                          ",
      "navyblue                      ",
      "None                          ",
      "oldlace                       ",
      "olivedrab                     ",
      "orange                        ",
      "orangered                     ",
      "orchid                        ",
      "palegoldenrod                 ",
      "palegreen                     ",
      "paleturquoise                 ",
      "palevioletred                 ",
      "papayawhip                    ",
      "peachpuff                     ",
      "peru                          ",
      "pink                          ",
      "plum                          ",
      "powderblue                    ",
      "purple                        ",
      "red                           ",
      "rosybrown                     ",
      "royalblue                     ",
      "saddlebrown                   ",
      "salmon                        ",
      "sandybrown                    ",
      "seagreen                      ",
      "seashell                      ",
      "sienna                        ",
      "skyblue                       ",
      "slateblue                     ",
      "slategray                     ",
      "slategrey                     ",
      "snow                          ",
      "springgreen                   ",
      "steelblue                     ",
      "tan                           ",
      "thistle                       ",
      "tomato                        ",
      "transparent                   ",
      "turquoise                     ",
      "violet                        ",
      "violetred                     ",
      "wheat                         ",
      "white                         ",
      "whitesmoke                    ",
      "yellow                        ",
      "yellowgreen                   ");
   -- Name for all colors used in a XPM file, it is public in this package to be used
   -- by Img_Translator program


   Img_To_Coded_File_C     : constant Img_To_File_Name_T        :=
     (Book_Open        => ("nofileused                    "),
      Book_Closed      => ("nofileused                    "),
      About_Dialog     => ("img001.bin                    "),
      Arrows_Down_Mini => ("img002.bin                    "),
      Cartoon_Dpm      => ("img003.bin                    "),
      Cartoon_Icm      => ("img004.bin                    "),
      Cartoon_Pcdm     => ("img005.bin                    "),
      Cartoon_Smu      => ("img006.bin                    "),
      Envelope_Mini    => ("img007.bin                    "),
      Gmv_Mini         => ("img008.bin                    "),
      Oeu              => ("img009.bin                    "),
      Oeu_Icon         => ("img010.bin                    "),
      Megaphone_Mini   => ("img011.bin                    "),
      Connect_Mini     => ("img012.bin                    "),
      Unconnect_Mini   => ("img013.bin                    ")
      );







   procedure Init (Debug_Routine  : in Basic_Types_I.Debug_Proc_T);

--   Xpm_Image        : Interfaces.C.Strings.Chars_Ptr_Array (0 .. Max_Xpm_Lines_C) :=
--     (others => Interfaces.C.Strings.Null_Ptr);

   function Get_Image_Xpm (Image   : Images_T) return Gdk.Pixbuf.Gdk_Pixbuf;

   function Get_Image_Xpm (Image   : Images_T) return
     Interfaces.C.Strings.chars_ptr_array;


end Wdgt_Images;

