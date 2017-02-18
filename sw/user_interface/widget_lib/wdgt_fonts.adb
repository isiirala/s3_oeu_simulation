
with Glib;
with Pango.Enums;


with Wdgt_Colors;


package body Wdgt_Fonts is






   procedure Set_Attrs
     (Font   : in String;
      Color  : in Wdgt_Colors.Color_T;
      Bold   : in Boolean;
      Scale  : in Glib.Gdouble;
      Attrs  : in out Pango.Attributes.Pango_Attr_List)
   is
      Attr_Family         : Pango.Attributes.Pango_Attribute    :=
        Pango.Attributes.Attr_Family_New (Font);

      Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
        Pango.Attributes.Attr_Foreground_New
        (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
         Green => Wdgt_Colors.Array_Colors_C (Color).Green,
         Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--      Attr_B_Color        : Pango.Attributes.Pango_Attribute    :=
--        Pango.Attributes.Attr_Background_New
--        (Red   => 0, --: Guint16;
--         Green => 200, --: Guint16;
--         Blue  => 0); --: Guint16) return Pango_Attribute;
      Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
        Pango.Attributes.Attr_Scale_New (Scale_Factor => Scale);
      Attr_Bold          : Pango.Attributes.Pango_Attribute   :=
        Pango.Attributes.Attr_Weight_New (Weight => Pango.Enums.Pango_Weight_Bold);
   begin

       Attrs.Insert (Attr_Family);
       Attrs.Insert (Attr_F_Color);
--       Attrs.Insert (Attr_B_Color);
       Attrs.Insert (Attr_Scale);
       if Bold then
           Attrs.Insert (Attr_Bold);
       end if;
   end Set_Attrs;




--     procedure Get_Attr_Title1
--       (Color  : in Wdgt_Colors.Color_T;
--        Bold   : in Boolean;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Franklin Gothic Heavy, 16");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 2.5);
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--     end Get_Attr_Title1;

--     procedure Get_Attr_Title2
--       (Color  : in Wdgt_Colors.Color_T;
--        Bold   : in Boolean;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Franklin Gothic Heavy, 16");  -- Normal 14
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--  --      Attr_B_Color        : Pango.Attributes.Pango_Attribute    :=
--  --        Pango.Attributes.Attr_Background_New
--  --        (Red   => 0, --: Guint16;
--  --         Green => 200, --: Guint16;
--  --         Blue  => 0); --: Guint16) return Pango_Attribute;
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 2.0);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--  --       Attrs.Insert (Attr_B_Color);
--         Attrs.Insert (Attr_Scale);
--     end Get_Attr_Title2;

--     procedure Get_Attr_Title3
--       (Color  : in Wdgt_Colors.Color_T;
--        Bold   : in Boolean;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Franklin Gothic Heavy, 16");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 1.0);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--     end Get_Attr_Title3;

--     procedure Get_Attr_Title4
--       (Color  : in Wdgt_Colors.Color_T;
--        Bold   : in Boolean;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Franklin Gothic Heavy, 16");  -- Normal 14
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 1.0);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--     end Get_Attr_Title4;
--
--     procedure Get_Attr_Title5
--       (Color  : in Wdgt_Colors.Color_T;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Franklin Gothic Heavy, 14");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--  --      Attr_B_Color        : Pango.Attributes.Pango_Attribute    :=
--  --        Pango.Attributes.Attr_Background_New
--  --        (Red   => 0, --: Guint16;
--  --         Green => 200, --: Guint16;
--  --         Blue  => 0); --: Guint16) return Pango_Attribute;
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 1.0);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--  --       Attrs.Insert (Attr_B_Color);
--         Attrs.Insert (Attr_Scale);
--     end Get_Attr_Title5;





