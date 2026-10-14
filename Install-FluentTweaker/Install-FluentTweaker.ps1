# ==============================================================================
# Script DEFINITIVO - Instalación Dinámica desde GitHub + Action1
# ==============================================================================
$githubRepo = "builtbybel/FluentTweaker"
$installDir = "$env:ProgramFiles\FluentTweaker"
$tempZipPath = "$env:TEMP\FluentTweaker_latest.zip"

Write-Host "1. Consultando la última versión en GitHub API..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    # Obtener el JSON con los datos del último release
    $releaseUrl = "https://api.github.com/repos/$githubRepo/releases/latest"
    $releaseData = Invoke-RestMethod -Uri $releaseUrl -ErrorAction Stop

    # Extraer el enlace de descarga del archivo .zip
    $downloadUrl = $releaseData.assets | Where-Object { $_.name -match "\.zip$" } | Select-Object -ExpandProperty browser_download_url -First 1

    if (-not $downloadUrl) {
        Write-Error "Fallo crítico: No se encontró un archivo .zip en la última versión publicada."
        Exit 1
    }

    Write-Host "2. Descargando la última versión desde: $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZipPath -UseBasicParsing -ErrorAction Stop

    # ==============================================================================
    # 3. EXTRACCIÓN Y LIMPIEZA
    # ==============================================================================
    if (Test-Path $installDir) {
        Write-Host "Se encontró una instalación previa. Limpiando carpeta para actualización limpia..."
        Get-ChildItem -Path $installDir -Recurse | Remove-Item -Force -Recurse
    } else {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    Write-Host "Extrayendo archivos a $installDir..."
    Expand-Archive -Path $tempZipPath -DestinationPath $installDir -Force -ErrorAction Stop

    # Borrar el ZIP descargado
    Remove-Item -Path $tempZipPath -Force

    # ==============================================================================
    # 4. FORZAR PERMISOS Y CREAR ACCESO DIRECTO
    # ==============================================================================
    Write-Host "Desbloqueando permisos de lectura/ejecución para usuarios regulares..."
    icacls "$installDir" /grant "*S-1-5-32-545:(OI)(CI)RX" /T /C /Q | Out-Null

    # CORRECCIÓN: Buscar específicamente FTweaker.exe de forma recursiva por la subcarpeta del ZIP
    $foundExe = Get-ChildItem -Path $installDir -Filter "FTweaker.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($foundExe) {
        $exePath = $foundExe.FullName
        $workingDir = Split-Path -Parent $exePath
        
        Write-Host "Ejecutable correcto encontrado en: $exePath"
        
        # Crear acceso directo en el Escritorio Público
        $publicDesktop = [Environment]::GetFolderPath('CommonDesktopDirectory')
        $shortcutPath = "$publicDesktop\FluentTweaker.lnk"
        
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($shortcutPath)
        $Shortcut.TargetPath = $exePath
        $Shortcut.WorkingDirectory = $workingDir
        $Shortcut.Save()
        
        Write-Host "Acceso directo creado correctamente en el Escritorio Público apuntando a FTweaker.exe."
    } else {
        Write-Warning "Se extrajo el programa, pero no se encontró el archivo FTweaker.exe."
    }

} catch {
    Write-Error "Ocurrió un error en el proceso: $_"
    Exit 1
}