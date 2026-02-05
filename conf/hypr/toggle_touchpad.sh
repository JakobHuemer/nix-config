#!/usr/bin/env bash
# https://github.com/hyprwm/Hyprland/discussions/4283

export STATUS_FILE="/tmp/tmp.touchpad.status-$UID"

enable_touchpad() {
  notify-send -u normal "Enabling Touchpad"
  printf "true" > "$STATUS_FILE"
  hyprctl keyword '$LAPTOP_TOUCHPAD_ENABLE' "true" -r
}

disable_touchpad() {
  notify-send -u normal "Disabling Touchpad"
  printf "false" > "$STATUS_FILE"
  hyprctl keyword '$LAPTOP_TOUCHPAD_ENABLE' "false" -r
}


if [ "$1" = "--readonly" ]; then
   
  if ! [ -f "$STATUS_FILE" ]; then
    echo "true" > "$STATUS_FILE"
  fi
  notify-send -u normal "Setting touchpad to $(cat "$STATUS_FILE")"
  hyprctl keyword '$LAPTOP_TOUCHPAD_ENABLE' "$(cat "$STATUS_FILE")" -r
elif ! [ -f "$STATUS_FILE" ]; then
  disable_touchpad
else
  if [ "$(cat "$STATUS_FILE")" = "true" ]; then
    disable_touchpad
  elif [ "$(cat "$STATUS_FILE")" = "false" ]; then
    enable_touchpad
  else
    notify-send -u critical "$STATUS_FILE is corrupted: $(cat '$STATUS_FILE')"
  fi
fi
