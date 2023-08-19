#!/bin/bash

# script for installing pacman packages on Steam Deck
# ATENTION: USE IT AT YOUR OWN RISK!!!!
#
# this will modify root filesystem so it will probably get
# overwrite on system updates but is totally ok executing
# it several times, so if something stops working just
# launch it again

# thanks to àngel "mussol" bosch - muzzol@gmail.com for https://gist.github.com/muzzol/f01fa6a3134d2ec90d3eb3e241bf541b, the original basis for this script

PACKAGES="x11vnc conky"

# make sure we're root...
echo -n "Checking permissions: "
if [[ "$(id -ru || true)" == "0" ]]; then
    echo "OK"
else # exit 1 if not
    echo "ERROR!";
    echo "this script must be executed by root"
    echo "Ex: sudo $0"
    exit 1
fi

## system related comands
echo "Disabling readonly filesystem"
steamos-readonly disable

# add a symlink so visudo will work (not that we actually need it now, since using kdesu)
if [[ ! -f "/usr/bin/vi" ]]; then
    echo "creating symlink /usr/bin/vim -> /usr/bin/vi for visudo";
    ln -s /usr/bin/vim /usr/bin/vi
fi

# set up the keyring if it doesn't exist already
if [[ ! -e "/etc/pacman.d/gnupg/trustdb.gpg" ]]; then
    echo "Initalizing pacman keys"
    pacman-key --init
    pacman-key --populate archlinux
fi

echo "Installing packages"
pacman -Sy --noconfirm --overwrite '*' ${PACKAGES}

echo "Re-enabling readonly filesystem"
steamos-readonly enable

echo "Done"