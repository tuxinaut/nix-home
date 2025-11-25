#!/usr/bin/env bash

#            "volume_muted" => "VOL MUTED",
#            "microphone_empty" => "MIC ",
#            "microphone_full" => "MIC",
#            "microphone_half" => "MIC",
#            "microphone_muted" => "MIC MUTED",

#command = "echo '{\"icon\":\"weather_thunder\",\"state\":\"Critical\", \"text\": \"Danger!\"}'"

# Get active audio source index
CURRENT_SOURCE=$(pactl info | grep "Default Source" | cut -f3 -d" ")

# List lines in pactl after the source name match and pick mute status
MUTED=$(pactl list sources | grep -A 10 $CURRENT_SOURCE | grep -c "Mute: yes")

if [[ $MUTED -eq 1 ]]; then
  # It does not work because this scriot is called every 5 seconds from i3status-rs
  # notify-send -e -a "changeMic" -u low -i microphone "Mic muted"
  echo ""
else
  # notify-send -e -a "changeMic" -u low -i microphone "Mic on"
  echo ""
fi
