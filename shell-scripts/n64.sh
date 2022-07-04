#!/bin/bash

xres="$(cat /sys/class/graphics/fb0/modes | grep -o -P '(?<=:).*(?=p-)' | cut -dx -f1)"
yres="$(cat /sys/class/graphics/fb0/modes | grep -o -P '(?<=:).*(?=p-)' | cut -dx -f2)"
ricewidthhack=$(((yres * 4) / 3))

if [[ $1 == "standalone-Rice" ]]; then
  if [[ $2 == "Widescreen_Aspect" ]]; then
    /opt/mupen64plus/mupen64plus --resolution "${xres}x${yres}" --plugindir /opt/mupen64plus --gfx mupen64plus-video-rice.so --corelib /opt/mupen64plus/libmupen64plus.so.2 --datadir /opt/mupen64plus "$3"
  else
    /opt/mupen64plus/mupen64plus --resolution "${ricewidthhack}x${yres}" --plugindir /opt/mupen64plus --gfx mupen64plus-video-rice.so --corelib /opt/mupen64plus/libmupen64plus.so.2 --datadir /opt/mupen64plus "$3"
  fi
elif [[ $1 == "standalone-Glide64mk2" ]]; then
  if [[ $2 == "Widescreen_Aspect" ]]; then
    /opt/mupen64plus/mupen64plus --set Video-Glide64mk2[aspect]=1 --resolution "${xres}x${yres}" --plugindir /opt/mupen64plus --gfx mupen64plus-video-glide64mk2.so --corelib /opt/mupen64plus/libmupen64plus.so.2 --datadir /opt/mupen64plus "$3"
  else
    /opt/mupen64plus/mupen64plus --set Video-Glide64mk2[aspect]=-1 --resolution "${xres}x${yres}" --plugindir /opt/mupen64plus --gfx mupen64plus-video-glide64mk2.so --corelib /opt/mupen64plus/libmupen64plus.so.2 --datadir /opt/mupen64plus "$3"
  fi
else
  /usr/local/bin/"$1" -L /home/ark/.config/"$1"/cores/"$2"_libretro.so "$3"
fi


