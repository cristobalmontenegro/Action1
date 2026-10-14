# Install-FluentCleaner.ps1

> Instala o actualiza **FluentCleaner** (`Builtbybel.FluentCleaner`) de forma
> global con **WinGet**, corrige permisos y crea un acceso directo público.

| Campo | Valor |
|---|---|
| **Categoría** | Instaladores |
| **Archivo** | `Install-FluentCleaner.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `instalarfluentcleaner.ps1` |

## Descripción

Instalador robusto pensado para despliegue masivo. Resuelve los dos problemas
habituales de instalar una app de la Store/WinGet como `SYSTEM`: la **instalación
fantasma** y los **permisos** para que el usuario final pueda ejecutarla.

## Comportamiento

1. **Localiza `winget.exe`** — si no está en el `PATH`, busca el ejecutable real
   dentro de `C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\`.
   Si no lo encuentra, aborta con código `1`.
2. Actualiza las fuentes (`winget source update`) e instala el runtime
   `Microsoft.WindowsAppRuntime.2.0`.
3. **Valida la instalación**:
   - Consulta `winget list` para ver si la app figura como instalada.
   - Comprueba también que la carpeta física exista en `%ProgramFiles%\WinGet\Packages`.
   - Si figura instalada pero la carpeta no existe → **instalación fantasma**:
     desinstala y reinstala en modo global (`--scope machine --force`).
   - Si la carpeta existe → ejecuta `winget upgrade`.
   - Si no está instalada → la instala en modo global.
4. **Permisos**: `icacls` concede lectura/ejecución al grupo *Usuarios*
   (`S-1-5-32-545`).
5. **Acceso directo**: busca `FCleaner.exe` recursivamente y crea
   `FluentCleaner.lnk` en el Escritorio Público.

## Parámetros

Ninguno. Las variables configurables al inicio del script son:

| Variable | Valor por defecto |
|---|---|
| `$appId` | `Builtbybel.FluentCleaner` |
| `$runtimeId` | `Microsoft.WindowsAppRuntime.2.0` |

## Códigos de salida

| Código | Condición |
|---|---|
| `0` | Instalación/actualización completada |
| `1` | No se pudo localizar `winget.exe` |

## Requisitos

- **WinGet** (App Installer) presente en el equipo.
- **Conectividad a Internet**.
- Contexto `SYSTEM` para el `--scope machine` y el acceso directo público.

## Uso en Action1

Política de "software de línea base". Al crear el acceso directo en el Escritorio
Público, la app queda disponible para todos los usuarios del equipo.

## Advertencias

- La app proviene de **WinGet/Store**: verifica la procedencia y confianza del
  publicador (`builtbybel`) según tu política.
- Requiere que el App Installer esté actualizado; versiones antiguas de `winget`
  pueden no reconocer `--scope machine`.
- Si no encuentra `FCleaner.exe`, avisa con `Write-Warning` pero no falla: la
  instalación puede haber cambiado de estructura en una versión nueva.
