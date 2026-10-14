# Set-CustomAttribute-LowDisk.ps1

> Evalúa el porcentaje de espacio libre del disco `C:` y publica el atributo
> personalizado **`LowDisk`** con valor `1` (bajo) o `0` (ok) en Action1.

| Campo | Valor |
|---|---|
| **Categoría** | Reporting |
| **Archivo** | `Set-CustomAttribute-LowDisk.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `pocodiscoLowDisk.ps1` |

## Descripción

Script de **inventario / alerta temprana**. Permite detectar endpoints con poco
espacio en disco desde el propio Action1, sin depender de monitores externos.

## Comportamiento

1. Obtiene el disco `C:` con `Get-PSDrive` (fuente más estable que WMI).
2. Calcula el porcentaje libre: `Free / (Used + Free) * 100`, redondeado a 2
   decimales.
3. Si el porcentaje es **menor o igual al umbral** → `1`; si no → `0`.
4. Publica el resultado con `Action1-Set-CustomAttribute 'LowDisk' <valor>`.

## Variables configurables

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `$ThresholdPercent` | `30` | Umbral de espacio libre en porcentaje. Si el disco baja de este valor se marca `1`. |
| `$DriveLetter` | `C` | Letra del disco a evaluar (sin dos puntos). |

Ajusta `$ThresholdPercent` para alinearlo con el criterio de tu reporte.

## Requisito especial

> ⚠️ Utiliza la función **`Action1-Set-CustomAttribute`**, disponible **solo** en
> el contexto del agente Action1.

## Uso en Action1

Programar como *Intelligent Run* diario. Los equipos con `LowDisk = 1` pueden
recibir automáticamente [`Invoke-DeepCleanup`](../../maintenance/Invoke-DeepCleanup/)
o generar una alerta para revisión manual.

## Advertencias

- No modifica el sistema; es de solo lectura.
- Si el disco no se puede leer, asigna `0` por defecto y lo registra en el log
  (evita falsos positivos, pero también puede ocultar un problema real de acceso).
