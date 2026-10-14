# Block-MicrosoftAccounts.ps1

> Bloquea el uso de **cuentas Microsoft** (Hotmail/Outlook/Live) y desactiva
> **OneDrive** a nivel de máquina mediante directivas de registro.

| Campo | Valor |
|---|---|
| **Categoría** | Políticas |
| **Archivo** | `Block-MicrosoftAccounts.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No (los cambios aplican a nuevos inicios de sesión) |
| **Nombre original** | `BloquearMicrosoft.ps1` |

## Descripción

Endpoint hardening para entornos corporativos gestionados: impide que los
usuarios vinculen cuentas personales de Microsoft y que OneDrive sincronice
archivos fuera del control de la organización.

## Qué modifica

**Ruta 1 — Cuentas Microsoft**

```
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
  NoConnectedUser = 3 (DWORD)
```

Valor `3` = "Los usuarios no pueden agregar ni iniciar sesión con cuentas
Microsoft".

**Ruta 2 — OneDrive**

```
HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive
  DisableFileSyncNGSC = 1 (DWORD)
```

Desactiva por completo la sincronización de archivos con OneDrive.

El script crea las claves si no existen (`New-Item -Force`) antes de escribir los
valores.

## Parámetros

Ninguno.

## Códigos de salida

| Código | Condición |
|---|---|
| `0` | Directivas aplicadas correctamente |
| `1` | Error al aplicar alguna directiva (detalle en `Write-Error`) |

## Uso en Action1

Política de *baseline* de seguridad. Ejecutar una vez y verificar con un
reporte de cumplimiento. Es idempotente: volver a ejecutarlo no causa daño.

## Advertencias

- Afecta a **todos los usuarios** del equipo.
- Usuarios que ya tenían una cuenta Microsoft vinculada pueden necesitar cerrar
  sesión o reiniciar para que la restricción surta efecto.
- No desinstala OneDrive; si ya estaba en uso, la sincronización se detendrá pero
  los archivos locales permanecen.
- **Revisa que no entre en conflicto con tu estrategia de identidad** (Entra ID /
  Azure AD). Si usas cuentas de trabajo de Microsoft 365, esta directiva es la
  adecuada; si usas otra cosa, valida el impacto antes.

## Cómo revertir

```powershell
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "NoConnectedUser" -Force
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Force
```
