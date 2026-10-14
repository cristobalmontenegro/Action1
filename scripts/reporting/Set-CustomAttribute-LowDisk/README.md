# Low Disk Space (Custom Attribute)

[Español abajo](#atributo-personalizado-de-disco-con-poco-espacio)

Measures the free-space percentage of drive `C:` and publishes the custom attribute **`LowDisk`** with value `1` (low) or `0` (ok) in Action1.

| Item | Value |
|---|---|
| **Category** | Reporting |
| **Script** | `Set-CustomAttribute-LowDisk.ps1` |
| **Context** | `SYSTEM` — **requires the Action1 agent** (`Action1-Set-CustomAttribute`) |
| **Reboot required** | No |
| **Original name** | `pocodiscoLowDisk.ps1` |

## Overview (EN)

An **inventory / early-warning** script. It lets you spot endpoints that are running out of disk space from inside Action1 itself, with no external monitoring tool.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM`, **inside the Action1 agent** — the script calls `Action1-Set-CustomAttribute`, which only exists there |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None beyond the Action1 agent environment |
| **Action1** | The `LowDisk` custom attribute must exist (or be created) in the console |

> ⚠️ **Agent-only.** `Action1-Set-CustomAttribute` is provided by the Action1 agent. Run this script locally or in a non-Action1 pipeline and it fails with a "command not found" error.

## How it works (EN)

1. Gets drive `C:` with `Get-PSDrive` (a more reliable source than WMI).
2. Computes the free-space percentage as `Free / (Used + Free) * 100`, rounded to 2 decimals.
3. If the percentage is **less than or equal to the threshold** → `1`; otherwise → `0`.
4. Publishes the result with `Action1-Set-CustomAttribute 'LowDisk' <value>`.

## Configuration (EN)

| Variable | Default | Description |
|---|---|---|
| `$ThresholdPercent` | `30` | Free-space threshold, in percent. When the drive drops to or below this value the attribute becomes `1`. |
| `$DriveLetter` | `C` | Drive letter to evaluate (without the colon). |

Tune `$ThresholdPercent` to match the criterion used by your Action1 report.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Normal completion — the script never calls `exit`; Action1 reports success when no terminating error occurs |
| non-zero | Only if PowerShell itself aborts, e.g. `Action1-Set-CustomAttribute` is unavailable because the script ran outside the Action1 agent |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Set-CustomAttribute-LowDisk.ps1`.
2. **Create the attribute** — make sure a `LowDisk` custom attribute exists in the Action1 settings so the value becomes visible in reports.
3. **Schedule** it as a daily *Intelligent Run*.
4. **Act on it** — endpoints reporting `LowDisk = 1` can automatically receive [`Invoke-DeepCleanup`](../../maintenance/Invoke-DeepCleanup/) or raise an alert for manual review.

## ⚠️ Security notes (EN)

- **Read-only.** The script does not modify the system; it only reads free-space counters.
- **Requires the Action1 agent.** Outside that context the call to `Action1-Set-CustomAttribute` fails.
- **Unreadable drives default to `0`.** If the drive cannot be read, the script assigns `0` and logs it. That avoids false positives, but it can also hide a real access problem — watch the execution log.

---

# Atributo Personalizado de Disco con Poco Espacio

[English above](#low-disk-space-custom-attribute)

Mide el porcentaje de espacio libre del disco `C:` y publica el atributo personalizado **`LowDisk`** con valor `1` (bajo) o `0` (ok) en Action1.

| Ítem | Valor |
|---|---|
| **Categoría** | Reportes |
| **Script** | `Set-CustomAttribute-LowDisk.ps1` |
| **Contexto** | `SYSTEM` — **requiere el agente de Action1** (`Action1-Set-CustomAttribute`) |
| **Requiere reinicio** | No |
| **Nombre original** | `pocodiscoLowDisk.ps1` |

## Descripción (ES)

Es un script de **inventario / alerta temprana**. Permite detectar desde el propio Action1 los equipos que se están quedando sin espacio en disco, sin depender de monitoreo externo.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM`, **dentro del agente de Action1** — el script llama a `Action1-Set-CustomAttribute`, que solo existe ahí |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno fuera del entorno del agente de Action1 |
| **Action1** | El atributo personalizado `LowDisk` debe existir (o crearse) en la consola |

> ⚠️ **Solo con el agente.** `Action1-Set-CustomAttribute` lo provee el agente de Action1. Si ejecutas este script en local o en un pipeline que no sea de Action1, falla con un error de "comando no encontrado".

## Cómo funciona (ES)

1. Obtiene el disco `C:` con `Get-PSDrive` (fuente más estable que WMI).
2. Calcula el porcentaje libre como `Free / (Used + Free) * 100`, redondeado a 2 decimales.
3. Si el porcentaje es **menor o igual al umbral** → `1`; si no → `0`.
4. Publica el resultado con `Action1-Set-CustomAttribute 'LowDisk' <valor>`.

## Configuración (ES)

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `$ThresholdPercent` | `30` | Umbral de espacio libre, en porcentaje. Cuando el disco baja a este valor o menos, el atributo pasa a `1`. |
| `$DriveLetter` | `C` | Letra del disco a evaluar (sin dos puntos). |

Ajusta `$ThresholdPercent` para alinearlo con el criterio de tu reporte de Action1.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Finalización normal — el script nunca llama a `exit`; Action1 lo reporta como exitoso si no hay un error terminante |
| distinto de cero | Solo si PowerShell aborta, por ejemplo cuando `Action1-Set-CustomAttribute` no está disponible porque el script corrió fuera del agente de Action1 |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Set-CustomAttribute-LowDisk.ps1`.
2. **Crear el atributo** — asegúrate de que exista un atributo personalizado `LowDisk` en la configuración de Action1 para que el valor sea visible en los reportes.
3. **Programarlo** como *Intelligent Run* diario.
4. **Actuar en consecuencia** — los equipos con `LowDisk = 1` pueden recibir automáticamente [`Invoke-DeepCleanup`](../../maintenance/Invoke-DeepCleanup/) o generar una alerta para revisión manual.

## ⚠️ Advertencias (ES)

- **Solo lectura.** El script no modifica el sistema; solo lee los contadores de espacio libre.
- **Requiere el agente de Action1.** Fuera de ese contexto la llamada a `Action1-Set-CustomAttribute` falla.
- **Si el disco no se puede leer, asigna `0`.** Cuando no se puede acceder al disco, el script asigna `0` y lo registra. Eso evita falsos positivos, pero también puede ocultar un problema real de acceso — revisa el log de ejecución.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
