# 🖥️ Action1 Scripts

**🇬🇧 English**

A curated collection of **14 PowerShell** scripts for endpoint automation, maintenance and management with [Action1](https://www.action1.com/) on Windows fleets. Every script ships with its own **bilingual README** (English / Spanish) documenting what it does, its parameters, its exit codes and its risks before you run it.

[Versión en Español abajo](#versión-en-español)

---

## 📦 The 14 scripts

| # | Script | Category | What it does | Reboots? |
|:--:|:---|:---|:---|:--:|
| 1 | [**Set-SafeModeBoot**](./Set-SafeModeBoot) | 🚀 Boot | Forces the next boot into **Safe Mode with networking** and reboots in 5 s. | **Yes** |
| 2 | [**Enable-LegacyBootMenu**](./Enable-LegacyBootMenu) | 🚀 Boot | Re-enables the classic **F8 boot menu** for startup recovery options. | No |
| 3 | [**Action-ChocolateyUpgradeAll**](./Action-ChocolateyUpgradeAll) | 🍫 Chocolatey | Silently upgrades every Chocolatey-managed package with `choco upgrade all -y`. | No |
| 4 | [**Set-CustomAttribute-Chocolatey**](./Set-CustomAttribute-Chocolatey) | 🍫 Chocolatey | Reports whether Chocolatey is installed as the custom attribute `Chocolatey` (1/0). | No |
| 5 | [**Install-FluentCleaner**](./Install-FluentCleaner) | 📦 Installers | Installs/updates FluentCleaner machine-wide via **WinGet** + public desktop shortcut. | No |
| 6 | [**Install-FluentTweaker**](./Install-FluentTweaker) | 📦 Installers | Downloads and installs the latest FluentTweaker release from **GitHub** + public shortcut. | No |
| 7 | [**Update-FirmaEC**](./Update-FirmaEC) | 📦 Installers | Updates **FirmaEC** (Ecuador's e-signature client) via its official `--update`. | No |
| 8 | [**Invoke-GeneralCleanup**](./Invoke-GeneralCleanup) | 🔧 Maintenance | Safe cleanup: temp files for every user plus broken `.lnk` shortcuts. | No |
| 9 | [**Invoke-DeepCleanup**](./Invoke-DeepCleanup) | 🔧 Maintenance | Deep cleanup (temp by age, WER, shader caches, recycle bin) + deferred DISM. | No |
| 10 | [**Invoke-SystemHealthCheck**](./Invoke-SystemHealthCheck) | 🔧 Maintenance | CHKDSK + DISM `/RestoreHealth` + SFC `/scannow`, then reboot. | **Yes** |
| 11 | [**Invoke-DiskCheck**](./Invoke-DiskCheck) | 🔧 Maintenance | Schedules `chkntfs /c` on every fixed disk and reboots. | **Yes** |
| 12 | [**Block-MicrosoftAccounts**](./Block-MicrosoftAccounts) | 🛡️ Policies | Blocks Microsoft accounts and disables OneDrive at machine level. | No |
| 13 | [**Disable-OOBEConsumerFeatures**](./Disable-OOBEConsumerFeatures) | 🛡️ Policies | Disables OOBE/SCOOBE and consumer suggestions for new users (idempotent). | No |
| 14 | [**Set-CustomAttribute-LowDisk**](./Set-CustomAttribute-LowDisk) | 💾 Reporting | Flags low free space on `C:` as the custom attribute `LowDisk` (1/0, 30% threshold). | No |

---

## 🗂️ The 6 categories

| Category | Scripts | Covers |
|:---|:--:|:---|
| 🚀 **Boot** | 2 | Boot Configuration Data (BCD): Safe Mode, F8 legacy menu. Persistent changes — read the Security notes. |
| 🍫 **Chocolatey** | 2 | Software lifecycle with Chocolatey: mass upgrade + a presence custom attribute. |
| 📦 **Installers** | 3 | Install / update specific applications: FluentCleaner (WinGet), FluentTweaker (GitHub), FirmaEC. |
| 🔧 **Maintenance** | 4 | Cleanup, diagnostics and system repair: temp files, broken `.lnk`, CHKDSK, SFC, DISM. |
| 🛡️ **Policies** | 2 | Machine-level registry policies: block Microsoft accounts + OneDrive, disable OOBE/SCOOBE. |
| 💾 **Reporting** | 1 | Inventory custom attributes: `LowDisk` (free-space warning). |

### Rollout order that usually works

- **🍫 Chocolatey weekly:** `Action-ChocolateyUpgradeAll` (mass upgrade) + `Set-CustomAttribute-Chocolatey` (to know who has it).
- **🔧 Maintenance weekly:** `Invoke-GeneralCleanup` (safe, non-destructive).
- **🔧 Maintenance monthly:** `Invoke-DeepCleanup` (aggressive, parametrised).
- **🚀 Boot, 🛡️ Policies, 📦 Installers:** one-off baseline + as needed.
- **🛠️ On demand:** `Invoke-DiskCheck` and `Invoke-SystemHealthCheck` for the endpoints that actually need them.

---

## 🛠️ Global requirements

| Item | Detail |
| :--- | :--- |
| **Action1** | An installed agent on a managed endpoint |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **Context** | Most scripts expect `SYSTEM` (the Action1 agent default) |
| **Modules** | Built-in Windows modules only. No external dependencies except where a script states otherwise (Chocolatey, WinGet) |

> Scripts that call `Action1-Set-CustomAttribute` **must** run from the Action1 agent: that function is injected by the agent itself and does not exist outside of it.

## 📥 How to deploy a script in Action1

1. Open the Action1 console → **Scripts** (or the *Runbook* you want to use it in).
2. Create a new **PowerShell** script.
3. Paste the contents of `<Script-Name>.ps1` into the editor.
4. Read the **Security notes** section of the script's README (reboots, BCD changes, data deletion).
5. Test on a **single endpoint** before rolling it out through a policy.
6. For recurring runs, attach it to a policy with *Intelligent Run* (only runs when the machine is out of compliance) or a fixed schedule.

### Exit codes

The scripts follow the Action1 convention:

| Code | Meaning |
| :---: | :--- |
| `0` | Success (green in the execution report) |
| `1` | Failure (red in the execution report) |

---

## ⚠️ Security notes

These scripts intentionally modify the system. Before a mass rollout, keep in mind:

- **Forced reboots** — `Invoke-SystemHealthCheck`, `Invoke-DiskCheck` and `Set-SafeModeBoot` shut the machine down without warning the user.
- **Boot (BCD) changes** — `Set-SafeModeBoot` leaves the machine persistently booting into Safe Mode until it is reverted. Read the script's README to learn how to exit.
- **Data deletion** — `Invoke-GeneralCleanup` and `Invoke-DeepCleanup` delete files. `Invoke-DeepCleanup` empties the recycle bin by default.
- **Registry policies** — `Block-MicrosoftAccounts` and `Disable-OOBEConsumerFeatures` apply machine policies that affect every user on the machine.

Always test in a controlled environment before production.

---

## ☕ Support me / Apóyame

**EN:** If any of these scripts saved you time, you can buy me a coffee. Thanks for the support!

**ES:** Si alguno de estos scripts te ahorró tiempo, puedes invitarme un café. ¡Gracias por el apoyo!

<p align="center">
  <a href="https://ko-fi.com/cristobalmontenegro" target="_blank">
    <img height="36" style="border:0px;height:36px;" src="https://storage.ko-fi.com/cdn/kofi6.png?v=6" border="0" alt="Buy Me a Coffee at ko-fi.com" />
  </a>
</p>

---

## 👤 Author

**Cristóbal Montenegro**
IT Automation & Software Development
GitHub: [@cristobalmontenegro](https://github.com/cristobalmontenegro)

## 📜 License

This project is licensed under the MIT License — see the [`LICENSE`](./LICENSE) file for details.

---

# 🇪🇸 Versión en Español

# 🖥️ Action1 Scripts

**🇪🇸 Español**

Una colección curada de **14 scripts PowerShell** para automatización, mantenimiento y gestión de endpoints con [Action1](https://www.action1.com/) en flotas Windows. Cada script incluye su propio **README bilingüe** (inglés / español) que documenta qué hace, sus parámetros, sus códigos de salida y sus riesgos antes de ejecutarlo.

---

## 📦 Los 14 scripts

| # | Script | Categoría | Qué hace | ¿Reinicia? |
|:-:|:---|:---|:---|:-:|
| 1 | [**Set-SafeModeBoot**](./Set-SafeModeBoot) | 🚀 Arranque | Fuerza el siguiente arranque en **Modo Seguro con red** y reinicia en 5 s. | **Sí** |
| 2 | [**Enable-LegacyBootMenu**](./Enable-LegacyBootMenu) | 🚀 Arranque | Reactiva el **menú F8 clásico** para acceder a opciones de recuperación al arrancar. | No |
| 3 | [**Action-ChocolateyUpgradeAll**](./Action-ChocolateyUpgradeAll) | 🍫 Chocolatey | Actualiza en silencio todos los paquetes gestionados con `choco upgrade all -y`. | No |
| 4 | [**Set-CustomAttribute-Chocolatey**](./Set-CustomAttribute-Chocolatey) | 🍫 Chocolatey | Reporta si Chocolatey está instalado como atributo personalizado `Chocolatey` (1/0). | No |
| 5 | [**Install-FluentCleaner**](./Install-FluentCleaner) | 📦 Instaladores | Instala/actualiza FluentCleaner para toda la máquina vía **WinGet** + acceso directo público. | No |
| 6 | [**Install-FluentTweaker**](./Install-FluentTweaker) | 📦 Instaladores | Descarga e instala el último release de FluentTweaker desde **GitHub** + acceso directo público. | No |
| 7 | [**Update-FirmaEC**](./Update-FirmaEC) | 📦 Instaladores | Actualiza **FirmaEC** (firmador electrónico de Ecuador) con su `--update` oficial. | No |
| 8 | [**Invoke-GeneralCleanup**](./Invoke-GeneralCleanup) | 🔧 Mantenimiento | Limpieza segura: temporales de todos los usuarios y `.lnk` rotos. | No |
| 9 | [**Invoke-DeepCleanup**](./Invoke-DeepCleanup) | 🔧 Mantenimiento | Limpieza profunda (temp por antigüedad, WER, cachés de shaders, papelera) + DISM diferido. | No |
| 10 | [**Invoke-SystemHealthCheck**](./Invoke-SystemHealthCheck) | 🔧 Mantenimiento | CHKDSK + DISM `/RestoreHealth` + SFC `/scannow`, y reinicia. | **Sí** |
| 11 | [**Invoke-DiskCheck**](./Invoke-DiskCheck) | 🔧 Mantenimiento | Programa `chkntfs /c` en todos los discos fijos y reinicia. | **Sí** |
| 12 | [**Block-MicrosoftAccounts**](./Block-MicrosoftAccounts) | 🛡️ Políticas | Bloquea cuentas Microsoft y desactiva OneDrive a nivel de máquina. | No |
| 13 | [**Disable-OOBEConsumerFeatures**](./Disable-OOBEConsumerFeatures) | 🛡️ Políticas | Desactiva OOBE/SCOOBE y las sugerencias de contenido para usuarios nuevos (idempotente). | No |
| 14 | [**Set-CustomAttribute-LowDisk**](./Set-CustomAttribute-LowDisk) | 💾 Reportes | Marca el poco espacio libre en `C:` como atributo personalizado `LowDisk` (1/0, umbral 30%). | No |

---

## 🗂️ Las 6 categorías

| Categoría | Scripts | Qué cubre |
|:---|:--:|:---|
| 🚀 **Arranque** | 2 | BCD (Boot Configuration Data): Modo Seguro, menú F8 heredado. Cambios persistentes — lee las advertencias de seguridad. |
| 🍫 **Chocolatey** | 2 | Ciclo de vida de software con Chocolatey: actualización masiva + atributo de presencia. |
| 📦 **Instaladores** | 3 | Instalación / actualización de aplicaciones concretas: FluentCleaner (WinGet), FluentTweaker (GitHub), FirmaEC. |
| 🔧 **Mantenimiento** | 4 | Limpieza, diagnóstico y reparación del sistema: temporales, `.lnk` rotos, CHKDSK, SFC, DISM. |
| 🛡️ **Políticas** | 2 | Directivas de registro a nivel de máquina: bloqueo de cuentas Microsoft + OneDrive, desactivación de OOBE/SCOOBE. |
| 💾 **Reportes** | 1 | Atributos personalizados de inventario: `LowDisk` (aviso de poco espacio). |

### Orden de despliegue habitual

- **🍫 Chocolatey semanal:** `Action-ChocolateyUpgradeAll` (actualización masiva) + `Set-CustomAttribute-Chocolatey` (para saber quién lo tiene).
- **🔧 Mantenimiento semanal:** `Invoke-GeneralCleanup` (seguro, no destructivo).
- **🔧 Mantenimiento mensual:** `Invoke-DeepCleanup` (agresivo, parametrizable).
- **🚀 Arranque, 🛡️ Políticas, 📦 Instaladores:** línea base única + según necesidad.
- **🛠️ Bajo demanda:** `Invoke-DiskCheck` e `Invoke-SystemHealthCheck` solo para los equipos que realmente lo necesitan.

---

## 🛠️ Requisitos globales

| Ítem | Detalle |
| :--- | :--- |
| **Action1** | Agente instalado en un endpoint gestionado |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Contexto** | La mayoría de scripts esperan `SYSTEM` (predeterminado del agente Action1) |
| **Módulos** | Solo módulos integrados de Windows. Sin dependencias externas salvo donde el script lo indique (Chocolatey, WinGet) |

> Los scripts que usan `Action1-Set-CustomAttribute` **deben** ejecutarse desde el agente de Action1: esa función la inyecta el propio agente y no existe fuera de él.

## 📥 Cómo desplegar un script en Action1

1. Abre la consola de Action1 → **Scripts** (o el *Runbook* donde quieras usarlo).
2. Crea un script nuevo de tipo **PowerShell**.
3. Pega el contenido de `<Nombre-Script>.ps1` en el editor.
4. Lee la sección **Advertencias** del README del script (reinicios, cambios de BCD, borrado de datos).
5. Prueba en **un solo equipo** antes de desplegarlo por política.
6. Para ejecuciones periódicas, asígnalo a una política con *Intelligent Run* (solo se ejecuta si el equipo no cumple la condición) o a una programación fija.

### Códigos de salida

Los scripts siguen la convención de Action1:

| Código | Significado |
| :---: | :--- |
| `0` | Éxito (verde en el reporte de ejecución) |
| `1` | Fallo (rojo en el reporte de ejecución) |

---

## ⚠️ Advertencias de seguridad

Estos scripts modifican el sistema de forma intencional. Antes de un despliegue masivo, ten en cuenta:

- **Reinicios forzados** — `Invoke-SystemHealthCheck`, `Invoke-DiskCheck` y `Set-SafeModeBoot` apagan el equipo sin avisar al usuario.
- **Cambios en el arranque (BCD)** — `Set-SafeModeBoot` deja el equipo arrancando en Modo Seguro de forma persistente hasta que se revierta. Lee el README del script para saber cómo salir.
- **Borrado de datos** — `Invoke-GeneralCleanup` y `Invoke-DeepCleanup` eliminan archivos. `Invoke-DeepCleanup` vacía la papelera de reciclaje por defecto.
- **Directivas de registro** — `Block-MicrosoftAccounts` y `Disable-OOBEConsumerFeatures` aplican políticas de máquina que afectan a todos los usuarios.

Prueba siempre en un entorno controlado antes de producción.

---

## 👤 Autor

**Cristóbal Montenegro**
Automatización de TI y desarrollo de software
GitHub: [@cristobalmontenegro](https://github.com/cristobalmontenegro)

## 📜 Licencia

Este proyecto se distribuye bajo la licencia MIT — ver el archivo [`LICENSE`](./LICENSE) para más detalles.
