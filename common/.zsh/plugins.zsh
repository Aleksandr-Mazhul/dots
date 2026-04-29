# --- Powerlevel10k ---
# Theme is sourced per-platform (macos.zsh / linux.zsh) since install paths differ.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- FZF ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey -r '^[c'
bindkey '^I' expand-or-complete
bindkey '^G' fzf-cd-widget

# --- Zoxide ---
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# --- Autosuggestions & Syntax Highlighting ---
# Sourced per-platform (macos.zsh / linux.zsh) since install paths differ.
