#!/bin/bash

##################################################################
# Created by Christian Haitian for use to easily update          #
# various standalone emulators, libretro cores, and other        #
# various programs for the RK3326 platform for various Linux     #
# based distributions.                                           #
# See the LICENSE.md file at the top-level directory of this     #
# repository.                                                    #
##################################################################

cur_wd="$PWD"
bitness="$(getconf LONG_BIT)"

	# Libretro mame2003-xtreme build
	if [[ "$var" == "mame2003-xtreme" || "$var" == "all" ]] && [[ "$bitness" == "32" ]]; then
	 cd $cur_wd
	  if [ ! -d "mame2003-xtreme-libretro/" ]; then
		git clone https://github.com/KMFDManic/mame2003-xtreme.git
		if [[ $? != "0" ]]; then
		  echo " "
		  echo "There was an error while cloning the libretro git.  Is Internet active or did the git location change?  Stopping here."
		  exit 1
		 fi
		cp patches/mame2003-xtreme-patch* mame2003-xtreme-libretro/.
	  fi

	 cd mame2003-xtreme-libretro/
	 
	 mame2003_xtreme_patches=$(find *.patch)
	 
	 if [[ ! -z "$mame2003_xtreme_patches" ]]; then
	  for patching in mame2003-xtreme-patch*
	  do
		   patch -Np1 < "$patching"
		   if [[ $? != "0" ]]; then
			echo " "
			echo "There was an error while applying $patching.  Stopping here."
			exit 1
		   fi
		   rm "$patching" 
	  done
	 fi

	  make clean
      make -j3

	  if [[ $? != "0" ]]; then
		echo " "
		echo "There was an error while building the newest lr-mame2003-xtreme core.  Stopping here."
		exit 1
	  fi

	  strip mame2003_xtreme_libretro.so

	  if [ ! -d "../cores$bitness/" ]; then
		mkdir -v ../cores$bitness
	  fi

	  cp mame2003_xtreme_libretro.so ../cores$bitness/mame2003_xtreme_libretro.so

	  gitcommit=$(git log | grep -m 1 commit | cut -c -14 | cut -c 8-)
	  echo $gitcommit > ../cores$bitness/mame2003_xtreme_libretro.so.commit

	  echo " "
	  echo "mame2003_xtreme_libretro.so has been created and has been placed in the rk3326_core_builds/cores$bitness subfolder"
	else
	  echo " "
	  echo "ERROR: $bitness, mame2003_xtreme_libretro.so only can build for 32 bits"
	fi

