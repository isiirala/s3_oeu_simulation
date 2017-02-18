@echo off

@echo -----------------------------------------------------------------------
@echo Create output directories
@echo -----------------------------------------------------------------------
: ============================================ ali
@md ..\ali
@md ..\ali\Common
@md ..\ali\Common\tools_and_pus
@md ..\ali\Common\tools_and_pus\lib_ali
@md ..\ali\Common\tools_and_pus\lib

@md ..\ali\opsw_sal
@md ..\ali\opsw_sal\lib
@md ..\ali\opsw_sal\lib_ali
@md ..\ali\opsw_sal\lib_src_if

@md ..\ali\osu_simulation

@md ..\ali\rsw_sal
@md ..\ali\rsw_sal\lib
@md ..\ali\rsw_sal\lib_ali
@md ..\ali\rsw_sal\lib_src_if

: ============================================ bin
@md ..\bin

: ============================================ obj
@md ..\obj\Common\tools_and_pus
@md ..\obj\ICM\opsw_sal
@md ..\obj\ICM\rsw_sal
@md ..\obj\oeu_simulation

: =================================================
: Build SW

cd Common\Sw_Components\01__scripts
call BUILD__lib_tools_and_pus.cmd
call COMPLETE__lib_tools_and_pus.cmd

cd ..\..\..\ICM\lib_onboard_sw
call BUILD__lib_rsw_sal.cmd
call COMPLETE__lib_rsw_sal.cmd

cd ..\..\ICM\lib_onboard_sw
call BUILD__lib_opsw_sal.cmd
call COMPLETE__lib_opsw_sal.cmd


cd ..\..\

@echo -----------------------------------------------------------------------
@echo BUILD oeu_simulation
@echo -----------------------------------------------------------------------
title BUILD oeu_simulation

: Create resources file for the executable program, to set the properties of the executable
cd user_interface\resources
call build_resources_oeu_simulation.cmd
cd ..\..\

gprbuild oeu_simulation.gpr
if ERRORLEVEL 1 goto :Showerror
pause


goto :EndOfCopi
:Showerror
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Build error occurred <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
pause
exit /b 1

:EndOfCopi

@echo -----------------------------------------------------------------------
@echo BUILD terminated sucessfully
@echo -----------------------------------------------------------------------

