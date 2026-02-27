#!/usr/bin/env bash
set -euo pipefail
IMG="/tmp/i3lock.png"
LOCKER="${LOCKER:-$(command -v i3lock)}"
maim "$IMG"
convert "$IMG" -filter Gaussian -blur 0x14 "$IMG"
convert "$IMG" -fill "rgba(0,0,0,0.30)" -colorize 30% "$IMG"
"$LOCKER" \
  --nofork \
  --image "$IMG" \
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
  --date-str "%A, %d %B %Y"
rm -f "$IMG"
