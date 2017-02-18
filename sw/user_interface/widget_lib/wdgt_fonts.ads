
with Pango.Attributes;

with Wdgt_Colors;

package Wdgt_Fonts is


   type Fonts_T is (F_Title1, F_Title2, F_Title3, F_Title4, F_Title5,
     F_Text1_Sans, F_Text1_Courier,
     F_Text2_Sans, F_Text2_Courier);


   function Get_Attributes
     (Font   : in Fonts_T;
      Color  : in Wdgt_Colors.Color_T := Wdgt_Colors.Black;
      Bold   : in Boolean := False) return Pango.Attributes.Pango_Attr_List;

end Wdgt_Fonts;
