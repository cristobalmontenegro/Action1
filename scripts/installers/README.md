# Installers

[Español abajo](#instaladores)

Category-level index for the **installers** scripts. They install or update specific third-party applications on a managed Windows machine. All three target a real-world need we keep hitting when provisioning endpoints: cleaning utilities, system tweaks and the Ecuadorian e-signature client.

| Script | App | What it does |
| :--- | :--- | :--- |
| [**Install-FluentCleaner**](./Install-FluentCleaner) | **FluentCleaner** (`Builtbybel.FluentCleaner`) | Installs/updates machine-wide via **WinGet**, fixes NTFS permissions and creates a public desktop shortcut. |
| [**Install-FluentTweaker**](./Install-FluentTweaker) | **FluentTweaker** (`builtbybel/FluentTweaker`) | Downloads the latest release from **GitHub** (TLS 1.2 + GitHub API), installs to `%ProgramFiles%`, fixes permissions and creates a public shortcut. |
| [**Update-FirmaEC**](./Update-FirmaEC) | **FirmaEC** (Ecuador's e-signature client) | Triggers the official `java -jar … --update` of FirmaEC **only if it is installed**; no-op otherwise. |

---

# Instaladores

Índice de la categoría **installers**. Instalan o actualizan aplicaciones concretas de terceros en un equipo Windows gestionado. Los tres atacan una necesidad real al aprovisionar endpoints: utilidades de limpieza, ajustes del sistema y el firmador electrónico de Ecuador.

| Script | App | Qué hace |
| :--- | :--- | :--- |
| [**Install-FluentCleaner**](./Install-FluentCleaner) | **FluentCleaner** (`Builtbybel.FluentCleaner`) | Instala/actualiza para toda la máquina vía **WinGet**, corrige permisos NTFS y crea acceso directo público. |
| [**Install-FluentTweaker**](./Install-FluentTweaker) | **FluentTweaker** (`builtbybel/FluentTweaker`) | Descarga el último release desde **GitHub** (TLS 1.2 + GitHub API), instala en `%ProgramFiles%`, corrige permisos y crea acceso directo público. |
| [**Update-FirmaEC**](./Update-FirmaEC) | **FirmaEC** (firmador electrónico de Ecuador) | Lanza el `java -jar … --update` oficial de FirmaEC **solo si está instalado**; si no, no hace nada. |

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../LICENSE).
