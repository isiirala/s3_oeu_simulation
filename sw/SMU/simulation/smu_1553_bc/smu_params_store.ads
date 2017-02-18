

with Basic_Types_1553;
with Basic_Types_I;
with Test_Params_I;


package Smu_Params_Store is


-- TODO: TO KNOW THE STATUS OF EACH TC.  ¿¿añadir caducidad de tiempo a los parametros
--      de HK??
--   type Tc_Status_T is (Tc_No_Ack, Tc_Tm_1_1, Tc_Tm_1_7, );
--
--   type Tm_Status_T is ();
--
--   procedure Set_Tc_As_Transmitted
--     (Tc_Id       : in Basic_Types_1553.Tc_Tm_Id_T);
--
--   procedure Get_Tm_Status
--     (Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
--      Status      : out Tm_Status_T);



   procedure Store
     (Tc_Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
      Params         : in Test_Params_I.Array_Params_T;
      Params_Len     : in Basic_Types_I.Data_32_Len_T);


   procedure Retrieve
     (Tc_Tm_Id       : in Basic_Types_1553.Tc_Tm_Id_T;
      Params         : in out Test_Params_I.Array_Params_T;
      Params_Len     : in out Basic_Types_I.Data_32_Len_T);



end Smu_Params_Store;
