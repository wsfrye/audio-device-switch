#!/bin/bash
# Idea shamelessly stolen this from here:
# https://ericlathrop.com/2021/02/changing-pulseaudio-outputs-programmatically/
# Modified to only cycle through the 2 of the playback devices from "pactl list short sinks"

default_sink=$(pactl info | awk -F': ' '/Default Sink/{print $2}')

sink1="alsa_output.usb-GeneralPlus_USB_Audio_Device-00.analog-stereo"
sink2="alsa_output.usb-C-Media_Electronics_Inc._USB_PnP_Sound_Device-00.analog-stereo"

current_sink=$(pactl info | awk -F': ' '/Default Sink/{print $2}')

if [ "$current_sink" == "$sink1" ]; then
  next_sink="$sink2"
else
  next_sink="$sink1"
fi

pactl set-default-sink "$next_sink"
pactl list short sink-inputs | awk '{print $1}' | xargs -I{} pactl move-sink-input {} "$next_sink"
