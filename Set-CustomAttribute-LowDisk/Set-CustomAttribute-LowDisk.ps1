# Name: CustomAttribute-LowDisk-V2.ps1
# Description: Evalúa si el espacio en el disco C: es bajo y establece el atributo personalizado 'LowDisk' a 1 (Sí) o 0 (No).

# ---------------------------------------------------------
# 1. Variables de Configuración
# ---------------------------------------------------------
# Define el umbral de espacio libre (en porcentaje). 
# Lo he ajustado a 30 para que coincida con tu reporte de Action1.
$ThresholdPercent = 30 

# Letra del disco a evaluar (Sin los dos puntos para Get-PSDrive)
$DriveLetter = "C"

# ---------------------------------------------------------
# 2. Lógica del Script
# ---------------------------------------------------------
$Status = 0 # Valor por defecto

# Obtenemos el disco usando un comando nativo de PowerShell (Más estable que WMI)
$Drive = Get-PSDrive -Name $DriveLetter -PSProvider FileSystem -ErrorAction SilentlyContinue

if ($Drive) {
    # Calcular el tamaño total sumando el espacio usado y el libre
    $TotalSize = $Drive.Used + $Drive.Free
    
    # Calcular el porcentaje de espacio libre y redondearlo a 2 decimales
    $FreeSpacePercent = [math]::Round((($Drive.Free / $TotalSize) * 100), 2)

    # Evaluar si el espacio libre es menor o igual al umbral
    if ($FreeSpacePercent -le $ThresholdPercent) {
        $Status = 1
    } else {
        $Status = 0
    }
    
    # Imprimir log para la consola de Action1
    Write-Output "Disco C: evaluado. Espacio libre actual: $FreeSpacePercent%. Umbral establecido: $ThresholdPercent%. Atributo asignado: $Status."
} else {
    $Status = 0
    Write-Output "Fallo crítico: No se pudo acceder a la lectura del disco $DriveLetter. Se asignará 0 por defecto."
}

# ---------------------------------------------------------
# 3. Salida hacia Action1
# ---------------------------------------------------------
Action1-Set-CustomAttribute 'LowDisk' $Status;