#!/usr/bin/env bash
set -euo pipefail

IMG="${XDG_RUNTIME_DIR:-/tmp}/i3lock.png"

lock_with_i3lock_color() {
  local locker="$1"
  shift

  "$locker" \
    --nofork \
    --clock \
    --indicator \
    --radius 110 \
    --ring-width 8 \
    --inside-color 00000055 \
    --ring-color ffffff55 \
    --line-color 00000000 \
    --keyhl-color 88c0d0ff \
    --bshl-color bf616aff \
    --separator-color 00000000 \
    --time-color eceff4ff \
    --date-color e5e9f0ff \
    --layout-color d8dee9ff \
    --verif-color ebcb8bff \
    --wrong-color bf616aff \
    --time-str "%-I:%M %p" \
    --date-str "%A, %d %B %Y" \
    "$@"
}

main() {
  local locker
  local image_args=()

  if command -v i3lock-color >/dev/null 2>&1; then
    locker="${LOCKER:-$(command -v i3lock-color)}"
  else
    locker="${LOCKER:-$(command -v i3lock)}"
  fi

  if command -v maim >/dev/null 2>&1; then
    maim "$IMG"

    if command -v convert >/dev/null 2>&1; then
      convert "$IMG" -filter Gaussian -blur 0x14 "$IMG"
      convert "$IMG" -fill "rgba(0,0,0,0.30)" -colorize 30% "$IMG"
    fi

    image_args=("$IMG")
  fi

  trap 'rm -f "$IMG"' EXIT

  if [[ "$(basename "$locker")" == "i3lock-color" ]]; then
    if [[ ${#image_args[@]} -gt 0 ]]; then
      lock_with_i3lock_color "$locker" --image "${image_args[0]}"
    else
      lock_with_i3lock_color "$locker" --color 1f2430
    fi
  else
    if [[ ${#image_args[@]} -gt 0 ]]; then
      "$locker" -n -i "${image_args[0]}"
    else
      "$locker" -n -c 1f2430
    fi
  fi
}

main "$@"
