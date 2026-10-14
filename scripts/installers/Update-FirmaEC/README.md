# Update-FirmaEC.ps1

> Detecta la instalación de **FirmaEC** y lanza su actualizador oficial
> (`--update`) si está presente; si no está instalado, no hace nada.

| Campo | Valor |
|---|---|
| **Categoría** | Instaladores |
| **Archivo** | `Update-FirmaEC.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `actualizaFirmaEC.ps1` |

## Descripción

FirmaEC es la herramienta de **firma electrónica** usada en Ecuador. Este script
mantiene actualizado el cliente usando el mecanismo de autoactualización que ya
trae la aplicación (no descarga binarios por su cuenta).

## Comportamiento

1. Verifica que existan **ambos** archivos:
   - `C:\Program Files\FirmaEC\jre\bin\java.exe`
   - `C:\Program Files\FirmaEC\firmador-jar-with-dependencies.jar`
2. Si **no** están (FirmaEC no instalado) → termina con código `0` (se omite, no
   es un fallo).
3. Si están, ejecuta:
   ```
   java.exe -jar "firmador-jar-with-dependencies.jar" --update
   ```
   redirigiendo la salida a archivos temporales
   (`%TEMP%\firmaec_out.log` y `%TEMP%\firmaec_err.log`).
4. Muestra el contenido de esos logs en la consola de Action1 y los borra.
5. Evalúa el `ExitCode` del proceso.

## Parámetros

Ninguno. Las rutas están codificadas para una instalación estándar de FirmaEC.

## Códigos de salida

| Código | Condición |
|---|---|
| `0` | Actualización correcta **o** FirmaEC no está instalado |
| `1` | FirmaEC terminó con error, o falló el lanzamiento del proceso |

## Logs

Se generan y se eliminan en la misma ejecución:
`%TEMP%\firmaec_out.log` y `%TEMP%\firmaec_err.log`. El contenido se vuelca al
log de ejecución de Action1.

## Uso en Action1

Programar como *Intelligent Run* (p. ej. mensual) sobre todos los equipos. Es
seguro desplegarlo de forma masiva porque se auto-omite donde no aplica.

## Advertencias

- Las **rutas son fijas** para una instalación estándar en `C:\Program Files\FirmaEC`.
  Si un equipo la tiene en otra ubicación, el script la considerará "no instalada".
- La actualización la realiza el propio `--update` de FirmaEC, que descarga desde
  los servidores del fabricante; requiere conectividad a Internet.
- Ejecutar en contexto `SYSTEM` escribe logs en el `%TEMP%` del sistema; es
  intencional y se limpian al final.
