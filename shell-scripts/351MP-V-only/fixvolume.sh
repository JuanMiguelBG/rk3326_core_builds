#!/bin/bash
amixer -c 0 cset iface=MIXER,name='Playback Path' SPK_HP
exit 0
