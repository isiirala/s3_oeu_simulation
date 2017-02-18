

with Glib;

with Gdk.Color;
with Gdk.Rgba;


package Wdgt_Colors is


   type Color_Rgb_T is record
      Red   : Glib.Guint16;
      Green : Glib.Guint16;
      Blue  : Glib.Guint16;
   end record;


   type Color_T is (Black,
     Smu_1, Dpm_1, Icm_1, Pcdm_1,
     Orange_1, Orange_2,
     Gray_1);


   type Array_Colors_T is array (Color_T'Range) of Color_Rgb_T;

   Array_Colors_C : constant Array_Colors_T   :=
     (Black       => (Red =>     0, Green =>     0, Blue =>     0),
      Dpm_1       => (Red =>  9766, Green => 29555, Blue => 24158),
      Icm_1       => (Red =>  9766, Green => 21331, Blue => 29555),
      Pcdm_1      => (Red => 18247, Green => 33153, Blue => 11051),
      Smu_1       => (Red => 47802, Green => 21074, Blue => 15934),
      Orange_1    => (Red => 65535, Green => 44975, Blue =>     0),
      Orange_2    => (Red => 47031, Green => 32382, Blue =>     0),
      Gray_1      => (Red => 23130, Green => 23130, Blue => 23130));

-- In range 1 - 255:
-- SMU: 186, 82, 62   DPM: 38, 115, 94    PCDM: 71, 129, 43    ICM: 38, 83, 115  (x257)
-- Orange_1 255, 175, 0
-- Orange_2 183, 126, 0
-- Gray_1 90, 90, 90


   Separator_1       : Gdk.Rgba.Gdk_Rgba                := Gdk.Rgba.Null_Rgba;
   Separator_2       : Gdk.Rgba.Gdk_Rgba                := Gdk.Rgba.Null_Rgba;



   procedure Init;


   function To_Gdk (Color : Color_T) return Gdk.Color.Gdk_Color;


end Wdgt_Colors;
