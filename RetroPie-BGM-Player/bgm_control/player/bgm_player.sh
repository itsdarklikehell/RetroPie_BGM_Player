#!/bin/bash 
#####################################################################
#Project		:	RetroPie_BGM_Player
#Git			:	https://github.com/Naprosnia/RetroPie_BGM_Player
#####################################################################
#Script Name	:	bgm_player.sh
#Date			:	20190222	(YYYYMMDD)
#Description	:	BGM Players settings.
#Usage			:	Should be called from RetroPie\ BGM\ Player.sh.
#Author       	:	Luis Torres aka Naprosnia
#####################################################################
#Credits		:	crcerror : https://github.com/crcerror
#####################################################################

BGM="$HOME/RetroPie-BGM-Player"
BGMCONTROL="$BGM/bgm_control"
BGMCONTROLPLAYER="$BGMCONTROL/player"
VERSION="$BGM/version.sh"
source $VERSION >/dev/null 2>&1

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "RetroPie BGM Player v.$bgm_version" --title "Player Settings" \
            --ok-label "Select" --cancel-label "Back" --no-tags \
            --menu "Settings" 25 75 20 \
			"bgm_reloadaudio" "1 Reload Audio Files" \
            2>&1 > /dev/tty)
		
		opt=$?
		[ $opt -eq 1 ] && exit
		
        bash $BGMCONTROLPLAYER/$choice.sh
		
    done
}

main_menu

