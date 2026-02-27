#!/usr/bin/env bash
read -r _ u n s i w irq sirq st _ < /proc/stat
prev_total=$((u+n+s+i+w+irq+sirq+st))
prev_iowait=$w
while sleep 2; do
  read -r _ u n s i w irq sirq st _ < /proc/stat
  total=$((u+n+s+i+w+irq+sirq+st))
  dt=$((total - prev_total))
  dw=$((w - prev_iowait))
  if [ "$dt" -gt 0 ]; then
    permille=$(((1000 * dw + dt / 2) / dt))
  else
    permille=0
  fi
  whole=$((permille / 10))
  frac=$((permille % 10))
  printf "%d.%d%%\n" "$whole" "$frac"
  prev_total=$total
  prev_iowait=$w
done
