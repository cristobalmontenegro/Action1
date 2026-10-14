# 🧹 Machine-Wide Install of FluentCleaner with WinGet

[Español abajo](#instalación-de-fluentcleaner-con-winget)

**🇬🇧 English**

Installs or updates **FluentCleaner** (`Builtbybel.FluentCleaner`) machine-wide with **WinGet**, repairs NTFS permissions so regular users can run it, and drops a shortcut on the Public Desktop.

| Item | Value |
|---|---|
| **Category** | Installers |
| **Script** | `Install-FluentCleaner.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No |
| **Original name** | `instalarfluentcleaner.ps1` |

## Overview (EN)

A hardening-minded installer for mass deployment. Installing a Store/WinGet package as `SYSTEM` normally hits two well-known problems: the **ghost install** (WinGet reports the app as installed while no files exist on disk) and unusable **permissions** (the package lands under a SYSTEM-owned folder that regular users cannot read or execute). This script detects and fixes both, then publishes the app to every user through the Public Desktop.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` — required for `--scope machine` and the Public Desktop shortcut |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None |
| **WinGet** | App Installer must be present (see *How it works*, step 1) |
| **Network** | Internet access to the WinGet sources and to the Windows App Runtime package |

## How it works (EN)

1. **Locates `winget.exe`** — first through `Get-Command winget`; if it is not on the `PATH`, it searches the real binary under `C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\`. If neither works the script calls `Write-Error` and exits with code `1`.
2. **Refreshes sources** (`winget source update`) and installs the dependency runtime `Microsoft.WindowsAppRuntime.2.0`.
3. **Validates the installation** with two independent checks — the WinGet inventory (`winget list --id Builtbybel.FluentCleaner --exact`) and the physical folder `%ProgramFiles%\WinGet\Packages\Builtbybel.FluentCleaner_*`:
   - **Listed but no folder → ghost install.** It uninstalls the entry and reinstalls globally with `--scope machine --force --skip-dependencies`.
   - **Folder present →** runs `winget upgrade --scope machine --skip-dependencies`.
   - **Not listed →** installs with `--scope machine --skip-dependencies`.
4. **Fixes permissions** — `icacls` grants read/execute on the package folder to the *Users* group (`S-1-5-32-545`), recursively.
5. **Creates the shortcut** — searches recursively for `FCleaner.exe` inside the package folder and creates `FluentCleaner.lnk` on the Public Desktop (`$env:PUBLIC\Desktop`).

> ℹ️ Every `winget` call is piped to `Out-Null`, so a non-zero `winget` exit code is **not** propagated. The script only fails hard when `winget.exe` itself cannot be found.

## Configuration (EN)

No parameters. The script is driven by variables declared at the top of the file:

| Variable | Default value | Purpose |
|---|---|---|
| `$appId` | `Builtbybel.FluentCleaner` | WinGet package id |
| `$runtimeId` | `Microsoft.WindowsAppRuntime.2.0` | Dependency runtime installed first |
| `$wingetExe` | `winget.exe` | Executable name; replaced by the resolved full path when `winget` is missing from the `PATH` |

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Installation/upgrade routine finished (also returned when `winget` itself reports an error) |
| `1` | `winget.exe` could not be located (`Write-Error` + `Exit 1`) |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Install-FluentCleaner.ps1`.
2. **Context** — confirm the agent runs the script as `SYSTEM` (mandatory for `--scope machine`).
3. **Baseline policy** — attach it to the policy that keeps baseline software present on all endpoints; re-running is safe because the script upgrades when the app already exists.
4. **Verify** — check the Action1 output for the messages *"Instalación global limpia"*, *"Desbloqueando permisos..."* and *"Acceso directo creado correctamente"*, and confirm `FluentCleaner.lnk` appears on a target endpoint's Public Desktop.
5. **Watch for warnings** — `Write-Warning` fires if `FCleaner.exe` is missing or the package folder was not created; those runs still exit with `0`.

## ⚠️ Security notes (EN)

- **Third-party publisher.** The package comes from WinGet/the Store and is published by `builtbybel`. Validate its provenance and trust level against your software approval policy before mass deployment.
- **App Installer version matters.** Older `winget` builds may not support `--scope machine`; keep App Installer updated on the endpoints.
- **Package layout can change.** If a future release renames or relocates `FCleaner.exe`, the recursive search fails and the script warns instead of erroring — the app is installed but no shortcut is created.
- **Wide permission grant.** `icacls ... /grant *S-1-5-32-545:(OI)(CI)RX` gives read/execute to *all* local users on the package tree. This is deliberate for an app that must be launchable by everyone, but review it against your least-privilege policy.

---

# 🧹 Instalación de FluentCleaner con WinGet

**🇪🇸 Español**

Instala o actualiza **FluentCleaner** (`Builtbybel.FluentCleaner`) de forma global con **WinGet**, repara los permisos NTFS para que cualquier usuario pueda ejecutarlo y crea un acceso directo en el Escritorio Público.

| Ítem | Valor |
|---|---|
| **Categoría** | Instaladores |
| **Script** | `Install-FluentCleaner.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `instalarfluentcleaner.ps1` |

## Descripción (ES)

Instalador pensado para despliegue masivo. Instalar un paquete de la Store/WinGet como `SYSTEM` choca normalmente con dos problemas conocidos: la **instalación fantasma** (WinGet reporta la app como instalada, pero en disco no hay archivos) y los **permisos** inservibles (el paquete queda en una carpeta propiedad de SYSTEM que los usuarios normales no pueden leer ni ejecutar). Este script detecta y corrige ambos, y luego publica la aplicación para todos los usuarios mediante el Escritorio Público.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` — necesario para `--scope machine` y el acceso directo público |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno |
| **WinGet** | Debe estar presente el App Installer (ver *Cómo funciona*, paso 1) |
| **Red** | Acceso a Internet a las fuentes de WinGet y al paquete Windows App Runtime |

## Cómo funciona (ES)

1. **Localiza `winget.exe`** — primero con `Get-Command winget`; si no está en el `PATH`, busca el binario real en `C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\`. Si ninguna vía funciona, el script lanza `Write-Error` y termina con código `1`.
2. **Actualiza las fuentes** (`winget source update`) e instala el runtime de dependencia `Microsoft.WindowsAppRuntime.2.0`.
3. **Valida la instalación** con dos comprobaciones independientes — el inventario de WinGet (`winget list --id Builtbybel.FluentCleaner --exact`) y la carpeta física `%ProgramFiles%\WinGet\Packages\Builtbybel.FluentCleaner_*`:
   - **Figura en la lista pero no existe la carpeta → instalación fantasma.** Desinstala la entrada y reinstala en modo global con `--scope machine --force --skip-dependencies`.
   - **La carpeta existe →** ejecuta `winget upgrade --scope machine --skip-dependencies`.
   - **No figura en la lista →** instala con `--scope machine --skip-dependencies`.
4. **Corrige permisos** — `icacls` concede lectura/ejecución sobre la carpeta del paquete al grupo *Usuarios* (`S-1-5-32-545`), de forma recursiva.
5. **Crea el acceso directo** — busca recursivamente `FCleaner.exe` dentro de la carpeta del paquete y crea `FluentCleaner.lnk` en el Escritorio Público (`$env:PUBLIC\Desktop`).

> ℹ️ Todas las llamadas a `winget` se canalizan a `Out-Null`, así que un código de salida distinto de cero de `winget` **no** se propaga. El script solo falla de forma dura cuando no encuentra el propio `winget.exe`.

## Configuración (ES)

Sin parámetros. El script se controla con variables declaradas al inicio del archivo:

| Variable | Valor por defecto | Propósito |
|---|---|---|
| `$appId` | `Builtbybel.FluentCleaner` | Id del paquete en WinGet |
| `$runtimeId` | `Microsoft.WindowsAppRuntime.2.0` | Runtime de dependencia que se instala primero |
| `$wingetExe` | `winget.exe` | Nombre del ejecutable; se sustituye por la ruta completa resuelta si `winget` no está en el `PATH` |

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Rutina de instalación/actualización finalizada (también se devuelve cuando el propio `winget` reporta un error) |
| `1` | No se pudo localizar `winget.exe` (`Write-Error` + `Exit 1`) |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Install-FluentCleaner.ps1`.
2. **Contexto** — confirma que el agente ejecuta el script como `SYSTEM` (obligatorio para `--scope machine`).
3. **Política de línea base** — asígnalo a la política que mantiene el software base presente en todos los equipos; volver a ejecutarlo es seguro porque el script actualiza cuando la app ya existe.
4. **Verificar** — revisa la salida en Action1 buscando los mensajes *"Instalación global limpia"*, *"Desbloqueando permisos..."* y *"Acceso directo creado correctamente"*, y confirma que `FluentCleaner.lnk` aparece en el Escritorio Público de un equipo destino.
5. **Vigilar las advertencias** — `Write-Warning` se dispara si falta `FCleaner.exe` o si no se creó la carpeta del paquete; esas ejecuciones igualmente salen con `0`.

## ⚠️ Advertencias (ES)

- **Publicador de terceros.** El paquete proviene de WinGet/Store y lo publica `builtbybel`. Valida su procedencia y nivel de confianza según tu política de aprobación de software antes del despliegue masivo.
- **Importa la versión del App Installer.** Versiones antiguas de `winget` pueden no soportar `--scope machine`; mantén el App Installer actualizado en los equipos.
- **La estructura del paquete puede cambiar.** Si una versión futura renombra o mueve `FCleaner.exe`, la búsqueda recursiva no lo encuentra y el script avisa en lugar de fallar: la app queda instalada pero sin acceso directo.
- **Concesión amplia de permisos.** `icacls ... /grant *S-1-5-32-545:(OI)(CI)RX` da lectura/ejecución a *todos* los usuarios locales sobre el árbol del paquete. Es intencional para una app que debe poder lanzar cualquiera, pero revísalo frente a tu política de mínimo privilegio.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
