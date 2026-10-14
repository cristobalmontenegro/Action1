# Invoke-DiskCheck.ps1

> Programa un chequeo de disco (`chkntfs /c`) en **todos** los discos fijos y
> reinicia el equipo para dispararlo.

| Campo | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Archivo** | `Invoke-DiskCheck.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | **Sí** (automático, 15 s) |
| **Nombre original** | `chequeodisco.ps1` |

## Descripción

Versión mínima del chequeo de sistema: **solo** programa el `chkntfs` y reinicia.
No ejecuta DISM ni SFC.

## Comportamiento

1. Detecta todos los discos locales fijos con `Win32_LogicalDisk` (`DriveType=3`).
2. Ejecuta `chkntfs /c <letra>:` en cada uno, programando el chequeo para el
   próximo arranque.
3. Espera 15 segundos (para que Action1 alcance a guardar el reporte) y reinicia
   con `shutdown /r /t 15 /f`.

## Parámetros

Ninguno.

## Códigos de salida

Siempre `0`.

## ⚠️ Advertencias

- **Reinicia el equipo** a los 15 segundos con cierre forzado de aplicaciones.
  Hay muy poco margen: avisa a los usuarios.
- El chequeo de disco se ejecuta **al arrancar** y puede alargar notablemente el
  tiempo de encendido.
- `chkntfs /c` solo *programa* el chequeo; no lo ejecuta el script.

## Uso en Action1

Para equipos concretos con sospecha de errores de disco. Si quieres el chequeo
combinado con reparación de imagen, usa
[`Invoke-SystemHealthCheck`](../Invoke-SystemHealthCheck/).
