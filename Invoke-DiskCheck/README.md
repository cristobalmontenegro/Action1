# 💽 Disk Check Scheduling

[Español abajo](#programación-de-chequeo-de-discos)

**🇬🇧 English**

Schedules a disk check (`chkntfs /c`) on **every** fixed disk and reboots the machine so Windows runs it.

| Item | Value |
|---|---|
| **Category** | Maintenance |
| **Script** | `Invoke-DiskCheck.ps1` |
| **Context** | `SYSTEM` (Action1 agent) |
| **Reboot required** | **Yes** — automatic, 15 seconds, forced |
| **Original name** | `chequeodisco.ps1` |

## Overview (EN)

The minimal version of the system check: it **only** schedules `chkntfs` and reboots. It does not run DISM or SFC.

> ⚠️ **It reboots the machine 15 seconds after being deployed.** That leaves almost no margin to warn the user. Read the warnings before deploying it.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` or elevated Administrator |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None — uses `chkntfs`, `shutdown` and `Win32_LogicalDisk` |
| **Reboot** | Yes — automatic, 15 seconds |

## How it works (EN)

1. Detects every fixed local disk with `Win32_LogicalDisk` (`DriveType=3`).
2. Runs `chkntfs /c <letter>:` on each one, scheduling the check for the next boot.
3. Waits 15 seconds (so Action1 can store the run report) and reboots with `shutdown /r /t 15 /f /c "Action1: Reinicio programado para comprobación de discos"`.

## Parameters (EN)

None.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Always — the script ends with an explicit `exit 0` |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Invoke-DiskCheck.ps1`.
2. **Notify the user** before running it — the reboot happens 15 seconds later.
3. **Deploy to the specific endpoint** you suspect has disk errors, not as a mass policy.
4. **Check the report** — the 15-second delay exists precisely so Action1 captures the run.
5. **For image repair too**, use [`Invoke-SystemHealthCheck`](\./Invoke-SystemHealthCheck/) instead.

## ⚠️ Security notes (EN)

- **Forces a reboot after 15 seconds** with forced application close. The margin is tiny — warn users first.
- The disk check runs **at boot** and can significantly lengthen startup time.
- `chkntfs /c` only *schedules* the check; the script does not run it.
- Because the reboot is so soon, any pending work on the endpoint is lost.

---

# 💽 Programación de Chequeo de Discos

**🇪🇸 Español**

Programa un chequeo de disco (`chkntfs /c`) en **todos** los discos fijos y reinicia el equipo para dispararlo.

| Ítem | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Script** | `Invoke-DiskCheck.ps1` |
| **Contexto** | `SYSTEM` (agente Action1) |
| **Requiere reinicio** | **Sí** — automático, 15 segundos, forzado |
| **Nombre original** | `chequeodisco.ps1` |

## Descripción (ES)

Es la versión mínima del chequeo de sistema: **solo** programa el `chkntfs` y reinicia. No ejecuta DISM ni SFC.

> ⚠️ **Reinicia el equipo 15 segundos después de desplegarse.** Eso deja casi sin margen para avisar al usuario. Lee las advertencias antes de desplegarlo.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` o Administrador elevado |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno — usa `chkntfs`, `shutdown` y `Win32_LogicalDisk` |
| **Reinicio** | Sí — automático, 15 segundos |

## Cómo funciona (ES)

1. Detecta todos los discos locales fijos con `Win32_LogicalDisk` (`DriveType=3`).
2. Ejecuta `chkntfs /c <letra>:` en cada uno, programando el chequeo para el próximo arranque.
3. Espera 15 segundos (para que Action1 alcance a guardar el reporte de la ejecución) y reinicia con `shutdown /r /t 15 /f /c "Action1: Reinicio programado para comprobación de discos"`.

## Parámetros (ES)

Ninguno.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Siempre — el script termina con un `exit 0` explícito |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Invoke-DiskCheck.ps1`.
2. **Avisar al usuario** antes de ejecutarlo — el reinicio ocurre 15 segundos después.
3. **Desplegar en el equipo concreto** en el que sospechas errores de disco, no como política masiva.
4. **Revisar el reporte** — los 15 segundos de espera existen precisamente para que Action1 capture la ejecución.
5. **Si quieres también reparación de imagen**, usa [`Invoke-SystemHealthCheck`](\./Invoke-SystemHealthCheck/).

## ⚠️ Advertencias (ES)

- **Fuerza un reinicio a los 15 segundos** con cierre forzado de aplicaciones. El margen es mínimo: avisa a los usuarios primero.
- El chequeo de disco se ejecuta **al arrancar** y puede alargar notablemente el tiempo de encendido.
- `chkntfs /c` solo *programa* el chequeo; el script no lo ejecuta.
- Como el reinicio es tan pronto, se pierde cualquier trabajo pendiente en el equipo.

---

---

## ☕ Support me / Apóyame

**EN:** If any of this was useful, you can buy me a coffee. Thanks for the support!

**ES:** Si te resultó útil, puedes invitarme un café. ¡Gracias por el apoyo!

<p align="center">
  <a href="https://ko-fi.com/cristobalmontenegro" target="_blank">
    <img height="36" style="border:0px;height:36px;" src="https://storage.ko-fi.com/cdn/kofi6.png?v=6" border="0" alt="Buy Me a Coffee at ko-fi.com" />
  </a>
</p>

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](\./LICENSE/).
