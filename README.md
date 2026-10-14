# Action1 Scripts

Colección de scripts **PowerShell** para automatización, mantenimiento y gestión
de endpoints con [Action1](https://www.action1.com/) en entornos Windows.

Cada script vive en su propia carpeta con un `README.md` que documenta qué hace,
qué parámetros acepta, qué salidas genera y qué riesgos tiene antes de ejecutarlo.

---

## Tabla de scripts

| Script | Categoría | Qué hace | ¿Reinicia? |
|---|---|---|---|
| [`Action-ChocolateyUpgradeAll`](scripts/chocolatey/Action-ChocolateyUpgradeAll/) | Chocolatey | Actualiza todo el software gestionado por `choco upgrade all -y` | No |
| [`Set-CustomAttribute-Chocolatey`](scripts/chocolatey/Set-CustomAttribute-Chocolatey/) | Chocolatey | Marca el atributo `Chocolatey` = 1/0 según si está instalado | No |
| [`Set-CustomAttribute-LowDisk`](scripts/reporting/Set-CustomAttribute-LowDisk/) | Reporting | Marca `LowDisk` = 1 si el disco `C:` tiene ≤ 30 % libre | No |
| [`Invoke-GeneralCleanup`](scripts/maintenance/Invoke-GeneralCleanup/) | Mantenimiento | Borra temporales de todos los usuarios y accesos directos `.lnk` rotos | No |
| [`Invoke-DeepCleanup`](scripts/maintenance/Invoke-DeepCleanup/) | Mantenimiento | Limpieza profunda (temp, WER, cachés de shaders, papelera) + DISM diferido | No |
| [`Invoke-SystemHealthCheck`](scripts/maintenance/Invoke-SystemHealthCheck/) | Mantenimiento | CHKDSK + DISM `/RestoreHealth` + SFC `/scannow` | **Sí** |
| [`Invoke-DiskCheck`](scripts/maintenance/Invoke-DiskCheck/) | Mantenimiento | Programa `chkntfs /c` en todos los discos y reinicia | **Sí** |
| [`Block-MicrosoftAccounts`](scripts/policies/Block-MicrosoftAccounts/) | Políticas | Bloquea cuentas Microsoft y OneDrive por directiva de máquina | No |
| [`Disable-OOBEConsumerFeatures`](scripts/policies/Disable-OOBEConsumerFeatures/) | Políticas | Desactiva OOBE/SCOOBE y sugerencias de contenido para usuarios nuevos | No |
| [`Set-SafeModeBoot`](scripts/boot/Set-SafeModeBoot/) | Arranque | Configura arranque en Modo Seguro con red y reinicia | **Sí** |
| [`Enable-LegacyBootMenu`](scripts/boot/Enable-LegacyBootMenu/) | Arranque | Reactiva el menú de arranque clásico (tecla F8) | No |
| [`Install-FluentCleaner`](scripts/installers/Install-FluentCleaner/) | Instaladores | Instala/actualiza FluentCleaner vía WinGet (+ acceso directo público) | No |
| [`Install-FluentTweaker`](scripts/installers/Install-FluentTweaker/) | Instaladores | Descarga e instala el último release de FluentTweaker desde GitHub | No |
| [`Update-FirmaEC`](scripts/installers/Update-FirmaEC/) | Instaladores | Actualiza FirmaEC (firma electrónica Ecuador) si está instalado | No |

---

## Estructura del repositorio

```
.
├── LICENSE
├── README.md
└── scripts/
    ├── boot/            # Control del arranque (BCD, modo seguro, menú F8)
    ├── chocolatey/      # Gestión de software con Chocolatey
    ├── installers/      # Instalación y actualización de aplicaciones
    ├── maintenance/     # Limpieza, diagnóstico y reparación del sistema
    ├── policies/        # Directivas de registro a nivel de máquina
    └── reporting/       # Atributos personalizados para inventario/reportes
        └── <Script-Name>/
            ├── README.md
            └── <Script-Name>.ps1
```

Cada carpeta de script sigue el mismo patrón:

```
<Script-Name>/
├── README.md            # Documentación del script
└── <Script-Name>.ps1    # Script listo para subir a Action1
```

---

## Requisitos generales

| Requisito | Detalle |
|---|---|
| **Action1** | Agente instalado y endpoint gestionado |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **Contexto** | La mayoría requiere ejecutarse como `SYSTEM` (el predeterminado del agente Action1) |
| **Módulos** | Solo módulos integrados de Windows. Sin dependencias externas salvo donde el script indique lo contrario (Chocolatey, WinGet) |

> Los scripts que usan la función `Action1-Set-CustomAttribute` **deben** ejecutarse
> desde el agente de Action1: esa función la inyecta el propio agente y no existe
> fuera de él.

---

## Cómo usar un script en Action1

1. Abre la consola de Action1 → **Scripts** (o el *Runbook* donde quieras usarlo).
2. Crea un script nuevo de tipo **PowerShell**.
3. Copia el contenido de `<Script-Name>.ps1` en el editor.
4. Revisa la sección **Advertencias** del `README.md` del script (reinicios, cambios de BCD, borrado de datos).
5. Prueba primero en **un solo endpoint** antes de desplegarlo por política.
6. Para ejecución periódica, asígnalo a una política con *Intelligent Run* (solo se
   ejecuta si el equipo no cumple con la condición) o a un *schedule* fijo.

### Códigos de salida

Se sigue la convención de Action1:

| Código | Significado |
|---|---|
| `0` | Éxito (verde en el reporte de ejecución) |
| `1` | Fallo (rojo en el reporte de ejecución) |

---

## Advertencias de seguridad

Estos scripts modifican el sistema de forma intencional. Antes de desplegarlos
de forma masiva, ten en cuenta:

- **Reinicios forzados** — `Invoke-SystemHealthCheck`, `Invoke-DiskCheck` y
  `Set-SafeModeBoot` apagan el equipo sin avisar al usuario.
- **Cambios en el arranque (BCD)** — `Set-SafeModeBoot` deja el equipo arrancando
  en Modo Seguro de forma persistente hasta que se revierta. Lee el README del
  script para saber cómo salir.
- **Borrado de datos** — `Invoke-GeneralCleanup` y `Invoke-DeepCleanup` eliminan
  archivos. `Invoke-DeepCleanup` vacía la papelera de reciclaje por defecto.
- **Directivas de registro** — `Block-MicrosoftAccounts` y
  `Disable-OOBEConsumerFeatures` aplican políticas de máquina que afectan a todos
  los usuarios.

Prueba siempre en un entorno controlado antes de producción.

---

## Licencia

Distribuido bajo licencia [MIT](LICENSE).
