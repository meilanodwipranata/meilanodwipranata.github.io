@echo off
REM ------------------------------
REM disable_defender.cmd
REM - Run as Administrator (script will self-elevate if not run as admin)
REM - Requires Tamper Protection OFF in Windows Security for permanency
REM ------------------------------

:: Self-elevate if not running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo Requesting administrative privileges...
  powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
  exit /b
)

echo.
echo === Disabling Microsoft Defender (registry + realtime) ===
echo Note: Tamper Protection must be OFF for this to persist.
echo.

:: Add registry keys (policies) to disable Defender and real-time monitoring
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f

:: Ensure the registry paths exist (redundant but safe)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /f >nul 2>&1

:: Try to disable realtime monitoring immediately via PowerShell
powershell -Command "Try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Stop; Write-Output 'Real-time monitoring command executed.' } Catch { Write-Output 'Could not change real-time via Set-MpPreference (may require Tamper Protection OFF).' }"

:: Create a Scheduled Task that runs this same script at every system startup as SYSTEM (ensures persistence)
schtasks /Create /F /SC ONSTART /RL HIGHEST /TN "DisableDefenderAtStartup" /TR "\"%~f0\"" /RU "SYSTEM" >nul 2>&1
if %errorlevel% equ 0 (
  echo Scheduled Task "DisableDefenderAtStartup" created to run at startup.
) else (
  echo Failed to create scheduled task. You may need to create it manually.
)

echo.
echo Registry and immediate commands applied. Restart the PC to confirm.
echo To re-enable Defender later, run the included enable_defender.cmd as Administrator.
echo.

pause
