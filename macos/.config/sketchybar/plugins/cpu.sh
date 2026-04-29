#!/bin/bash

CACHE_FILE="/tmp/sketchybar_cpu_cache"

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"

# Delta check: только обновляем если изменение > 2%
LAST_VALUE=""
if [ -f "$CACHE_FILE" ]; then
  LAST_VALUE=$(cat "$CACHE_FILE")
  DELTA=$((${CPU_PERCENT%\%} - ${LAST_VALUE%\%}))
  # Если изменение меньше 2%, не обновляем
  if [ ${DELTA#-} -lt 2 ]; then
    exit 0
  fi
fi

echo "$CPU_PERCENT" > "$CACHE_FILE"
sketchybar --set $NAME label="$CPU_PERCENT%"