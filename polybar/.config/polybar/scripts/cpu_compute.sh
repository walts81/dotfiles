#!/usr/bin/env bash
read -r _ u n s i w irq sirq st _ < /proc/stat
prev_total=$((u+n+s+i+w+irq+sirq+st))
prev_busy=$((u+n+s+irq+sirq+st))
while sleep 2; do
  read -r _ u n s i w irq sirq st _ < /proc/stat
  total=$((u+n+s+i+w+irq+sirq+st))
  busy=$((u+n+s+irq+sirq+st))
  dt=$((total - prev_total))
  db=$((busy - prev_busy))
  if [ "$dt" -gt 0 ]; then
    permille=$(((1000 * db + dt / 2) / dt))
  else
    permille=0
  fi
  whole=$((permille / 10))
  frac=$((permille % 10))
  printf "%d.%d%%\n" "$whole" "$frac"
  prev_total=$total
  prev_busy=$busy
done
