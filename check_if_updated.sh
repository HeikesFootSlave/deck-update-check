#!/usr/bin/env bash

# check if we're on a new SteamOS release, and if so, prompt to update installed pacman packages!

INSTALL_DIR=$(dirname "$0");

PREVIOUS_OS_RELEASE=$(cat "${INSTALL_DIR}"/.last_steamos_release);
CURRENT_OS_RELEASE=$(grep "ID" /etc/os-release);

DECK_USER=$(grep "^User=" /etc/sddm.conf.d/steamos.conf | cut -d"=" -f2)

if [[ "${PREVIOUS_OS_RELEASE}" = "${CURRENT_OS_RELEASE}" ]]; then
    echo "release ids unchanged, assuming no update. exiting.";
    exit 0;
else
    echo "release ids changed. Prompting for permission to update...";

    NOTIFY_PROMPT=$(notify-send -t 60000 -u 'critical' -i 'update-high' -a 'System Update' --action=CONFIRM='Ok!' --action=DENY='No.' 'It looks like a SteamOS Update happened. Do you want to re-install pacman packages?');
    if [[ ${NOTIFY_PROMPT} == "CONFIRM" ]]; then

    	# make kdesu use sudo instead of su so we dont have to set a pw for root
    	if [[ ! -f "/home/deck/.config/kdesurc" ]]; then
    		echo "[super-user-command]" > /home/deck/.config/kdesurc;
    		echo "super-user-command=sudo" >> /home/deck/.config/kdesurc;
		fi;

		# create post_update.sh if it doesn't aready exist
    	if [[ ! -f "${INSTALL_DIR}/post_update.sh" ]]; then
    		echo "#!/bin/bash" > "${INSTALL_DIR}/post_update.sh";
    		echo "echo 'running post-update script...';" >> "${INSTALL_DIR}/post_update.sh"
    		echo "#insert post-update commands here" >> "${INSTALL_DIR}/post_update.sh";
    		chmod +x "${INSTALL_DIR}/post_update.sh";
		fi;

		# populate ./packages-to-install if it doesn't exist yet
    	if [[ ! -f "${INSTALL_DIR}/packages-to-install" ]]; then
    		echo "x11vnc conky" > "${INSTALL_DIR}/packages-to-install";
		fi;

		# add an entry to ~/.config/autostart to run when KDE starts, if not already present
		if [[ ! -f "/home/${DECK_USER}/.config/autostart/check_if_updated.sh.desktop" ]]; then
    		echo "installing autostart entry...";
    		touch "/home/${DECK_USER}/.config/autostart/check_if_updated.sh.desktop";
    		{
				echo '[Desktop Entry]';
				echo 'Comment[en_US]=';
				echo 'Comment=';
				echo "Exec=${INSTALL_DIR}/check_if_updated.sh";
				echo 'GenericName[en_US]=Re-install pacman packages when a new SteamOS release is detected';
				echo 'GenericName=Re-install pacman packages when a new SteamOS release is detected';
				echo 'Icon=update-none';
				echo 'MimeType=';
				echo 'Name[en_US]=pacman update';
				echo 'Name=pacman update';
				echo 'Path=';
				echo 'StartupNotify=true';
				echo 'Terminal=false';
				echo 'TerminalOptions=';
				echo 'Type=Application';
				echo 'X-DBUS-ServiceName=';
				echo 'X-DBUS-StartupType=';
				echo 'X-KDE-SubstituteUID=false';
				echo 'X-KDE-Username=';
			} >> /home/${DECK_USER}/.config/autostart/check_if_updated.sh.desktop
		fi;

		echo "Running pacman update...";
        
        # run the script that actually does the update
		if kdesu -n -t -i 'update-high' "${INSTALL_DIR}/install_pacman_packages.sh" | tee ${INSTALL_DIR}/last_update.log; then
			echo 'pacman update succeeded!';
		    notify-send -i emblem-success -a 'System Update' "pacman update successful!"

		    # save current release info to a file so we can compare next time
		    echo "${CURRENT_OS_RELEASE}" > "${INSTALL_DIR}"/.last_steamos_release;
		    "${INSTALL_DIR}"/post_update.sh;
		    exit 0;
		else # yikes, something went wrong
			echo 'pacman update failed!';

			# notify about the failure, and offer to open the log file
		    FAILURE_NOTICE=$(notify-send -i emblem-error -a 'System Update' --action=LOG='View log file' "pacman update failed!");
		    if [[ ${FAILURE_NOTICE} == "LOG" ]]; then
		    	konsole --hold -e "cat ${INSTALL_DIR}/last_update.log" &
		    fi;
		    exit 1;
		fi;
    else
    	echo "Update Declined. exiting.";
    	exit 0;
    fi;
fi;
