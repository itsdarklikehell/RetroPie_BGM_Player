#!/bin/bash 
#####################################################################
#Project		:	RetroPie_BGM_Player
#Version		:	2.0
#Git			:	https://github.com/Naprosnia/RetroPie_BGM_Player
#####################################################################
#Script Name	:	install.sh
#Date			:	20190224	(YYYYMMDD)
#Description	:	The installation script.
#Usage			:	wget -N https://raw.githubusercontent.com/Naprosnia/RetroPie_BGM_Player/master/install.sh
#				:	chmod +x install.sh
#				:	bash install.sh
#Author       	:	Luis Torres aka Naprosnia
#####################################################################
#Credits		:	crcerror : https://github.com/crcerror
#####################################################################

clear
echo -e "####################################"
echo -e "#  Installing RetroPie_BGM_Player  #"
echo -e "####################################\n"


BGMGITBRANCH="master"
RP="$HOME/RetroPie"
RPMENU="$RP/retropiemenu"
RPSETUP="$HOME/RetroPie-Setup"
RPCONFIGS="/opt/retropie/configs/all"
BGM="$HOME/RetroPie-BGM-Player"
BGMCONTROL="$BGM/bgm_control"
BGMCONTROLGENERAL="$BGMCONTROL/general"
BGMCONTROLPLAY="$BGMCONTROL/play"
BGMCONTROLPLAYER="$BGMCONTROL/player"
BGMLISTS="$BGM/bgm_lists"
BGMBOTH="$BGMLISTS/both"
BGMEMU="$BGMLISTS/emu"
BGMMP3="$BGMLISTS/mp3"
BGMCUSTOM="$BGMLISTS/custom"
BGMMUSICS="$RP/roms/music"
BGMOLD="$RPCONFIGS/retropie_bgm_player"
AUD="$HOME/.config/audacious"

SCRIPTPATH=$(realpath $0)

echo -e "[Preparing Installation]"
sleep 1

########################
##   Kill Processes   ##
########################
echo -e "-Killing some processes..."
killall audacious mpg123 >/dev/null 2>&1
########################
########################

########################
##remove older version##
########################
echo -e "-Removing older versions..."
rm -rf $BGMOLD
rm -rf $BGM
[ -e $RPMENU/Background\ Music\ Settings.sh ] && rm -f $RPMENU/Background\ Music\ Settings.sh
#use sudo because, owner can be root or file created incorrectly for any reason
sudo chmod 777 $RPCONFIGS/runcommand-onstart.sh $RPCONFIGS/runcommand-onend.sh $RPCONFIGS/autostart.sh >/dev/null 2>&1
sed -i "/retropie_bgm_player\/bgm_stop.sh/d" $RPCONFIGS/runcommand-onstart.sh >/dev/null 2>&1
sed -i "/retropie_bgm_player\/bgm_play.sh/d" $RPCONFIGS/runcommand-onend.sh >/dev/null 2>&1
sed -i "/retropie_bgm_player\/bgm_init.sh/d" $RPCONFIGS/autostart.sh >/dev/null 2>&1
########################
########################

#############################
##Packages and Dependencies##
#############################
echo -e "[Packages and Dependencies Installation]"
sleep 1

echo -e "-Checking packages and dependencies..."
sleep 1

packages=("mpg123" "audacious" "audacious-plugins")
installpackages=

for package in "${packages[@]}"; do
	if dpkg -s $package >/dev/null 2>&1; then
		echo -e "--$package : Installed"
	else
		echo -e "--$package : Not Installed"
		installpackages+=("$package")
	fi
done

