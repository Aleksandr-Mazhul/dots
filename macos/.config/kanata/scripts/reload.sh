#!/bin/bash
# After granting Input Monitoring + Accessibility to /usr/local/bin/kanata,
# reload the daemon.
set -euo pipefail
osascript -e 'do shell script "launchctl kickstart -k system/dev.kanata.kanata" with administrator privileges'
echo "Reloaded. Last log lines:"
sleep 3
tail -20 /var/log/kanata.log 2>/dev/null || true
