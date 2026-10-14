# 🏥 System Health Check and Repair

[Español abajo](#verificación-y-reparación-del-sistema)

**🇬🇧 English**

Full system repair: **CHKDSK + DISM `/RestoreHealth` + SFC `/scannow`**, followed by an automatic reboot.

| Item | Value |
|---|---|
| **Category** | Maintenance |
| **Script** | `Invoke-SystemHealthCheck.ps1` |
| **Context** | `SYSTEM` (Action1 agent) |
| **Reboot required** | **Yes** — automatic, 60 seconds, forced |
| **Original name** | `chequeosistema.ps1` |

## Overview (EN)

This is the heavy repair script. It is also a **diagnostic tool**: it records a full transcript of the run so you can review it afterwards and tell whether SFC or DISM actually found and repaired damage.

> ⚠️ **It reboots the machine on its own.** It sends a forced `shutdown` 60 seconds after starting. Read the warnings before deploying it.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` or elevated Administrator (DISM/SFC need elevation) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None — uses `DISM.exe`, `sfc.exe`, `chkntfs`, `shutdown` and CIM |
| **Time** | DISM and SFC can take 15–60 minutes; the Action1 policy timeout must be generous |
| **Reboot** | Yes — automatic, 60 seconds |

## How it works (EN)

| Step | Action |
|---|---|
| 0 | Opens a transcript at `C:\Mantenimiento_Action1.log` (`Start-Transcript -Force`) |
| 1 | Detects fixed disks (`Win32_LogicalDisk`, `DriveType=3`) and schedules `chkntfs /c` on each one |
| 2 | Runs `DISM.exe /Online /Cleanup-image /Restorehealth` (output suppressed) |
| 3 | Runs `sfc.exe /scannow` (output suppressed) |
| 4 | Closes the transcript and reboots with `shutdown /r /t 60 /f /c "Mantenimiento Action1: Reiniciando el equipo"` |

The `chkntfs /c` calls only **schedule** a disk check; Windows runs it during the next boot.

## Parameters (EN)

None.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Always — the last command is `shutdown` and the error logic is silenced. The script does **not** validate `$LASTEXITCODE` from DISM or SFC |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Invoke-SystemHealthCheck.ps1`.
2. **Raise the policy timeout** so DISM and SFC can finish before the agent cuts the run.
3. **Notify users** — the machine will reboot in 60 seconds once the repair steps complete.
4. **Deploy to affected endpoints only** — not as a routine mass policy.
5. **Collect the log** — read `C:\Mantenimiento_Action1.log` to confirm what SFC and DISM repaired.

## ⚠️ Security notes (EN)

- **Forces a reboot after 60 seconds.** The user cannot cancel it and unsaved work is lost (`/f` closes applications without warning). **Warn users** before deploying.
- **Slow.** DISM and SFC can run for 15–60 minutes together; an Action1 run timeout that is too short may cut the repair off.
- `chkntfs /c` schedules a disk check that runs on the **next boot**, lengthening startup time.
- Damaged system files may be replaced; review the transcript before assuming the machine is clean.

---

# 🏥 Verificación y Reparación del Sistema

**🇪🇸 Español**

Reparación integral: **CHKDSK + DISM `/RestoreHealth` + SFC `/scannow`**, seguida de un reinicio automático.

| Ítem | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Script** | `Invoke-SystemHealthCheck.ps1` |
| **Contexto** | `SYSTEM` (agente Action1) |
| **Requiere reinicio** | **Sí** — automático, 60 segundos, forzado |
| **Nombre original** | `chequeosistema.ps1` |

## Descripción (ES)

Es el script de reparación pesado. También es un **script de diagnóstico**: guarda una transcripción completa de la ejecución para poder revisarla después y saber si SFC o DISM realmente encontraron y repararon daños.

> ⚠️ **Reinicia el equipo por sí solo.** Envía un `shutdown` forzado 60 segundos después de iniciar. Lee las advertencias antes de desplegarlo.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` o Administrador elevado (DISM/SFC exigen elevación) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno — usa `DISM.exe`, `sfc.exe`, `chkntfs`, `shutdown` y CIM |
| **Tiempo** | DISM y SFC pueden tardar entre 15 y 60 minutos; el tiempo límite de la política en Action1 debe ser amplio |
| **Reinicio** | Sí — automático, 60 segundos |

## Cómo funciona (ES)

| Paso | Acción |
|---|---|
| 0 | Abre una transcripción en `C:\Mantenimiento_Action1.log` (`Start-Transcript -Force`) |
| 1 | Detecta discos fijos (`Win32_LogicalDisk`, `DriveType=3`) y programa `chkntfs /c` en cada uno |
| 2 | Ejecuta `DISM.exe /Online /Cleanup-image /Restorehealth` (salida silenciada) |
| 3 | Ejecuta `sfc.exe /scannow` (salida silenciada) |
| 4 | Cierra la transcripción y reinicia con `shutdown /r /t 60 /f /c "Mantenimiento Action1: Reiniciando el equipo"` |

Las llamadas a `chkntfs /c` solo **programan** un chequeo de disco; Windows lo ejecuta en el próximo arranque.

## Parámetros (ES)

Ninguno.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Siempre — el último comando es `shutdown` y la lógica de errores está silenciada. El script **no** valida el `$LASTEXITCODE` de DISM ni de SFC |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Invoke-SystemHealthCheck.ps1`.
2. **Ampliar el tiempo límite** de la política para que DISM y SFC alcancen a terminar antes de que el agente corte la ejecución.
3. **Avisar a los usuarios** — el equipo se reiniciará 60 segundos después de terminar los pasos de reparación.
4. **Desplegar solo en equipos afectados** — no como política masiva de rutina.
5. **Recoger el log** — lee `C:\Mantenimiento_Action1.log` para confirmar qué repararon SFC y DISM.

## ⚠️ Advertencias (ES)

- **Fuerza un reinicio a los 60 segundos.** El usuario no puede cancelarlo y pierde el trabajo no guardado (`/f` cierra aplicaciones sin avisar). **Avisa a los usuarios** antes de desplegarlo.
- **Tarda mucho.** DISM y SFC pueden tardar entre 15 y 60 minutos en conjunto; un tiempo límite demasiado corto en Action1 puede cortar la reparación.
- El `chkntfs /c` programa un chequeo de disco que se ejecutará **en el próximo arranque**, alargando el tiempo de encendido.
- Puede reemplazar archivos de sistema dañados; revisa la transcripción antes de dar el equipo por limpio.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](\./LICENSE/).
