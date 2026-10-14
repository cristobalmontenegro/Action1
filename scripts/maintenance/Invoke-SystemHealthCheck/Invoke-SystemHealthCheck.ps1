# ====================================================================
# Script de Mantenimiento para Action1 - VERSIÓN LIMPIA
# ====================================================================

$LogPath = "C:\Mantenimiento_Action1.log"
Start-Transcript -Path $LogPath -Force
Write-Output "=== Iniciando Mantenimiento del Sistema ==="
Write-Output "Fecha y hora: $(Get-Date)"

# 1. CHKDSK
Write-Output "`n[Paso 1] Detectando y programando discos para CHKDSK..."
$discos = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

foreach ($disco in $discos) {
    $letra = $disco.DeviceID
    Write-Output " -> Unidad $letra lista para CHKDSK en el reinicio."
    # El Out-Null es la magia que oculta el texto innecesario
    & cmd.exe /c "chkntfs /c $letra" | Out-Null 
}

# 2. DISM
Write-Output "`n[Paso 2] Ejecutando DISM (Reparando imagen)..."
Write-Output " -> Trabajando en segundo plano, esto tomará un rato..."
# Silenciamos el progreso para que no inunde la consola de Action1
& DISM.exe /Online /Cleanup-image /Restorehealth | Out-Null
Write-Output " -> DISM finalizado."

# 3. SFC
Write-Output "`n[Paso 3] Ejecutando SFC (Verificando archivos)..."
& sfc.exe /scannow | Out-Null
Write-Output " -> SFC finalizado."

# 4. REINICIO
Write-Output "`n=== Tareas completadas con éxito ==="
Write-Output "Enviando orden de reinicio (60 segundos)..."
Stop-Transcript

& shutdown /r /t 60 /f /c "Mantenimiento Action1: Reiniciando el equipo"

exit 0