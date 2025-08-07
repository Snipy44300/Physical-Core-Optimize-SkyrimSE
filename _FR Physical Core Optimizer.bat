@echo off
:: Demande l'exécution en admin si nécessaire
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cd /d "%~dp0"

color 06
echo           ====================================================
echo.
echo                Core Physique Optimizer - Par Snipy_Stream
echo.                          
echo           ====================================================


powershell -ExecutionPolicy Bypass -File ".\SetAffinity.ps1"

:: Message de confirmation
powershell -Command "Write-Host '  '
powershell -Command "Write-Host '           ====================================================  '
powershell -Command "Write-Host '  '
powershell -Command "Write-Host '              Optimisation faite avec succes. Have Fun ! ;-)' -ForegroundColor Green"
powershell -Command "Write-Host '  '
powershell -Command "Write-Host '           ====================================================  '

:: Attente avant fermeture
timeout /t 7 >nul
exit