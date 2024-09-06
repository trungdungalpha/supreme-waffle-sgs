if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "SGS" /min "%~f0" %* && exit
@echo on

start /MIN cmd.exe /c call "ForceReset"

REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v ScoobeSystemSettingEnabled /t REG_DWORD /d 00000000 /f

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
if %loopvar% gtr 1 (goto :done) else (set /a loopvar=%loopvar%+1 && echo Loop && goto :c)

:c
taskkill /f /im salad.bowl.service.exe

echo Reload Salad!

goto :a

:done

rmdir /s /q C:\ProgramData\Salad\logs\ndm

shutdown /r

cd %windir%\SystemApps
taskkill /f /im SearchApp.exe
taskkill /f /im SearchApp.exe
taskkill /f /im SearchApp.exe
move Microsoft.Windows.Search_cw5n1h2txyewy Microsoft.Windows.Search_cw5n1h2txyewy.old
timeout /t 5
exit
