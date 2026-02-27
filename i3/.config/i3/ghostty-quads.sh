#!/bin/bash
set -euo pipefail

ws="6"
layout="$HOME/.config/i3/layouts/ghostty-quad.json"

ws_id=$(i3-msg -t get_workspaces | jq -r ".[] | select(.num == ${ws}) | .id")
if [ -n "${ws_id}" ]; then
  i3-msg "[con_id=\"${ws_id}\"] kill" >/dev/null
fi

i3-msg "workspace number ${ws}; append_layout ${layout}; exec --no-startup-id ghostty --gtk-single-instance=false --class=com.mitchellh.ghosttyq1 --window-padding-x=0 --window-padding-y=0 -e /home/jwalters/.opencode/bin/opencode; exec --no-startup-id ghostty --gtk-single-instance=false --class=com.mitchellh.ghosttyq2; exec --no-startup-id ghostty --gtk-single-instance=false --class=com.mitchellh.ghosttyq3; exec --no-startup-id ghostty --gtk-single-instance=false --class=com.mitchellh.ghosttyq4" >/dev/null

sleep 5
q1_id=$(i3-msg -t get_tree | jq -r '.. | objects | select(.window_properties?.class == "com.mitchellh.ghosttyq1") | .id' | head -n1)
if [ -n "${q1_id}" ]; then
  i3-msg "[con_id=\"${q1_id}\"] focus" >/dev/null
fi
