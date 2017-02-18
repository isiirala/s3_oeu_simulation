

with Basic_Types_1553;
with Basic_Types_I;

package Uif_Tc_Tm_If_Out is


-- TODO:     CONTROLAR LA INTERFAZ DE SALIDA DE LOS GRUPOS DE PAQUETES
--      - una if como esta o un paquete con renames


   type If_Out_T is interface;


   procedure Send_Tc
     (If_Out    : not null access If_Out_T;
      Sa_Id     : in Basic_Types_1553.Sa_Id_T;
      Raw_Tc    : in Basic_Types_I.Byte_Array_T)
   is abstract;





end Uif_Tc_Tm_If_Out;

