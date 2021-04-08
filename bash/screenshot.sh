#!/usr/bin/env bash

screenshot_file_name="${HOME}/Pictures/screenshot_$(date +"%F_%H_%M_%S").png"

reply_action () {
  gimp $screenshot_file_name
}

grim $screenshot_file_name

ACTION=$(dunstify --action="default,Reply" "Screenshot (${screenshot_file_name}) was taken")

case "$ACTION" in
"default")
    reply_action
    ;;
esac
