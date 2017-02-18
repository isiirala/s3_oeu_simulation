
with Ada.Characters.Latin_1;

package Uif_Resources_Lib is


--   type Res_Id is (

-- que este paquete sea la interfaz (espéicifica de esta aplicación)
-- de un componente generico que se ponga en widget_lib que luego todo widget_lib se
-- pueda mover a una dll
-- el Resources_Lib de widget_lib que devuelva una cada de bytes o caracteres por cada
-- recurso que se le pida. implementando una forma de volcar a fichero un byte_array
-- Pero hay que hacer tambien el programilla que genere el fichero



   Css_Style_C        : constant String       :=
     ".notebook tab { " & Ada.Characters.Latin_1.LF &
     "   background-image: -gtk-gradient (linear, left top, left bottom, from(#aaa), to(#fff)); " &
     Ada.Characters.Latin_1.LF &
     "} " & Ada.Characters.Latin_1.LF &
--     "GtkNotebook .active { " & Ada.Characters.Latin_1.LF &
--     "   color: red; " & Ada.Characters.Latin_1.LF &
--     "   background-color: yellow; " &Ada.Characters.Latin_1.LF &
--     "}" & Ada.Characters.Latin_1.LF &
     "GtkTreeView *:hover { " & Ada.Characters.Latin_1.LF &
     "   color: #009900; " & Ada.Characters.Latin_1.LF &
     "}" & Ada.Characters.Latin_1.LF &
--     ".notebook :active { " & Ada.Characters.Latin_1.LF &
--     "   background-image:none; " & Ada.Characters.Latin_1.LF &
--     "} " & Ada.Characters.Latin_1.LF &
     ".notebook, .button, .entry { " & Ada.Characters.Latin_1.LF &
     "  border-radius: 8px;" & Ada.Characters.Latin_1.LF &
     "  border-style: solid;" & Ada.Characters.Latin_1.LF &
--     "  border-width: 1;" & Ada.Characters.Latin_1.LF &
     "}" & Ada.Characters.Latin_1.LF &
-- Scrollbars with arrow stepper buttons:
     ".scrollbar {" & Ada.Characters.Latin_1.LF &
     "  -GtkScrollbar-has-backward-stepper: true;" & Ada.Characters.Latin_1.LF &
     "  -GtkScrollbar-has-forward-stepper: true;" & Ada.Characters.Latin_1.LF &
     "}";






--
--.titlebar {
-- border-radius: 0;
--}






   procedure Init;

--   procedure Get_Image_Xpm


end Uif_Resources_Lib;
