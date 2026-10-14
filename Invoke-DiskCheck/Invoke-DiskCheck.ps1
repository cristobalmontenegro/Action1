# ====================================================================
# Script de Chequeo de Discos para Action1 (Solo CHKDSK y Reinicio)
# ====================================================================

Write-Output "=== Iniciando programación de chequeo de discos ==="

# 1. Detectar de forma dinámica todos los discos locales (fijos) conectados
Write-Output "Detectando discos locales..."
$discos = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

foreach ($disco in $discos) {
    $letra = $disco.DeviceID # Obtiene la letra, por ejemplo: "C:"
    Write-Output "-> Programando CHKDSK en la unidad $letra para el próximo reinicio..."
    chkntfs /c $letra
}

# 2. Programar el reinicio del equipo
# Dejamos 15 segundos para que Action1 guarde el reporte de éxito antes de apagar
Write-Output "=== Configuración finalizada ==="
Write-Output "Reiniciando el equipo en 15 segundos para iniciar el análisis de los discos..."
shutdown /r /t 15 /f /c "Action1: Reinicio programado para comprobación de discos"

# Salida exitosa para la consola de Action1
exit 0