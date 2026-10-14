# Invoke-SystemHealthCheck.ps1

> Reparación integral del sistema: **CHKDSK + DISM `/RestoreHealth` + SFC
> `/scannow`**, seguido de un reinicio automático.

| Campo | Valor |
|---|---|
| **Categoría** | Mantenimiento |
| **Archivo** | `Invoke-SystemHealthCheck.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | **Sí** (automático, 60 s) |
| **Nombre original** | `chequeosistema.ps1` |

## Descripción

Script de reparación pesado. También es un **script de diagnóstico**: guarda una
transcripción completa de la ejecución para poder revisarla después.

## Comportamiento

| Paso | Acción |
|---|---|
| 0 | Abre una transcripción en `C:\Mantenimiento_Action1.log` |
| 1 | Detecta discos fijos (`Win32_LogicalDisk`, `DriveType=3`) y programa `chkntfs /c` en cada uno |
| 2 | Ejecuta `DISM.exe /Online /Cleanup-image /Restorehealth` (salida silenciada) |
| 3 | Ejecuta `sfc.exe /scannow` (salida silenciada) |
| 4 | Cierra la transcripción y reinicia con `shutdown /r /t 60 /f` |

## Parámetros

Ninguno.

## Logs

`C:\Mantenimiento_Action1.log` — transcripción completa con fecha/hora de la
ejecución. Útil para saber si SFC/DISM encontraron y repararon daños.

## Códigos de salida

Siempre `0` (el último comando es `shutdown`, y la lógica de errores está
silenciada). No hay validación del `$LASTEXITCODE` de DISM o SFC.

## ⚠️ Advertencias

- **Reinicia el equipo** a los 60 segundos sin posibilidad de cancelar
  (`/f` fuerza el cierre de aplicaciones). **Avisa a los usuarios** antes de
  desplegarlo.
- **Tarda mucho** (DISM y SFC pueden tardar entre 15 y 60 minutos). El límite de
  ejecución de la política en Action1 debe ser amplio o el agente podría cortarlo.
- El `chkntfs /c` programa un chequeo de disco que se ejecutará **en el próximo
  arranque**, alargando el tiempo de encendido.
- Pérdida de trabajo no guardado por el `/f` del `shutdown`.

## Uso en Action1

Reservar para equipos con problemas reales (corrupción de sistema, errores de
disco). **No** es un script de mantenimiento rutinario.
