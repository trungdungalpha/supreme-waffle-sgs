@echo off

:: Relaunch the script minimized if not already
if not defined IS_MINIMIZED (
    set IS_MINIMIZED=1
    start "SGS Monitor" /min "%~f0" %*
    exit
)

:: Initial setup
start /MIN cmd.exe /c call "ForceReset"
taskkill /F /IM TrafficMonitor.exe >nul 2>&1
REG ADD HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f >nul

setlocal EnableExtensions

set "EXE=sgs-client.exe"
set "loopvar=0"

:monitor_loop
:: Wait between 7200 and 9000 seconds (2 to 2.5 hours)
set /a delay=(%RANDOM% %%1801) + 7200
timeout /t %delay% /nobreak >nul

:: Check if the process is running
tasklist /FI "IMAGENAME eq %EXE%" 2>NUL | find /I "%EXE%" >NUL
if not errorlevel 1 (
    echo %EXE% is running.
    set "loopvar=0"
    goto monitor_loop
) else (
    echo %EXE% is NOT running.
    goto reload_attempt
)

:reload_attempt
if %loopvar% geq 3 (
    goto shutdown_sequence
) else (
    set /a loopvar+=1
    echo Attempt #%loopvar% to recover...
    goto try_restart_service
)

:try_restart_service
taskkill /F /IM salad.bowl.service.exe >nul 2>&1
echo Salad service terminated. Retrying in next cycle...
goto monitor_loop

:shutdown_sequence
echo Recovery failed after %loopvar% attempts. Proceeding with shutdown and cleanup...
rmdir /s /q "C:\ProgramData\Salad\logs\ndm" >nul 2>&1

:: Optional: Disable Windows Search
cd /d %windir%\SystemApps
taskkill /F /IM SearchApp.exe >nul 2>&1
move "Microsoft.Windows.Search_cw5n1h2txyewy" "Microsoft.Windows.Search_cw5n1h2txyewy.old" >nul 2>&1

timeout /t 5 >nul
shutdown /r /t 0
