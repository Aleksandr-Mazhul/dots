# Dotfiles (GNU Stow)

Modular dotfiles for macOS/Linux with GNU Stow.

## Structure

- `common/` — shared configs
- `macos/` — macOS overrides
- `linux/` — Linux overrides
- `hosts/macbook/` — host-specific files
- `private/` — secrets/private files (ignored by git)
- `scripts/` — bootstrap and sync scripts

## Install (macOS)

```bash
cd ~/dotfiles
./scripts/bootstrap-macos.sh
```

## Install (Linux)

```bash
cd ~/dotfiles
./scripts/bootstrap-linux.sh
```

## Update

```bash
cd ~/dotfiles
./scripts/sync.sh
```

## Add new config

1. Put file under the right package (`common/`, `macos/`, `linux/`, `hosts/...`).
2. Re-apply stow:

```bash
cd ~/dotfiles
stow -R common
stow -R macos      # on macOS
stow -R linux      # on Linux
```

## Add Linux machine

1. Clone repo to `~/dotfiles`.
2. Fill Linux-specific files in `linux/`.
3. Run:

```bash
cd ~/dotfiles
./scripts/bootstrap-linux.sh
```

## Secrets

- Never commit secrets.
- Keep sensitive files in `private/`, `*.local`, or `.env`.
- `private/` is gitignored.

## Rollback

Backups are created before replacing existing targets:

```bash
cp -R <target> <target>.bak-<timestamp>
```

To rollback, restore backup and restow:

```bash
cp -R ~/.zshrc.bak-<timestamp> ~/.zshrc
cd ~/dotfiles && stow -D common -D macos -D hosts/macbook
```
