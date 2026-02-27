#!/bin/bash
set -euo pipefail

workspace_name="$1"
class_regex="$2"
launch_cmd="$3"

current_workspace=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true) | .name')
if [ "${current_workspace}" = "${workspace_name}" ]; then
  i3-msg "workspace back_and_forth" >/dev/null
  exit 0
fi

i3-msg "workspace ${workspace_name}" >/dev/null

if ! i3-msg -t get_tree | jq -e ".. | objects | select((.window_properties?.class // \"\") | test(\"${class_regex}\"))" >/dev/null; then
  i3-msg "exec --no-startup-id ${launch_cmd}" >/dev/null
fi
