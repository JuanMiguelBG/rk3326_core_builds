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

	# Libretro fbalpha2018 build
	if [[ "$var" == "fbalpha2018" || "$var" == "all" ]] && [[ "$bitness" == "32" ]]; then
	  cd $cur_wd
	  if [ ! -d "fbalpha2018/" ]; then
		git clone https://github.com/barbudreadmon/fbalpha-backup-dontuse-ty.git -b v0.2.97.43 fbalpha2018
		if [[ $? != "0" ]]; then
		  echo " "
		  echo "There was an error while cloning the libretro git.  Is Internet active or did the git location change?  Stopping here."
		  exit 1
		fi
		cp patches/fbalpha2018-patch* fbalpha2018/.
	  fi

	 cd fbalpha2018/
	 
	 fbalpha2018_patches=$(find *.patch)
	 
	  if [[ ! -z "$fbalpha2018_patches" ]]; then
	  for patching in fbalpha2018-patch*
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

	  make -f makefile.libretro platform=rk3326 -j$(nproc) 

	  if [[ $? != "0" ]]; then
		echo " "
		echo "There was an error while building the newest lr-fbalpha2018 core.  Stopping here."
		exit 1
	  fi

	  strip fbalpha2018_libretro.so

	  if [ ! -d "$cur_wd/cores$bitness/" ]; then
		mkdir -v $cur_wd/cores$bitness
	  fi

	  cp fbalpha2018_libretro.so $cur_wd/cores$bitness/.

	  gitcommit=$(git log | grep -m 1 commit | cut -c -14 | cut -c 8-)
	  echo $gitcommit > $cur_wd/cores$bitness/fbalpha2018_libretro.so.commit

	  echo " "
	  echo "fbalpha2018_libretro.so has been created and has been placed in the rk3326_core_builds/cores$bitness subfolder"
	fi
