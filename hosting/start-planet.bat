@echo off
REM Ignition — Ein-Klick-Planet-Host (Doppelklick-Starter).
REM Ruft start-planet.ps1 im selben Ordner auf. Optional: start-planet.bat 7778 (anderer Port).
setlocal
set PORT=%1
if "%PORT%"=="" set PORT=7777
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-planet.ps1" -Port %PORT%
echo.
pause
