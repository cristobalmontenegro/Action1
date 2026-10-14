# Invoke-DeepCleanup.ps1

> Limpieza profunda y parametrizable: temporales con filtro de antigüedad, WER,
> cachés de shaders, accesos directos rotos, papelera de reciclaje y **DISM
> diferido mediante tarea programada**.

| Campo | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Archivo** | `Invoke-DeepCleanup.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `superlimpieza.ps1` |

## Descripción

Versión agresiva y configurable de la limpieza. Diseñada para ejecutarse como
`SYSTEM` en el agente de Action1. El componente más lento (DISM) se lanza en una
tarea programada independiente para que el agente **no se quede colgado** y el
script termine rápido.

## Parámetros

| Parámetro | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `-MinAgeDays` | `int` | `2` | Solo borra archivos de temporales con más de N días de antigüedad. `0` = sin filtro (borra todo). |
| `-IncludeRecycleBin` | `bool` | `$true` | Vacía la papelera de reciclaje. |
| `-RunDism` | `bool` | `$true` | Lanza `dism /Online /Cleanup-Image /StartComponentCleanup` como tarea programada. |

Ejemplo de invocación en Action1:

```powershell
& .\Invoke-DeepCleanup.ps1 -MinAgeDays 7 -IncludeRecycleBin $false
```

## Qué limpia

Por **cada usuario** (omitiendo perfiles de sistema):
- `AppData\Local\Temp` — archivos según antigüedad, y luego carpetas que quedaron vacías.
- `AppData\Local\Microsoft\Windows\WER` — reportes de errores.
- Cachés de shaders: `D3DSCache`, `NVIDIA\DXCache`, `NVIDIA\GLCache`,
  `NVIDIA Corporation\NV_Cache`, `Intel\ShaderCache`.
- Accesos directos `.lnk` rotos en escritorio y menú de inicio.

A **nivel de sistema**:
- `%SystemRoot%\Temp` (con filtro de antigüedad).
- Accesos directos rotos en escritorio público y menú de inicio de `ProgramData`.
- Papelera de reciclaje de `%SystemDrive%` (si `-IncludeRecycleBin $true`).

## Protección de datos

Existe una lista de rutas protegidas que **nunca** se borran aunque cumplan la
antigüedad. Por defecto:

```powershell
$ProtectedSegments = @('\IndexedDB\chrome-extension_')
```

Añade aquí cualquier ruta que quieras blindar.

## DISM diferido

Si `-RunDism $true`:

1. Crea/registra la tarea programada `Mantenimiento_DISM_Cleanup` (como `SYSTEM`,
   límite de 3 horas, arranca con batería).
2. La tarea ejecuta `dism.exe /Online /Cleanup-Image /StartComponentCleanup`,
   escribe en `DISM_Cleanup.log` y **se autoelimina** al terminar.
3. Si la tarea ya está en ejecución, no lanza una segunda instancia.

## Logs

| Archivo | Contenido |
|---|---|
| `%ProgramData%\Action1\Mantenimiento_General.log` | Traza completa de la limpieza |
| `%ProgramData%\Action1\DISM_Cleanup.log` | Salida de DISM (tarea programada) |

## Códigos de salida

Siempre `0` (el script usa `$ErrorActionPreference = 'SilentlyContinue'` y
registra los errores en el log en vez de abortar).

## Uso en Action1

Programar como *Intelligent Run* mensual, idealmente después de
[`Set-CustomAttribute-LowDisk`](../../reporting/Set-CustomAttribute-LowDisk/).

## Advertencias

- **Borra datos de forma permanente**, incluida la papelera por defecto.
- Con `-MinAgeDays 0` es mucho más agresivo: úsalo solo en equipos controlados.
- La limpieza de cachés de shaders provoca una **regeneración** que puede causar
  pequeñas ralentizaciones temporales en gráficos la primera vez que se abre cada app.
