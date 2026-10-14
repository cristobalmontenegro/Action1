# ====================================================================
# Script: Reactivar Menú de Arranque Clásico (F8) para Action1
# ====================================================================

Write-Output "=== Reactivando la tecla F8 para el menú de arranque ==="

# Cambiar la política del menú de arranque a "Legacy" (Heredado)
bcdedit /set {default} bootmenupolicy legacy

if ($LASTEXITCODE -eq 0) {
    Write-Output "¡Éxito! El menú clásico ha sido activado. Ahora puedes usar F8 al arrancar."
    exit 0
} else {
    Write-Warning "Hubo un problema al aplicar el comando."
    exit 1
}