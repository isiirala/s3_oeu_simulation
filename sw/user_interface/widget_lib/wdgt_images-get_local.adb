
separate (Wdgt_Images)

function Get_Local (Image : Images_T) return Interfaces.C.Strings.Chars_Ptr_Array
is
   package ICS renames Interfaces.C.Strings;

begin

   case Image is
   when Book_Open =>
      return --Interfaces.C.Strings.Chars_Ptr_Array
     (ICS.New_String ("16 16 4 1"),
      ICS.New_String ("       c None s None"),
      ICS.New_String (".      c black"),
      ICS.New_String ("X      c #808080"),
      ICS.New_String ("o      c white"),
      ICS.New_String ("                "),
      ICS.New_String ("  ..            "),
      ICS.New_String (" .Xo.    ...    "),
      ICS.New_String (" .Xoo. ..oo.    "),
      ICS.New_String (" .Xooo.Xooo...  "),
      ICS.New_String (" .Xooo.oooo.X.  "),
      ICS.New_String (" .Xooo.Xooo.X.  "),
      ICS.New_String (" .Xooo.oooo.X.  "),
      ICS.New_String (" .Xooo.Xooo.X.  "),
      ICS.New_String (" .Xooo.oooo.X.  "),
      ICS.New_String ("  .Xoo.Xoo..X.  "),
      ICS.New_String ("   .Xo.o..ooX.  "),
      ICS.New_String ("    .X..XXXXX.  "),
      ICS.New_String ("    ..X.......  "),
      ICS.New_String ("     ..         "),
      ICS.New_String ("                "));

   when Book_Closed =>
      return -- Interfaces.C.Chars_Ptr_Array
     (ICS.New_String ("16 16 6 1"),
      ICS.New_String ("       c None s None"),
      ICS.New_String (".      c black"),
      ICS.New_String ("X      c red"),
      ICS.New_String ("o      c yellow"),
      ICS.New_String ("O      c #808080"),
      ICS.New_String ("#      c white"),
      ICS.New_String ("                "),
      ICS.New_String ("       ..       "),
      ICS.New_String ("     ..XX.      "),
      ICS.New_String ("   ..XXXXX.     "),
      ICS.New_String (" ..XXXXXXXX.    "),
      ICS.New_String (".ooXXXXXXXXX.   "),
      ICS.New_String ("..ooXXXXXXXXX.  "),
      ICS.New_String (".X.ooXXXXXXXXX. "),
      ICS.New_String (".XX.ooXXXXXX..  "),
      ICS.New_String (" .XX.ooXXX..#O  "),
      ICS.New_String ("  .XX.oo..##OO. "),
      ICS.New_String ("   .XX..##OO..  "),
      ICS.New_String ("    .X.#OO..    "),
      ICS.New_String ("     ..O..      "),
      ICS.New_String ("      ..        "),
      ICS.New_String ("                "));

--     when Arrows_Down =>
--        return --Interfaces.C.Chars_Ptr_Array
--       (ICS.New_String ("16 16 4 1"),
--        ICS.New_String ("       c None s None"),
--        ICS.New_String (".      c black"),
--        ICS.New_String ("O      c yellow"),
--        ICS.New_String ("o      c white"),
--        ICS.New_String (".              ."),
--        ICS.New_String ("..            .."),
--        ICS.New_String ("o..          ..o"),
--        ICS.New_String (" o..        ..o "),
--        ICS.New_String ("  o..      ..o  "),
--        ICS.New_String ("   o..    ..o   "),
--        ICS.New_String (".   o..  ..o   ."),
--        ICS.New_String ("..   o....o   .."),
--        ICS.New_String ("o..   o..o   ..o"),
--        ICS.New_String (" o..   oo   ..o "),
--        ICS.New_String ("  o..      ..o  "),
--        ICS.New_String ("   o..    ..o   "),
--        ICS.New_String ("    o..  ..o    "),
--        ICS.New_String ("     o....o     "),
--        ICS.New_String ("      o..o      "),
--        ICS.New_String ("       oo       "));
--     when Envelope =>
--        return --Interfaces.C.Chars_Ptr_Array
--       (ICS.New_String ("16 16 4 1"),
--        ICS.New_String ("       c None s None"),
--        ICS.New_String (".      c black"),
--        ICS.New_String ("O      c yellow"),
--        ICS.New_String ("o      c white"),
--        ICS.New_String ("                "),
--        ICS.New_String ("................"),
--        ICS.New_String ("...          ..."),
--        ICS.New_String (". ..        ..o."),
--        ICS.New_String (".  ..      ..o ."),
--        ICS.New_String (".   ..    ..o  ."),
--        ICS.New_String (".    ..  ..o   ."),
--        ICS.New_String (".    .....o.   ."),
--        ICS.New_String (".   .  ..o  .  ."),
--        ICS.New_String (".  .    o    . ."),
--        ICS.New_String (". .           .."),
--        ICS.New_String ("..             ."),
--        ICS.New_String ("................"),
--        ICS.New_String ("                "),
--        ICS.New_String ("                "),
--        ICS.New_String ("                "));

   when others =>
      return Empty_Chars_Ptr_Array_C;
   end case;

end Get_Local;
