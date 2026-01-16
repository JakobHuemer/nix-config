#!/usr/bin/env bash

# https://github.com/hyprwm/Hyprland/discussions/4283

export STATUS_FILE="$XDG_RUNTIME_DIR/keyboard.status"

enable_touchpad() {
  printf "true" > "$STATUS_FILE"
  notify-send -u normal "Enabling Touchpad"
  hyprctl keyword '$LAPTOP_TOUCHPAD_ENABLE' "true" -r
}

disable_touchpad() {
  printf "false" > "$STATUS_FILE"
  notify-send -u normal "Disabling Touchpad"
  hyprctl keyword '$LAPTOP_TOUCHPAD_ENABLE' "false" -r
}


if ! [ -f "$STATUS_FILE" ]; then
  disable_touchpad
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disable_touchpad
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enable_touchpad
  fi
fi
