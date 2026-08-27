#!/bin/bash 
#####################################################################
#Project		:	RetroPie_BGM_Player
#Git			:	https://github.com/Naprosnia/RetroPie_BGM_Player
#####################################################################
#Script Name	:	bgm_generatem3u.sh
#Date			:	20190222	(YYYYMMDD)
#Description	:	BGM Player m3u generator for emulator player
#Usage			:	Should be called from bgm_control.sh.
#Author       	:	Luis Torres aka Naprosnia
#####################################################################
#Credits		:	crcerror : https://github.com/crcerror
#####################################################################

BGM="$HOME/RetroPie-BGM-Player"
VERSION="$BGM/version.sh"
source $VERSION >/dev/null 2>&1



function main_menu() {
	
	infobox=
	infobox="${infobox}___________________________________________________________________________\n\n"
	infobox="${infobox}RetroPie BGM Player Reload Audio Files\n\n"
	infobox="${infobox}If you add new audio files, you need to reload them.\n\n"
	infobox="${infobox}The files are reloaded automatically when system start/restart, or using\n"
	infobox="${infobox}this menu.\n\n"
	infobox="${infobox}Do you want to reload audio files?\n"
	infobox="${infobox}___________________________________________________________________________\n\n"

	dialog --backtitle "RetroPie BGM Player v.$bgm_version" --title "BGM Reload Audio Files" --ok-label "Reload" --cancel-label "Back" --yesno "${infobox}" 0 0
	
	opt=$?
	[ $opt -eq 1 ] && exit

	bash $BGM/bgm_system.sh -reload
	sleep 0.5
	bash $BGM/bgm_system.sh -i
	reloaded

}

function reloaded(){
	infobox=
	infobox="${infobox}___________________________________________________________________________\n\n"
	infobox="${infobox}RetroPie BGM Player Reload Audio Files\n\n"
	infobox="${infobox}Audio files reloaded.\n\n"
	infobox="${infobox}___________________________________________________________________________\n\n"

	dialog --backtitle "RetroPie BGM Player v.$bgm_version" --title "BGM Reload Audio Files" --msgbox "${infobox}" 0 0
	
	exit
}

main_menu