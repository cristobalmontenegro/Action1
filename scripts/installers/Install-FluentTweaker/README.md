# 🛠️ Install FluentTweaker from the Latest GitHub Release

[Español abajo](#instalación-de-fluenttweaker-desde-github)

**🇬🇧 English**

Downloads and installs the **latest release** of **FluentTweaker** straight from the GitHub releases API, fixes NTFS permissions, and drops a shortcut on the Public Desktop.

| Item | Value |
|---|---|
| **Category** | Installers |
| **Script** | `Install-FluentTweaker.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No |
| **Original name** | `instalarFluenttweaker.ps1` |

## Overview (EN)

Unlike FluentCleaner (available in WinGet), FluentTweaker ships as a `.zip` attached to GitHub releases. This script queries the GitHub API for the newest release every time, downloads and unpacks it, and leaves the binary reachable by all users — which makes it a built-in auto-update mechanism when scheduled.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` — required to write into `%ProgramFiles%` and to create the Public Desktop shortcut |
| **PowerShell** | 5.1 (Windows PowerShell) or later (`Expand-Archive` is used) |
| **Modules** | None |
| **Network** | Outbound HTTPS to `api.github.com` and `github.com`/`objects.githubusercontent.com` |

## How it works (EN)

1. **Forces TLS 1.2** on the session (`[Net.ServicePointManager]::SecurityProtocol`) for the GitHub API and the download.
2. **Queries** `https://api.github.com/repos/builtbybel/FluentTweaker/releases/latest` and picks the download URL of the **first asset whose name ends in `.zip`**. If the release has no `.zip` asset, it errors out with exit code `1`.
3. **Downloads** the ZIP to `%TEMP%\FluentTweaker_latest.zip`.
4. **Clean install** — if `%ProgramFiles%\FluentTweaker` already exists, its contents are wiped first so no stale files survive the upgrade; otherwise the folder is created.
5. **Extracts** with `Expand-Archive -Force` into `%ProgramFiles%\FluentTweaker` and deletes the temporary ZIP.
6. **Fixes permissions** — `icacls` grants read/execute to the *Users* group (`S-1-5-32-545`), recursively.
7. **Creates the shortcut** — searches recursively for `FTweaker.exe` and creates `FluentTweaker.lnk` on the Public Desktop (`[Environment]::GetFolderPath('CommonDesktopDirectory')`).

> ℹ️ If `FTweaker.exe` is not found after extraction, the script only emits `Write-Warning`. The exit code stays `0` — the app is installed, but without a shortcut.

## Configuration (EN)

No parameters. The script is driven by variables declared at the top of the file:

| Variable | Default value | Purpose |
|---|---|---|
| `$githubRepo` | `builtbybel/FluentTweaker` | `owner/repo` queried for the latest release |
| `$installDir` | `$env:ProgramFiles\FluentTweaker` | Extraction target |
| `$tempZipPath` | `$env:TEMP\FluentTweaker_latest.zip` | Temporary download path, removed after extraction |

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Extraction, permissions and shortcut routine finished (including the warning-only case where `FTweaker.exe` was not found) |
| `1` | No `.zip` asset in the latest release, or any error caught while querying, downloading or extracting |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Install-FluentTweaker.ps1`.
2. **Context** — confirm the agent runs the script as `SYSTEM`.
3. **Schedule** — attach it to a baseline-tools policy and run it periodically (e.g. monthly): every execution installs whatever release is newest, so it doubles as an updater.
4. **Verify** — look for *"Acceso directo creado correctamente..."* in the Action1 output and confirm `FluentTweaker.lnk` exists on the Public Desktop of a target endpoint.
5. **Pin a version (optional)** — if you must freeze a release, point `$githubRepo`/the URL at `/releases/tags/<version>` instead of `/releases/latest`.

## ⚠️ Security notes (EN)

- **No integrity verification.** The script trusts whatever the GitHub release publishes: there is no hash or signature check. Add SHA-256 validation if your policy requires it.
- **Always upgrades to the newest release.** There is no way to pin a specific version without editing the script.
- **Destructive folder cleanup.** Everything inside `%ProgramFiles%\FluentTweaker` is deleted before extraction, including files someone added by hand.
- **Unauthenticated API calls.** The GitHub API allows only 60 requests per hour per source IP without a token; heavy mass rollouts could hit that limit (the script would then fail with exit code `1`).
- **Third-party publisher.** Verify the provenance and trust of `builtbybel` before deploying broadly.

---

# 🛠 Instalación de FluentTweaker desde GitHub

**🇪🇸 Español**

Descarga e instala la **última versión** de **FluentTweaker** directamente desde la API de releases de GitHub, corrige los permisos NTFS y crea un acceso directo en el Escritorio Público.

| Ítem | Valor |
|---|---|
| **Categoría** | Instaladores |
| **Script** | `Install-FluentTweaker.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `instalarFluenttweaker.ps1` |

## Descripción (ES)

A diferencia de FluentCleaner (que está en WinGet), FluentTweaker se distribuye como `.zip` adjunto en las releases de GitHub. Este script consulta la API de GitHub para obtener siempre la versión más reciente, la descarga y la descomprime, dejando el binario accesible para todos los usuarios — lo que lo convierte en un mecanismo de actualización automática si se programa.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` — necesario para escribir en `%ProgramFiles%` y crear el acceso directo público |
| **PowerShell** | 5.1 (Windows PowerShell) o superior (se usa `Expand-Archive`) |
| **Módulos** | Ninguno |
| **Red** | Salida HTTPS a `api.github.com` y `github.com`/`objects.githubusercontent.com` |

## Cómo funciona (ES)

1. **Fuerza TLS 1.2** en la sesión (`[Net.ServicePointManager]::SecurityProtocol`) para la API de GitHub y la descarga.
2. **Consulta** `https://api.github.com/repos/builtbybel/FluentTweaker/releases/latest` y toma la URL de descarga del **primer asset cuyo nombre termina en `.zip`**. Si el release no tiene ningún `.zip`, falla con código de salida `1`.
3. **Descarga** el ZIP a `%TEMP%\FluentTweaker_latest.zip`.
4. **Instalación limpia** — si ya existe `%ProgramFiles%\FluentTweaker`, primero vacía su contenido para que no sobrevivan archivos antiguos tras la actualización; si no existe, crea la carpeta.
5. **Extrae** con `Expand-Archive -Force` en `%ProgramFiles%\FluentTweaker` y borra el ZIP temporal.
6. **Corrige permisos** — `icacls` concede lectura/ejecución al grupo *Usuarios* (`S-1-5-32-545`), de forma recursiva.
7. **Crea el acceso directo** — busca recursivamente `FTweaker.exe` y crea `FluentTweaker.lnk` en el Escritorio Público (`[Environment]::GetFolderPath('CommonDesktopDirectory')`).

> ℹ️ Si tras extraer no encuentra `FTweaker.exe`, el script solo emite `Write-Warning`. El código de salida sigue siendo `0`: la app queda instalada, pero sin acceso directo.

## Configuración (ES)

Sin parámetros. El script se controla con variables declaradas al inicio del archivo:

| Variable | Valor por defecto | Propósito |
|---|---|---|
| `$githubRepo` | `builtbybel/FluentTweaker` | `owner/repo` consultado para el último release |
| `$installDir` | `$env:ProgramFiles\FluentTweaker` | Carpeta de extracción |
| `$tempZipPath` | `$env:TEMP\FluentTweaker_latest.zip` | Ruta temporal de descarga, eliminada tras extraer |

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Rutina de extracción, permisos y acceso directo finalizada (incluye el caso de solo advertencia cuando no se encontró `FTweaker.exe`) |
| `1` | No hay asset `.zip` en el último release, o cualquier error capturado al consultar, descargar o extraer |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Install-FluentTweaker.ps1`.
2. **Contexto** — confirma que el agente ejecuta el script como `SYSTEM`.
3. **Programar** — asígnalo a una política de herramientas de línea base y ejecútalo de forma periódica (p. ej. mensual): cada ejecución instala el release más reciente, así que también sirve como actualizador.
4. **Verificar** — busca *"Acceso directo creado correctamente..."* en la salida de Action1 y confirma que `FluentTweaker.lnk` existe en el Escritorio Público de un equipo destino.
5. **Fijar una versión (opcional)** — si necesitas congelar un release, apunta `$githubRepo`/la URL a `/releases/tags/<version>` en lugar de `/releases/latest`.

## ⚠️ Advertencias (ES)

- **Sin verificación de integridad.** El script confía en lo que publique el release de GitHub: no comprueba hash ni firma. Añade validación SHA-256 si tu política lo exige.
- **Actualiza siempre al release más reciente.** No hay forma de fijar una versión concreta sin modificar el script.
- **Limpieza destructiva de la carpeta.** Todo el contenido de `%ProgramFiles%\FluentTweaker` se borra antes de extraer, incluidos archivos añadidos manualmente.
- **Consultas a la API sin autenticar.** La API de GitHub permite solo 60 peticiones por hora por IP de origen sin token; un despliegue masivo intenso podría alcanzar ese límite (el script fallaría entonces con código `1`).
- **Publicador de terceros.** Verifica la procedencia y la confianza de `builtbybel` antes de desplegarlo masivamente.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
