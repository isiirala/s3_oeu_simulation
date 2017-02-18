-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : UIF_Oeu_Simu.Icm
--  Unit Type           : Package specification
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Builder of ICM User Interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************


package UIF_Oeu_Simu.Icm is


   procedure Build;

   procedure Destroy;


--   procedure Write_Char_In_Log (C : in Character);
   procedure Write_Str_In_Log (Str : in String);

--   procedure Switch_On;
--   procedure Switch_Off;


end UIF_Oeu_Simu.Icm;
