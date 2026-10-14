# 🛡️ Policies

[Español abajo](#políticas)

**🇬🇧 English**

Category-level index for the **policies** scripts. They apply **machine-level registry policies** under `HKLM` (and, where relevant, the default user profile) to harden the endpoint. Both are **idempotent** and safe to re-run.

| Script | What it does | Registry path | Affects new users? |
| :--- | :--- | :--- | :---: |
| [**Block-MicrosoftAccounts**](./Block-MicrosoftAccounts) | Blocks Microsoft accounts (`NoConnectedUser = 3`) and disables OneDrive (`DisableFileSyncNGSC = 1`). | `HKLM\SOFTWARE\…\Policies\System` and `…\Policies\Microsoft\Windows\OneDrive` | No |
| [**Disable-OOBEConsumerFeatures**](./Disable-OOBEConsumerFeatures) | Disables the OOBE/SCOOBE "Finish setting up" screen and Microsoft's content suggestions in the default user profile. | `HKLM\…\CloudContent` and `HKU\DefaultUser\…` | **Yes** |

---

# 🛡 Políticas

**🇪🇸 Español**

Índice de la categoría **policies**. Aplican **directivas de registro a nivel de máquina** bajo `HKLM` (y, cuando aplica, el perfil de usuario por defecto) para endurecer el endpoint. Ambos son **idempotentes** y seguros de re-ejecutar.

| Script | Qué hace | Ruta de registro | ¿Afecta usuarios nuevos? |
| :--- | :--- | :--- | :---: |
| [**Block-MicrosoftAccounts**](./Block-MicrosoftAccounts) | Bloquea cuentas Microsoft (`NoConnectedUser = 3`) y desactiva OneDrive (`DisableFileSyncNGSC = 1`). | `HKLM\SOFTWARE\…\Policies\System` y `…\Policies\Microsoft\Windows\OneDrive` | No |
| [**Disable-OOBEConsumerFeatures**](./Disable-OOBEConsumerFeatures) | Desactiva la pantalla OOBE/SCOOBE "Terminar de configurar" y las sugerencias de contenido de Microsoft en el perfil por defecto. | `HKLM\…\CloudContent` y `HKU\DefaultUser\…` | **Sí** |

---

## 👤 Author / Autoría

**Cristóbal Montenegro** — https://github.com/cristobalmontenegro

## 📜 License / Licencia

MIT — see [`LICENSE`](../../LICENSE).
