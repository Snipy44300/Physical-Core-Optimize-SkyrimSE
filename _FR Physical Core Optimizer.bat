@echo off
:: Demande l'exécution en admin si nécessaire
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
)

cd /d "%~dp0"

color 06
echo.
echo           ====================================================
echo.
echo                Core Physique Optimizer - Par Snipy_Stream
echo.                          
echo           ====================================================

:: Ajout de la variable d'environnement DXVK_ASYNC=1
setx DXVK_ASYNC 1 /M >nul
if %errorlevel% NEQ 0 (
    echo   [Erreur] Impossible d'ajouter DXVK_ASYNC. Exécutez ce script en tant qu'administrateur.
) else (
    echo.   
)

powershell -ExecutionPolicy Bypass -File ".\SetAffinity.ps1"

:: Message de confirmation
powershell -Command "Write-Host '  '"
powershell -Command "Write-Host '           ====================================================  '"
powershell -Command "Write-Host '  '"
powershell -Command "Write-Host '              Optimisation faite avec succes. Have Fun ! ;-)' -ForegroundColor Green"
powershell -Command "Write-Host '  '"
powershell -Command "Write-Host '           ====================================================  '"

:: Attente avant fermeture
timeout /t 7 >nul
exit
