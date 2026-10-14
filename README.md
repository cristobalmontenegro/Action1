# 🖥️ Action1 Scripts

A curated collection of **PowerShell** scripts for endpoint automation, maintenance and management with [Action1](https://www.action1.com/) on Windows fleets. Every script ships with its own **bilingual README** (English / Spanish) documenting what it does, its parameters, its exit codes and its risks before you run it.

**14 scripts · 6 categories** — hand-written for real-world IT operations: cleanup, system repair, software deployment, Windows policies, boot control and custom-attribute reporting.

[Versión en Español abajo](#versión-en-español-es)

---

## 🏗️ Repository layout

Scripts are grouped by **category**, and each script lives in its own subfolder with its own README.

| Category | Purpose | Scripts |
| :--- | :--- | :---: |
| [**boot**](./scripts/boot) | Boot control: BCD, Safe Mode, legacy F8 menu | 2 |
| [**chocolatey**](./scripts/chocolatey) | Software lifecycle with Chocolatey | 2 |
| [**installers**](./scripts/installers) | Install / update specific applications | 3 |
| [**maintenance**](./scripts/maintenance) | Cleanup, diagnostics and system repair | 4 |
| [**policies**](./scripts/policies) | Machine-level registry policies | 2 |
| [**reporting**](./scripts/reporting) | Custom attributes for inventory & reports | 1 |

```
scripts/
└── <category>/
    └── <Script-Name>/
        ├── README.md            # bilingual documentation
        └── <Script-Name>.ps1    # ready to paste into Action1
```

---

## 📦 Available scripts

Everything in this repository, category by category.

<details>
<summary><b>🔧 Maintenance (4)</b></summary>

| Script | What it does | Reboots? |
| :--- | :--- | :---: |
| [**Invoke-GeneralCleanup**](./scripts/maintenance/Invoke-GeneralCleanup) | Safe cleanup: temp files for all users plus broken `.lnk` shortcuts. | No |
| [**Invoke-DeepCleanup**](./scripts/maintenance/Invoke-DeepCleanup) | Deep cleanup (temp by age, WER, shader caches, recycle bin) + deferred DISM via a scheduled task. | No |
| [**Invoke-SystemHealthCheck**](./scripts/maintenance/Invoke-SystemHealthCheck) | Full repair: CHKDSK + DISM `/RestoreHealth` + SFC `/scannow`, then reboot. | **Yes** |
| [**Invoke-DiskCheck**](./scripts/maintenance/Invoke-DiskCheck) | Schedules `chkntfs /c` on every fixed disk and reboots to run it. | **Yes** |

</details>

<details>
<summary><b>⚙️ Chocolatey (2)</b></summary>

| Script | What it does | Reboots? |
| :--- | :--- | :---: |
| [**Action-ChocolateyUpgradeAll**](./scripts/chocolatey/Action-ChocolateyUpgradeAll) | Silently upgrades every Chocolatey-managed package (`choco upgrade all -y`). | No |
| [**Set-CustomAttribute-Chocolatey**](./scripts/chocolatey/Set-CustomAttribute-Chocolatey) | Reports whether Chocolatey is installed as the custom attribute `Chocolatey` (1/0). | No |

</details>

<details>
<summary><b>📦 Installers (3)</b></summary>

| Script | What it does | Reboots? |
| :--- | :--- | :---: |
| [**Install-FluentCleaner**](./scripts/installers/Install-FluentCleaner) | Installs/updates FluentCleaner machine-wide via WinGet, fixes permissions and creates a public shortcut. | No |
| [**Install-FluentTweaker**](./scripts/installers/Install-FluentTweaker) | Downloads and installs the latest FluentTweaker release from GitHub, fixes permissions and creates a public shortcut. | No |
| [**Update-FirmaEC**](./scripts/installers/Update-FirmaEC) | Updates FirmaEC (Ecuador's e-signature client) through its official `--update` if installed. | No |

</details>

<details>
<summary><b>🛡️ Policies (2)</b></summary>

| Script | What it does | Reboots? |
| :--- | :--- | :---: |
| [**Block-MicrosoftAccounts**](./scripts/policies/Block-MicrosoftAccounts) | Blocks Microsoft accounts and disables OneDrive at machine level. | No |
| [**Disable-OOBEConsumerFeatures**](./scripts/policies/Disable-OOBEConsumerFeatures) | Disables OOBE/SCOOBE and consumer suggestions for new users (idempotent). | No |

</details>

<details>
<summary><b>🚀 Boot (2)</b></summary>

| Script | What it does | Reboots? |
| :--- | :--- | :---: |
| [**Enable-LegacyBootMenu**](./scripts/boot/Enable-LegacyBootMenu) | Re-enables the classic F8 boot menu. | No |
| [**Set-SafeModeBoot**](./scripts/boot/Set-SafeModeBoot) | Boots into Safe Mode with networking (persistent) and reboots. | **Yes** |

</details>

<details>
<summary><b>📊 Reporting (1)</b></summary>

| Script | What it does | Reboots? |
| :--- | :--- | :---: |
| [**Set-CustomAttribute-LowDisk**](./scripts/reporting/Set-CustomAttribute-LowDisk) | Flags low free space on `C:` as the custom attribute `LowDisk` (1/0, 30% threshold). | No |

</details>

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
4. Read the **Warnings** section of the script's README (reboots, BCD changes, data deletion).
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

# Versión en Español (ES)

# 🖥️ Action1 Scripts

Una colección curada de scripts **PowerShell** para automatización, mantenimiento y gestión de endpoints con [Action1](https://www.action1.com/) en flotas Windows. Cada script incluye su propio **README bilingüe** (inglés / español) que documenta qué hace, sus parámetros, sus códigos de salida y sus riesgos antes de ejecutarlo.

**14 scripts · 6 categorías** — escritos a mano para operación de TI real: limpieza, reparación del sistema, despliegue de software, políticas de Windows, control de arranque y atributos personalizados para reportes.

---

## 🏗️ Estructura del repositorio

Los scripts se agrupan por **categoría**, y cada script vive en su propia subcarpeta con su propio README.

| Categoría | Propósito | Scripts |
| :--- | :--- | :---: |
| [**boot**](./scripts/boot) | Control de arranque: BCD, Modo Seguro, menú F8 heredado | 2 |
| [**chocolatey**](./scripts/chocolatey) | Ciclo de vida de software con Chocolatey | 2 |
| [**installers**](./scripts/installers) | Instalación / actualización de aplicaciones concretas | 3 |
| [**maintenance**](./scripts/maintenance) | Limpieza, diagnóstico y reparación del sistema | 4 |
| [**policies**](./scripts/policies) | Directivas de registro a nivel de máquina | 2 |
| [**reporting**](./scripts/reporting) | Atributos personalizados para inventario y reportes | 1 |

```
scripts/
└── <categoría>/
    └── <Nombre-Script>/
        ├── README.md            # documentación bilingüe
        └── <Nombre-Script>.ps1  # listo para pegar en Action1
```

---

## 📦 Scripts disponibles

Todo lo que hay en este repositorio, categoría por categoría.

<details>
<summary><b>🔧 Mantenimiento (4)</b></summary>

| Script | Qué hace | ¿Reinicia? |
| :--- | :--- | :---: |
| [**Invoke-GeneralCleanup**](./scripts/maintenance/Invoke-GeneralCleanup) | Limpieza segura: temporales de todos los usuarios y accesos directos `.lnk` rotos. | No |
| [**Invoke-DeepCleanup**](./scripts/maintenance/Invoke-DeepCleanup) | Limpieza profunda (temp por antigüedad, WER, cachés de shaders, papelera) + DISM diferido por tarea programada. | No |
| [**Invoke-SystemHealthCheck**](./scripts/maintenance/Invoke-SystemHealthCheck) | Reparación integral: CHKDSK + DISM `/RestoreHealth` + SFC `/scannow`, y reinicia. | **Sí** |
| [**Invoke-DiskCheck**](./scripts/maintenance/Invoke-DiskCheck) | Programa `chkntfs /c` en todos los discos fijos y reinicia para ejecutarlo. | **Sí** |

</details>

<details>
<summary><b>⚙️ Chocolatey (2)</b></summary>

| Script | Qué hace | ¿Reinicia? |
| :--- | :--- | :---: |
| [**Action-ChocolateyUpgradeAll**](./scripts/chocolatey/Action-ChocolateyUpgradeAll) | Actualiza en silencio todos los paquetes gestionados por Chocolatey (`choco upgrade all -y`). | No |
| [**Set-CustomAttribute-Chocolatey**](./scripts/chocolatey/Set-CustomAttribute-Chocolatey) | Reporta si Chocolatey está instalado como atributo personalizado `Chocolatey` (1/0). | No |

</details>

<details>
<summary><b>📦 Instaladores (3)</b></summary>

| Script | Qué hace | ¿Reinicia? |
| :--- | :--- | :---: |
| [**Install-FluentCleaner**](./scripts/installers/Install-FluentCleaner) | Instala/actualiza FluentCleaner para toda la máquina vía WinGet, corrige permisos y crea acceso directo público. | No |
| [**Install-FluentTweaker**](./scripts/installers/Install-FluentTweaker) | Descarga e instala el último release de FluentTweaker desde GitHub, corrige permisos y crea acceso directo público. | No |
| [**Update-FirmaEC**](./scripts/installers/Update-FirmaEC) | Actualiza FirmaEC (firmador electrónico de Ecuador) con su `--update` oficial si está instalado. | No |

</details>

<details>
<summary><b>🛡️ Políticas (2)</b></summary>

| Script | Qué hace | ¿Reinicia? |
| :--- | :--- | :---: |
| [**Block-MicrosoftAccounts**](./scripts/policies/Block-MicrosoftAccounts) | Bloquea cuentas Microsoft y desactiva OneDrive a nivel de máquina. | No |
| [**Disable-OOBEConsumerFeatures**](./scripts/policies/Disable-OOBEConsumerFeatures) | Desactiva OOBE/SCOOBE y las sugerencias de contenido para usuarios nuevos (idempotente). | No |

</details>

<details>
<summary><b>🚀 Arranque (2)</b></summary>

| Script | Qué hace | ¿Reinicia? |
| :--- | :--- | :---: |
| [**Enable-LegacyBootMenu**](./scripts/boot/Enable-LegacyBootMenu) | Reactiva el menú de arranque clásico (tecla F8). | No |
| [**Set-SafeModeBoot**](./scripts/boot/Set-SafeModeBoot) | Arranca en Modo Seguro con red (persistente) y reinicia. | **Sí** |

</details>

<details>
<summary><b>📊 Reportería (1)</b></summary>

| Script | Qué hace | ¿Reinicia? |
| :--- | :--- | :---: |
| [**Set-CustomAttribute-LowDisk**](./scripts/reporting/Set-CustomAttribute-LowDisk) | Marca el poco espacio libre en `C:` como atributo personalizado `LowDisk` (1/0, umbral 30%). | No |

</details>

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
