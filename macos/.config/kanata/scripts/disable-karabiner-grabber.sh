#!/bin/bash
# Disable Karabiner-Elements grabber; keep VirtualHID for Kanata.
# Safe to run repeatedly as root (watchdog LaunchDaemon).
set -euo pipefail

launchctl disable system/org.pqrs.service.daemon.Karabiner-Core-Service 2>/dev/null || true
launchctl bootout system/org.pqrs.service.daemon.Karabiner-Core-Service 2>/dev/null || true
launchctl enable system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true

USER_LABELS=(
  org.pqrs.service.agent.Karabiner-Menu
  org.pqrs.service.agent.Karabiner-Core-Service
  org.pqrs.service.agent.Karabiner-Core-Service-rev2
  org.pqrs.service.agent.Karabiner-NotificationWindow
  org.pqrs.service.agent.karabiner_console_user_server
  org.pqrs.service.agent.karabiner_session_monitor
)

console_uid="$(stat -f %u /dev/console 2>/dev/null || true)"
for uid in "${console_uid}" 501; do
  [[ -n "${uid}" && "${uid}" != "0" ]] || continue
  for label in "${USER_LABELS[@]}"; do
    launchctl disable "gui/${uid}/${label}" 2>/dev/null || true
    launchctl bootout "gui/${uid}/${label}" 2>/dev/null || true
  done
done

pkill -x Karabiner-Core-Service 2>/dev/null || true
pkill -x Karabiner-NotificationWindow 2>/dev/null || true
pkill -x karabiner_console_user_server 2>/dev/null || true
pkill -x Karabiner-Menu 2>/dev/null || true
pkill -x Karabiner-Elements 2>/dev/null || true
pkill -x Karabiner-EventViewer 2>/dev/null || true

exit 0
