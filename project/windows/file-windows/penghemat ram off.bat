@echo off
echo =========================================
echo   Mengembalikan Pengaturan Default Windows 11
echo =========================================
timeout /t 2 >nul

:: 1. Aktifkan kembali service yang dimatikan
sc config "SysMain" start= auto
sc start "SysMain"

sc config "DiagTrack" start= auto
sc start "DiagTrack"

sc config "WSearch" start= delayed-auto
sc start "WSearch"

:: 2. Pulihkan efek visual ke default
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Performance Settings" /v VisualFXSetting /t REG_DWORD /d 0 /f

:: 3. Pulihkan telemetry & tips bawaan
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 1 /f

echo.
echo ✅ Semua pengaturan telah dikembalikan ke default.
echo Restart komputer agar perubahan aktif.
echo =========================================
pause