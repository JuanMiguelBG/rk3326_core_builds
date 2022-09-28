#!/bin/bash

##################################################################
# Created by Christian Haitian for use to easily update          #
# various standalone emulators, libretro cores, and other        #
# various programs for the RK3566 platform for various Linux     #
# based distributions.                                           #
# See the LICENSE.md file at the top-level directory of this     #
# repository.                                                    #
##################################################################

cur_wd="$PWD"
valid_id='^[0-9]+$'
es_git="https://github.com/JuanMiguelBG/EmulationStation-fcamod-ogs.git"
bitness="$(getconf LONG_BIT)"

# Build Emulationstation-FCAMOD
if [[ "$var" == "es_build" ]] && [[ "$bitness" == "64" ]]; then

	echo ""
	echo "Building emulationstation-fcamod of JuanMiguel's (Baco)."

	source $HOME/es_build.properties

	echo ""
	if [[ -z "$devid" ]]; then
		devid=$(printenv DEV_ID)
		[ ! -z $devid ] && echo "We're going to use '$devid' since you entered nothing above."
	fi
	echo "SCREENSCRAPER_DEV_ID --> $devid"
	echo ""
	if [[ -z "$devpass" ]]; then
		devpass=$(printenv DEV_PASS)
		[ ! -z $devpass ] && echo "We're going to use '$devpass' since you entered nothing above."
	fi
	echo "SCREENSCRAPER_DEV_PWD --> $devpass"
	echo ""
	if [[ -z "$softname" ]]; then
		softname=$(printenv SOFTNAME)
		[ ! -z $softname ] && echo "The software name has been set to '$softname' since one was not provided at start."
	fi
	echo "SCREENSCRAPER_SOFTNAME --> $softname"
	echo ""
	if [[ -z "$apikey" ]]; then
		apikey=$(printenv TGDB_APIKEY)
		[ ! -z $apikey ] && echo "We're going to use '$apikey' since you entered nothing above."
	fi
	echo "GAMESDB_APIKEY --> $apikey"
	echo ""

	# Ensure dependencies are installed and available
	neededlibs=( libboost-system-dev libboost-filesystem-dev libboost-locale-dev libfreeimage-dev libfreetype6-dev libeigen3-dev libcurl4-openssl-dev libboost-date-time-dev libasound2-dev cmake libsdl2-dev rapidjson-dev libvlc-dev libvlccore-dev vlc-bin libsdl2-mixer-dev )
	updateapt="N"
	for libs in "${neededlibs[@]}"
	do
		dpkg -s "${libs}" &>/dev/null
		if [[ $? != "0" ]]; then
			if [[ "$ updateapt" == "N" ]]; then
				apt-get -y update
				updateapt="Y"
			fi
			apt-get -y install --no-install-recommends "${libs}"
			if [[ $? != "0" ]]; then
				echo " "
				echo "Could not install needed library ${libs}.  Stopping here so this can be reviewed."
				exit 1
			fi
		fi
	done

	cd $cur_wd

	if [ ! -d "emulationstation-fcamod/" ]; then
		git clone --recursive $es_git emulationstation-fcamod
		if [[ $? != "0" ]]; then
			echo " "
			echo "There was an error while cloning the  emulationstation-fcamod git.  Is Internet active or did the git location change?  Stopping here."
			exit 1
		fi
	fi 

	cd emulationstation-fcamod

#	cp ../patches/es-fcamod-patch-build.patch .
#	patch -Np1 < es-fcamod-patch-build.patch
#	if [[ $? != "0" ]]; then
#		echo " "
#		echo "There was an error while applying es-fcamod-patch-build.patch.  Stopping here."
#		exit 1
#	fi
#	rm es-fcamod-patch-build.patch

	cmake -DSCREENSCRAPER_DEV_LOGIN="devid=$devid&devpassword=$devpass" -DGAMESDB_APIKEY="$apikey" -DSCREENSCRAPER_SOFTNAME="$softname" -DCMAKE_BUILD_TYPE=Release

	if [[ $? != "0" ]]; then
		echo " "
		echo "There was an error while cmaking the emulationstation-fcamod.  Stopping here."
		exit 1
	fi

	make -j$(nproc)
	if [[ $? != "0" ]]; then
		echo " "
		echo "There was an error while building the emulationstation-fcamod.  Stopping here."
		exit 1
	fi

	strip emulationstation

	if [ ! -d "../es-fcamod/" ]; then
		mkdir -v ../es-fcamod
	fi

	cp emulationstation ../es-fcamod/emulationstation
	echo " "
	echo "The version of emulationstation-fcamod has been created and has been placed in the rk3566_core_builds/es-fcamod subfolder."
	exit 0
fi
