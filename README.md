## deck-update-check
This script checks to see if a SteamOS update has happened, and if so, it offers (using a system notification modal from [notify-send](https://man.archlinux.org/man/notify-send.1.en)) to re-install previously specified pacman packages.

If accepted, it then prompts for a sudo password with [kdesu](https://api.kde.org/frameworks/kdesu/html/index.html), and then attempts the re-install.

If the re-install is successful, it then runs `post_update.sh`. Add any commands you want to this file. (start docker containers, conky, whatever). This file is created on first run (if not already present).

If the re-install fails, it offers to open a log file that contains the output of `install_pacman_packages.sh`, so you can (hopefully) debug.

The pacman update log from `install_pacman_packages.sh` is saved to `last_update.log`.
The SteamOS release info is saved to `.last_steamos_release`.

### Installation:
1. Clone this repo. (somewhere in /home/deck, or elsewhere that won't get overwritten by SteamOS updates)
2. Add the package names you want to be installed to `packages-to-install`. (if you dont, this file will be created on first run, and populated with 'x11vnc conky')
3. Execute `check_if_updated.sh` to add an entry for the script to KDE's autostart, install/update packages, and create `post_update.sh`.
4. *(Optional)* Update `post_update.sh` to include any additional commands you want run after the packages are re-installed.

Once installed, it will check for SteamOS updates every time desktop mode is launched.

#### Disclaimer:
Use at your own risk. It works for me, but your mileage may vary.

Good luck, Have fun!

#### Shout out:
Thank you to [@muzzol](https://github.com/muzzol) for posting https://gist.github.com/muzzol/f01fa6a3134d2ec90d3eb3e241bf541b, from which `install_pacman_packages.sh` was forked! 