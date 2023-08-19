## deck-update-check
When you launch Desktop Mode, this script checks to see if a SteamOS update has happened, and if so, offers (using [notify-send](https://man.archlinux.org/man/notify-send.1.en)) to re-install previously specified pacman packages. (listed in the file `packages-to-install`)

If accepted, it then prompts for a sudo password with [kdesu](https://api.kde.org/frameworks/kdesu/html/index.html), and then attempts the re-install (using `install_pacman_packages.sh`).

If the re-install is successful, it runs `post_update.sh`. Add any commands you want to this file. The file is created on first run (if not already present).

If the re-install fails, it offers to open the log file (`last_update.log`), so you can (hopefully) debug.

### Installation:
1. Clone this repo. (somewhere in /home/deck, or elsewhere that won't get overwritten by SteamOS updates)
2. Add the package names you want to be installed to `packages-to-install`. (if you dont, the file will be created on first run, and populated with 'x11vnc conky')
3. Manually execute `check_if_updated.sh` once to add an entry for the script to KDE's autostart, install/update packages, and create `post_update.sh`.
4. *(Optional)* Update `post_update.sh` to include any additional commands you want run after the packages are re-installed.

Once installed, it will check for SteamOS updates every time desktop mode is launched.

If you need to debug or change the list of packages, run `sudo install_pacman_packages.sh` to skip the SteamOS update checks and directly install everything listed in `packages-to-install`

#### Disclaimer:
Use at your own risk. It works for me, but your mileage may vary.

Good luck, have fun!

#### Shout out:
Thank you to [@muzzol](https://github.com/muzzol) for posting https://gist.github.com/muzzol/f01fa6a3134d2ec90d3eb3e241bf541b, from which `install_pacman_packages.sh` was forked! 