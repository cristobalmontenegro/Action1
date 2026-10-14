# ====================================================================
# Súper Limpiador Corporativo - Action1 (SYSTEM)
# DISM se lanza mediante una tarea programada independiente del agente.
# ====================================================================
param(
    [int]$MinAgeDays = 2,
    [bool]$IncludeRecycleBin = $true,
    [bool]$RunDism = $true
)

$ErrorActionPreference = 'SilentlyContinue'

# --- Logs -------------------------------------------------------------------
$logDir = Join-Path $env:ProgramData 'Action1'
$log    = Join-Path $logDir 'Mantenimiento_General.log'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
function Log([string]$m){
    $msg = "[{0}] {1}" -f (Get-Date -Format s), $m
    Write-Output $msg
    Add-Content -Path $log -Value $msg
}

Log "=== Iniciando mantenimiento (SYSTEM) ==="

$ProtectedSegments = @('\IndexedDB\chrome-extension_')
function Test-Protected([string]$Path){
    foreach($s in $ProtectedSegments){ if($Path -like "*$s*"){ return $true } }
    return $false
}

$cut = if($MinAgeDays -gt 0){ (Get-Date).AddDays(-$MinAgeDays) } else { $null }

function Remove-BrokenShortcuts([string[]]$Paths){
    foreach($ruta in $Paths){
        if(-not (Test-Path -LiteralPath $ruta)){ continue }
        foreach($lnk in (Get-ChildItem -LiteralPath $ruta -Filter '*.lnk' -Recurse -File -Force -EA SilentlyContinue)){
            try {
                $t = [Environment]::ExpandEnvironmentVariables($shell.CreateShortcut($lnk.FullName).TargetPath)
                # Solo rutas con letra de unidad local; ignora UWP, URLs, UNC y accesos sin destino
                if($t -match '^[a-zA-Z]:\\' -and -not (Test-Path -LiteralPath $t)){
                    Log "   [X] Acceso directo roto: $($lnk.FullName)"
                    Remove-Item -LiteralPath $lnk.FullName -Force -EA SilentlyContinue
                }
            } catch { continue }
        }
    }
}

# --- Por usuario ------------------------------------------------------------
$shell = New-Object -ComObject WScript.Shell

foreach($u in (Get-ChildItem 'C:\Users' -Directory -Force -EA SilentlyContinue)){
    if($u.Name -in @('All Users','Default','Default User','Public')){ continue }
    $root = $u.FullName
    Log "Procesando usuario: $($u.Name)"

    # Temporales (con filtro de antigüedad)
    $temp = Join-Path $root 'AppData\Local\Temp'
    if(Test-Path -LiteralPath $temp){
        Get-ChildItem -LiteralPath $temp -Force -Recurse -File -EA SilentlyContinue |
            Where-Object { -not (Test-Protected $_.FullName) -and (-not $cut -or $_.LastWriteTime -lt $cut) } |
            Remove-Item -Force -EA SilentlyContinue

        Get-ChildItem -LiteralPath $temp -Directory -Recurse -Force -EA SilentlyContinue |
            Sort-Object FullName -Descending |
            Where-Object { -not (Get-ChildItem -LiteralPath $_.FullName -Force -EA SilentlyContinue) } |
            Remove-Item -Force -Recurse -EA SilentlyContinue
    }

    # WER
    $wer = Join-Path $root 'AppData\Local\Microsoft\Windows\WER'
    if(Test-Path -LiteralPath $wer){
        Get-ChildItem -LiteralPath $wer -Force -EA SilentlyContinue | Remove-Item -Force -Recurse -EA SilentlyContinue
    }

    # Cachés de shaders
    foreach($rel in @('AppData\Local\D3DSCache','AppData\Local\NVIDIA\DXCache','AppData\Local\NVIDIA\GLCache','AppData\Local\NVIDIA Corporation\NV_Cache','AppData\Local\Intel\ShaderCache')){
        $p = Join-Path $root $rel
        if(Test-Path -LiteralPath $p){
            Get-ChildItem -LiteralPath $p -Force -Recurse -EA SilentlyContinue | Remove-Item -Force -Recurse -EA SilentlyContinue
        }
    }

    Remove-BrokenShortcuts @("$root\Desktop", "$root\AppData\Roaming\Microsoft\Windows\Start Menu\Programs")
}

# --- Sistema ----------------------------------------------------------------
Log "-> Limpiando áreas del sistema..."

$sysTemp = Join-Path $env:SystemRoot 'Temp'
if(Test-Path -LiteralPath $sysTemp){
    Get-ChildItem -LiteralPath $sysTemp -Recurse -Force -File -EA SilentlyContinue |
        Where-Object { -not $cut -or $_.LastWriteTime -lt $cut } |
        Remove-Item -Force -EA SilentlyContinue
}

Remove-BrokenShortcuts @('C:\Users\Public\Desktop', 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs')

if($IncludeRecycleBin){
    Log "-> Vaciando papelera de reciclaje..."
    Get-ChildItem -LiteralPath "$env:SystemDrive\`$Recycle.Bin" -Force -EA SilentlyContinue |
        Remove-Item -Force -Recurse -EA SilentlyContinue
}

# --- DISM vía tarea programada (independiente del agente de Action1) --------
if($RunDism){
    $taskName = 'Mantenimiento_DISM_Cleanup'
    try {
        $existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if($existing -and $existing.State -eq 'Running'){
            Log "DISM ya está en ejecución; no se lanza otra vez."
        } else {
            $dismLog = Join-Path $logDir 'DISM_Cleanup.log'
            $arg = "/c dism.exe /Online /Cleanup-Image /StartComponentCleanup >> `"$dismLog`" 2>&1 & schtasks.exe /Delete /TN $taskName /F"
            $action    = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument $arg
            $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
            $settings  = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 3) `
                            -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
            Register-ScheduledTask -TaskName $taskName -Action $action -Principal $principal `
                -Settings $settings -Force -ErrorAction Stop | Out-Null
            Start-ScheduledTask -TaskName $taskName -ErrorAction Stop
            Log "DISM lanzado como tarea programada. Salida en: $dismLog"
        }
    } catch {
        Log "Error al lanzar DISM: $($_.Exception.Message)"
    }
}

Log "=== Mantenimiento finalizado ==="