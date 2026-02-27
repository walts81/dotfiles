#!/usr/bin/env bash

set -euo pipefail

mode="${1:-}"
shot_dir="$HOME/Pictures/screenshots"
timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
file="$shot_dir/screenshot_${timestamp}.png"

mkdir -p "$shot_dir"

capture_full() {
    maim "$1"
}

capture_selection() {
    import "$1"
}

open_preview() {
    if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v swappy >/dev/null 2>&1; then
        swappy -f "$1"
    elif command -v ristretto >/dev/null 2>&1; then
        ristretto "$1"
    else
        xdg-open "$1" >/dev/null 2>&1
    fi
}

case "$mode" in
    full-save)
        capture_full "$file"
        ;;
    full-edit)
        capture_full "$file"
        open_preview "$file"
        ;;
    select-save)
        capture_selection "$file"
        ;;
    select-edit)
        capture_selection "$file"
        open_preview "$file"
        ;;
    *)
        printf 'Usage: %s {full-save|full-edit|select-save|select-edit}\n' "${0##*/}" >&2
        exit 2
        ;;
esac