if [ ${#installpackages[@]} -gt 0 ]; then
	
	echo -e "---Installing missing packages and dependencies.../n"
	sleep 1
	
	sudo apt-get update; sudo apt-get install -y ${installpackages[@]}

fi
echo -e "/n--All packages and dependencies are installed."
sleep 1
########################
########################

########################
## Install BGM Player ##
########################

echo -e "[Installing RetroPie BGM Player]"
sleep 1

echo -e "-Creating folders..."
sleep 1
mkdir -p -m 0777 $BGMCONTROLGENERAL $BGMCONTROLPLAY $BGMCONTROLPLAYER $BGMBOTH $BGMEMU $BGMMP3 $BGMCUSTOM $BGMMUSICS

echo -e "--Downloading system files...\n"
sleep 1

function gitdownloader(){

	files=("$@")
	((last_id=${#files[@]} - 1))
	path=${files[last_id]}
	unset files[last_id]

	for i in "${files[@]}"; do
		wget -N -q --show-progress "https://raw.githubusercontent.com/Naprosnia/RetroPie_BGM_Player/$BGMGITBRANCH$path/$i"
		#chmod a+rwx "$i"
	done
}

cd $BGM
BGMFILES=("bgm_system.sh" "bgm_control.sh" "bgm_settings.ini" "version.sh")
gitdownloader ${BGMFILES[@]} "/RetroPie-BGM-Player"

cd $BGMCONTROL
BGMFILES=("bgm_updater.sh")
gitdownloader ${BGMFILES[@]} "/RetroPie-BGM-Player/bgm_control"

cd $BGMCONTROLGENERAL
BGMFILES=("bgm_general.sh" "bgm_setplayer.sh" "bgm_settoggle.sh" "bgm_setvolume.sh")
gitdownloader ${BGMFILES[@]} "/RetroPie-BGM-Player/bgm_control/general"

cd $BGMCONTROLPLAY
BGMFILES=("bgm_play.sh" "bgm_setdelay.sh" "bgm_setfade.sh" "bgm_setnonstop.sh")
gitdownloader ${BGMFILES[@]} "/RetroPie-BGM-Player/bgm_control/play"

cd $BGMCONTROLPLAYER
BGMFILES=("bgm_player.sh" "bgm_generatem3u.sh" "bgm_generatesequence.sh")
gitdownloader ${BGMFILES[@]} "/RetroPie-BGM-Player/bgm_control/player"

cd $RPMENU
BGMFILES=("RetroPie-BGM-Player.sh")
gitdownloader ${BGMFILES[@]} "/RetroPie-BGM-Player"

cd $AUD
BGMFILES=("config" )
gitdownloader ${BGMFILES[@]} "/audconfig"

cd $BGMMUSICS
BGMFILES=("1.mp3" "2.mp3" "3.mp3" "4.mp3" "5.mp3" "6.mp3" )
gitdownloader ${BGMFILES[@]} "/music"

echo -e "--Applying permissions...\n"
sleep 1
chmod -R a+rwx $BGM $BGMMUSICS $AUD


echo -e "\n-Writing commands...\n"
sleep 1

cd $RPCONFIGS
echo -e "--Writing on runcommand commands..."
sleep 1
function runcommandsetup(){

	file=$1
	command=$2

	if [ ! -e $file ]; then
			echo -e "---$file not found, creating..."
			sleep 1
			touch $file
			sleep 0.5
			chmod a+rwx $file
			sleep 0.5
			echo "$command" > $file
		else
			echo -e "---$file found, writing..."
			sleep 1
			#use sudo because, owner can be root or file created incorrectly for any reason
			sudo chmod 777 $file
			sleep 0.5
			sed -i "/bgm_system.sh/d" $file
			[ -s $file ] && sed -i "1i $command" $file || echo "$command" > $file
	fi
}
runcommandsetup "runcommand-onstart.sh" "bash \$HOME/RetroPie-BGM-Player/bgm_system.sh -s"
runcommandsetup "runcommand-onend.sh" "bash \$HOME/RetroPie-BGM-Player/bgm_system.sh -p"
sleep 1
echo -e "--Writing on autostart script..."
sleep 1
#use sudo because, owner can be root or file created incorrectly for any reason
sudo chmod 777 autostart.sh
sed -i "/bgm_system.sh/d" autostart.sh
sed -i "1 i bash \$HOME/RetroPie-BGM-Player/bgm_system.sh -i --autostart" autostart.sh
sleep 1

echo -e "\n[Instalation finished.]\n"
sleep 1
########################
########################

########################
##       Restart      ##
########################
if [ "$1" == "--update" ]; then
	(rm -f $SCRIPTPATH; bash $BGMCONTROL/bgm_updater.sh --reboot)
else
	echo -e "[Restart System]"
	echo -e "-To finish, we need to reboot.\n"
	read -n 1 -s -r -p "Press any key to Restart."
	echo -e "\n"
	(rm -f $SCRIPTPATH; sudo reboot)
fi

########################
########################