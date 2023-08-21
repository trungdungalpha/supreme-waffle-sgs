if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "SGS" /min "%~f0" %* && exit
@echo on

start /MIN cmd.exe /c call "ForceReset"

SETLOCAL EnableExtensions

set EXE=sgs-client.exe

set loopvar=1

:a
set /a rand=%random% %%400+14000
timeout /t %rand%

FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF %%x == %EXE% goto ProcessFound

goto ProcessNotFound

:ProcessFound
echo %EXE% is running
goto a

:ProcessNotFound
echo %EXE% is not running
goto RELOAD


:RELOAD
taskkill /f /im salad.exe
timeout 5
taskkill /f /im salad.bowl.service.exe
set /a rand=%random% %%60+120
timeout /t %rand%
start /MIN cmd.exe /c "C:\Program Files\Salad\Salad.exe"
timeout 3
TASKKILL /F /IM explorer.exe
start "explorer.exe" "C:\Windows\explorer.exe"
echo Reload Salad!


if %loopvar% gtr 6 (goto :done) else (set /a loopvar=%loopvar%+1 && echo Loop && goto :a)
:done

shutdown /r
