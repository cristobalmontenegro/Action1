# ✍️ Update FirmaEC

[Español abajo](#actualizar-firmaec)

**🇬🇧 English**

Detects whether **FirmaEC** is installed and runs its official updater (`--update`) when it is; if it is not installed, it does nothing.

| Item | Value |
|---|---|
| **Category** | Installers |
| **Script** | `Update-FirmaEC.ps1` |
| **Context** | `SYSTEM` |
| **Reboot required** | No |
| **Original name** | `actualizaFirmaEC.ps1` |

## Overview (EN)

FirmaEC is the **electronic signature** tool used in Ecuador. This script keeps the client up to date by using the application's own self-update mechanism — it does not download binaries on its own. That makes it safe to deploy broadly: it simply skips any endpoint that does not have FirmaEC installed.

## Requirements (EN)

| Item | Detail |
|---|---|
| **Windows** | 10 / 11 or Server equivalent |
| **Context** | `SYSTEM` (or an elevated account) |
| **PowerShell** | 5.1 (Windows PowerShell) or later |
| **FirmaEC** | Installed in the default location `C:\Program Files\FirmaEC` |
| **Network** | Internet access — the vendor's updater downloads the new version |

## How it works (EN)

1. Verifies that **both** files exist:
   - `C:\Program Files\FirmaEC\jre\bin\java.exe`
   - `C:\Program Files\FirmaEC\firmador-jar-with-dependencies.jar`
2. If they do not exist (FirmaEC not installed) → exits with `0` (skipped, not a failure).
3. If they do, starts:
   ```
   java.exe -jar "firmador-jar-with-dependencies.jar" --update
   ```
   with `Start-Process -Wait -NoNewWindow`, redirecting output to the temporary files `%TEMP%\firmaec_out.log` and `%TEMP%\firmaec_err.log`.
4. Prints the contents of both logs to the Action1 console and deletes them.
5. Evaluates the process `ExitCode` and returns `0` on success, `1` on failure.

## Parameters (EN)

None. The paths are hardcoded for a standard FirmaEC installation; the script reads no arguments.

## Exit codes (EN)

| Code | Condition |
|---|---|
| `0` | Update succeeded **or** FirmaEC is not installed |
| `1` | FirmaEC exited with an error, or the process failed to start (critical Windows error) |

## Step-by-step implementation in Action1 (EN)

1. **Upload** — create a new **PowerShell** script in the Action1 console and paste the contents of `Update-FirmaEC.ps1`.
2. **Schedule** it as an *Intelligent Run* (for example, monthly) across all endpoints — it self-skips where FirmaEC is absent.
3. **Review the execution log** after the first runs; the updater's own output (`firmaec_out.log` / `firmaec_err.log`) is echoed there before being deleted.

## ⚠️ Security notes (EN)

- **Fixed paths.** Only the standard `C:\Program Files\FirmaEC` layout is detected. An endpoint that installed FirmaEC elsewhere is treated as "not installed" and silently skipped.
- **The vendor updater does the download.** `--update` pulls from the manufacturer's servers, so the endpoint needs Internet access and the update path is only as trustworthy as the vendor.
- **Logs in the system `%TEMP%`.** Running as `SYSTEM` writes `%TEMP%\firmaec_out.log` and `%TEMP%\firmaec_err.log`; this is intentional and both files are removed at the end of the run.
- **Exit code `1` is your signal.** A non-zero result means the update failed or the Java process could not be launched — check the log excerpt in the Action1 run output.

---

# ✍ Actualizar FirmaEC

**🇪🇸 Español**

[English above](#update-firmaec)

Detecta si **FirmaEC** está instalado y lanza su actualizador oficial (`--update`) si está presente; si no está instalado, no hace nada.

| Ítem | Valor |
|---|---|
| **Categoría** | Instaladores |
| **Script** | `Update-FirmaEC.ps1` |
| **Contexto** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `actualizaFirmaEC.ps1` |

## Descripción (ES)

FirmaEC es la herramienta de **firma electrónica** usada en Ecuador. Este script mantiene actualizado el cliente usando el mecanismo de autoactualización de la propia aplicación — no descarga binarios por su cuenta. Eso lo hace seguro para desplegar de forma masiva: simplemente se omite en los equipos donde FirmaEC no está instalado.

## Requisitos (ES)

| Ítem | Detalle |
|---|---|
| **Windows** | 10 / 11 o Server equivalente |
| **Contexto** | `SYSTEM` (o una cuenta elevada) |
| **PowerShell** | 5.1 (Windows PowerShell) o superior |
| **FirmaEC** | Instalado en la ubicación estándar `C:\Program Files\FirmaEC` |
| **Red** | Acceso a Internet — el actualizador del fabricante descarga la versión nueva |

## Cómo funciona (ES)

1. Verifica que existan **ambos** archivos:
   - `C:\Program Files\FirmaEC\jre\bin\java.exe`
   - `C:\Program Files\FirmaEC\firmador-jar-with-dependencies.jar`
2. Si no existen (FirmaEC no instalado) → termina con `0` (se omite, no es un fallo).
3. Si existen, lanza:
   ```
   java.exe -jar "firmador-jar-with-dependencies.jar" --update
   ```
   con `Start-Process -Wait -NoNewWindow`, redirigiendo la salida a los archivos temporales `%TEMP%\firmaec_out.log` y `%TEMP%\firmaec_err.log`.
4. Muestra el contenido de ambos logs en la consola de Action1 y los borra.
5. Evalúa el `ExitCode` del proceso y devuelve `0` si tuvo éxito o `1` si falló.

## Parámetros (ES)

Ninguno. Las rutas están codificadas para una instalación estándar de FirmaEC y el script no recibe argumentos.

## Códigos de salida (ES)

| Código | Condición |
|---|---|
| `0` | Actualización correcta **o** FirmaEC no está instalado |
| `1` | FirmaEC terminó con error, o el proceso no pudo iniciarse (error crítico de Windows) |

## Guía de implementación paso a paso en Action1 (ES)

1. **Subir** — crea un script nuevo de tipo **PowerShell** en la consola de Action1 y pega el contenido de `Update-FirmaEC.ps1`.
2. **Programarlo** como *Intelligent Run* (por ejemplo, mensual) en todos los equipos — se auto-omite donde no hay FirmaEC.
3. **Revisar el log de ejecución** tras las primeras corridas; la salida del propio actualizador (`firmaec_out.log` / `firmaec_err.log`) se vuelca ahí antes de borrarse.

## ⚠️ Advertencias (ES)

- **Rutas fijas.** Solo se detecta la instalación estándar en `C:\Program Files\FirmaEC`. Un equipo que tenga FirmaEC en otra ubicación se considerará "no instalado" y se omitirá en silencio.
- **La descarga la hace el actualizador del fabricante.** `--update` baja desde los servidores del fabricante, así que el equipo necesita Internet y la confiabilidad de la actualización depende de ese origen.
- **Logs en el `%TEMP%` del sistema.** Al correr como `SYSTEM` se escriben `%TEMP%\firmaec_out.log` y `%TEMP%\firmaec_err.log`; es intencional y ambos archivos se eliminan al final de la ejecución.
- **El código `1` es tu señal.** Un resultado distinto de cero significa que la actualización falló o que el proceso Java no pudo lanzarse — revisa el extracto del log en la salida de la ejecución de Action1.

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](\./LICENSE/).
