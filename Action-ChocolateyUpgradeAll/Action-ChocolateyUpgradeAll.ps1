# Name: Action-ChocolateyUpgradeAll.ps1
# Description: Actualiza todo el software gestionado por Chocolatey en el equipo usando 'choco upgrade all -y'.

# ---------------------------------------------------------
# 1. Búsqueda del ejecutable de Chocolatey
# ---------------------------------------------------------
$ChocoDefaultPath = "$env:ProgramData\chocolatey\bin\choco.exe"
$ChocoCommand = Get-Command "choco.exe" -ErrorAction SilentlyContinue

$ChocoExe = $null

if ($ChocoCommand) {
    $ChocoExe = $ChocoCommand.Source
} elseif (Test-Path $ChocoDefaultPath -ErrorAction SilentlyContinue) {
    $ChocoExe = $ChocoDefaultPath
}

# ---------------------------------------------------------
# 2. Lógica de Actualización
# ---------------------------------------------------------
if ($ChocoExe) {
    Write-Output "====================================================="
    Write-Output "Iniciando actualización de software con Chocolatey..."
    Write-Output "Ejecutable encontrado en: $ChocoExe"
    Write-Output "====================================================="
    
    try {
        # Ejecutamos el comando de actualización silenciosa y aceptando todas las confirmaciones
        & $ChocoExe upgrade all -y
        
        Write-Output "====================================================="
        Write-Output "Proceso de actualización finalizado correctamente."
        Write-Output "====================================================="
    } catch {
        Write-Output "ERROR CRÍTICO: Ocurrió un problema al ejecutar Chocolatey."
        Write-Output $_.Exception.Message
        exit 1
    }
} else {
    Write-Output "ERROR: Chocolatey NO se encuentra instalado en este equipo. No se puede proceder con la actualización."
    # Salimos con código 1 para que Action1 lo marque como fallido (rojo) en el reporte de ejecución
    exit 1 
}