--     procedure Get_Attr_Text1_Sans
--       (Color  : in Wdgt_Colors.Color_T;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Sans, 12");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 2.0);
--  --      Attr_Bold          : Pango.Attributes.Pango_Attribute   :=
--  --        Pango.Attributes.Attr_Weight_New (Weight => Pango.Enums.Pango_Weight_Bold);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--  --       Attrs.Insert (Attr_Bold);
--     end Get_Attr_Text1_Sans;
--
--     procedure Get_Attr_Text1_Courier
--       (Color  : in Wdgt_Colors.Color_T;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Courier New, 12");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 2.0);
--  --      Attr_Bold          : Pango.Attributes.Pango_Attribute   :=
--  --        Pango.Attributes.Attr_Weight_New (Weight => Pango.Enums.Pango_Weight_Bold);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--  --       Attrs.Insert (Attr_Bold);
--     end Get_Attr_Text1_Courier;
--
--     procedure Get_Attr_Text2_Sans
--       (Color  : in Wdgt_Colors.Color_T;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Sans, 12");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 1.0);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--     end Get_Attr_Text2_Sans;
--
--     procedure Get_Attr_Text2_Courier
--       (Color  : in Wdgt_Colors.Color_T;
--        Attrs  : in out Pango.Attributes.Pango_Attr_List)
--     is
--        Attr_Family         : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Family_New ("Courier New, 12");
--
--        Attr_F_Color        : Pango.Attributes.Pango_Attribute    :=
--          Pango.Attributes.Attr_Foreground_New
--          (Red   => Wdgt_Colors.Array_Colors_C (Color).Red,
--           Green => Wdgt_Colors.Array_Colors_C (Color).Green,
--           Blue  => Wdgt_Colors.Array_Colors_C (Color).Blue);
--        Attr_Scale          : Pango.Attributes.Pango_Attribute   :=
--          Pango.Attributes.Attr_Scale_New (Scale_Factor => 1.0);
--  --      Attr_Bold          : Pango.Attributes.Pango_Attribute   :=
--  --        Pango.Attributes.Attr_Weight_New (Weight => Pango.Enums.Pango_Weight_Bold);
--
--     begin
--
--         Attrs.Insert (Attr_Family);
--         Attrs.Insert (Attr_F_Color);
--         Attrs.Insert (Attr_Scale);
--  --       Attrs.Insert (Attr_Bold);
--     end Get_Attr_Text2_Courier;


   function Get_Attributes
     (Font   : in Fonts_T;
      Color  : in Wdgt_Colors.Color_T := Wdgt_Colors.Black;
      Bold   : in Boolean := False) return Pango.Attributes.Pango_Attr_List
   is

      Text_Attrs       : Pango.Attributes.Pango_Attr_List    :=
        Pango.Attributes.Pango_Attr_List_New;

   begin

      case Font is
         when F_Title1 =>
           Set_Attrs
--             (Font   => "Franklin Gothic Heavy, 16",
             (Font   => "Franklin Gothic Medium, 16",
              Color  => Color,
              Bold   => Bold,
              Scale  => 2.5,
              Attrs  => Text_Attrs);
         when F_Title2 =>
           Set_Attrs
--             (Font   => "Franklin Gothic Heavy, 16",
             (Font   => "Franklin Gothic Medium, 16",
              Color  => Color,
              Bold   => Bold,
              Scale  => 2.0,
              Attrs  => Text_Attrs);
         when F_Title3 =>
           Set_Attrs
--             (Font   => "Franklin Gothic Heavy, 16",
             (Font   => "Franklin Gothic Medium, 16",
              Color  => Color,
              Bold   => Bold,
              Scale  => 1.0,
              Attrs  => Text_Attrs);
         when F_Title4 =>
           Set_Attrs
--             (Font   => "Franklin Gothic Heavy, 14",
             (Font   => "Franklin Gothic Medium, 14",
              Color  => Color,
              Bold   => Bold,
              Scale  => 1.0,
              Attrs  => Text_Attrs);
         when F_Title5 =>
           Set_Attrs
--             (Font   => "Franklin Gothic Heavy, 10",
             (Font   => "Franklin Gothic Medium, 10",
              Color  => Color,
              Bold   => Bold,
              Scale  => 1.0,
              Attrs  => Text_Attrs);

         when F_Text1_Courier =>
           Set_Attrs
             (Font   => "Courier New, 12",
              Color  => Color,
              Bold   => Bold,
              Scale  => 2.0,
              Attrs  => Text_Attrs);
         when F_Text1_Sans    =>
           Set_Attrs
             (Font   => "Sans, 12",
              Color  => Color,
              Bold   => Bold,
              Scale  => 2.0,
              Attrs  => Text_Attrs);
         when F_Text2_Sans    =>
           Set_Attrs
             (Font   => "Sans, 12",
              Color  => Color,
              Bold   => Bold,
              Scale  => 1.0,
              Attrs  => Text_Attrs);
         when F_Text2_Courier =>
           Set_Attrs
             (Font   => "Courier New, 12",
              Color  => Color,
              Bold   => Bold,
              Scale  => 1.0,
              Attrs  => Text_Attrs);
      end case;

      return Text_Attrs;
   end Get_Attributes;


end Wdgt_Fonts;
