# =========================================================================
# SCRIPT COMPATIBLE CON ACTION1 - CONFIGURACIÓN MENSUAL INTELLIGENT RUN
# =========================================================================

# Variable para rastrear si es necesario aplicar cambios
$NecesitaCambios = $false

# 1. VERIFICACIÓN A NIVEL DE MÁQUINA (DisableWindowsConsumerFeatures)
$CloudContentPath = "HKLM:\Software\Policies\Microsoft\Windows\CloudContent"
if (-not (Test-Path $CloudContentPath)) {
    $NecesitaCambios = $true
} else {
    $Propiedad = Get-ItemProperty -Path $CloudContentPath -Name "DisableWindowsConsumerFeatures" -ErrorAction SilentlyContinue
    if ($null -eq $Propiedad -or $Propiedad.DisableWindowsConsumerFeatures -ne 1) {
        $NecesitaCambios = $true
    }
}

# 2. VERIFICACIÓN EN EL PERFIL POR DEFECTO (Para nuevos usuarios locales)
# Intentamos cargar la colmena de registro por defecto
try {
    # Redirigimos errores por si otra tarea la tiene bloqueada temporalmente
    reg load HKU\DefaultUser C:\Users\Default\NTUSER.DAT 2>$null
    
    $ScoobePath = "Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
    $ContentPath = "Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"

    # Verificar pantalla SCOOBE "Terminar de configurar"
    if (-not (Test-Path $ScoobePath)) {
        $NecesitaCambios = $true
    } else {
        $ScoobeProp = Get-ItemProperty -Path $ScoobePath -Name "ScoobeSystemSettingEnabled" -ErrorAction SilentlyContinue
        if ($null -eq $ScoobeProp -or $ScoobeProp.ScoobeSystemSettingEnabled -ne 0) { $NecesitaCambios = $true }
    }

    # Verificar sugerencias y avisos de cuenta MS
    if (-not (Test-Path $ContentPath)) {
        $NecesitaCambios = $true
    } else {
        $Sugerencias = @("310093Enabled", "338387Enabled", "338388Enabled", "338389Enabled", "353694Enabled", "353696Enabled")
        foreach ($Id in $Sugerencias) {
            $CheckProp = Get-ItemProperty -Path $ContentPath -Name "SubscribedContent-$Id" -ErrorAction SilentlyContinue
            if ($null -eq $CheckProp -or $CheckProp."SubscribedContent-$Id" -ne 0) {
                $NecesitaCambios = $true
                break
            }
        }
    }
} finally {
    # Descargamos la colmena siempre, pase lo que pase
    [gc]::Collect()
    reg unload HKU\DefaultUser 2>$null
}


# =========================================================================
# EJECUCIÓN DE CAMBIOS (Solo si la máquina no cumple con la directiva)
# =========================================================================
if ($NecesitaCambios) {
    Write-Output "La maquina no cumple con la politica de bloqueo. Aplicando configuracion..."

    # Aplicar HKLM
    if (-not (Test-Path $CloudContentPath)) { New-Item -Path $CloudContentPath -Force | Out-Null }
    Set-ItemProperty -Path $CloudContentPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord -Force

    # Aplicar HKU\DefaultUser
    reg load HKU\DefaultUser C:\Users\Default\NTUSER.DAT 2>$null
    
    if (-not (Test-Path $ScoobePath)) { New-Item -Path $ScoobePath -Force | Out-Null }
    if (-not (Test-Path $ContentPath)) { New-Item -Path $ContentPath -Force | Out-Null }

    Set-ItemProperty -Path $ScoobePath -Name "ScoobeSystemSettingEnabled" -Value 0 -Type DWord -Force

    $Sugerencias = @("310093Enabled", "338387Enabled", "338388Enabled", "338389Enabled", "353694Enabled", "353696Enabled")
    foreach ($Id in $Sugerencias) {
        Set-ItemProperty -Path $ContentPath -Name "SubscribedContent-$Id" -Value 0 -Type DWord -Force
    }

    [gc]::Collect()
    reg unload HKU\DefaultUser 2>$null
    
    Write-Output "Configuracion aplicada con exito."
} else {
    Write-Output "La maquina ya esta protegida contra avisos de Microsoft. No se requieren acciones."
}
