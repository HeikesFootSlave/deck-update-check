#!/bin/bash

# check if we're on a new SteamOS release, and if so, prompt to update!

INSTALL_DIR="/home/deck/code/deck-update-check"

PREVIOUS_OS_RELEASE=$(cat "${INSTALL_DIR}"/.last_steamos_release)
CURRENT_OS_RELEASE=$(grep "ID" /etc/os-release)

if [[ "${PREVIOUS_OS_RELEASE}" = "${CURRENT_OS_RELEASE}" ]]; then
    echo "release ids unchanged, assuming no update. exiting.";
    exit 0;
else
    echo "release ids changed. Prompting for permission to update...";

    NOTIFY_PROMPT=$(notify-send -t 60000 -u 'critical' -i 'update-high' -a 'System Update' --action=CONFIRM='Ok!' --action=DENY='No.' 'It looks like a SteamOS Update happened. Do you want to update installed pacman packages?');
    if [[ ${NOTIFY_PROMPT} == "CONFIRM" ]]; then
    	echo "Running pacman update...";

    	# make kdesu use sudo instead of su so we dont have to set a pw for root
    	if [[ ! -f "/home/deck/.config/kdesurc" ]]; then
    		echo "[super-user-command]" > /home/deck/.config/kdesurc;
    		echo "super-user-command=sudo" >> /home/deck/.config/kdesurc;
		fi

		# create post_update.sh if it doesn't aready exist
    	if [[ ! -f "${INSTALL_DIR}/post_update.sh" ]]; then
    		echo "!#/bin/bash" > "${INSTALL_DIR}/post_update.sh";
    		echo "#insert post-update commands here" >> "${INSTALL_DIR}/post_update.sh";
		fi
        
        # run the script that actually does the update
		if kdesu -n -t -i 'update-high' "${INSTALL_DIR}/install_pacman_packages.sh"; then
			echo 'pacman update succeeded!'
		    notify-send -i emblem-success -a 'System Update' "pacman update successful!"
		    # save current release info to a file so we can compare next time
		    echo "${CURRENT_OS_RELEASE}" > "${INSTALL_DIR}"/.last_steamos_release;
		    "${INSTALL_DIR}"/post_update.sh;
		    exit 0;
		else # yikes something went wrong
			echo 'pacman update failed!'

			# notify about the failure, and offer to open the log file
		    FAILURE_NOTICE=$(notify-send -i emblem-error -a 'System Update' --action=LOG='View log file' "pacman update failed!")
		    if [[ ${FAILURE_NOTICE} == "LOG" ]]; then
		    	kde-open ${INSTALL_DIR}/last_update.log;
		    fi
		    exit 1;
		fi
    else
    	echo "Update Declined. exiting.";
    	exit 0;
    fi
fi
