# Name: CustomAttribute-Chocolatey.ps1
# Description: Evalúa si Chocolatey está instalado en el equipo y establece el atributo personalizado 'Chocolatey' a 1 (Sí) o 0 (No).

# ---------------------------------------------------------
# 1. Variables de Configuración
# ---------------------------------------------------------
$AttributeName = 'Chocolatey'
$Status = 0 # Valor por defecto (0 = No instalado, 1 = Instalado)

# Rutas y comandos a verificar
$ChocoDefaultPath = "$env:ProgramData\chocolatey\bin\choco.exe"

# ---------------------------------------------------------
# 2. Lógica del Script
# ---------------------------------------------------------

# Verificamos si 'choco' responde como un comando reconocido en el sistema
$ChocoCommand = Get-Command "choco.exe" -ErrorAction SilentlyContinue

# Verificamos si el ejecutable existe en la ruta de instalación habitual
$ChocoPathExists = Test-Path $ChocoDefaultPath -ErrorAction SilentlyContinue

# Evaluamos si alguna de las dos condiciones se cumple
if ($ChocoCommand -or $ChocoPathExists) {
    $Status = 1
    Write-Output "Chocolatey está instalado en el equipo. Atributo asignado: $Status."
} else {
    $Status = 0
    Write-Output "Chocolatey NO se encontró en el equipo. Atributo asignado: $Status."
}

# ---------------------------------------------------------
# 3. Salida hacia Action1
# ---------------------------------------------------------
Action1-Set-CustomAttribute $AttributeName $Status;