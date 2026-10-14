# 🔕 Disable OOBE (SCOOBE) and Consumer Features

[Español abajo](#desactivar-oobe-scoobe-y-sugerencias-al-consumidor)

**🇬🇧 English**

Disables the **OOBE/SCOOBE** "Finish setting up" screen and Microsoft consumer content suggestions, both machine-wide and in the **default user profile** so they apply to new accounts.

| Item | Value |
|---|---|
| **Category** | Policies |
| **Script** | `Disable-OOBEConsumerFeatures.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No |
| **Original name** | `deshabilitaroobe.ps1` |

## Overview (EN)

An **idempotent script designed for Intelligent Run**. It first checks whether the machine already satisfies the policy and only applies changes when something is missing, so recurring executions normally do nothing and stay cheap.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent with the consumer-content policy nodes |
| **Context** | `SYSTEM` — required to load `NTUSER.DAT` into `HKU` and to write under `HKLM` |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None (uses `reg.exe` for hive load/unload) |
| **Network** | Not required |

## How it works (EN)

**Machine level (HKLM)**

```
HKLM:\Software\Policies\Microsoft\Windows\CloudContent
  DisableWindowsConsumerFeatures = 1
```

**Default profile** (`C:\Users\Default\NTUSER.DAT`, temporarily mounted as `HKU\DefaultUser`) — so the settings apply to **new users**:
```
...\UserProfileEngagement
  ScoobeSystemSettingEnabled = 0
```

plus six suggestion values in `...\ContentDeliveryManager`:
```
SubscribedContent-310093Enabled, -338387Enabled, -338388Enabled,
-338389Enabled, -353694Enabled, -353696Enabled  → all = 0
```

**Two-phase logic**

1. **Verify** — checks each key/value; if any is missing or wrong it sets the flag `$NecesitaCambios = $true`.
2. **Apply** — only when `$NecesitaCambios` is true, it mounts the hive, writes everything and unloads it.

The `NTUSER.DAT` hive is **always unloaded** in a `finally` block, even on error, so the registry never stays locked. In the verification phase the `reg load` output is redirected to `$null`, so a hive locked by another task is skipped silently.

> **How to revert.** Delete the values and, optionally, reboot:
> ```powershell
> Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Force
> reg load HKU\DefaultUser C:\Users\Default\NTUSER.DAT
> Remove-ItemProperty -Path "Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Force
> Remove-ItemProperty -Path "Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-*" -Force
> reg unload HKU\DefaultUser
> ```

## Parameters (EN)

None. The registry paths, DWORD values and the six `SubscribedContent-*` ids are hardcoded.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Always — the script has no explicit `exit`; it logs whether it applied changes or the machine already complied |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Disable-OOBEConsumerFeatures.ps1`.
2. **Context** — run as `SYSTEM`.
3. **Schedule as Intelligent Run (monthly)** — this is the ideal pattern for the script: most executions do nothing because the machine already complies.
4. **Verify** — read the output message: `Configuracion aplicada con exito.` means changes were applied, `La maquina ya esta protegida contra avisos de Microsoft. No se requieren acciones.` means it was already compliant.
5. **Revert if needed** — see the *How to revert* block above.

## ⚠️ Security notes (EN)

- **Only the default profile is modified**, not existing profiles. Accounts created before the execution keep their previous configuration.
- **Mounting `NTUSER.DAT` can fail** if another task holds it at that moment; that block is skipped silently (retry later). The hive is unloaded in `finally` to avoid leaving the registry locked.
- **Nothing is uninstalled.** Microsoft Store and the preinstalled apps stay in place; only the suggestions and the SCOOBE screen are turned off.
- **Machine-level policy is broad.** `DisableWindowsConsumerFeatures` suppresses consumer content for every user of the endpoint — confirm it matches your UX policy.
- **No hard error reporting.** Because the script has no explicit exit code, verify through the log messages rather than through the Action1 status alone.

---

# 🔕 Desactivar OOBE (SCOOBE) y Sugerencias al Consumidor

**🇪🇸 Español**

Desactiva la pantalla **OOBE/SCOOBE** ("Terminar de configurar") y las sugerencias de contenido de Microsoft, tanto a nivel de máquina como en el **perfil por defecto** para que apliquen a los usuarios nuevos.

| Ítem | Valor |
|---|---|
| **Categoría** | Políticas |
| **Script** | `Disable-OOBEConsumerFeatures.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `deshabilitaroobe.ps1` |

## Descripción (ES)

Script **idempotente y diseñado para Intelligent Run**. Primero verifica si la máquina ya cumple la política y solo aplica cambios cuando algo falta, así que las ejecuciones periódicas normalmente no hacen nada y resultan baratas.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente con los nodos de directiva de contenido al consumidor |
| **Contexto** | `SYSTEM` — necesario para cargar `NTUSER.DAT` en `HKU` y escribir en `HKLM` |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno (usa `reg.exe` para cargar y descargar la colmena) |
| **Red** | No se necesita |

## Cómo funciona (ES)

**A nivel de máquina (HKLM)**

```
HKLM:\Software\Policies\Microsoft\Windows\CloudContent
  DisableWindowsConsumerFeatures = 1
```

**En el perfil por defecto** (`C:\Users\Default\NTUSER.DAT`, montado temporalmente como `HKU\DefaultUser`) — para que aplique a los **usuarios nuevos**:
```
...\UserProfileEngagement
  ScoobeSystemSettingEnabled = 0
```

y seis valores de sugerencias en `...\ContentDeliveryManager`:
```
SubscribedContent-310093Enabled, -338387Enabled, -338388Enabled,
-338389Enabled, -353694Enabled, -353696Enabled  → todos = 0
```

**Lógica de dos fases**

1. **Verificación** — comprueba cada clave/valor; si alguno falta o está mal, activa la bandera `$NecesitaCambios = $true`.
2. **Aplicación** — solo si `$NecesitaCambios` es verdadero, monta la colmena, escribe todo y la descarga.

La colmena `NTUSER.DAT` se **descarga siempre** en el bloque `finally`, incluso si hubo error, para no dejar el registro bloqueado. En la fase de verificación la salida de `reg load` se redirige a `$null`, así que una colmena bloqueada por otra tarea se omite en silencio.

> **Cómo revertir.** Borra los valores y, si quieres, reinicia:
> ```powershell
> Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Force
> reg load HKU\DefaultUser C:\Users\Default\NTUSER.DAT
> Remove-ItemProperty -Path "Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Force
> Remove-ItemProperty -Path "Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-*" -Force
> reg unload HKU\DefaultUser
> ```

## Parámetros (ES)

Ninguno. Las rutas de registro, los valores DWORD y los seis ids `SubscribedContent-*` están fijos.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Siempre — el script no tiene `exit` explícito; en el log indica si aplicó cambios o si la máquina ya estaba conforme |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Disable-OOBEConsumerFeatures.ps1`.
2. **Contexto** — ejecútalo como `SYSTEM`.
3. **Programar como Intelligent Run (mensual)** — es el patrón ideal para este script: la mayoría de ejecuciones no harán nada porque la máquina ya cumple.
4. **Verificar** — lee el mensaje de salida: `Configuracion aplicada con exito.` significa que aplicó cambios, y `La maquina ya esta protegida contra avisos de Microsoft. No se requieren acciones.` que ya estaba conforme.
5. **Revertir si hace falta** — ver el bloque *Cómo revertir* arriba.

## ⚠️ Advertencias (ES)

- **Solo modifica el perfil por defecto**, no los perfiles ya existentes. Los usuarios creados antes de la ejecución conservan su configuración previa.
- **El montaje de `NTUSER.DAT` puede fallar** si otra tarea lo tiene bloqueado en ese instante; ese bloque se omite silenciosamente (reintentar más tarde). La colmena se descarga en el `finally` para no dejar el registro bloqueado.
- **No desinstala nada.** Microsoft Store y las aplicaciones preinstaladas siguen ahí; solo se apagan las sugerencias y la pantalla SCOOBE.
- **La directiva de máquina es amplia.** `DisableWindowsConsumerFeatures` suprime el contenido al consumidor para todos los usuarios del equipo — confirma que encaja con tu política de experiencia de usuario.
- **Sin reporte de error duro.** Como el script no tiene código de salida explícito, verifica por los mensajes del log y no solo por el estado que muestra Action1.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../../LICENSE).
