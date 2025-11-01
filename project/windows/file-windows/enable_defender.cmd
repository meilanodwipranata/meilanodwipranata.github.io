@echo off
REM ------------------------------
REM enable_defender.cmd
REM - Run as Administrator (script will self-elevate if not run as admin)
REM ------------------------------

:: Self-elevate if not running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo Requesting administrative privileges...
  powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
  exit /b
)

echo.
echo === Re-enabling Microsoft Defender and removing persistence ===
echo.

:: Remove scheduled task
schtasks /Delete /TN "DisableDefenderAtStartup" /F >nul 2>&1

:: Remove registry settings we added
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f >nul 2>&1

:: Try to enable realtime monitoring via PowerShell
powershell -Command "Try { Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop; Write-Output 'Real-time monitoring command executed.' } Catch { Write-Output 'Could not change real-time via Set-MpPreference.' }"

echo.
echo Done. Restart the PC to make sure Defender is active again.
echo.

pause
