# Script to automate the build of various Libretro cores, Nxengine-evo, Retroarch, PPSSPP, ScummVM, Emulationstation-fcamod for use with RK3326 devices (including Chi, OGA, OGS, RG351P/M/MP/V, and the RK2020)

### Assumptions:
This script was designed to work with 32bit and 64bit chroot Linux environments for the RK3326 chipset. \
See [this document](https://github.com/christianhaitian/rk3326_core_builds/blob/main/docs/chroot.md) for instructions on how to create them yourself. \
You can also download a prebuilt one I created by following the information [here](https://forum.odroid.com/viewtopic.php?p=306185#p306185)

This script is designed to only build cores, retroarch and PPSSPP that are compatible with the aarch64 or armhf environment it's run from.  So to build cores for the 32bit armhf environment, it should be run from an arm32 environment such as a 32bit chroot.

## How to use: (In a aarch64 chroot or armhf chroot or building from Ubuntu based distro on a RK3326 device)

```
git clone https://github.com/christianhaitian/rk3326_core_builds.git
cd rk3326_core_builds
```

### To build all libretro cores defined in the script:
`./builds.sh all`

### To build just caprice32 (64bit only):
`./builds.sh cap32`

### To build just dosbox_pure (64bit only):
`./builds.sh dosbox_pure`

### To download and unpack duckstation (64bit only):
`./builds.sh duckstation`

### To build just fbneo (64bit only):
`./builds.sh fbneo`

### To build just gambatte (64bit only):
`./builds.sh gambatte`

### To build just genesis-plus-gx (64bit only):
`./builds.sh genesis-plus-gx`

### To build just gpsp:
`./builds.sh gpsp`

### To build just flycast:
`./builds.sh flycast`

### To build just fmsx (64bit only):
`./builds.sh fmsx`

### To build just mgba (64bit only):
`./builds.sh mgba`

### To build just mess (64bit only): <--Very long build.  Could be 24 hours or more to complete.
`./builds.sh mess`

### To build just mame (64bit only): <--Very long build.  Could be 24 hours or more to complete.
`./builds.sh mame`

### To build just pcfx (64bit Only):
`./builds.sh pcfx`

### To build just pokemini (64bit only):
`./builds.sh pokemini`

### To build just parallel-n64:
`./builds.sh parallel-n64`

### To build just picodrive:
`./builds.sh picodrive`

### To build just pcsx_rearmed (32bit only):
`./builds.sh pcsx_rearmed`

### To build just ppsspp standalone emulator (64bit only):
`./builds.sh ppsspp`

### To build just libretro-ppsspp (64bit only):
`./builds.sh ppsspp-libretro`

### To build just sameboy (64bit only):
`./builds.sh sameboy`

### To build just sameduck (64bit only):
`./builds.sh sameduck`

### To build just scummvm standalone:
`./builds.sh scummvm`

### To build just scummvm libretro (64bit only):
`./builds.sh scummvm-libretro`

### To build just snes9x (64bit only):
`./builds.sh snes9x`

### To build just supafaust (64bit only):
`./builds.sh supafaust`

### To build just quicknes (64bit only):
`./builds.sh quicknes`

### To build just yabasanshiro (32bit only):
`./builds.sh yabasanshiro`

### To build just retroarch:
`./builds.sh retroarch`

### To build Nxegnine-evo (64bit only)
`./builds.sh nxengine-evo`

### To add a system for screenscraper scraping in Emulationstation-fcamod (64bit only)
`./builds.sh es_add_scrape`

### To build Emulationstation-fcamod (64bit only)
`./builds.sh es_build`

### To update the retroarch-cores repo with new or updated cores:
`./builds.sh update`

### To clean the folder of all builds and gits
`./builds.sh clean`
