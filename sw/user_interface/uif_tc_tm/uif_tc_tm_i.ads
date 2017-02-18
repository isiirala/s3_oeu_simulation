
with Basic_Types_1553;
with Basic_Types_I;
with Pus_Format_Types_I;

with Test_Params_I;
--with Uif_Tc_Tm_If_Out;

package Uif_Tc_Tm_I is



   procedure Build;

   function Is_Built return Boolean;
   -- True when the TC/TM dialog is built in the UIF

   procedure Take_Focus;

   procedure Destroy;

   function Get_Tm_Displayed return Basic_Types_1553.Tc_Tm_Id_T;

   procedure Update_Tm_Params
     (Tm_Id         : in Basic_Types_1553.Tc_Tm_Id_T;
      Tm_Params     : in out Test_Params_I.Array_Params_T;
      Tm_Params_Len : in out Basic_Types_I.Data_32_Len_T);


end Uif_Tc_Tm_I;


