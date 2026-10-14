# Safe Mode Boot with Networking

[Español abajo](#arranque-en-modo-seguro-con-red)

Configures the machine to boot into **Safe Mode with networking** and reboots immediately. Meant for diagnostics and malware-remediation tasks that require a minimal Windows environment.

| Item | Value |
|---|---|
| **Category** | Boot |
| **Script** | `Set-SafeModeBoot.ps1` |
| **Context** | `SYSTEM` (Action1 agent) |
| **Reboot required** | **Yes** — forced, 5 seconds |
| **Original name** | `forzarreinicioseguro.ps1` |

## Overview (EN)

Forces a persistent Safe Mode boot so you can work on a machine in a minimal environment. It is the classic tool for cleaning up drivers, services or malware that refuse to be removed in normal mode — and for recovering a machine that will not boot normally.

> ⚠️ **This is persistent, not one-shot.** The machine keeps booting into Safe Mode on every restart until the BCD setting is reverted. Read the warnings before using it.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` or elevated Administrator (BCDs need elevation) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None — uses `bcdedit.exe` and `shutdown.exe` from the OS |
| **Network** | Not needed to apply the setting, but *networking* in Safe Mode requires a wired/Wi-Fi driver that loads in Safe Mode |

## How it works (EN)

1. Runs `bcdedit /set '{current}' safeboot network`, setting the current boot entry to Safe Mode with networking.
2. Reboots in 5 seconds with `shutdown /r /t 5 /f` (forced, applications closed without warning).

The single quotes around `{current}` are intentional: they stop PowerShell from interpreting the braces as a script block.

## Parameters (EN)

None. The Safe Mode flavour (`network`) is hardcoded; change it to `minimal` or `minimal (alternateshell)` in the script if you need a different mode.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Always — the script does not validate `bcdedit`'s exit code |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Set-SafeModeBoot.ps1`.
2. **Review** the warnings below and confirm the target endpoint can recover without the Action1 agent.
3. **Deploy to a single endpoint** — never as a mass policy.
4. **Recover remotely** — after the Safe Mode work is done, revert with:
   ```powershell
   bcdedit /deletevalue '{current}' safeboot
   ```
   then reboot. Consider deploying the revert script **before** this one.

## ⚠️ Security notes (EN)

- **Persistent change.** Every reboot re-enters Safe Mode until `safeboot` is deleted from the BCD.
- **Forced reboot in 5 seconds.** The user loses unsaved work and cannot cancel it.
- **The Action1 agent may lose connectivity.** In Safe Mode many services and drivers do not start, so the endpoint can drop out of management until you exit Safe Mode. A bad rollout can leave a machine unreachable.
- **Always have a revert plan.** Prepare (and test) the `bcdedit /deletevalue` command before deploying.

---

# Arranque en Modo Seguro con Red

Configura el equipo para arrancar en **Modo Seguro con funciones de red** y reinicia de inmediato. Pensado para tareas de diagnóstico y desinfección que requieren un entorno mínimo de Windows.

| Ítem | Valor |
|---|---|
| **Categoría** | Arranque |
| **Script** | `Set-SafeModeBoot.ps1` |
| **Contexto** | `SYSTEM` (agente Action1) |
| **Requiere reinicio** | **Sí** — forzado, 5 segundos |
| **Nombre original** | `forzarreinicioseguro.ps1` |

## Descripción (ES)

Fuerza un arranque **persistente** en Modo Seguro para poder trabajar en un entorno mínimo. Es la herramienta clásica para limpiar controladores, servicios o malware que se resisten en modo normal — y para recuperar un equipo que no arranca correctamente.

> ⚠️ **Es persistente, no de una sola vez.** El equipo seguirá arrancando en Modo Seguro en cada reinicio hasta que se revierta el valor del BCD. Lee las advertencias antes de usarlo.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` o Administrador elevado (el BCD exige elevación) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno — usa `bcdedit.exe` y `shutdown.exe` del sistema |
| **Red** | No se necesita para aplicar el cambio, pero la *red* en Modo Seguro requiere un controlador de red que cargue en ese modo |

## Cómo funciona (ES)

1. Ejecuta `bcdedit /set '{current}' safeboot network`, poniendo la entrada de arranque actual en Modo Seguro con red.
2. Reinicia en 5 segundos con `shutdown /r /t 5 /f` (forzado, cierra aplicaciones sin avisar).

Las comillas simples alrededor de `{current}` son intencionales: evitan que PowerShell interprete las llaves como un bloque de código.

## Parámetros (ES)

Ninguno. El modo (`network`) está fijo; cámbialo a `minimal` o `minimal (alternateshell)` en el script si necesitas otro modo.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Siempre — el script no valida el código de salida de `bcdedit` |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Set-SafeModeBoot.ps1`.
2. **Revisar** las advertencias de abajo y confirmar que el equipo destino puede recuperarse sin el agente de Action1.
3. **Desplegar en un solo equipo** — nunca como política masiva.
4. **Recuperar en remoto** — cuando termine el trabajo en Modo Seguro, revertir con:
   ```powershell
   bcdedit /deletevalue '{current}' safeboot
   ```
   y reiniciar. Conviene desplegar el script de reversión **antes** que este.

## ⚠️ Advertencias (ES)

- **Cambio persistente.** Cada reinicio vuelve a entrar en Modo Seguro hasta borrar `safeboot` del BCD.
- **Reinicio forzado en 5 segundos.** El usuario pierde trabajo no guardado y no puede cancelarlo.
- **El agente de Action1 puede perder conectividad.** En Modo Seguro muchos servicios y controladores no arrancan, así que el equipo puede salir de la gestión hasta que se salga del modo. Un despliegue erróneo puede dejar una máquina inaccesible.
- **Ten siempre un plan de reversión.** Prepara (y prueba) el comando `bcdedit /deletevalue` antes de desplegar.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
