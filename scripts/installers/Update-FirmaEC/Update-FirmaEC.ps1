# Definir las rutas de los archivos de FirmaEC
$javaPath = "C:\Program Files\FirmaEC\jre\bin\java.exe"
$jarPath = "C:\Program Files\FirmaEC\firmador-jar-with-dependencies.jar"

$existeJava = Test-Path("$javaPath")
$existeJar = Test-Path("$jarPath")

if ($existeJava -and$existeJar) {
    Write-Host "FirmaEC detectado. Iniciando actualizacion..."
    
    # Creamos rutas para archivos temporales donde Java escribira sus logs sin asustar a PowerShell
    $outFile = "$env:TEMP\firmaec_out.log"
    $errFile = "$env:TEMP\firmaec_err.log"
    
    $argumentos = "-jar `"$jarPath`" --update"
    
    try {
        # Ejecutamos desviando los textos a los archivos temporales
        $process = Start-Process -FilePath "$javaPath" -ArgumentList $argumentos -Wait -NoNewWindow -RedirectStandardOutput "$outFile" -RedirectStandardError "$errFile" -PassThru
        
        Write-Host "--- Resultado de la ejecucion de FirmaEC ---"
        # Leemos los archivos temporales para mostrarlos en Action1
        if (Test-Path "$outFile") { Get-Content "$outFile" | Write-Host }
        if (Test-Path "$errFile") { Get-Content "$errFile" | Write-Host }
        Write-Host "--------------------------------------------"
        
        # Borramos los archivos temporales para dejar todo limpio
        if (Test-Path "$outFile") { Remove-Item "$outFile" -Force }
        if (Test-Path "$errFile") { Remove-Item "$errFile" -Force }
        
        # Validamos como termino (0 = Todo OK)
        if ($process.ExitCode -eq 0) {
            Write-Host "La actualizacion finalizo con exito (Exit Code 0)."
            exit 0
        } else {
            Write-Host "FirmaEC termino con errores (Exit Code $($process.ExitCode)). Revisa el log arriba."
            exit 1
        }
    } catch {
        Write-Host "Error critico de Windows al intentar lanzar el programa: $_"
        exit 1
    }
} else {
    Write-Host "FirmaEC no esta instalado en este equipo. Omitiendo actualizacion."
    exit 0
}