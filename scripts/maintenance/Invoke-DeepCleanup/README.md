# Deep Cleanup

[Español abajo](#limpieza-profunda)

Configurable, aggressive cleanup: age-filtered temp files, Windows Error Reporting, shader caches, broken shortcuts, the Recycle Bin and a **deferred DISM run via a scheduled task**.

| Item | Value |
|---|---|
| **Category** | Maintenance |
| **Script** | `Invoke-DeepCleanup.ps1` |
| **Context** | `SYSTEM` (Action1 agent) |
| **Reboot required** | No |
| **Original name** | `superlimpieza.ps1` |

## Overview (EN)

The aggressive, configurable counterpart of [`Invoke-GeneralCleanup`](../Invoke-GeneralCleanup/). It is designed to run as `SYSTEM` under the Action1 agent. Its slowest step (DISM) is launched through a separate scheduled task so the agent **never hangs** and the script returns quickly.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` or elevated Administrator (needs write access to every profile) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None — uses the `WScript.Shell` COM object and the built-in ScheduledTasks cmdlets |
| **Reboot** | Not required |

## How it works (EN)

**Per user** (skipping `All Users`, `Default`, `Default User` and `Public`):

- `AppData\Local\Temp` — files filtered by age, then any folders left empty.
- `AppData\Local\Microsoft\Windows\WER` — error reports.
- Shader caches: `D3DSCache`, `NVIDIA\DXCache`, `NVIDIA\GLCache`, `NVIDIA Corporation\NV_Cache`, `Intel\ShaderCache`.
- Broken `.lnk` shortcuts on the desktop and Start menu (same local-path-only guard as the safe cleanup).

**System-wide:**

- `%SystemRoot%\Temp` (age-filtered).
- Broken shortcuts on the public desktop and the `ProgramData` Start menu.
- The Recycle Bin of `%SystemDrive%` (only when `-IncludeRecycleBin $true`).

**Protected data.** A list of protected path segments is **never** deleted even when it matches the age filter:

```powershell
$ProtectedSegments = @('\IndexedDB\chrome-extension_')
```

Add here any path you want to shield.

**Deferred DISM.** When `-RunDism $true`:

1. It registers the scheduled task `Mantenimiento_DISM_Cleanup` (running as `SYSTEM`, 3-hour time limit, allowed to start on battery).
2. The task runs `dism.exe /Online /Cleanup-Image /StartComponentCleanup`, writes to `DISM_Cleanup.log` and **deletes itself** when it finishes.
3. If the task is already running, no second instance is launched.

**Logging.** Every action is written to `%ProgramData%\Action1\Mantenimiento_General.log`; the deferred DISM output goes to `%ProgramData%\Action1\DISM_Cleanup.log`.

## Parameters (EN)

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-MinAgeDays` | `int` | `2` | Only deletes temp files older than N days. `0` = no filter (delete everything). |
| `-IncludeRecycleBin` | `bool` | `$true` | Empties the Recycle Bin. |
| `-RunDism` | `bool` | `$true` | Launches `dism /Online /Cleanup-Image /StartComponentCleanup` as a scheduled task. |

Example invocation in Action1:

```powershell
& .\Invoke-DeepCleanup.ps1 -MinAgeDays 7 -IncludeRecycleBin $false
```

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Normal completion. The script has **no explicit `exit` statement** and sets `$ErrorActionPreference = 'SilentlyContinue'`, so failures are logged to `Mantenimiento_General.log` instead of aborting the run |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Invoke-DeepCleanup.ps1`.
2. **Set parameters** — add the call line shown above to change the age filter, the Recycle Bin or DISM.
3. **Schedule** it as a monthly *Intelligent Run*, ideally after [`Set-CustomAttribute-LowDisk`](../../reporting/Set-CustomAttribute-LowDisk/).
4. **Allow time** — the script returns fast, but check `DISM_Cleanup.log` later to confirm the deferred task completed.

## ⚠️ Security notes (EN)

- **Deletes data permanently**, including the Recycle Bin by default.
- With `-MinAgeDays 0` it becomes far more aggressive — use it only on machines you control.
- Clearing shader caches forces a **regeneration** that can cause brief graphics slowdowns the first time each app is opened.
- The deferred DISM task stays registered until it completes; verify it is gone (or has self-deleted) after a run.

---

# Limpieza Profunda

Limpieza agresiva y parametrizable: temporales con filtro de antigüedad, WER, cachés de shaders, accesos directos rotos, papelera de reciclaje y **DISM diferido mediante tarea programada**.

| Ítem | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Script** | `Invoke-DeepCleanup.ps1` |
| **Contexto** | `SYSTEM` (agente Action1) |
| **Requiere reinicio** | No |
| **Nombre original** | `superlimpieza.ps1` |

## Descripción (ES)

La versión agresiva y configurable de la limpieza segura ([`Invoke-GeneralCleanup`](../Invoke-GeneralCleanup/)). Está diseñada para ejecutarse como `SYSTEM` en el agente de Action1. Su paso más lento (DISM) se lanza en una tarea programada independiente para que el agente **no se quede colgado** y el script termine rápido.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` o Administrador elevado (necesita escribir en todos los perfiles) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno — usa el objeto COM `WScript.Shell` y los cmdlets `ScheduledTasks` del sistema |
| **Reinicio** | No requiere |

## Cómo funciona (ES)

**Por cada usuario** (omitiendo `All Users`, `Default`, `Default User` y `Public`):

- `AppData\Local\Temp` — archivos según antigüedad, y luego las carpetas que quedaron vacías.
- `AppData\Local\Microsoft\Windows\WER` — reportes de errores.
- Cachés de shaders: `D3DSCache`, `NVIDIA\DXCache`, `NVIDIA\GLCache`, `NVIDIA Corporation\NV_Cache`, `Intel\ShaderCache`.
- Accesos directos `.lnk` rotos en el escritorio y el menú de inicio (mismo candado de "solo rutas locales" que la limpieza segura).

**A nivel de sistema:**

- `%SystemRoot%\Temp` (con filtro de antigüedad).
- Accesos directos rotos en el escritorio público y en el menú de inicio de `ProgramData`.
- La papelera de reciclaje de `%SystemDrive%` (solo si `-IncludeRecycleBin $true`).

**Protección de datos.** Una lista de rutas protegidas **nunca** se borra aunque cumpla la antigüedad:

```powershell
$ProtectedSegments = @('\IndexedDB\chrome-extension_')
```

Añade aquí cualquier ruta que quieras blindar.

**DISM diferido.** Cuando `-RunDism $true`:

1. Registra la tarea programada `Mantenimiento_DISM_Cleanup` (como `SYSTEM`, límite de 3 horas, permitida con batería).
2. La tarea ejecuta `dism.exe /Online /Cleanup-Image /StartComponentCleanup`, escribe en `DISM_Cleanup.log` y **se autoelimina** al terminar.
3. Si la tarea ya está en ejecución, no lanza una segunda instancia.

**Registro.** Cada acción se escribe en `%ProgramData%\Action1\Mantenimiento_General.log`; la salida del DISM diferido va a `%ProgramData%\Action1\DISM_Cleanup.log`.

## Parámetros (ES)

| Parámetro | Tipo | Por defecto | Descripción |
|---|---|---|---|
| `-MinAgeDays` | `int` | `2` | Solo borra archivos de temporales con más de N días de antigüedad. `0` = sin filtro (borra todo). |
| `-IncludeRecycleBin` | `bool` | `$true` | Vacía la papelera de reciclaje. |
| `-RunDism` | `bool` | `$true` | Lanza `dism /Online /Cleanup-Image /StartComponentCleanup` como tarea programada. |

Ejemplo de invocación en Action1:

```powershell
& .\Invoke-DeepCleanup.ps1 -MinAgeDays 7 -IncludeRecycleBin $false
```

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Al completar normalmente. El script **no tiene una sentencia `exit` explícita** y fija `$ErrorActionPreference = 'SilentlyContinue'`, así que los errores se registran en `Mantenimiento_General.log` en vez de abortar la ejecución |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Invoke-DeepCleanup.ps1`.
2. **Definir parámetros** — agrega la línea de invocación de arriba para cambiar el filtro de antigüedad, la papelera o DISM.
3. **Programar** como *Intelligent Run* mensual, idealmente después de [`Set-CustomAttribute-LowDisk`](../../reporting/Set-CustomAttribute-LowDisk/).
4. **Dar tiempo** — el script termina rápido, pero revisa después `DISM_Cleanup.log` para confirmar que la tarea diferida terminó.

## ⚠️ Advertencias (ES)

- **Borra datos de forma permanente**, incluida la papelera de reciclaje por defecto.
- Con `-MinAgeDays 0` es mucho más agresivo: úsalo solo en equipos que controlas.
- La limpieza de cachés de shaders provoca una **regeneración** que puede causar pequeñas ralentizaciones gráficas la primera vez que se abre cada aplicación.
- La tarea DISM diferida queda registrada hasta que termina; verifica que ya no esté (o que se haya autoeliminado) tras una ejecución.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
