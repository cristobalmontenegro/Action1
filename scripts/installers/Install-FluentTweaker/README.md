# Install-FluentTweaker.ps1

> Descarga e instala la **última versión** de FluentTweaker directamente desde
> las releases de GitHub, corrige permisos y crea un acceso directo público.

| Campo | Valor |
|---|---|
| **Categoría** | Instaladores |
| **Archivo** | `Install-FluentTweaker.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `instalarFluenttweaker.ps1` |

## Descripción

A diferencia de FluentCleaner (que está en WinGet), FluentTweaker se distribuye
como `.zip` en GitHub. Este script consulta la API de GitHub para obtener siempre
el último release, lo descarga, lo extrae y deja el binario accesible para los
usuarios.

## Comportamiento

1. Fuerza **TLS 1.2** para la conexión con la API de GitHub.
2. Consulta `https://api.github.com/repos/builtbybel/FluentTweaker/releases/latest`
   y extrae la URL del primer asset `.zip`. Si no hay `.zip`, aborta con código `1`.
3. Descarga el ZIP a `%TEMP%\FluentTweaker_latest.zip`.
4. **Extracción limpia**: si ya existe `%ProgramFiles%\FluentTweaker`, vacía su
   contenido antes de extraer la versión nueva.
5. `Expand-Archive` a `%ProgramFiles%\FluentTweaker` y borra el ZIP temporal.
6. **Permisos**: `icacls` concede lectura/ejecución al grupo *Usuarios*.
7. **Acceso directo**: busca `FTweaker.exe` recursivamente y crea
   `FluentTweaker.lnk` en el Escritorio Público.

## Variables configurables

| Variable | Valor por defecto |
|---|---|
| `$githubRepo` | `builtbybel/FluentTweaker` |
| `$installDir` | `%ProgramFiles%\FluentTweaker` |

## Códigos de salida

| Código | Condición |
|---|---|
| `0` | Instalación completada |
| `1` | No hay asset `.zip` en el release, o error de descarga/extracción |

## Requisitos

- **Conectividad a Internet** y acceso a `api.github.com` y `github.com`.
- Contexto `SYSTEM` para escribir en `%ProgramFiles%` y crear el acceso directo público.

## Uso en Action1

Política de despliegue de herramientas de línea base. Cada ejecución instala la
versión más reciente disponible, por lo que sirve como mecanismo de actualización
automática.

## Advertencias

- **Sin verificación de integridad**: el script confía en lo que publique el
  repositorio de GitHub. Si tu política lo exige, añade validación de hash o
  firma.
- Actualiza al último release **siempre**: no permite fijar una versión concreta.
  Si necesitas versionado fijo, habría que modificar el script para usar
  `/releases/tags/<version>`.
- La limpieza de la carpeta de instalación borra cualquier archivo añadido
  manualmente en `%ProgramFiles%\FluentTweaker`.
