# ====================================================================
# Script: Limpiador General Seguro para Action1
# Acción: Borra temporales de todos los usuarios y accesos directos rotos
# ====================================================================

Write-Output "=== Iniciando Mantenimiento y Limpieza Segura ==="

# --------------------------------------------------------------------
# PASO 1: Limpieza de archivos temporales (De todo el sistema y usuarios)
# --------------------------------------------------------------------
Write-Output "1. Limpiando archivos temporales..."

# Temporales de Windows (Sistema)
$sysTemp = "C:\Windows\Temp"
if (Test-Path $sysTemp) {
    Write-Output "-> Limpiando Temp del Sistema..."
    Get-ChildItem -Path $sysTemp -Recurse -Force -ErrorAction SilentlyContinue | 
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

# Temporales de cada usuario en el equipo
$userProfiles = Get-ChildItem -Path "C:\Users" -Directory
foreach ($profile in $userProfiles) {
    # Ignorar carpetas del sistema por seguridad
    if ($profile.Name -in @("All Users", "Default", "Default User", "Public")) { continue }

    $userTemp = "$($profile.FullName)\AppData\Local\Temp"
    if (Test-Path $userTemp) {
        Write-Output "-> Limpiando temporales del usuario: $($profile.Name)"
        # Borra el contenido de la carpeta, pero NO la carpeta raíz Temp en sí misma
        Get-ChildItem -Path $userTemp -Recurse -Force -ErrorAction SilentlyContinue | 
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# --------------------------------------------------------------------
# PASO 2: Eliminación de Accesos Directos (.lnk) Rotos
# --------------------------------------------------------------------
Write-Output "2. Buscando y eliminando accesos directos rotos..."

# Recopilar rutas de escritorios y menús de inicio (De usuarios y públicos)
$rutasShortcuts = @()
foreach ($profile in $userProfiles) {
    $rutasShortcuts += "$($profile.FullName)\Desktop"
    $rutasShortcuts += "$($profile.FullName)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
}
$rutasShortcuts += "C:\Users\Public\Desktop"
$rutasShortcuts += "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

# Instanciar el objeto COM para leer accesos directos
$shell = New-Object -ComObject WScript.Shell

foreach ($ruta in $rutasShortcuts) {
    if (-not (Test-Path $ruta)) { continue }
    
    # Buscar todos los archivos .lnk en esas ubicaciones
    $shortcuts = Get-ChildItem -Path $ruta -Filter "*.lnk" -Recurse -File -ErrorAction SilentlyContinue
    
    foreach ($lnk in $shortcuts) {
        try {
            $target = $shell.CreateShortcut($lnk.FullName).TargetPath
            
            # Expandir variables de entorno si las tiene (ej: %ProgramFiles%)
            $targetExpanded = [System.Environment]::ExpandEnvironmentVariables($target)

            # --- CANDADOS DE SEGURIDAD ---
            # Solo validar si apunta a una ruta local absoluta (ej: C:\... o D:\...)
            # Esto evita borrar accesos directos de red (\\servidor) si la PC está desconectada,
            # y evita borrar accesos directos especiales/web o de la Microsoft Store.
            if ($targetExpanded -match '^[a-zA-Z]:\\') {
                if (-not (Test-Path -Path $targetExpanded)) {
                    Write-Output "-> Eliminando acceso directo roto: $($lnk.Name) (Apuntaba a: $targetExpanded)"
                    Remove-Item -Path $lnk.FullName -Force -ErrorAction SilentlyContinue
                }
            }
        } catch {
            # Si da error al leerlo, lo saltamos por seguridad
            continue
        }
    }
}

Write-Output "=== Limpieza finalizada con éxito ==="
exit 0