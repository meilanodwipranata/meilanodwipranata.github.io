@echo off
:: =============================
:: WINDOWS RESTORE DEFAULTS
:: =============================

:: Aktifkan Windows Search
sc config "WSearch" start=delayed-auto
sc start "WSearch"

:: Aktifkan SysMain
sc config "SysMain" start=auto
sc start "SysMain"

:: Aktifkan Delivery Optimization
sc config "DoSvc" start=auto
sc start "DoSvc"

:: Aktifkan DiagTrack (telemetry)
sc config "DiagTrack" start=auto
sc start "DiagTrack"

:: Aktifkan Printer Spooler
sc config "Spooler" start=auto
sc start "Spooler"

:: Aktifkan Xbox services
sc config "XblGameSave" start=auto
sc config "XboxGipSvc" start=auto
sc config "XboxNetApiSvc" start=auto

:: Kembalikan efek visual Windows default
reg delete "HKCU\Control Panel\Desktop" /v UserPreferencesMask /f
reg delete "HKCU\Control Panel\Desktop" /v DragFullWindows /f
reg delete "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /f

:: Aktifkan Widgets / News
reg delete "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f

:: Kembalikan pengaturan TCP/IP
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=default
netsh int tcp set global chimney=default

echo ====================================
echo Semua pengaturan dikembalikan seperti semula!
echo Restart laptop untuk menyelesaikan.
echo ====================================
pause
