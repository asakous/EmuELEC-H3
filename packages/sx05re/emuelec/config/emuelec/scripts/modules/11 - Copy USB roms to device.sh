#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

ROMFILE="emuelec_copy_roms_from_here"
source /emuelec/scripts/env.sh
rp_registerAllModules

joy2keyStart

function copy_from_where() {
FULLPATHTOROMS="$(find /media/*/roms/ -name ${ROMFILE} -maxdepth 1 | head -n 1)"

if [[ -z "${FULLPATHTOROMS}" ]]; then
	ROMSNOTFOUND="yes"
else
	ROMSNOTFOUND="no"
	PATHTOROMS=${FULLPATHTOROMS%$ROMFILE}
fi 

echo $PATHTOROMS
}

ROMFOLDER=$(copy_from_where)

function copy_confirm() {
if [ -z "${ROMFOLDER}" ]; then 
	dialog --ascii-lines --colors --no-collapse --ok-label "Close" --msgbox "No USB media with the file \"${ROMFILE}\" is connected! Did you create the file? \n\n You need to create a file named \n\n \"${ROMFILE}\" (NO EXTENSION!)\n\n in the USB:/roms folder before runing this script! " 22 65 >&1
	exit 1
fi
	     if dialog --ascii-lines --yesno "This will copy all files from \"${ROMFOLDER}\", to \"/storage/roms\" on the device. MAKE SURE YOU HAVE ENOUGH SPACE IN YOUR DEVICE! \n\n WARNING: Existing files in \"/storage/roms\" with the same name will be overwriten, NO BACKUP WILL BE CREATED! are you sure you want to continue?"  22 76 >/dev/tty; then
		copy_roms
      fi
 }

function copy_roms() {
	# Sanity checks
	[[ -L "/storage/roms" ]] && rm /storage/roms
	[[ -d /storage/roms2 ]] && mv /storage/roms2 /storage/roms
	[[ ! -d /storage/roms ]] && mkdir -p /storage/roms
	# End sanity
	
	cp -rfv ${ROMFOLDER}* /storage/roms
	
	# Clean up
	[[ -f /storage/roms/${ROMFILE} ]] && rm /storage/roms/${ROMFILE}
	[[ -f /storage/roms/emuelecroms ]] && rm /storage/roms/emuelecroms
	echo "Finished"
	read -n 1 -s -r -p "Press any key to continue"
	
if dialog --ascii-lines --yesno "Copy finished! Remove the USB media from the device and press OK to restart ES, cancel will return to ES without restarting!" 22 65 >&1; then
	systemctl restart emustation
fi
}

copy_confirm
