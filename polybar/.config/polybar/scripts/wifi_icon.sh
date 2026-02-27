#!/usr/bin/env bash
# Usage: wifi_icon.sh <interface>
# Example: wifi_icon.sh wlp3s0
IFACE="${1:-wlan0}"
ICON_DISCONNECTED="󰤭"
ICON_0="󰤯"
ICON_1="󰤟"
ICON_2="󰤢"
ICON_3="󰤥"
ICON_4="󰤨"
# If interface missing or down, treat as disconnected
if [ ! -d "/sys/class/net/$IFACE" ] || [ "$(cat "/sys/class/net/$IFACE/operstate" 2>/dev/null)" = "down" ]; then
  printf "%s\n" "$ICON_DISCONNECTED"
  exit 0
fi
# /proc/net/wireless link quality is typically 0..70
quality="$(awk -v iface="$IFACE" '$1 ~ (iface ":") {gsub(/\./,"",$3); print int($3)}' /proc/net/wireless)"
if [ -z "$quality" ]; then
  printf "%s\n" "$ICON_DISCONNECTED"
  exit 0
fi
pct=$(( quality * 100 / 70 ))
if [ "$pct" -lt 10 ]; then
  icon="$ICON_0"
elif [ "$pct" -lt 35 ]; then
  icon="$ICON_1"
elif [ "$pct" -lt 60 ]; then
  icon="$ICON_2"
elif [ "$pct" -lt 85 ]; then
  icon="$ICON_3"
else
  icon="$ICON_4"
fi
printf "%s\n" "$icon"
