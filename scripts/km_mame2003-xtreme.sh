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

	# Libretro km_mame2003-xtreme build
	if [[ "$var" == "km_mame2003-xtreme" || "$var" == "all" ]] && [[ "$bitness" == "32" ]]; then
	 cd $cur_wd
	  if [ ! -d "km_mame2003-xtreme-libretro/" ]; then
		git clone https://github.com/KMFDManic/mame2003-xtreme.git km_mame2003-xtreme-libretro
		if [[ $? != "0" ]]; then
		  echo " "
		  echo "There was an error while cloning the libretro git.  Is Internet active or did the git location change?  Stopping here."
		  exit 1
		 fi
		cp patches/km_mame2003-xtreme-patch* km_mame2003-xtreme-libretro/.
	  fi

	 # Ensure dependencies are installed and available
     neededlibs=( dos2unix )
     updateapt="N"
     for libs in "${neededlibs[@]}"
     do
          dpkg -s "${libs}" &>/dev/null
          if [[ $? != "0" ]]; then
           if [[ "$updateapt" == "N" ]]; then
            apt-get -y update
            updateapt="Y"
           fi
           apt-get -y install "${libs}"
           if [[ $? != "0" ]]; then
            echo " "
            echo "Could not install needed library ${libs}.  Stopping here so this can be reviewed."
            exit 1
           fi
          fi
     done

	 cd km_mame2003-xtreme-libretro/
	 
	 km_mame2003_xtreme_patches=$(find *.patch)
	 
	 if [[ ! -z "$km_mame2003_xtreme_patches" ]]; then
	  for patching in km_mame2003-xtreme-patch*
	  do
	       echo "Patch: '$patching'"
	       # Fix for "Hunk #N FAILED at X (different line endings)" messages
		   # The files use Windows (CR-LF) end on line
	       files_to_patch=$(grep "diff --git" "$patching" | grep -o -P '(?<=a/).*(?= )')
		   for file in $files_to_patch
		   do
  		      echo "'$file', changing EOF from CR-LF to LF before patching"
		      dos2unix "$file"
		   done
		   patch -Np1 < "$patching"
		   if [[ $? != "0" ]]; then
			echo " "
			echo "There was an error while applying $patching.  Stopping here."
			exit 1
		   fi
		   rm "$patching" 
		   for file in $files_to_patch
		   do
  		      echo "'$file', changing EOF from LF to CR-LF after patching"
		      unix2dos "$file"
		   done
	  done
	 fi

	  make clean
      make -f Makefile platform=rk3326 system_platform=unix -j$(nproc)

	  if [[ $? != "0" ]]; then
		echo " "
		echo "There was an error while building the newest lr-km_mame2003-xtreme core.  Stopping here."
		exit 1
	  fi

	  strip km_mame2003_xtreme_libretro.so

	  if [ ! -d "../cores$bitness/" ]; then
		mkdir -v ../cores$bitness
	  fi

	  cp km_mame2003_xtreme_libretro.so ../cores$bitness/km_mame2003_xtreme_libretro.so
	  cp info/km_mame2003_xtreme_libretro.info ../cores$bitness/km_mame2003_xtreme_libretro.info

	  gitcommit=$(git log | grep -m 1 commit | cut -c -14 | cut -c 8-)
	  echo $gitcommit > ../cores$bitness/km_mame2003_xtreme_libretro.so.commit

	  echo " "
	  echo "km_mame2003_xtreme_libretro.so has been created and has been placed in the rk3326_core_builds/cores$bitness subfolder"
	else
	  echo " "
	  echo "ERROR: $bitness, km_mame2003_xtreme_libretro.so only can build for 32 bits"
	fi

