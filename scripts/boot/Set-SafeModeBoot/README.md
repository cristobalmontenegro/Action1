# Set-SafeModeBoot.ps1

> Configura el equipo para arrancar en **Modo Seguro con funciones de red** y
> reinicia de inmediato.

| Campo | Valor |
|---|---|
| **Categoría** | Arranque |
| **Archivo** | `Set-SafeModeBoot.ps1` |
| **Contexto recomendado** | `SYSTEM` |
| **Requiere reinicio** | **Sí** (automático, 5 s) |
| **Nombre original** | `forzarreinicioseguro.ps1` |

## Descripción

Fuerza el arranque en Modo Seguro con red. Pensado para tareas de diagnóstico y
desinfección que requieren un entorno mínimo de Windows.

## Comportamiento

1. Ejecuta `bcdedit /set '{current}' safeboot network`.
2. Reinicia en 5 segundos con `shutdown /r /t 5 /f`.

## Parámetros

Ninguno.

## Códigos de salida

Siempre `0`.

## ⚠️ Advertencias — LEER ANTES DE USAR

- **Es persistente.** El equipo seguirá arrancando en Modo Seguro en **cada**
  reinicio hasta que se revierta el cambio. No es un arranque puntual.
- **Reinicia en 5 segundos** con cierre forzado: el usuario pierde trabajo no
  guardado y no puede cancelarlo.
- En Modo Seguro muchos servicios no arrancan; el agente de Action1 puede quedar
  **sin conectividad** hasta que se salga del modo seguro. Un error de despliegue
  puede dejar el equipo fuera de gestión.

## Cómo salir del Modo Seguro (obligatorio después de usarlo)

Ejecutar en el equipo:

```powershell
bcdedit /deletevalue '{current}' safeboot
```

o desde la consola de recuperación:

```
bcdedit /deletevalue {current} safeboot
```

Recomendación: preparar y desplegar **primero** el script de reversión antes de
usar este.

## Uso en Action1

Desplegar **solo** a endpoints concretos y con el script de reversión listo.
Nunca como política masiva automática.
