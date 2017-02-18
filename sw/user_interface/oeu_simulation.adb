-- ****************************************************************************
--  Project             : S3 OLCI OEU Simulation
--  Unit Name           : Oeu_Simulation
--  Unit Type           : Procedure
--  Copyright           : GMV
--  Classification      :
--  Date                : $Date: 2011/11/25 06:55:06 $
--  Revision            : $Revision: 1.21 $
--  Function            : Main program of user interface
-- ****************************************************************************
--  REVISION AUTHOR  DATE    :  CHANGE
--   1.0     iiiv  27/04/2013 : Initial version
-- ****************************************************************************

with Debug_Log;
with UIF_Builder;
--with Uif_Configs;
--with Oeu_Executer;



--with Oeu_Simu.Icm.Wrapper_From_Obsw;

procedure Oeu_Simulation is

begin

-- Create the Application log debug file
--         Debug_Log.Init;


   UIF_Builder.Build_Application;

--   UIF_Builder.Config_UIF_Callbacks(
--     Period       => Uif_Configs.Period_Glib_Interrupt_C,
--     Periodic_CB  => Oeu_Executer.UIF_Periodic_CB'Access,
--     Idle_CB      => Oeu_Executer.UIF_Idle_CB'Access);

   UIF_Builder.Main_Loop;

   Debug_Log.Do_Log ("[Oeu_Simulation] After Main_Loop");

   UIF_Builder.Terminate_UIF;

end Oeu_Simulation;


