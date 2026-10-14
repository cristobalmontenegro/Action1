# ==============================================================================
# Script para Action1: Bloquear Cuentas Microsoft y OneDrive a nivel de Máquina
# ==============================================================================

try {
    # 1. Cortar de raíz el uso de Cuentas de Microsoft (Hotmail, Outlook, Live)
    $MsAccountPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    
    if (-not (Test-Path $MsAccountPolicyPath)) { New-Item -Path $MsAccountPolicyPath -Force | Out-Null }
    Set-ItemProperty -Path $MsAccountPolicyPath -Name "NoConnectedUser" -Value 3 -Type DWord -Force -ErrorAction Stop

    # 2. Desactivar y bloquear OneDrive por completo
    $OneDrivePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
    
    if (-not (Test-Path $OneDrivePolicyPath)) { New-Item -Path $OneDrivePolicyPath -Force | Out-Null }
    Set-ItemProperty -Path $OneDrivePolicyPath -Name "DisableFileSyncNGSC" -Value 1 -Type DWord -Force -ErrorAction Stop

    # Mensaje para los logs de Action1
    Write-Output "ÉXITO: Cuentas Microsoft y OneDrive fueron desactivados desde la raíz."
    
    # Devuelve el status explícito de "Terminado Exitoso" a Action1
    exit 0
}
catch {
    # Si algo falla, captura el error para los logs
    Write-Error "FALLO: No se pudieron aplicar las directivas. Detalle del error: $_"
    
    # Devuelve el status explícito de "Error" a Action1
    exit 1
}