# Enable-LegacyBootMenu.ps1

> Reactiva el **menú de arranque clásico de Windows** para poder usar la tecla
> **F8** (Opciones de arranque avanzadas) al encender.

| Campo | Valor |
|---|---|
| **Categoría** | Arranque |
| **Archivo** | `Enable-LegacyBootMenu.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | No (aplica al próximo arranque) |
| **Nombre original** | `reactivarF8.ps1` |

## Descripción

En Windows 8/10/11 el menú clásico de F8 está deshabilitado por defecto (el
arranque es demasiado rápido para alcanzarlo). Este script lo vuelve a habilitar,
lo que resulta útil para soporte técnico y recuperación en sitio.

## Comportamiento

Ejecuta:

```
bcdedit /set {default} bootmenupolicy legacy
```

Luego verifica `$LASTEXITCODE` y reporta éxito o advertencia.

## Parámetros

Ninguno.

## Códigos de salida

| Código | Condición |
|---|---|
| `0` | Política aplicada (`bcdedit` devolvió 0) |
| `1` | `bcdedit` falló |

## Uso en Action1

Útil como preparación previa a tareas de soporte en sitio, o como parte de una
política de "modo recuperación". Combínalo con
[`Set-SafeModeBoot`](../Set-SafeModeBoot/) cuando necesites acceso al arranque.

## Advertencias

- Añade unos segundos al tiempo de arranque (aparece el menú de arranque).
- Requiere privilegios elevados / `SYSTEM` para modificar el BCD.
- Es un cambio de configuración de arranque: valida que sea compatible con tu
  política de seguridad antes de desplegarlo masivamente.

## Cómo revertir

```powershell
bcdedit /set {default} bootmenupolicy standard
```
