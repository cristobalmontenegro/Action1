# 🛠️ Scripts

[Español abajo](#scripts-1)

**🇬🇧 English**

Index of every script in this repository, organised by category. Each category has its own bilingual README with the table of scripts in that group; every individual script has its own detailed README with the "how to use" steps.

| Category | Scripts | What it covers |
| :--- | :---: | :--- |
| [**boot**](./boot) | 2 | Boot control: BCD changes, Safe Mode, legacy F8 menu. |
| [**chocolatey**](./chocolatey) | 2 | Software lifecycle with Chocolatey: mass upgrade and a presence custom attribute. |
| [**installers**](./installers) | 3 | Install / update specific applications: FluentCleaner (WinGet), FluentTweaker (GitHub), FirmaEC. |
| [**maintenance**](./maintenance) | 4 | Cleanup, diagnostics and system repair: temp files, broken `.lnk`, CHKDSK, SFC, DISM. |
| [**policies**](./policies) | 2 | Machine-level registry policies: block Microsoft accounts + OneDrive, disable OOBE/SCOOBE. |
| [**reporting**](./reporting) | 1 | Inventory custom attributes: `LowDisk` (free-space warning). |
| **Total** | **14** | |

## How to navigate

1. Pick a **category** from the table above and open its `README.md` to see the scripts in that group.
2. Inside the category, open the `README.md` of the **specific script** you want to deploy — it includes requirements, parameters, exit codes, the Action1 deployment steps and the security notes.

## Repository tree

```
scripts/
├── README.md                           ← this file
├── boot/                               ← 2 scripts
│   ├── README.md
│   ├── Enable-LegacyBootMenu/
│   └── Set-SafeModeBoot/
├── chocolatey/                         ← 2 scripts
│   ├── README.md
│   ├── Action-ChocolateyUpgradeAll/
│   └── Set-CustomAttribute-Chocolatey/
├── installers/                         ← 3 scripts
│   ├── README.md
│   ├── Install-FluentCleaner/
│   ├── Install-FluentTweaker/
│   └── Update-FirmaEC/
├── maintenance/                        ← 4 scripts
│   ├── README.md
│   ├── Invoke-GeneralCleanup/
│   ├── Invoke-DeepCleanup/
│   ├── Invoke-DiskCheck/
│   └── Invoke-SystemHealthCheck/
├── policies/                           ← 2 scripts
│   ├── README.md
│   ├── Block-MicrosoftAccounts/
│   └── Disable-OOBEConsumerFeatures/
└── reporting/                          ← 1 script
    ├── README.md
    └── Set-CustomAttribute-LowDisk/
```

---

# 🛠 Scripts

**🇪🇸 Español**

Índice de todos los scripts del repositorio, organizados por categoría. Cada categoría tiene su propio README bilingüe con la tabla de los scripts del grupo; cada script individual tiene su README detallado con los pasos de uso.

| Categoría | Scripts | Qué cubre |
| :--- | :---: | :--- |
| [**boot**](./boot) | 2 | Control de arranque: cambios en la BCD, Modo Seguro, menú F8 heredado. |
| [**chocolatey**](./chocolatey) | 2 | Ciclo de vida de software con Chocolatey: actualización masiva y atributo de presencia. |
| [**installers**](./installers) | 3 | Instalación / actualización de aplicaciones concretas: FluentCleaner (WinGet), FluentTweaker (GitHub), FirmaEC. |
| [**maintenance**](./maintenance) | 4 | Limpieza, diagnóstico y reparación del sistema: temporales, `.lnk` rotos, CHKDSK, SFC, DISM. |
| [**policies**](./policies) | 2 | Directivas de registro a nivel de máquina: bloqueo de cuentas Microsoft + OneDrive, desactivación de OOBE/SCOOBE. |
| [**reporting**](./reporting) | 1 | Atributos personalizados de inventario: `LowDisk` (aviso de poco espacio). |
| **Total** | **14** | |

## Cómo navegar

1. Elige una **categoría** de la tabla de arriba y abre su `README.md` para ver los scripts del grupo.
2. Dentro de la categoría, abre el `README.md` del **script concreto** que quieras desplegar — incluye requisitos, parámetros, códigos de salida, los pasos de despliegue en Action1 y las advertencias de seguridad.

## Árbol del repositorio

```
scripts/
├── README.md                           ← este archivo
├── boot/                               ← 2 scripts
│   ├── README.md
│   ├── Enable-LegacyBootMenu/
│   └── Set-SafeModeBoot/
├── chocolatey/                         ← 2 scripts
│   ├── README.md
│   ├── Action-ChocolateyUpgradeAll/
│   └── Set-CustomAttribute-Chocolatey/
├── installers/                         ← 3 scripts
│   ├── README.md
│   ├── Install-FluentCleaner/
│   ├── Install-FluentTweaker/
│   └── Update-FirmaEC/
├── maintenance/                        ← 4 scripts
│   ├── README.md
│   ├── Invoke-GeneralCleanup/
│   ├── Invoke-DeepCleanup/
│   ├── Invoke-DiskCheck/
│   └── Invoke-SystemHealthCheck/
├── policies/                           ← 2 scripts
│   ├── README.md
│   ├── Block-MicrosoftAccounts/
│   └── Disable-OOBEConsumerFeatures/
└── reporting/                          ← 1 script
    ├── README.md
    └── Set-CustomAttribute-LowDisk/
```

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../LICENSE).
