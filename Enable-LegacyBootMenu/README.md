# ⌨️ Enable Legacy Boot Menu (F8)

[Español abajo](#reactivar-el-menú-de-arranque-clásico)

**🇬🇧 English**

Re-enables the classic Windows **boot menu** so you can press **F8** (Advanced Boot Options) while the machine starts. Meant for on-site support and recovery tasks.

| Item | Value |
|---|---|
| **Category** | Boot |
| **Script** | `Enable-LegacyBootMenu.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No — takes effect from the next boot |
| **Original name** | `reactivarF8.ps1` |

## Overview (EN)

On Windows 8, 10 and 11 the classic F8 menu is disabled by default, because the machine boots too fast to reach it. This script restores the legacy boot menu policy: the boot entry point becomes reachable again, giving direct access to Safe Mode, "Last Known Good Configuration" and the other advanced startup options.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` or elevated Administrator (BCD changes need elevation) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None — uses `bcdedit.exe` from the OS |
| **Boot configuration** | Requires a valid BCD store with a default boot entry (`{default}`) |

## How it works (EN)

1. Runs `bcdedit /set {default} bootmenupolicy legacy`, switching the default boot entry to the classic menu policy.
2. Checks `$LASTEXITCODE` and reports success or a warning.

`{default}` targets the default boot entry. The policy applies from the next start; the script does **not** force a reboot, so the change is visible only after the endpoint restarts.

## Parameters (EN)

None. The policy value (`legacy`) is hardcoded; change it to `standard` in the script, or run the revert command below, to undo it.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Policy applied (`bcdedit` returned 0) |
| `1` | `bcdedit` failed |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Enable-LegacyBootMenu.ps1`.
2. **Review** the warnings below and confirm the change fits your boot and security policy.
3. **Deploy** — to a single endpoint for testing, then to the group that needs F8 access.
4. **Revert** when it is no longer needed:
   ```powershell
   bcdedit /set {default} bootmenupolicy standard
   ```
5. **Combine it** with [`Set-SafeModeBoot`](\./Set-SafeModeBoot/) when you need hands-on access to the recovery options.

## ⚠️ Security notes (EN)

- **Adds a few seconds to every boot**, since the boot menu is displayed before Windows starts.
- **Requires elevation / `SYSTEM`** — the BCD store cannot be modified otherwise.
- **It is a boot configuration change.** Validate it against your security policy before rolling it out widely: an unattended endpoint would sit at a boot menu until someone presses a key or the timeout expires.

---

# ⌨ Reactivar el Menú de Arranque Clásico

**🇪🇸 Español**

[English above](#enable-legacy-boot-menu-f8)

Reactiva el **menú de arranque clásico de Windows** para poder pulsar **F8** (Opciones de arranque avanzadas) al encender. Pensado para tareas de soporte en sitio y recuperación.

| Ítem | Valor |
|---|---|
| **Categoría** | Arranque |
| **Script** | `Enable-LegacyBootMenu.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No — se aplica en el siguiente arranque |
| **Nombre original** | `reactivarF8.ps1` |

## Descripción (ES)

En Windows 8, 10 y 11 el menú clásico de F8 está deshabilitado por defecto, porque el equipo arranca demasiado rápido para alcanzarlo. Este script vuelve a habilitar la política del menú de arranque clásico: el punto de entrada queda accesible otra vez y da acceso directo al Modo Seguro, a "Última configuración válida conocida" y a las demás opciones avanzadas de inicio.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` o Administrador elevado (el BCD exige elevación) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno — usa `bcdedit.exe` del sistema |
| **Configuración de arranque** | Requiere un almacén BCD válido con una entrada de arranque predeterminada (`{default}`) |

## Cómo funciona (ES)

1. Ejecuta `bcdedit /set {default} bootmenupolicy legacy`, poniendo la entrada de arranque predeterminada en la política de menú clásico.
2. Verifica `$LASTEXITCODE` y reporta éxito o una advertencia.

`{default}` apunta a la entrada de arranque predeterminada. La política se aplica desde el siguiente inicio; el script **no** fuerza ningún reinicio, así que el cambio se ve recién cuando el equipo se reinicia.

## Parámetros (ES)

Ninguno. El valor de la política (`legacy`) está fijo; cámbialo a `standard` en el script, o usa el comando de reversión de abajo, para deshacerlo.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Política aplicada (`bcdedit` devolvió 0) |
| `1` | `bcdedit` falló |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Enable-LegacyBootMenu.ps1`.
2. **Revisar** las advertencias de abajo y confirmar que el cambio encaja con tu política de arranque y seguridad.
3. **Desplegar** — primero en un solo equipo de prueba y luego en el grupo que necesita acceso con F8.
4. **Revertir** cuando ya no se necesite:
   ```powershell
   bcdedit /set {default} bootmenupolicy standard
   ```
5. **Combinarlo** con [`Set-SafeModeBoot`](\./Set-SafeModeBoot/) cuando necesites acceso manual a las opciones de recuperación.

## ⚠️ Advertencias (ES)

- **Añade unos segundos a cada arranque**, porque el menú se muestra antes de que Windows inicie.
- **Requiere elevación / `SYSTEM`** — el almacén BCD no se puede modificar de otra forma.
- **Es un cambio de configuración de arranque.** Valídalo con tu política de seguridad antes de desplegarlo de forma masiva: un equipo desatendido quedaría detenido en el menú de arranque hasta que alguien pulse una tecla o venza el tiempo de espera.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](\./LICENSE/).
