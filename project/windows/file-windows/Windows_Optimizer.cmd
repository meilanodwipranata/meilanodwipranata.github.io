@echo off
:: =============================
:: WINDOWS OPTIMIZER CMD SCRIPT
:: =============================

:: Matikan Windows Search (paling boros RAM)
sc stop "WSearch"
sc config "WSearch" start=disabled

:: Matikan SysMain (Superfetch)
sc stop "SysMain"
sc config "SysMain" start=disabled

:: Matikan Delivery Optimization
sc stop "DoSvc"
sc config "DoSvc" start=disabled

:: Matikan DiagTrack (telemetry)
sc stop "DiagTrack"
sc config "DiagTrack" start=disabled

:: Hapus File Temporary
del /q /s %temp%\*
del /q /s C:\Windows\Temp\*
del /q /s C:\Windows\Prefetch\*

:: Matikan animasi & efek berat
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f

:: Matikan Xbox services
sc stop "XblGameSave"
sc config "XblGameSave" start=disabled

sc stop "XboxGipSvc"
sc config "XboxGipSvc" start=disabled

sc stop "XboxNetApiSvc"
sc config "XboxNetApiSvc" start=disabled

:: Matikan Printer Spooler jika tidak digunakan
sc stop "Spooler"
sc config "Spooler" start=disabled

:: Matikan Widgets
taskkill /f /im widgetservice.exe
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f

:: Optimalkan TCP/IP network
netsh int tcp set global autotuninglevel=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled

echo ====================================
echo SELESAI! Restart Laptop kamu sekarang
echo ====================================
pause
