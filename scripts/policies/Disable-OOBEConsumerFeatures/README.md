# Disable-OOBEConsumerFeatures.ps1

> Desactiva la pantalla **OOBE/SCOOBE** ("Terminar de configurar") y las
> sugerencias de contenido de Microsoft, tanto a nivel de máquina como en el
> **perfil por defecto** para que apliquen a usuarios nuevos.

| Campo | Valor |
|---|---|
| **Categoría** | Políticas |
| **Archivo** | `Disable-OOBEConsumerFeatures.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `deshabilitaroobe.ps1` |

## Descripción

Script **idempotente y diseñado para Intelligent Run**. Primero verifica si la
máquina ya cumple la política; solo si algo falta, aplica los cambios. Esto evita
re-aplicar directivas en cada ejecución periódica.

## Qué modifica

**A nivel de máquina (HKLM)**

```
HKLM:\Software\Policies\Microsoft\Windows\CloudContent
  DisableWindowsConsumerFeatures = 1
```

**En el perfil por defecto** (`C:\Users\Default\NTUSER.DAT`, montado temporalmente
como `HKU\DefaultUser`) — para que aplique a **usuarios nuevos**:

```
...\UserProfileEngagement
  ScoobeSystemSettingEnabled = 0
```

y 6 valores de sugerencias en `...\ContentDeliveryManager`:

```
SubscribedContent-310093Enabled, -338387Enabled, -338388Enabled,
-338389Enabled, -353694Enabled, -353696Enabled  → todos = 0
```

## Lógica de dos fases

1. **Verificación** — comprueba cada clave/valor. Si alguno falta o está mal,
   activa la bandera `$NecesitaCambios = $true`.
2. **Aplicación** — solo si `$NecesitaCambios` es verdadero, monta la colmena,
   escribe todo y la descarga.

La colmena `NTUSER.DAT` se **descarga siempre** en el bloque `finally`, incluso si
hubo error, para no dejar el registro bloqueado.

## Parámetros

Ninguno.

## Códigos de salida

Siempre `0`. El script reporta en el log si aplicó cambios o si la máquina ya
estaba conforme.

## Uso en Action1

Configurar como **Intelligent Run mensual**. Es el patrón ideal para este script:
la mayoría de ejecuciones no harán nada porque la máquina ya cumple.

## Advertencias

- Modifica el **perfil por defecto**, no los perfiles ya existentes. Los usuarios
  creados antes de la ejecución conservan su configuración previa.
- El montaje de `NTUSER.DAT` puede fallar si otra tarea lo tiene bloqueado en ese
  instante; en ese caso ese bloque se omite silenciosamente (reintentar más tarde).
- No elimina Microsoft Store ni aplicaciones; solo apaga las sugerencias.
