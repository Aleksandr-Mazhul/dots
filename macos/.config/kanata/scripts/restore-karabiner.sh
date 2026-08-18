#!/bin/bash
# Stop Kanata and bring Karabiner-Elements back.
set -euo pipefail
BACKUP="${HOME}/dotfiles/macos/.config/keyboard-backup-20260817-195331"

UID_NUM="$(id -u)"

osascript -e 'do shell script "
  launchctl bootout system/dev.kanata.disable-karabiner 2>/dev/null || true
  launchctl disable system/dev.kanata.disable-karabiner 2>/dev/null || true
  launchctl bootout system/dev.kanata.kanata 2>/dev/null || true
  pkill -x kanata 2>/dev/null || true
  launchctl enable system/org.pqrs.service.daemon.Karabiner-Core-Service
  launchctl kickstart -k system/org.pqrs.service.daemon.Karabiner-Core-Service 2>/dev/null || true
" with administrator privileges' || true

for label in \
  org.pqrs.service.agent.Karabiner-Menu \
  org.pqrs.service.agent.Karabiner-Core-Service \
  org.pqrs.service.agent.Karabiner-Core-Service-rev2 \
  org.pqrs.service.agent.Karabiner-NotificationWindow \
  org.pqrs.service.agent.karabiner_console_user_server \
  org.pqrs.service.agent.karabiner_session_monitor
do
  launchctl enable "gui/${UID_NUM}/${label}" 2>/dev/null || true
done

open -a "Karabiner-Elements" || true

echo "Kanata stopped, Karabiner-Elements launched."
echo "Full config backup (if you also want the old kanata files):"
echo "  $BACKUP/RESTORE.sh"
