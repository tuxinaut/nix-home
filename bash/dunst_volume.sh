#!/usr/bin/env bash

# Arbitrary but unique message tag
msgTag="myVolumeChanger"

SINK=$(pactl info | grep "Default Sink" | cut -f3 -d" ")
volume=$(pactl list sinks | grep -m 1 -A 7 "${SINK}" |  grep '^[[:space:]]Volume:' | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

if [[ $volume == 0 || "$mute" == "off" ]]; then
    # Show the sound muted notification
    notify-send -e -a "changeVolume" -u low -i audio-volume-muted -h string:synchronous:volume-progress "Volume muted"
else
    # Show the volume notification
    notify-send -e -a "changeVolume" -u low -i audio-volume-high -h string:synchronous:volume-progress -h int:value:"$volume" "Volume: ${volume}%"
fi

exit 0
