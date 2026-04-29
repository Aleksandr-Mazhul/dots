# --- Linuxbrew (if installed) ---
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Linux shell plugins ---
# Search common install paths: distro packages, manual installs, Linuxbrew.
_zsh_plugin_dirs=(/usr/share /usr/local/share "$HOME/.local/share" /home/linuxbrew/.linuxbrew/share)

for dir in "${_zsh_plugin_dirs[@]}"; do
  [[ -f "$dir/powerlevel10k/powerlevel10k.zsh-theme" ]] && { source "$dir/powerlevel10k/powerlevel10k.zsh-theme"; break; }
done

for dir in "${_zsh_plugin_dirs[@]}"; do
  [[ -f "$dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && { source "$dir/zsh-autosuggestions/zsh-autosuggestions.zsh"; break; }
done

for dir in "${_zsh_plugin_dirs[@]}"; do
  [[ -f "$dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && { source "$dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; break; }
done

unset _zsh_plugin_dirs
