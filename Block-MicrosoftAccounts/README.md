# 🚫 Block Microsoft Accounts and OneDrive

[Español abajo](#bloquear-cuentas-microsoft-y-onedrive)

**🇬🇧 English**

Blocks the use of **Microsoft accounts** (Hotmail/Outlook/Live) and disables **OneDrive** file sync machine-wide through registry-based policies.

| Item | Value |
|---|---|
| **Category** | Policies |
| **Script** | `Block-MicrosoftAccounts.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No — changes apply to new sign-ins |
| **Original name** | `BloquearMicrosoft.ps1` |

## Overview (EN)

Endpoint hardening for managed corporate fleets: it stops users from linking personal Microsoft accounts and stops OneDrive from syncing files outside the organisation's control. Both settings are machine-level (HKLM) policies, so they apply to every account on the endpoint and to accounts created afterwards.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent (editions with the Group Policy registry nodes) |
| **Context** | `SYSTEM` or elevated Administrator — writing under `HKLM` requires elevation |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None |
| **Network** | Not required |

## How it works (EN)

**Policy 1 — Microsoft accounts**

```
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
  NoConnectedUser = 3 (DWORD)
```

Value `3` means *"Users cannot add or log on with Microsoft accounts"*.

**Policy 2 — OneDrive**

```
HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive
  DisableFileSyncNGSC = 1 (DWORD)
```

This turns off OneDrive file sync entirely.

The script creates each key first if it is missing (`New-Item -Force`) and then writes the value with `Set-ItemProperty ... -Force -ErrorAction Stop`, all inside a `try/catch`. On success it prints `ÉXITO: Cuentas Microsoft y OneDrive fueron desactivados desde la raíz.` and returns `0`; on failure it writes the error and returns `1`.

> **How to revert.** Delete the two values and reboot (or sign out and back in):
> ```powershell
> Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Force
> Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Force
> ```

## Parameters (EN)

None. The registry paths and values are hardcoded in the script.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Both policies applied successfully (explicit `exit 0`) |
| `1` | An error occurred while applying either policy (detail in `Write-Error`, explicit `exit 1`) |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Block-MicrosoftAccounts.ps1`.
2. **Context** — run as `SYSTEM`.
3. **Security baseline policy** — attach it to the baseline policy for managed endpoints and run it once on each machine, then schedule a periodic re-check for compliance reporting. The script is idempotent, so re-running causes no harm.
4. **Report** — use a compliance report or a custom attribute to confirm `NoConnectedUser = 3` and `DisableFileSyncNGSC = 1` on the fleet.
5. **Revert if needed** — see the *How to revert* block above.

## ⚠️ Security notes (EN)

- **Applies to all users** of the machine, including administrators.
- **Existing Microsoft accounts** may require a sign-out or reboot before the restriction takes effect.
- **OneDrive is not uninstalled.** If it was already in use, syncing stops but local files remain on disk; the OneDrive client may also display errors when the user tries to sign in.
- **Check your identity strategy first.** This policy is the right call if you standardise on Microsoft 365 *work* accounts; if you use another identity model (or Entra ID-joined devices with a different sync strategy), validate the impact before rolling it out.
- **Strong user impact.** Removed access to personal accounts is deliberately visible to end users — communicate the change beforehand.

---

# 🚫 Bloquear Cuentas Microsoft y OneDrive

**🇪🇸 Español**

Bloquea el uso de **cuentas Microsoft** (Hotmail/Outlook/Live) y desactiva la sincronización de **OneDrive** a nivel de máquina mediante directivas de registro.

| Ítem | Valor |
|---|---|
| **Categoría** | Políticas |
| **Script** | `Block-MicrosoftAccounts.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No — los cambios aplican a nuevos inicios de sesión |
| **Nombre original** | `BloquearMicrosoft.ps1` |

## Descripción (ES)

Endpoint hardening para parques corporativos gestionados: impide que los usuarios vinculen cuentas personales de Microsoft y que OneDrive sincronice archivos fuera del control de la organización. Ambas son directivas a nivel de máquina (HKLM), así que aplican a todas las cuentas del equipo y también a las que se creen después.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente (ediciones con los nodos de registro de directiva de grupo) |
| **Contexto** | `SYSTEM` o Administrador elevado — escribir en `HKLM` exige elevación |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno |
| **Red** | No se necesita |

## Cómo funciona (ES)

**Directiva 1 — Cuentas Microsoft**

```
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
  NoConnectedUser = 3 (DWORD)
```

El valor `3` significa *"Los usuarios no pueden agregar ni iniciar sesión con cuentas Microsoft"*.

**Directiva 2 — OneDrive**

```
HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive
  DisableFileSyncNGSC = 1 (DWORD)
```

Desactiva por completo la sincronización de archivos con OneDrive.

El script crea primero cada clave si no existe (`New-Item -Force`) y después escribe el valor con `Set-ItemProperty ... -Force -ErrorAction Stop`, todo dentro de un `try/catch`. Si sale bien imprime `ÉXITO: Cuentas Microsoft y OneDrive fueron desactivados desde la raíz.` y devuelve `0`; si falla, escribe el error y devuelve `1`.

> **Cómo revertir.** Borra los dos valores y reinicia (o cierra y vuelve a iniciar sesión):
> ```powershell
> Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Force
> Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Force
> ```

## Parámetros (ES)

Ninguno. Las rutas y los valores de registro están fijos en el script.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Ambas directivas aplicadas correctamente (`exit 0` explícito) |
| `1` | Ocurrió un error al aplicar alguna directiva (detalle en `Write-Error`, `exit 1` explícito) |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Block-MicrosoftAccounts.ps1`.
2. **Contexto** — ejecútalo como `SYSTEM`.
3. **Política de baseline de seguridad** — asígnalo a la política base de los equipos gestionados, ejecútalo una vez por máquina y programa una reverificación periódica para el reporte de cumplimiento. El script es idempotente, así que volver a ejecutarlo no causa daño.
4. **Reportar** — usa un reporte de cumplimiento o un atributo personalizado para confirmar `NoConnectedUser = 3` y `DisableFileSyncNGSC = 1` en el parque.
5. **Revertir si hace falta** — ver el bloque *Cómo revertir* arriba.

## ⚠️ Advertencias (ES)

- **Afecta a todos los usuarios** del equipo, incluidos los administradores.
- Las **cuentas Microsoft ya vinculadas** pueden necesitar cerrar sesión o reiniciar para que la restricción surta efecto.
- **OneDrive no se desinstala.** Si ya estaba en uso, la sincronización se detiene pero los archivos locales permanecen en disco; además el cliente de OneDrive puede mostrar errores cuando el usuario intente iniciar sesión.
- **Revisa antes tu estrategia de identidad.** Esta directiva es la adecuada si estandarizas con cuentas de *trabajo* de Microsoft 365; si usas otro modelo de identidad (o equipos unidos a Entra ID con otra estrategia de sincronización), valida el impacto antes de desplegarla.
- **Impacto fuerte en el usuario.** La pérdida de acceso a cuentas personales es visible a propósito — comunica el cambio con antelación.

---

---

## ☕ Support me / Apóyame

**EN:** If any of this was useful, you can buy me a coffee. Thanks for the support!

**ES:** Si te resultó útil, puedes invitarme un café. ¡Gracias por el apoyo!

<p align="center">
  <a href="https://ko-fi.com/cristobalmontenegro" target="_blank">
    <img height="36" style="border:0px;height:36px;" src="https://storage.ko-fi.com/cdn/kofi6.png?v=6" border="0" alt="Buy Me a Coffee at ko-fi.com" />
  </a>
</p>

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](\./LICENSE/).
