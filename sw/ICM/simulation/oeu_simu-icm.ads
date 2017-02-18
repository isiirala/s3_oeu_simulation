-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simu.Icm
--  Unit Type           : Package Specification 
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : ICM main simulation package of OEU
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************


with If_Bus_1553_Pus;

package Oeu_Simu.Icm is

   procedure Init(Bc_Access  : in If_Bus_1553_Pus.Acc_Bus_1553_Pus_Bc_For_Rt_T);
   
   procedure Switch_On;
   procedure Switch_Off;

   
   
   procedure Read_Obsw_Log(Str : in out String; Actual_Len : out Natural);
   
   
private

   procedure Write_Obsw_Log(Str : in String);



--   null;


end Oeu_Simu.Icm;

