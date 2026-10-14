# Maintenance

[Español abajo](#mantenimiento)

Category-level index for the **maintenance** scripts. They keep Windows endpoints clean, healthy and error-free. Two of them **force a reboot**, so read the "Security notes" section of each README before deploying them broadly.

| Script | Cleanup depth | Force reboot? |
| :--- | :--- | :---: |
| [**Invoke-GeneralCleanup**](./Invoke-GeneralCleanup) | Conservative: temp files for every user, broken `.lnk` shortcuts. | No |
| [**Invoke-DeepCleanup**](./Invoke-DeepCleanup) | Aggressive and parameterised: temp by age, WER reports, shader caches, recycle bin, and a **deferred DISM** via a scheduled task. | No |
| [**Invoke-SystemHealthCheck**](./Invoke-SystemHealthCheck) | Repair: `chkntfs` on every fixed disk, `DISM /RestoreHealth` and `SFC /scannow`. | **Yes** (60 s) |
| [**Invoke-DiskCheck**](./Invoke-DiskCheck) | Schedules `chkntfs /c` on every fixed disk. | **Yes** (15 s) |

> **Rollout order that usually works:** `Invoke-GeneralCleanup` weekly → `Invoke-DeepCleanup` monthly → `Invoke-DiskCheck` and `Invoke-SystemHealthCheck` on demand.

---

# Mantenimiento

Índice de la categoría **maintenance**. Mantienen los endpoints Windows limpios, sanos y sin errores. **Dos de ellos fuerzan reinicio**, así que lee la sección de advertencias de cada README antes de desplegarlos de forma masiva.

| Script | Profundidad de limpieza | ¿Forzar reinicio? |
| :--- | :--- | :---: |
| [**Invoke-GeneralCleanup**](./Invoke-GeneralCleanup) | Conservadora: temporales de todos los usuarios, accesos directos `.lnk` rotos. | No |
| [**Invoke-DeepCleanup**](./Invoke-DeepCleanup) | Agresiva y parametrizable: temp por antigüedad, reportes WER, cachés de shaders, papelera, y un **DISM diferido** por tarea programada. | No |
| [**Invoke-SystemHealthCheck**](./Invoke-SystemHealthCheck) | Reparación: `chkntfs` en todos los discos fijos, `DISM /RestoreHealth` y `SFC /scannow`. | **Sí** (60 s) |
| [**Invoke-DiskCheck**](./Invoke-DiskCheck) | Programa `chkntfs /c` en todos los discos fijos. | **Sí** (15 s) |

> **Orden de despliegue habitual:** `Invoke-GeneralCleanup` semanal → `Invoke-DeepCleanup` mensual → `Invoke-DiskCheck` e `Invoke-SystemHealthCheck` bajo demanda.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../LICENSE).
