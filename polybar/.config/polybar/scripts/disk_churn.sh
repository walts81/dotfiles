#!/usr/bin/env bash
set -u
DEV="${1:-nvme0n1}"
STAT="/sys/block/$DEV/stat"
if [ ! -r "$STAT" ]; then
  printf "0.0%%\n"
  exit 0
fi
read_stat() {
  # field 10 = ms spent doing I/Os
  read -r _ _ _ _ _ _ _ _ _ io_ms _ < "$STAT"
  printf "%s\n" "$io_ms"
}
prev_io_ms="$(read_stat)"
prev_ns="$(date +%s%N)"
while sleep 2; do
  io_ms="$(read_stat)"
  now_ns="$(date +%s%N)"
  d_io_ms=$((io_ms - prev_io_ms))
  d_ns=$((now_ns - prev_ns))
  [ "$d_ns" -le 0 ] && d_ns=1
  awk -v d_io_ms="$d_io_ms" -v d_ns="$d_ns" '
    BEGIN {
      d_ms = d_ns / 1000000.0
      churn = (d_io_ms / d_ms) * 100.0
      if (churn < 0) churn = 0
      if (churn > 100) churn = 100
      printf "%.1f%%\n", churn
    }'
  prev_io_ms="$io_ms"
  prev_ns="$now_ns"
done
