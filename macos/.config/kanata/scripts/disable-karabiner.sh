#!/bin/bash
# Stop Karabiner-Elements grabber permanently (survives reboot).
# VirtualHID driver/daemon stays — Kanata needs it.
set -euo pipefail

UID_NUM="$(id -u)"

osascript -e 'quit app "Karabiner-Elements"' 2>/dev/null || true
osascript -e 'quit app "Karabiner-EventViewer"' 2>/dev/null || true
osascript -e 'quit app "Karabiner-Elements Settings"' 2>/dev/null || true

USER_LABELS=(
  org.pqrs.service.agent.Karabiner-Menu
  org.pqrs.service.agent.Karabiner-Core-Service
  org.pqrs.service.agent.Karabiner-Core-Service-rev2
  org.pqrs.service.agent.Karabiner-NotificationWindow
  org.pqrs.service.agent.karabiner_console_user_server
  org.pqrs.service.agent.karabiner_session_monitor
)

for label in "${USER_LABELS[@]}"; do
  launchctl disable "gui/${UID_NUM}/${label}" 2>/dev/null || true
  launchctl bootout "gui/${UID_NUM}/${label}" 2>/dev/null || true
done

pkill -x Karabiner-Core-Service 2>/dev/null || true
pkill -x Karabiner-NotificationWindow 2>/dev/null || true
pkill -x karabiner_console_user_server 2>/dev/null || true
pkill -x Karabiner-Menu 2>/dev/null || true
pkill -x Karabiner-Elements 2>/dev/null || true

osascript <<'APPLESCRIPT'
do shell script "
launchctl disable system/org.pqrs.service.daemon.Karabiner-Core-Service
launchctl bootout system/org.pqrs.service.daemon.Karabiner-Core-Service 2>/dev/null || true
# Keep VirtualHID for Kanata
launchctl enable system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon
launchctl kickstart system/org.pqrs.service.daemon.Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || true
" with administrator privileges
APPLESCRIPT

osascript <<'APPLESCRIPT' 2>/dev/null || true
tell application "System Events"
  set loginItems to (get every login item)
  repeat with i in loginItems
    if (name of i as string) contains "Karabiner" then
      delete i
    end if
  end repeat
end tell
APPLESCRIPT

echo "Karabiner grabber disabled (persists across reboot)."
echo "VirtualHID daemon left running for Kanata."
echo "If it still appears after reboot: System Settings → General → Login Items"
echo "→ Allow in the Background → turn off Karabiner-Core-Service / Karabiner-Elements."
