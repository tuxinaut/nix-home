#!/usr/bin/env bash

screenshot_file_name="${HOME}/Pictures/screenshot_$(date +"%F_%H_%M_%S").png"

reply_action () {
  gimp $screenshot_file_name
}

selection=$(echo "active
screen
output
area
window" | bemenu -b -i -l 10 --nb  "#002b36 " --tb  "#002b36 " --fb  "#002b36 " --fn  "Hack 14 " -p  "pick > " -b -P  " " --hb  "#002b36 " --hf  "#b5890 " --tf  "#fdf6e3 " --nf  "#fdf6e3 " -m focused)

grimshot save "${selection}" "${screenshot_file_name}"

ACTION=$(dunstify --action="default,Reply" "Screenshot (${screenshot_file_name}) was taken")

case "$ACTION" in
"default")
    reply_action
    ;;
esac
