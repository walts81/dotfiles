#!/usr/bin/env bash
# Nerd Font icons (change if your font differs)
ICON_ON="󰂯"
ICON_OFF="󰂲"
if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  printf "%s\n" "$ICON_ON"
else
  printf "%s\n" "$ICON_OFF"
fi
