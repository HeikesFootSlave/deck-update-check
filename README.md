## deck-update-check

This script checks to see if a SteamOS update has happened, and if so, offers to update pacman packages. (on first run, it will assume an update has happened, and offer to update)

It then prompts for a sudo password, then attempts the update.

If the update is successful, it then runs `post_update.sh`. Add any commands you want to this file (start docker containers, conky, whatever)

If the update fails, it opens a log file that contains the output of the `pacman -Sy --noconfirm --overwrite '*' ${PACKAGES}` command it tried to run, so you can hopefully debug.

### Installation:

1. clone this repo
2. add the packages you want installed to $PACKAGES in `install_pacman_packages.sh` 
3. Add `check_if_updated.sh` to autostart (open start menu, type 'autostart', click +add, browse to wherever you cloned this repo, click `check_if_updated.sh`)


#### Disclaimer

Use at your own risk. It works for me, but no promises! have fun!

Thank you to @muzzol for https://gist.github.com/muzzol/f01fa6a3134d2ec90d3eb3e241bf541b, on which `install_pacman_packages.sh` is based