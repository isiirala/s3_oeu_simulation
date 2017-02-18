
with Debug_Log;

package body Wdgt_Colors is


   Initialised    : Boolean       := False;


   procedure Init
   is
      Color_Ok  : Boolean    := False;
   begin

      if not Initialised then

         Gdk.Rgba.Parse
          (Self    => Separator_1,
           Spec    => "#838383",
           Success => Color_Ok);
         Separator_1.Alpha := 0.7;
         if not Color_Ok then
            Debug_Log.Do_Log ("Error creating Separator_1");
         end if;

         Gdk.Rgba.Parse
          (Self    => Separator_2,
           Spec    => "#939393",
           Success => Color_Ok);
         Separator_2.Alpha := 0.7;
         if not Color_Ok then
            Debug_Log.Do_Log ("Error creating Separator_2");
         end if;


         Initialised := True;
      end if;
   end Init;



   function To_Gdk (Color : Color_T) return Gdk.Color.Gdk_Color
   is
      Result : Gdk.Color.Gdk_Color       := Gdk.Color.Null_Color;
   begin

      Gdk.Color.Set_Rgb
        (Color => Result,
         Red   => Array_Colors_C (Color).Red,
         Green => Array_Colors_C (Color).Green,
         Blue  => Array_Colors_C (Color).Blue);
      return Result;
   end To_Gdk;


end Wdgt_Colors;
