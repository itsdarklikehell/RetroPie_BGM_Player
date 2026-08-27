#!/bin/bash 
#####################################################################
#Project		:	RetroPie_BGM_Player
#Git			:	https://github.com/Naprosnia/RetroPie_BGM_Player
#####################################################################
#Script Name	:	bgm_settoggle.sh
#Date			:	20190222	(YYYYMMDD)
#Description	:	BGM Player toggle setting menu.
#Usage			:	Should be called from bgm_control.sh.
#Author       	:	Luis Torres aka Naprosnia
#####################################################################
#Credits		:	crcerror : https://github.com/crcerror
#####################################################################

BGM="$HOME/RetroPie-BGM-Player"
BGMSETTINGS="$BGM/bgm_settings.ini"
VERSION="$BGM/version.sh"
source $VERSION >/dev/null 2>&1

function description() {
infobox=
infobox="${infobox}___________________________________________________________________________\n\n"
infobox="${infobox}RetroPie BGM Player Toggle\n\n"
infobox="${infobox}Set BGM Player ON/OFF .\n"
infobox="${infobox}___________________________________________________________________________\n\n"

dialog --backtitle "RetroPie BGM Player v.$bgm_version" --title "BGM Toggle Description" --msgbox "${infobox}" 0 0
}
#description

function main_menu() {
    local choice

    while true; do
	
		source $BGMSETTINGS >/dev/null 2>&1
		[ $bgm_toggle -eq 0 ] && status=( "disabled" "Enable" 1 )  || status=( "enabled" "Disable" 0 )
		
        choice=$(dialog --backtitle "RetroPie BGM Player v.$bgm_version" --title "Toggle BGM" \
            --ok-label "Select" --cancel-label "Back" --no-tags \
            --menu "BGM Player is ${status[0]}" 25 75 20 \
            1 "${status[1]} BGM Player" \
            2>&1 > /dev/tty)

        opt=$?
		[ $opt -eq 1 ] && exit
		
		bash $BGM/bgm_system.sh -setsetting bgm_toggle ${status[2]}
		bash $BGM/bgm_system.sh -i
		
    done
}

main_menu