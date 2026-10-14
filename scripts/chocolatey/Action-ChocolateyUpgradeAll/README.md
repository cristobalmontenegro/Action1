# Action-ChocolateyUpgradeAll.ps1

> Actualiza **todo** el software gestionado por Chocolatey en el equipo con un
> único comando silencioso (`choco upgrade all -y`).

| Campo | Valor |
|---|---|
| **Categoría** | Chocolatey |
| **Archivo** | `Action-ChocolateyUpgradeAll.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `actualizacioneschoco.ps1` |

## Descripción

Pensado para mantenimiento periódico. Ejecuta la actualización completa del
catálogo de Chocolatey sin interacción del usuario, registrando el resultado en
el log de ejecución de Action1.

## Comportamiento

1. **Detecta el ejecutable de Chocolatey** en dos pasos:
   - Primero intenta `Get-Command "choco.exe"` (busca en el `PATH`).
   - Si falla, comprueba el fallback `%ProgramData%\chocolatey\bin\choco.exe`.
2. Si encuentra el ejecutable, ejecuta `choco upgrade all -y`.
3. Si no lo encuentra, escribe un error y termina con código `1` para que Action1
   marque la ejecución como **fallida (roja)**.

## Parámetros

Ninguno.

## Códigos de salida

| Código | Condición |
|---|---|
| `0` | Actualización ejecutada sin excepción |
| `1` | Chocolatey no está instalado, o falló la ejecución |

> Nota: el script no valida el `$LASTEXITCODE` de `choco`. Un `choco` que devuelva
> código distinto de cero por un paquete puntual **no** marcará el script como
> fallido.

## Uso en Action1

Asignar a una política de mantenimiento mensual. Combínalo con
[`Set-CustomAttribute-Chocolatey`](../Set-CustomAttribute-Chocolatey/) para saber
de antemano qué equipos tienen Chocolatey y filtrar el despliegue.

## Advertencias

- No reinicia ni fuerza cierres, pero algunas actualizaciones pueden requerir
  reinicio posterior para surtir efecto.
- Requiere **conectividad a Internet** y acceso a los repositorios de Chocolatey.
- Si el equipo tiene una licencia de Chocolatey de pago, el comportamiento del
  comando puede variar según la configuración del cliente.
