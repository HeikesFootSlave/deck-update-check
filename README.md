## deck-update-check

This script checks to see if a SteamOS update has happened (by looking at `/etc/os-release`), and if so, offers to update pacman packages. (on first run, it will assume an update has happened, and offer to update)

It then prompts for a sudo password with [kdesu](https://api.kde.org/frameworks/kdesu/html/index.html), then attempts the update.

If the update is successful, it then runs `post_update.sh`. Add any commands you want to this file. (start docker containers, conky, whatever)

If the update fails, it offers to open a log file that contains the output of the `pacman -Sy --noconfirm --overwrite '*' ${PACKAGES}` command it tried to run, so you can hopefully debug.

Uses [notify-send](https://man.archlinux.org/man/notify-send.1.en) to prompt for confirmation to do the update, report success or failure, and ask if you want to see the log.

the update log is saved to `last_update.log`.

the SteamOS release info is saved to `.last_steamos_release`.

### Installation:
1. clone this repo.
2. add the packages you want installed to `./packages-to-install`. (if you dont, this file will be created on first run, and poplulated with 'x11vnc conky')
3. run `check_if_updated.sh` to verify functionality
4. add any post-update commands you want to `post_update.sh`. (created on first run of `./check_if_updated.sh`, if not already present)
5. Add `check_if_updated.sh` to autostart in KDE. (open start menu, type 'autostart', click +add, browse to wherever you cloned this repo, click `check_if_updated.sh`)


#### Disclaimer:
Use at your own risk. It works for me, but your milage may vary.

Good luck, Have fun!

#### Shout out:
Thank you to [@muzzol](https://github.com/muzzol) for https://gist.github.com/muzzol/f01fa6a3134d2ec90d3eb3e241bf541b, from which `install_pacman_packages.sh` was forked!