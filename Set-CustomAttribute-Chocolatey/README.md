# 🍫 Chocolatey Installed (Custom Attribute)

[Español abajo](#atributo-personalizado-chocolatey-instalado)

**🇬🇧 English**

Checks whether Chocolatey is installed and publishes the custom attribute **`Chocolatey`** with value `1` (yes) or `0` (no) in Action1.

| Item | Value |
|---|---|
| **Category** | Chocolatey |
| **Script** | `Set-CustomAttribute-Chocolatey.ps1` |
| **Context** | `SYSTEM` — **requires the Action1 agent** (`Action1-Set-CustomAttribute`) |
| **Reboot required** | No |
| **Original name** | `chocolateyinstalado.ps1` |

## Overview (EN)

This is an **inventory** script, not an action script. It feeds an Action1 custom attribute so you can then filter endpoints in reports and deployments (for example: "only machines with Chocolatey").

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM`, **inside the Action1 agent** — the script calls `Action1-Set-CustomAttribute`, which only exists there |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Modules** | None beyond the Action1 agent environment |
| **Action1** | The `Chocolatey` custom attribute must exist (or be created) in the console |

> ⚠️ **Agent-only.** `Action1-Set-CustomAttribute` is provided by the Action1 agent. Run this script locally or in a non-Action1 pipeline and it fails with a "command not found" error.

## How it works (EN)

1. Checks `Get-Command "choco.exe"` (Chocolatey on the `PATH`).
2. Checks `Test-Path "$env:ProgramData\chocolatey\bin\choco.exe"`.
3. If **either** condition is true → `1`; otherwise → `0`.
4. Publishes the result with `Action1-Set-CustomAttribute 'Chocolatey' <value>`.

## Configuration (EN)

| Variable | Default | Description |
|---|---|---|
| `$AttributeName` | `Chocolatey` | Name of the custom attribute written back to Action1 |
| `$Status` | `0` | Working value; set to `1` when Chocolatey is found (not usually edited) |

Edit `$AttributeName` in the script if you want to publish under a different attribute name.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Normal completion — the script never calls `exit`; Action1 reports success when no terminating error occurs |
| non-zero | Only if PowerShell itself aborts, e.g. `Action1-Set-CustomAttribute` is unavailable because the script ran outside the Action1 agent |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Set-CustomAttribute-Chocolatey.ps1`.
2. **Create the attribute** — make sure a `Chocolatey` custom attribute exists in the Action1 settings so the value becomes visible in reports.
3. **Schedule** it as a daily or weekly *Intelligent Run*.
4. **Use it** — build dynamic groups from the attribute and target [`Action-ChocolateyUpgradeAll`](\./Action-ChocolateyUpgradeAll/) only at endpoints where `Chocolatey = 1`.

## ⚠️ Security notes (EN)

- **Read-only.** The script does not modify the system; it only inspects two paths/commands.
- **Requires the Action1 agent.** Outside that context the call to `Action1-Set-CustomAttribute` fails.
- **Attribute must exist.** If the `Chocolatey` attribute is not defined in the Action1 console, the value will not show up in reports even though the script ran.

---

# 🍫 Atributo Personalizado Chocolatey Instalado

**🇪🇸 Español**

[English above](#chocolatey-installed-custom-attribute)

Evalúa si Chocolatey está instalado y publica el atributo personalizado **`Chocolatey`** con valor `1` (sí) o `0` (no) en Action1.

| Ítem | Valor |
|---|---|
| **Categoría** | Chocolatey |
| **Script** | `Set-CustomAttribute-Chocolatey.ps1` |
| **Contexto** | `SYSTEM` — **requiere el agente de Action1** (`Action1-Set-CustomAttribute`) |
| **Requiere reinicio** | No |
| **Nombre original** | `chocolateyinstalado.ps1` |

## Descripción (ES)

Es un script de **inventario**, no de acción. Alimenta un atributo personalizado de Action1 para después poder filtrar equipos en los reportes y en los despliegues (por ejemplo: "solo equipos con Chocolatey").

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM`, **dentro del agente de Action1** — el script llama a `Action1-Set-CustomAttribute`, que solo existe ahí |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Módulos** | Ninguno fuera del entorno del agente de Action1 |
| **Action1** | El atributo personalizado `Chocolatey` debe existir (o crearse) en la consola |

> ⚠️ **Solo con el agente.** `Action1-Set-CustomAttribute` lo provee el agente de Action1. Si ejecutas este script en local o en un pipeline que no sea de Action1, falla con un error de "comando no encontrado".

## Cómo funciona (ES)

1. Verifica `Get-Command "choco.exe"` (Chocolatey en el `PATH`).
2. Verifica `Test-Path "$env:ProgramData\chocolatey\bin\choco.exe"`.
3. Si **cualquiera** de las dos condiciones se cumple → `1`; si no → `0`.
4. Publica el resultado con `Action1-Set-CustomAttribute 'Chocolatey' <valor>`.

## Configuración (ES)

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `$AttributeName` | `Chocolatey` | Nombre del atributo personalizado que se escribe en Action1 |
| `$Status` | `0` | Valor de trabajo; se pone en `1` cuando se encuentra Chocolatey (no suele editarse) |

Edita `$AttributeName` en el script si quieres publicar bajo otro nombre de atributo.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Finalización normal — el script nunca llama a `exit`; Action1 lo reporta como exitoso si no hay un error terminante |
| distinto de cero | Solo si PowerShell aborta, por ejemplo cuando `Action1-Set-CustomAttribute` no está disponible porque el script corrió fuera del agente de Action1 |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Set-CustomAttribute-Chocolatey.ps1`.
2. **Crear el atributo** — asegúrate de que exista un atributo personalizado `Chocolatey` en la configuración de Action1 para que el valor sea visible en los reportes.
3. **Programarlo** como *Intelligent Run* diario o semanal.
4. **Usarlo** — crea grupos dinámicos a partir del atributo y dirige [`Action-ChocolateyUpgradeAll`](\./Action-ChocolateyUpgradeAll/) solo a los equipos donde `Chocolatey = 1`.

## ⚠️ Advertencias (ES)

- **Solo lectura.** El script no modifica el sistema; solo inspecciona dos rutas/comandos.
- **Requiere el agente de Action1.** Fuera de ese contexto la llamada a `Action1-Set-CustomAttribute` falla.
- **El atributo debe existir.** Si el atributo `Chocolatey` no está definido en la consola de Action1, el valor no aparecerá en los reportes aunque el script se haya ejecutado.

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
