param (
    [string]$ProcessName = "SkyrimSE"
)

# Détection automatique de la langue
$culture = (Get-Culture).TwoLetterISOLanguageName
$isFrench = $culture -eq "fr"

# Initialisation des messages
function Localized {
    param([string]$fr, [string]$en)
    return $(if ($isFrench) { $fr } else { $en })
}

# Création du log
$logFile = "$PSScriptRoot\Physical Core Optimizer_PS_by_Snipy.log"
Add-Content -Path $logFile -Value "========================================================"
Add-Content -Path $logFile -Value "[Date] $(Get-Date) - $(Localized "Lancement de SetAffinity.ps1" "Launching SetAffinity.ps1")"

# Récupération des infos CPU
try {
    $cpu = Get-CimInstance Win32_Processor -ErrorAction Stop
    $PhysicalCores = $cpu.NumberOfCores
    $LogicalCores = $cpu.NumberOfLogicalProcessors
    $ProcessorName = $cpu.Name
} catch {
    Write-Host "❌ $(Localized "Erreur lors de la détection du CPU." "Error detecting CPU.")" -ForegroundColor Red
    exit
}

Add-Content -Path $logFile -Value "[Info] $(Localized "Processeur détecté" "Detected processor") : $ProcessorName"
Add-Content -Path $logFile -Value "[Info] $(Localized "Cœurs physiques / logiques" "Physical / Logical cores") : $PhysicalCores / $LogicalCores"

# Vérifier le processus
try {
    $process = Get-Process -Name $ProcessName -ErrorAction Stop
    Add-Content -Path $logFile -Value "[OK] $(Localized "Processus trouvé" "Process found") : $ProcessName (PID: $($process.Id))"
} catch {
    $msg = Localized "❌ Processus introuvable. Lance d'abord le jeu." "❌ Process not found. Launch the game first."
    Write-Host $msg -ForegroundColor Red
    Add-Content -Path $logFile -Value "[Erreur] $msg"
    exit
}

# Générer la liste des threads physiques (1 sur 2)
$physicalThreadIds = @()
for ($i = 0; $i -lt $LogicalCores; $i += 2) {
    $physicalThreadIds += $i
}

# Générer le BitArray
try {
    $bitArray = New-Object System.Collections.BitArray 64
    foreach ($id in $physicalThreadIds) {
        $bitArray.Set($id, $true)
    }

    $bytes = New-Object Byte[] 8
    $bitArray.CopyTo($bytes, 0)
    $affinityMask = [BitConverter]::ToInt64($bytes, 0)
} catch {
    $msg = Localized "Erreur lors de la création du masque." "Error while creating the affinity mask."
    Write-Host "❌ $msg" -ForegroundColor Red
    Add-Content -Path $logFile -Value "[Erreur] $msg : $($_.Exception.Message)"
    exit
}

# Logs de vérification
$affinityHex = "0x{0:X}" -f $affinityMask
$affinityBin = [Convert]::ToString($affinityMask, 2).PadLeft(64, '0')
Add-Content -Path $logFile -Value "[Info] $(Localized "Threads physiques ciblés" "Targeted physical threads") : $($physicalThreadIds -join ', ')"
Add-Content -Path $logFile -Value "[Info] Binary mask  : $affinityBin"
Add-Content -Path $logFile -Value "[Info] Hex mask     : $affinityHex"

# Appliquer l'affinité
try {
    $process.ProcessorAffinity = $affinityMask
    # Ne plus afficher à l'écran en vert, juste log
    Add-Content -Path $logFile -Value "[OK] Affinité appliquée avec succès (Masque : $affinityHex)"
} catch {
    $msg = Localized "Échec lors de l'application de l'affinité" "Failed to apply affinity"
    Write-Host "❌ $msg" -ForegroundColor Red
    Add-Content -Path $logFile -Value "[Erreur] $msg : $($_.Exception.Message)"
    exit
}

Add-Content -Path $logFile -Value "[Fin] $(Get-Date -Format 'HH:mm:ss') - $(Localized "Script terminé." "Script finished.")"
