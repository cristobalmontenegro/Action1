# Invoke-GeneralCleanup.ps1

> Limpieza segura: borra temporales de **todos los usuarios** y elimina accesos
> directos (`.lnk`) rotos de escritorios y menús de inicio.

| Campo | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Archivo** | `Invoke-GeneralCleanup.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `limpiezageneral.ps1` |

## Descripción

Script de limpieza conservador. A diferencia de
[`Invoke-DeepCleanup`](../Invoke-DeepCleanup/), no aplica filtros de antigüedad,
no vacía papelera y no toca cachés de aplicaciones: solo temporales y accesos
directos rotos.

## Comportamiento

**Paso 1 — Temporales**
- Vacía `C:\Windows\Temp`.
- Recorre cada perfil en `C:\Users` (omitiendo `All Users`, `Default`,
  `Default User` y `Public`) y vacía `AppData\Local\Temp`. Borra el **contenido**,
  no la carpeta `Temp` en sí.

**Paso 2 — Accesos directos rotos**
- Recopila rutas de escritorio y menú de inicio de cada usuario, más
  `C:\Users\Public\Desktop` y `C:\ProgramData\Microsoft\Windows\Start Menu\Programs`.
- Para cada `.lnk` lee su destino con `WScript.Shell`.
- **Solo** elimina el acceso directo si el destino es una ruta local absoluta
  (`^[a-zA-Z]:\`) que ya no existe.

## Candados de seguridad

| Situación | Acción |
|---|---|
| Destino es UNC (`\\servidor\...`) | **No borra** (evita falsos positivos por red desconectada) |
| Destino es una app de la Store / URL / sin destino | **No borra** |
| Error al leer el `.lnk` | Lo salta (`continue`) |

## Parámetros

Ninguno.

## Códigos de salida

Siempre `0`. Los errores de borrado de archivos están suprimidos con
`-ErrorAction SilentlyContinue` (archivos en uso se omiten en silencio).

## Uso en Action1

Política de mantenimiento semanal. Es el script de limpieza más seguro para
desplegar de forma masiva sin supervisión.

## Advertencias

- Elimina archivos de forma permanente (no van a la papelera).
- Los archivos bloqueados por procesos en ejecución se omiten, no se fuerzan.
