# login — бесшовный вход без SDDM (Plymouth + автологин + hyprlock)

Отдельный **опт-ин** установщик логин-схемы. Лежит вне главного `install.sh`,
потому что трогает **загрузку** (cmdline, UKI, mkinitcpio, bootloader, systemd) —
прогон вслепую на чужой машине может **сломать загрузку**. Читай требования.

## Что это даёт

Убирает чёрный экран после ввода пароля у SDDM. Поток входа:

```
firmware (Lenovo) → меню systemd-boot (3с, можно «e») → статичный yaneart-лого
→ yaneart-сплэш + спиннер (Plymouth) → hyprlock (пароль/отпечаток) → десктоп
```

Нет дисплей-менеджера: на `tty1` автологин, графику поднимает `uwsm start
hyprland.desktop` из `~/.bash_profile`, а первым в сессии — `hyprlock` как гейт.
Plymouth-сплэш удерживается (`--retain-splash`) до самого hyprlock, чтобы между
фазами не моргал голый текстовый VT.

## Требования

| Нужно | Зачем |
|---|---|
| **UKI-схема** (`/boot/EFI/Linux/arch-linux.efi` + mkinitcpio preset) | cmdline и статичный `.splash` вшиваются в UKI |
| **systemd-boot** | `loader.conf timeout` |
| **Intel GPU (i915)** | `MODULES=(i915)` ранний KMS + `i915.fastboot=1`. На другом GPU убери эти флаги |
| **plymouth, hyprland (uwsm), hyprlock** | сама схема |

На не-UKI / не-Intel установщик предупредит на preflight и спросит подтверждение.

## Установка

```bash
cd login
./install-login.sh          # спрашивает перед каждым опасным шагом
./install-login.sh --yes    # без вопросов (ТОЛЬКО на своей машине)
```

После — обязательно `sudo mkinitcpio -P` (установщик предложит сам) и **перезагрузка**.
Ручной машинно-специфичный шаг — порядок загрузки `efibootmgr` (см. вывод скрипта).

## Что лежит в папке

```
etc/
  kernel-cmdline                машинно-специфичный cmdline целиком (РЕФЕРЕНС, не копируется как есть)
  kernel-cmdline-login-flags    только флаги логина — установщик доклеивает их в твой cmdline
  mkinitcpio.conf               референс (hook plymouth после kms, MODULES=i915)
  mkinitcpio.d-linux.preset     референс (default_options=--splash …)
  getty-tty1-autologin.conf     drop-in автологина agetty
  plymouth-quit-override.conf   drop-in: plymouth quit --retain-splash
  loader.conf                   timeout 3
  plymouthd.conf                Theme=yaneart
plymouth-theme-yaneart/         кастомная тема целиком (генерённые картинки + .plymouth + splash bmp)
user/
  wayland-wm-quiet-stderr.conf  stderr компоновщика → journal (а не на VT1)
  bash_profile-login-block.sh   блок автостарта uwsm, дописывается в ~/.bash_profile
install-login.sh
```

`kernel-cmdline` хранится целиком как бэкап, но установщик его **не накатывает**
(там твои `root=PARTUUID=…`, `resume=…`) — он лишь доклеивает флаги из
`kernel-cmdline-login-flags` к уже существующему cmdline.

## ⚠️ Грабли

- **plymouth-quit / plymouth-quit-wait НИКОГДА не маскировать** — `plymouthd`
  держит DRM-мастер (`card1`), Hyprland падает «Device busy» → краш-луп → вечный
  спиннер. Должны быть `static`. Установщик делает `unmask`.
- Обновление `sddm-astronaut-theme` из AUR может пере-`enable` sddm (symlink
  `display-manager.service`). После `yay`, тронувшего sddm, проверь
  `systemctl is-enabled sddm` и при нужде снова `sudo systemctl disable sddm`.
- Накатывать cmdline/preset/mkinitcpio → всегда `sudo mkinitcpio -P` следом.

## Откат к SDDM / штатному входу

```bash
sudo systemctl enable --now sddm                 # вернуть дисплей-менеджер
sudo systemctl revert getty@tty1                 # убрать автологин
# восстановить тронутые файлы из *.bak-prelogin (их кладёт установщик):
sudo cp /etc/mkinitcpio.conf.bak-prelogin        /etc/mkinitcpio.conf
sudo cp /etc/mkinitcpio.d/linux.preset.bak-prelogin /etc/mkinitcpio.d/linux.preset
sudo cp /etc/kernel/cmdline.bak-prelogin         /etc/kernel/cmdline
sudo cp /boot/loader/loader.conf.bak-prelogin    /boot/loader/loader.conf
sudo rm -f /etc/systemd/system/plymouth-quit.service.d/override.conf
sudo plymouth-set-default-theme bgrt             # вернуть фирмварный лого
sudo mkinitcpio -P
# убрать блок автостарта из ~/.bash_profile вручную; удалить
# ~/.config/systemd/user/wayland-wm@.service.d/quiet-stderr.conf
```

Аварийно (вход не поднялся): `Ctrl+Alt+F2` → логин → `sudo systemctl start sddm`.
SDDM специально оставлен установленным как страховка.
