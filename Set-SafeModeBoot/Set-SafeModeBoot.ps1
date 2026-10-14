# ====================================================================
# Script: Forzar Inicio en Modo Seguro con Red para Action1
# ====================================================================

Write-Output "=== Configurando Modo Seguro ==="

# Modificar el cargador de arranque de Windows (BCD)
# Se usan comillas '{current}' para que PowerShell no confunda las llaves con un bloque de código
Write-Output "-> Configurando arranque en Modo Seguro con Funciones de Red..."
bcdedit /set '{current}' safeboot network

# Programar reinicio rápido (5 segundos)
Write-Output "-> Reiniciando el equipo en 5 segundos..."
shutdown /r /t 5 /f /c "Action1: Reinicio forzado en Modo Seguro"

exit 0