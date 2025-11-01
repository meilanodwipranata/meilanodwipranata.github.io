@echo off
echo =========================================
echo   Optimasi RAM Windows 11 - Mode Permanen
echo =========================================
timeout /t 2 >nul

:: 1. Nonaktifkan service berat
sc config "SysMain" start= disabled
sc config "DiagTrack" start= disabled
sc config "WSearch" start= disabled

:: 2. Matikan efek visual
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Performance Settings" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: 3. Matikan telemetry & tips Windows
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f

:: 4. Bersihkan startup & cache
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*" /q >nul 2>&1
del /q/f/s %TEMP%\* >nul 2>&1
del /q/f/s C:\Windows\Temp\* >nul 2>&1

rundll32.exe advapi32.dll,ProcessIdleTasks

echo.
echo ✅ Optimasi permanen selesai!
echo Restart komputer agar aktif sepenuhnya.
pause