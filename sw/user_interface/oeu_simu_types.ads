

package Oeu_Simu_Types is





-- --------------------------------------------------------------------------------------
-- Logs of the application. Text files generated with execution info

   type Log_T is (Log_App_Exe, Log_Smu_1553, Log_Icm_Exe, Log_Dpm_Exe, Log_Pcdm_Exe);

   type Arr_Bool_Log_T is array (Log_T'Range) of Boolean;





end Oeu_Simu_Types;
