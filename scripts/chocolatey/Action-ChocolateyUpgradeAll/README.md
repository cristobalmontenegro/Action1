# 🍫 Chocolatey Upgrade All

[Español abajo](#actualizar-todo-el-software-con-chocolatey)

**🇬🇧 English**

Upgrades **every** Chocolatey-managed package on the machine with a single silent command (`choco upgrade all -y`). Made for scheduled maintenance.

| Item | Value |
|---|---|
| **Category** | Chocolatey |
| **Script** | `Action-ChocolateyUpgradeAll.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No |
| **Original name** | `actualizacioneschoco.ps1` |

## Overview (EN)

Runs a full pass over the Chocolatey catalogue without any user interaction and logs the result to the Action1 execution log. It is the "patch everything the easy way" task: whatever was installed through Chocolatey gets updated to its latest published version.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` (packages install machine-wide) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Chocolatey** | Must be installed — otherwise the script exits with `1` |
| **Network** | Internet access to the Chocolatey community repository (or your internal source) |

## How it works (EN)

1. Locates the Chocolatey executable in two steps:
   - `Get-Command "choco.exe"` (searches the `PATH`).
   - Fallback: `%ProgramData%\chocolatey\bin\choco.exe`.
2. If found, runs `choco upgrade all -y` (silent, auto-confirming).
3. If not found, writes an error and exits with `1` so Action1 flags the run as **failed (red)**.
4. If the execution throws, the `catch` block logs the message and also exits with `1`.

## Parameters (EN)

None. The fallback path (`%ProgramData%\chocolatey\bin\choco.exe`) is hardcoded in the script.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Upgrade ran without an exception |
| `1` | Chocolatey is not installed, or the execution threw |

> Note: the script does not check `choco`'s `$LASTEXITCODE`. A non-zero code caused by a single failing package will **not** mark the run as failed.

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Action-ChocolateyUpgradeAll.ps1`.
2. **Assign** it to a monthly (or quarterly) maintenance policy.
3. **Filter the targets** — pair it with [`Set-CustomAttribute-Chocolatey`](../Set-CustomAttribute-Chocolatey/) so you know in advance which endpoints have Chocolatey and only deploy there.
4. **Review the execution log** after the first runs to spot packages that fail repeatedly.

## ⚠️ Security notes (EN)

- **Network required.** The command reaches out to the Chocolatey repositories; no Internet means partial or failed upgrades.
- **Reboots may be needed.** The script does not restart the machine or force-close applications, but some packages only take effect after a reboot.
- **Runs with full privileges.** Chocolatey install scripts execute as `SYSTEM`; keep the package source trustworthy and consider an internal repository.
- **Licensing.** On endpoints with a paid Chocolatey edition, the command's behaviour can differ depending on the client configuration.

---

# 🍫 Actualizar Todo el Software con Chocolatey

**🇪🇸 Español**

[English above](#chocolatey-upgrade-all)

Actualiza **todo** el software gestionado por Chocolatey en el equipo con un solo comando silencioso (`choco upgrade all -y`). Pensado para mantenimiento programado.

| Ítem | Valor |
|---|---|
| **Categoría** | Chocolatey |
| **Script** | `Action-ChocolateyUpgradeAll.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `actualizacioneschoco.ps1` |

## Descripción (ES)

Ejecuta un barrido completo del catálogo de Chocolatey sin ninguna interacción del usuario y registra el resultado en el log de ejecución de Action1. Es la tarea de "parchear todo por la vía fácil": lo que se haya instalado con Chocolatey se actualiza a su última versión publicada.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` (los paquetes se instalan para todo el equipo) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Chocolatey** | Debe estar instalado — si no, el script termina con `1` |
| **Red** | Acceso a Internet al repositorio comunitario de Chocolatey (o a tu fuente interna) |

## Cómo funciona (ES)

1. Localiza el ejecutable de Chocolatey en dos pasos:
   - `Get-Command "choco.exe"` (busca en el `PATH`).
   - Alternativa: `%ProgramData%\chocolatey\bin\choco.exe`.
2. Si lo encuentra, ejecuta `choco upgrade all -y` (silencioso, aceptando todas las confirmaciones).
3. Si no lo encuentra, escribe un error y termina con `1` para que Action1 marque la ejecución como **fallida (roja)**.
4. Si la ejecución lanza una excepción, el bloque `catch` registra el mensaje y también termina con `1`.

## Parámetros (ES)

Ninguno. La ruta alternativa (`%ProgramData%\chocolatey\bin\choco.exe`) está fija en el script.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Actualización ejecutada sin excepción |
| `1` | Chocolatey no está instalado, o la ejecución lanzó una excepción |

> Nota: el script no revisa el `$LASTEXITCODE` de `choco`. Un código distinto de cero provocado por un paquete puntual **no** marcará la ejecución como fallida.

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Action-ChocolateyUpgradeAll.ps1`.
2. **Asignarlo** a una política de mantenimiento mensual (o trimestral).
3. **Filtrar los destinos** — combínalo con [`Set-CustomAttribute-Chocolatey`](../Set-CustomAttribute-Chocolatey/) para saber de antemano qué equipos tienen Chocolatey y desplegar solo ahí.
4. **Revisar el log de ejecución** tras las primeras corridas para detectar los paquetes que fallan de forma recurrente.

## ⚠️ Advertencias (ES)

- **Requiere red.** El comando sale hacia los repositorios de Chocolatey; sin Internet las actualizaciones serán parciales o fallidas.
- **Puede necesitar reinicio.** El script no reinicia ni cierra aplicaciones a la fuerza, pero algunos paquetes solo surten efecto tras un reinicio.
- **Se ejecuta con privilegios totales.** Los scripts de instalación de Chocolatey corren como `SYSTEM`; mantén una fuente de paquetes confiable y considera usar un repositorio interno.
- **Licenciamiento.** En equipos con edición paga de Chocolatey, el comportamiento del comando puede variar según la configuración del cliente.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
