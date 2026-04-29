# 🎯 Dotfiles with GNU Stow

Modular dotfiles for **macOS** and **Linux** using **GNU Stow** for clean, maintainable symlink management.

## 🏗️ Structure

```
dotfiles/
├── common/              # Shared configs (nvim, tmux, wezterm, git, etc.)
│   ├── .config/
│   ├── .zsh/            # Modular shell functions
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .tmux.conf
│   └── Brewfile         # Homebrew dependencies
│
├── macos/               # macOS-specific configs
│   ├── .config/         # sketchybar, karabiner, kanata, borders
│   ├── .zprofile
│   ├── .zsh/
│   └── .aerospace.toml
│
├── linux/               # Linux-specific configs
│   ├── .config/
│   └── .zsh/
│
├── hosts/
│   └── macbook/         # Host-specific overrides
│       └── .zsh/
│
├── private/             # 🔐 Secrets (NOT in git)
│   └── .zsh.private     # tokens, credentials
│
├── scripts/             # Bootstrap automation
│   ├── bootstrap-macos.sh
│   ├── bootstrap-linux.sh
│   └── install-stow.sh
│
└── README.md
```

## 🚀 Quick Start

### macOS

```bash
# Clone the repo
git clone https://github.com/yourusername/dotfiles ~/dotfiles
cd ~/dotfiles

# Run bootstrap
./scripts/bootstrap-macos.sh

# Or manually:
# brew install stow
# stow common
# stow macos
# stow hosts/macbook
```

### Linux

```bash
git clone https://github.com/yourusername/dotfiles ~/dotfiles
cd ~/dotfiles
./scripts/bootstrap-linux.sh
```

## 📋 What's Configured

✅ **Shell (Zsh)**
- Modular zsh config in `.zsh/` (aliases, exports, functions, completions, plugins)
- Platform-specific overrides (macos.zsh, linux.zsh)
- Host-specific setup (host.zsh)

✅ **Editors**
- Neovim with LazyVim
- IdeaVim

✅ **Terminal & Multiplexers**
- WezTerm (cross-platform)
- tmux
- starship prompt
- p10k theme

✅ **CLI Tools**
- lazygit
- yazi (file manager)
- GitHub CLI
- fzf

✅ **macOS-Only**
- AeroSpace (tiling window manager)
- Karabiner (key remapping)
- Kanata (keyboard config)
- SketchyBar (menu bar)
- Borders

✅ **Git**
- Unified .gitconfig
- Platform-specific local overrides (.gitconfig.local)
- Global .gitignore

✅ **Package Management**
- Homebrew Brewfile for dependencies

## 🔧 How to Use

### Verify Symlinks Are Correct

After bootstrap, check that configs are symlinked (not copied):

```bash
# Should show symlinks pointing to ~/dotfiles:
ls -la ~/.zshrc
ls -la ~/.config/nvim
ls -la ~/.tmux.conf
ls -la ~/.config/starship.toml

# Example output:
# .zshrc -> dotfiles/common/.zshrc
# .config/nvim/init.lua -> ../../dotfiles/common/.config/nvim/init.lua
```

### Add a New Config

1. Place the file in the correct package directory:
   - `common/` for cross-platform files
   - `macos/` for macOS-specific
   - `linux/` for Linux-specific
   - `hosts/macbook/` for host-specific

2. Re-stow the package:
```bash
cd ~/dotfiles
stow -R common  # -R to restow (replace existing)
# or re-run the full bootstrap
```

### Update Configs

```bash
cd ~/dotfiles
git pull
# Changes apply immediately (symlinks)
```

### Add a New Machine

1. Create new host directory:
```bash
mkdir -p hosts/new-hostname
mkdir -p hosts/new-hostname/.config
mkdir -p hosts/new-hostname/.zsh
```

2. Add host-specific overrides to `hosts/new-hostname/`

3. Stow it:
```bash
cd ~/dotfiles
stow hosts/new-hostname
```

### Add Linux Support

1. Add configs to `linux/`:
```bash
mkdir -p linux/.config/nvim  # if using platform-specific nvim
mkdir -p linux/.zsh
```

2. Update `linux/.zsh/linux.zsh` with Linux-specific exports

3. On Linux, run:
```bash
cd ~/dotfiles
stow common
stow linux
```

## 🔐 Managing Secrets

**Never commit secrets to this repo!**

Safe ways to handle credentials:

### Option 1: Local files (gitignored)
```bash
# .gitignore includes:
*.local
.env

# Create local overrides:
~/.zshrc.local      # sourced from .zshrc if exists
~/.gitconfig.local  # included by .gitconfig
```

### Option 2: Private directory
```bash
# dotfiles/private/ is gitignored
# Add to private/:
private/.zsh.private    # API tokens, etc.

# Source in .zshrc:
[[ -r ~/.zsh.private ]] && source ~/.zsh.private
```

### Option 3: Environment variables
```bash
# Use .env file (gitignored)
# Load with: source ~/.env (or setup in your shell)
```

## 🔄 Rollback / Unstow

If something breaks:

```bash
# Unstow a package
cd ~/dotfiles
stow -D common      # remove common package
stow -D macos       # remove macos package

# Or restore from backup (if available)
cp ~/.zshrc.bak-<timestamp> ~/.zshrc
```

## 🛠️ Maintenance

### Check Stow Status

```bash
cd ~/dotfiles
# List what stow will do (dry run)
stow --simulate common
stow --simulate macos
```

### Find Orphaned Links

```bash
# Find broken symlinks in home
find ~/ -maxdepth 1 -type l ! -valid -exec ls -la {} \;
```

### Update Brewfile

```bash
cd ~/dotfiles
brew bundle dump --file=common/Brewfile --force
git add common/Brewfile
git commit -m "Update Brewfile"
```

## 🆘 Troubleshooting

### "ERROR: could not expand target"

This usually means stow found an existing file that isn't owned by stow.
- **Solution**: Back it up and delete it, then restow:
```bash
mv ~/.zshrc ~/.zshrc.backup
cd ~/dotfiles && stow common
```

### Symlinks point to wrong path

Check the symlink:
```bash
ls -la ~/.zshrc
# If it shows: .zshrc -> /old/path/...
# Delete it and restow:
rm ~/.zshrc
cd ~/dotfiles && stow common
```

### Shell doesn't load after stowing

Verify the symlink exists and is correct:
```bash
cat ~/.zshrc  # should show content from dotfiles, not an error
exec $SHELL   # reload shell
```

## 📖 Further Reading

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [Why Stow?](https://www.gnu.org/software/stow/manual/stow.html#Introduction)

## 📝 License

Personal dotfiles. Feel free to adapt and use in your setup.
