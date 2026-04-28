if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
  RUNNING_AGENT="$(ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]')"
  if [ "$RUNNING_AGENT" = "0" ]; then
    ssh-agent -s &> "$HOME/.ssh/ssh-agent"
  fi
  eval "$(cat "$HOME/.ssh/ssh-agent")"
fi
