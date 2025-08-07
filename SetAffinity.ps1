# Cache les erreurs PowerShell
$ErrorActionPreference = 'SilentlyContinue'
Write-Host "               Lancement de Skyrim avec coeurs physiques..." -ForegroundColor Green
Write-Host "                    Calcul de l'affinite physique..." -ForegroundColor Green

# Récupération des infos CPU
$cpu = Get-CimInstance Win32_Processor
$cpuName = $cpu.Name.Trim()
$logicalCores = $cpu.NumberOfLogicalProcessors
$physicalCores = $cpu.NumberOfCores

Write-Host "     " 
Write-Host "          CPU Detecte : $cpuName" -ForegroundColor Green
Write-Host "               Coeurs physiques : $physicalCores cores physiques" -ForegroundColor Green
Write-Host "                Coeurs logiques : $logicalCores cores logiques" -ForegroundColor Green

# Calcul du masque d'affinité uniquement pour les coeurs physiques (1 sur 2)
$affinityMask = 0
for ($i = 0; $i -lt $logicalCores; $i += 2) {
    $affinityMask = $affinityMask -bor (1 -shl $i)
}

Write-Host "$Calculated            Analyse de l'emplacement des coeurs physiques" -ForegroundColor Green

# Lancer Skyrim (remplacer selon votre chemin d'exe ou nom si pas skse)
$skyrimProcess = Start-Process "skse64_loader.exe" -PassThru
Start-Sleep -Seconds 2

# Application de l'affinité
$p = Get-Process -Name SkyrimSE -ErrorAction SilentlyContinue
if ($p) {
    $p.ProcessorAffinity = $affinityMask
    Write-Host "$Affinite                   Optimisation de SkyrimSE.exe" -ForegroundColor Green
} else {
    Write-Host "            [ERREUR] Processus Skyrim introuvable." -ForegroundColor Red
}
