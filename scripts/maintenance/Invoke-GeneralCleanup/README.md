# General Cleanup (Safe)

[Español abajo](#limpieza-general-segura)

Conservative cleanup: empties the temp folders of **every user** and removes broken `.lnk` shortcuts from desktops and Start menus.

| Item | Value |
|---|---|
| **Category** | Maintenance |
| **Script** | `Invoke-GeneralCleanup.ps1` |
| **Context** | `SYSTEM` (Action1 agent) |
| **Reboot required** | No |
| **Original name** | `limpiezageneral.ps1` |

## Overview (EN)

This is the conservative cleanup script. Unlike [`Invoke-DeepCleanup`](../Invoke-DeepCleanup/), it applies no age filter, does not empty the Recycle Bin and does not touch application caches: it only removes temp files and broken shortcuts.

Because it is non-destructive, it is the safest cleanup option to deploy broadly and unattended.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` or elevated Administrator (needs read access to every profile and to `ProgramData`) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None — uses the `WScript.Shell` COM object built into Windows |
| **Reboot** | Not required |

## How it works (EN)

**Step 1 — Temp files**

- Empties `C:\Windows\Temp` recursively and forcibly.
- Enumerates every profile folder under `C:\Users`, skipping `All Users`, `Default`, `Default User` and `Public`, and empties `AppData\Local\Temp` in each one.
- Deletes the **contents**, never the `Temp` folder itself.

**Step 2 — Broken shortcuts**

- Collects the desktop and Start menu paths of every user, plus `C:\Users\Public\Desktop` and `C:\ProgramData\Microsoft\Windows\Start Menu\Programs`.
- For each `.lnk` it reads the target through `WScript.Shell` and expands any environment variables in it.
- It deletes the shortcut **only** when the expanded target is an absolute local path (`^[a-zA-Z]:\`) that no longer exists.

Safety guards:

| Situation | Action |
|---|---|
| Target is a UNC path (`\\server\...`) | **Not deleted** (avoids false positives when the network is offline) |
| Target is a Store app, a URL or empty | **Not deleted** |
| Error reading the `.lnk` | Skipped (`continue`) |

## Parameters (EN)

None.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Always — file-deletion errors are suppressed with `-ErrorAction SilentlyContinue` (files in use are skipped silently) |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Invoke-GeneralCleanup.ps1`.
2. **Assign** it as a weekly maintenance policy.
3. **Deploy to any endpoint** — this is the safest cleanup script for mass, unattended rollout.
4. **Review the output** in the script run report to confirm both steps completed.

## ⚠️ Security notes (EN)

- **Files are deleted permanently** — they do not go to the Recycle Bin.
- Files locked by running processes are **skipped, not forced**.
- UNC, URL and Store shortcuts are deliberately left alone to avoid deleting shortcuts that merely point to an offline resource. Verify the deletion list on a pilot machine before a mass rollout.

---

# Limpieza General Segura

Limpieza conservadora: vacía los temporales de **todos los usuarios** y elimina los accesos directos (`.lnk`) rotos de escritorios y menús de inicio.

| Ítem | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Script** | `Invoke-GeneralCleanup.ps1` |
| **Contexto** | `SYSTEM` (agente Action1) |
| **Requiere reinicio** | No |
| **Nombre original** | `limpiezageneral.ps1` |

## Descripción (ES)

Es el script de limpieza conservador. A diferencia de [`Invoke-DeepCleanup`](../Invoke-DeepCleanup/), no aplica filtros de antigüedad, no vacía la papelera de reciclaje y no toca cachés de aplicaciones: solo borra temporales y accesos directos rotos.

Como no es destructivo, es la opción de limpieza más segura para desplegar de forma masiva y sin supervisión.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` o Administrador elevado (necesita leer todos los perfiles y `ProgramData`) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno — usa el objeto COM `WScript.Shell` incluido en Windows |
| **Reinicio** | No requiere |

## Cómo funciona (ES)

**Paso 1 — Archivos temporales**

- Vacía `C:\Windows\Temp` de forma recursiva y forzada.
- Recorre cada carpeta de perfil en `C:\Users`, omitiendo `All Users`, `Default`, `Default User` y `Public`, y vacía `AppData\Local\Temp` en cada una.
- Borra el **contenido**, nunca la carpeta `Temp` en sí.

**Paso 2 — Accesos directos rotos**

- Recopila las rutas de escritorio y menú de inicio de cada usuario, más `C:\Users\Public\Desktop` y `C:\ProgramData\Microsoft\Windows\Start Menu\Programs`.
- Para cada `.lnk` lee el destino con `WScript.Shell` y expande las variables de entorno que contenga.
- Elimina el acceso directo **solo** cuando el destino expandido es una ruta local absoluta (`^[a-zA-Z]:\`) que ya no existe.

Candados de seguridad:

| Situación | Acción |
|---|---|
| El destino es UNC (`\\servidor\...`) | **No borra** (evita falsos positivos si la red está desconectada) |
| El destino es una app de la Store, una URL o está vacío | **No borra** |
| Error al leer el `.lnk` | Lo salta (`continue`) |

## Parámetros (ES)

Ninguno.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Siempre — los errores de borrado se suprimen con `-ErrorAction SilentlyContinue` (los archivos en uso se omiten en silencio) |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Invoke-GeneralCleanup.ps1`.
2. **Asignar** como política de mantenimiento semanal.
3. **Desplegar en cualquier equipo** — es el script de limpieza más seguro para ejecución masiva y sin supervisión.
4. **Revisar la salida** en el reporte de ejecución del script para confirmar que ambos pasos terminaron.

## ⚠️ Advertencias (ES)

- **Los archivos se eliminan de forma permanente** — no van a la papelera de reciclaje.
- Los archivos bloqueados por procesos en ejecución se **omiten, no se fuerzan**.
- Los accesos directos UNC, de URL y de la Store se dejan intactos a propósito, para no borrar accesos que solo apuntan a un recurso no disponible. Verifica la lista de borrados en un equipo piloto antes de un despliegue masivo.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
