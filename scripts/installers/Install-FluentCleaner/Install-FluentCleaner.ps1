# ==============================================================================
# Script DEFINITIVO - Limpieza + WinGet Global + Permisos + Acceso Directo
# ==============================================================================

$appId = "Builtbybel.FluentCleaner"
$runtimeId = "Microsoft.WindowsAppRuntime.2.0"
$wingetExe = "winget.exe"

Write-Host "Iniciando validación de WinGet..."

# 1. Encontrar ejecutable real
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    $realWingetPath = (Get-ChildItem -Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
    if ($realWingetPath) {
        $wingetExe = $realWingetPath
    } else {
        Write-Error "Fallo crítico: No se pudo localizar winget.exe."
        Exit 1
    }
}

& $wingetExe source update --accept-source-agreements --disable-interactivity | Out-Null
& $wingetExe install --id $runtimeId --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity | Out-Null

# ==============================================================================
# 2. VALIDACIÓN FÍSICA E INSTALACIÓN
# ==============================================================================
$globalPath = "$env:ProgramFiles\WinGet\Packages"
$isPhysicallyPresent = Test-Path "$globalPath\Builtbybel.FluentCleaner_*"

$checkApp = & $wingetExe list --id $appId --exact --accept-source-agreements 2>&1 | Out-String

if ($checkApp -match $appId) {
    if (-not $isPhysicallyPresent) {
        Write-Host "Instalación fantasma detectada (carpeta vacía). Forzando limpieza profunda..."
        & $wingetExe uninstall --id $appId --exact --silent --accept-source-agreements --disable-interactivity | Out-Null
        
        Write-Host "Iniciando instalación global limpia..."
        & $wingetExe install --id $appId --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --scope machine --skip-dependencies --force
    } else {
        Write-Host "Instalación global real detectada. Buscando actualizaciones..."
        & $wingetExe upgrade --id $appId --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --scope machine --skip-dependencies
    }
} else {
    Write-Host "FluentCleaner no instalado. Iniciando instalación global..."
    & $wingetExe install --id $appId --exact --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --scope machine --skip-dependencies
}

# ==============================================================================
# 3. FORZAR PERMISOS Y CREAR ACCESO DIRECTO
# ==============================================================================
Write-Host "Buscando la carpeta de instalación para arreglar permisos..."
$appFolder = Get-ChildItem -Path $globalPath -Filter "Builtbybel.FluentCleaner_*" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1

if ($appFolder) {
    Write-Host "Desbloqueando permisos de lectura/ejecución en: $($appFolder.FullName)"
    icacls "$($appFolder.FullName)" /grant "*S-1-5-32-545:(OI)(CI)RX" /T /C /Q | Out-Null

    # CORRECCIÓN: Buscamos FCleaner.exe basado en la captura de pantalla
    $foundExe = Get-ChildItem -Path $appFolder.FullName -Filter "FCleaner.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($foundExe) {
        $exePath = $foundExe.FullName
        Write-Host "Ejecutable listo en: $exePath"
        
        $publicDesktop = "$env:PUBLIC\Desktop"
        $shortcutPath = "$publicDesktop\FluentCleaner.lnk"
        
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($shortcutPath)
        $Shortcut.TargetPath = $exePath
        $Shortcut.WorkingDirectory = Split-Path -Parent $exePath 
        $Shortcut.Save()
        
        Write-Host "Acceso directo creado correctamente en el Escritorio Público."
    } else {
        Write-Warning "Se arreglaron los permisos, pero no se encontró el ejecutable (FCleaner.exe)."
    }
} else {
    Write-Warning "No se encontró la carpeta del programa en $globalPath tras la instalación."
}