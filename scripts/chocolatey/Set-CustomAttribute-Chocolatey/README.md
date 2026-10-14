# Set-CustomAttribute-Chocolatey.ps1

> Evalúa si Chocolatey está instalado y publica el atributo personalizado
> **`Chocolatey`** con valor `1` (sí) o `0` (no) en Action1.

| Campo | Valor |
|---|---|
| **Categoría** | Chocolatey / Reporting |
| **Archivo** | `Set-CustomAttribute-Chocolatey.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No |
| **Nombre original** | `chocolateyinstalado.ps1` |

## Descripción

Script de **inventario**, no de acción. Se usa para poblar un atributo
personalizado de Action1 y luego poder filtrar endpoints en los reportes y en los
despliegues (por ejemplo: "solo equipos con Chocolatey").

## Comportamiento

1. Verifica `Get-Command "choco.exe"` (Chocolatey en el `PATH`).
2. Verifica `Test-Path "$env:ProgramData\chocolatey\bin\choco.exe"`.
3. Si **cualquiera** de las dos condiciones se cumple → `1`; si no → `0`.
4. Publica el resultado con `Action1-Set-CustomAttribute 'Chocolatey' <valor>`.

## Requisito especial

> ⚠️ Utiliza la función **`Action1-Set-CustomAttribute`**, que **solo existe dentro
> del agente de Action1**. Fuera de él el script fallará. No lo ejecutes con
> PowerShell local ni en un pipeline que no sea de Action1.

## Parámetros

Ninguno. El nombre del atributo (`Chocolatey`) está codificado en el script; si
quieres cambiarlo, edita la variable `$AttributeName`.

## Uso en Action1

Programar como *Intelligent Run* diario o semanal. Con el atributo poblado puedes
crear grupos dinámicos y dirigir [`Action-ChocolateyUpgradeAll`](../Action-ChocolateyUpgradeAll/)
solo a los equipos que lo tengan instalado.

## Advertencias

- No modifica el sistema; es de solo lectura.
- El atributo `Chocolatey` debe existir (o crearse) en la configuración de
  atributos personalizados de Action1 para que el valor sea visible en reportes.
