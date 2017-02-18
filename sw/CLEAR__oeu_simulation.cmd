@echo off

: ============================================ ali
@del /q ..\ali\Common\tools_and_pus\lib_ali\*.*
@del /q ..\ali\Common\tools_and_pus\lib\*.*

@del /q ..\ali\opsw_sal\lib\*.*
@del /q ..\ali\opsw_sal\lib_ali\*.*
@del /q ..\ali\opsw_sal\lib_src_if\*.*

@del /q ..\ali\osu_simulation

@del /q ..\ali\rsw_sal\lib\*.*
@del /q ..\ali\rsw_sal\lib_ali\*.*
@del /q ..\ali\rsw_sal\lib_src_if\*.*


: ============================================ bin
@del /q ..\bin\*.dll
@del /q ..\bin\oeu_simulation.exe

: ============================================ obj
@del /q ..\obj\Common\tools_and_pus\*.*
@del /q ..\obj\ICM\opsw_sal\*.*
@del /q ..\obj\ICM\rsw_sal\*.*
@del /q ..\obj\oeu_simulation\*.*


pause
