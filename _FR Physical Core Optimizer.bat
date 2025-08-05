@echo off
:: Définir le nouveau nom du fichier de log
set "logFile=%~dp0Physical_core_optimizer_Logs_by_Snipy_Stream.log"

:: Supprimer l'ancien fichier de log s'il existe pour garantir une réinitialisation complète
if exist %logFile% del %logFile%

:: Créer un nouveau fichier de log et ajouter l'en-tête
echo ======================================================== >> %logFile%
echo [Date] %date% [Heure] %time% - Début de l'optimiseur par Snipy_Stream >> %logFile%
echo ======================================================== >> %logFile%
echo. >> %logFile%

:: Vérifier les droits d'administrateur
mkdir "%systemdrive%\testadmin" >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo Exécution en mode administrateur requise. Relance en cours...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
rmdir "%systemdrive%\testadmin" >nul 2>&1

:: Ajouter la variable d'environnement DXVK_ASYNC=1 (de manière permanente)
echo [Action] %time%      - Ajout de la variable d'environnement DXVK_ASYNC=1 >> %logFile%
setx DXVK_ASYNC 1 /M >nul
if %errorlevel% NEQ 0 (
    echo           [Erreur] Impossible d'ajouter la variable DXVK_ASYNC. >> %logFile%
    echo           Veuillez exécuter ce script en tant qu'administrateur. >> %logFile%
) else (
    echo           [Info] Variable DXVK_ASYNC=1 ajoutée avec succès. >> %logFile%
)

:: Désactiver l'affichage de la page de codes
chcp 65001 >nul

:: Affichage esthétique de l'optimiseur
cls

:: Définir la couleur du texte en rouge et le fond en noir (Code 4 = Rouge, Code 0 = Noir)
color 04

:: Afficher le titre et sous-titres avec une jolie mise en forme
echo.
echo   ======================================================
echo                ** Core Physique Optimizer **
echo                    ** Par Snipy_Stream **
echo   ======================================================
echo.
echo                     Lancement de Skyrim SKSE
echo                Détection des informations système...
echo   ------------------------------------------------------
echo.

:: Détecter le nom du processeur et le nombre total de cœurs logiques
for /f "tokens=*" %%a in ('powershell -Command "(Get-CimInstance -Class Win32_Processor).Name"') do (
    set processorName=%%a
)
for /f "tokens=*" %%a in ('powershell -Command "(Get-CimInstance -Class Win32_Processor).NumberOfLogicalProcessors"') do (
    set logicalCores=%%a
)
for /f "tokens=*" %%a in ('powershell -Command "(Get-CimInstance -Class Win32_Processor).NumberOfCores"') do (
    set physicalCores=%%a
)

echo                  Nom du processeur détecté :
echo             %processorName%
echo.
echo             Nombre total de cores logiques : %logicalCores%
echo               Nombre de cores physiques : %physicalCores%
echo             [Info] Nom du processeur détecté : %processorName% >> %logFile%
echo             [Info] Nombre total de cores logiques : %logicalCores% >> %logFile%
echo             [Info] Nombre de cores physiques : %physicalCores% >> %logFile%

:: Lancer SKSE64
echo                  Lancement de SKSE64...
echo [Action] %time%         - Lancement de SKSE64 >> %logFile%
start "" "%~dp0skse64_loader.exe"
if %errorlevel% NEQ 0 (
    echo            [Erreur] Échec lors du lancement de SKSE64. >> %logFile%
    echo            SKSE64 n'a pas pu être lancé. Veuillez vérifier le chemin d'accès. >> %logFile%
    exit /b
)

:: Attendre quelques secondes pour le démarrage de SkyrimSE.exe
timeout /t 10 /nobreak >nul

:: Exécuter le script PowerShell pour appliquer l'affinité
echo     // Application de l'affinité pour SkyrimSE.exe... \\
echo [Action] %time%      - Application de l'affinité pour SkyrimSE.exe via SetAffinity.ps1 >> %logFile%
powershell -ExecutionPolicy Bypass -File "%~dp0SetAffinity.ps1" -PhysicalCores %physicalCores% -LogicalCores %logicalCores% -ProcessorName "%processorName%"
if %errorlevel% NEQ 0 (
    echo           [Erreur] Échec lors de l'exécution de SetAffinity.ps1. >> %logFile%
    echo           Le script PowerShell pour l'affinité n'a pas pu être exécuté. >> %logFile%
    exit /b
)

:: Indiquer la fin de l'optimiseur dans le log
echo [Fin] %time%      - Fermeture de l'optimiseur après application de l'affinité >> %logFile%
echo.
echo   ======================================================
echo              Optimisation terminée avec succès!
echo   ======================================================
timeout /t 10 /nobreak >nul
exit
