# 🔧 macOS Dotfiles

Чистый репозиторий конфигурационных файлов для macOS с поддержкой Linux.

## 📦 Что входит

- **Neovim** - конфигурация редактора (Lua, Lazy.nvim)
- **tmux** - сессии терминала с кроссплатформенной поддержкой
- **WezTerm** - современный терминал с красивой конфигурацией
- **Zsh** - модульная оболочка (base, exports, aliases, functions, completion, plugins)
- **Starship** - быстрый кастомный prompt
- **Yazi** - файловый менеджер TUI
- **Lazygit** - интерактивный git UI
- **GitHub CLI** - конфигурация gh
- **Homebrew** - список пакетов (Brewfile)
- **Git** - основной и локальный конфиги
- **Прочее:** AeroSpace, Borders, Kanata, Karabiner, Sketchybar

## 🚀 Быстрый старт (с нуля)

### 1. Клонировать репозиторий
```bash
cd ~
git clone https://github.com/your-username/dotfiles.git
cd dotfiles
```

### 2. Запустить bootstrap
```bash
bash scripts/bootstrap-macos.sh
```

Этот скрипт:
- ✅ Установит GNU Stow (если нет)
- ✅ Установит пакеты из Brewfile
- ✅ Создаст symlinks для всех конфигов
- ✅ Загрузит модули Zsh

## 📁 Структура

```
dotfiles/
├── common/                    # Общие конфиги (macOS + Linux)
│   ├── .config/
│   │   ├── nvim/              # Neovim (Lua, Lazy, LSP, Copilot)
│   │   ├── wezterm/           # WezTerm с модулями colors/keys
│   │   ├── yazi/              # Файловый менеджер
│   │   ├── lazygit/           # Git UI
│   │   ├── starship.toml       # Prompt
│   │   ├── ghostty/           # Ghostty (опционально)
│   │   ├── gh/                # GitHub CLI
│   │   └── github-copilot/    # GitHub Copilot (в private/)
│   ├── .zsh/                  # Модули Zsh (загружаются в .zshrc)
│   │   ├── base.zsh           # Базовые опции
│   │   ├── exports.zsh        # Переменные окружения
│   │   ├── aliases.zsh        # Aliases (ll, lg, и т.д.)
│   │   ├── functions.zsh      # Shell функции
│   │   ├── completion.zsh     # Completion системы
│   │   └── plugins.zsh        # Plugin менеджеры
│   ├── .zshrc                 # Главный конфиг оболочки
│   ├── .gitconfig             # Git конфиг (user.name, user.email)
│   ├── .gitignore_global      # Глобальный .gitignore
│   ├── .p10k.zsh              # Powerlevel10k prompt
│   ├── .tmux.conf             # tmux конфиг
│   ├── .ideavimrc             # IdeaVim (для JetBrains IDE)
│   ├── .wezterm.lua           # Альтернативная загрузка WezTerm
│   └── Brewfile               # Homebrew пакеты
│
├── macos/                     # macOS-специфичные конфиги
│   ├── .config/
│   │   ├── borders/           # Window borders decoration
│   │   ├── kanata/            # Раскладка клавиатуры (Karabiner замена)
│   │   ├── karabiner/         # Ремапирование клавиш
│   │   ├── sketchybar/        # Статус бар (замена Menu Bar)
│   │   ├── tmux/              # macOS-специфичные tmux настройки
│   │   └── wezterm/           # macOS override для WezTerm
│   ├── .zsh/
│   │   └── macos.zsh          # macOS-специфичные переменные (ssh-agent, и т.д.)
│   ├── .zprofile              # macOS login shell (PATH и т.д.)
│   ├── .aerospace.toml        # Window manager AeroSpace
│   ├── .gitconfig.local       # Локальные git настройки (НЕ коммитятся!)
│   └── .macos                 # macOS startup скрипт
│
├── linux/                     # Linux-специфичные конфиги (skeleton)
│   ├── .config/
│   │   ├── wezterm/
│   │   │   └── linux.lua       # Linux override для WezTerm
│   │   └── tmux/
│   │       └── linux.conf      # Linux-специфичные tmux настройки
│   └── .zsh/
│       └── linux.zsh          # Linux-специфичные переменные
│
├── hosts/
│   └── macbook/               # Машина-специфичные конфиги (HOSTNAME-specific)
│       ├── .config/
│       └── .zsh/
│           └── host.zsh       # Только для этой машины
│
├── private/                   # ❌ НЕ КОММИТЯТСЯ (в .gitignore)
│   ├── .config/
│   │   ├── github-copilot/    # GitHub OAuth токены
│   │   │   ├── apps.json      # App credentials
│   │   │   └── oauth.json     # OAuth tokens
│   │   └── gh/
│   │       └── hosts.yml      # GitHub hosts config
│   └── .zsh.private           # Приватные экспорты (API ключи, и т.д.)
│
├── scripts/
│   ├── bootstrap-macos.sh     # Полная установка для macOS (стартовый скрипт)
│   ├── bootstrap-linux.sh     # Полная установка для Linux
│   ├── install-stow.sh        # Установка GNU Stow (если нужен)
│   └── sync.sh                # Синхронизация изменений (pull + restow)
│
├── .gitignore                 # Исключить private/, *.local, .env, и т.д.
├── README.md                  # Этот файл
└── LICENSE
```

## 🔧 Использование

### Добавить новый конфиг

Пример: добавить конфиг для Rust-tool

1. **Скопировать конфиг в dotfiles**
```bash
# Если инструмент кроссплатформенный (общий):
mkdir -p ~/dotfiles/common/.config/rust-tool
cp -r ~/.config/rust-tool/* ~/dotfiles/common/.config/rust-tool/

# Если macOS-специфичный:
mkdir -p ~/dotfiles/macos/.config/rust-tool
cp -r ~/.config/rust-tool/* ~/dotfiles/macos/.config/rust-tool/
```

2. **Удалить оригинал и создать symlink**
```bash
# Удалим оригинал (он теперь в dotfiles!)
rm -rf ~/.config/rust-tool

# Создадим symlink на dotfiles версию:
ln -s ~/dotfiles/common/.config/rust-tool ~/.config/rust-tool
# или для macOS:
ln -s ~/dotfiles/macos/.config/rust-tool ~/.config/rust-tool
```

3. **Добавить в git и коммитить**
```bash
cd ~/dotfiles
git add -A
git commit -m "Add rust-tool config"
git push
```

### Обновить конфиги (sync)

После изменения конфига:
```bash
cd ~/dotfiles
bash scripts/sync.sh
```

Этот скрипт:
- 🔄 Стягивает последние изменения (git pull)
- 🔗 Пересоздаёт symlinks (stow -R)

### Откатить если что-то сломалось

```bash
# Восстановить backup
cp -R ~/dotfiles.backup-20260429-033411/* ~/dotfiles/

# Или просто переустановить symlinks:
cd ~/dotfiles
bash scripts/bootstrap-macos.sh
```

## 🔐 Секреты и Приватные Конфиги

**НИКОГДА не коммитьте токены, пароли, credentials!**

Используйте `private/` для всего, что содержит:
- 🔑 API ключи
- 🔐 OAuth tokens
- 🛡️ SSH ключи
- 💳 Credentials

**private/** папка автоматически исключена в .gitignore.

Пример (.zsh.private):
```bash
# private/.zsh.private
export GITHUB_TOKEN="ghp_..."
export AWS_SECRET_ACCESS_KEY="..."
```

Загружайте в .zshrc:
```bash
# .zshrc
[ -f ~/.zsh.private ] && source ~/.zsh.private
```

## 🖥️ Добавить новую машину (Linux или другую macOS)

### Новый хост (машина-специфичные конфиги):
```bash
cd ~/dotfiles
mkdir -p hosts/laptop-name/.config
mkdir -p hosts/laptop-name/.zsh

# Добавить машина-специфичные конфиги
echo "export HOSTNAME_SPECIFIC_VAR=value" > hosts/laptop-name/.zsh/host.zsh
```

### Новая платформа (Linux):

1. Обновить **linux/.zsh/** с Linux-специфичными переменными
2. Обновить **linux/.config/** с Linux конфигами (если нужны)
3. Запустить bootstrap-linux.sh:
```bash
bash scripts/bootstrap-linux.sh
```

## 📜 Что делают скрипты?

### 1. `bootstrap-macos.sh`
**Полная установка для macOS с нуля**

Что делает:
```
1. Проверяет GNU Stow (устанавливает если нет)
2. Устанавливает Homebrew пакеты (из Brewfile)
3. Создаёт symlinks для всех конфигов:
   - common/
   - macos/
   - hosts/macbook/
4. Выводит итоговое сообщение
```

Когда использовать: **Первая установка на новой машине**

### 2. `bootstrap-linux.sh`
**Полная установка для Linux**

Похож на macos.sh, но:
- Не использует brew (вместо этого apt/yum/pacman)
- Стоует `common` + `linux` (не macos)

### 3. `install-stow.sh`
**Установка GNU Stow (вспомогательный)**

Что делает:
```
1. Проверяет есть ли stow в PATH
2. Если нет - устанавливает:
   - На macOS: через brew
   - На Linux: через apt/yum/pacman
```

Используется: Вызывается из bootstrap скриптов

### 4. `sync.sh`
**Синхронизация изменений из GitHub**

Что делает:
```
1. Стягивает последние изменения: git pull --rebase
2. Пересоздаёт symlinks: stow -R
3. Обновляет всё до актуального состояния
```

Когда использовать: **После git pull или если symlinks сломались**

## 🔄 Workflow: Как это работает?

### Установка:
```bash
cd ~
git clone https://github.com/your-username/dotfiles.git
cd dotfiles
bash scripts/bootstrap-macos.sh
# Теперь ~/.config/nvim → ~/dotfiles/common/.config/nvim
# И все остальные конфиги подключены!
```

### День в день:
```bash
# Редактируете конфиг (например nvim):
vim ~/.config/nvim/init.lua

# На самом деле редактируете:
# ~/dotfiles/common/.config/nvim/init.lua (через symlink!)

# Коммитите изменения:
cd ~/dotfiles
git add .
git commit -m "Update nvim config"
git push
```

### Синхронизация на другой машине:
```bash
cd ~/dotfiles
git pull
bash scripts/sync.sh
# Все конфиги обновлены!
```

### Откат:
```bash
# Если что-то сломалось:
cd ~/dotfiles
git revert <commit-hash>
bash scripts/sync.sh
```

## 🛠️ Требования

- macOS 13+ (для bootstrap-macos.sh)
- Linux Ubuntu 20+, Debian, Fedora, Arch (для bootstrap-linux.sh)
- Zsh (не bash, так как используются zsh-специфичные функции)
- Git
- Homebrew (только для macOS)

## 📝 Примечания

- Все конфиги хранятся в git как **реальные файлы**
- Symlinks создаются автоматически в ~/ и ~/.config/
- `private/` папка **НЕ коммитится** (в .gitignore)
- Можно безопасно делать `git clone`, `bootstrap`, и ничего не поломается

## 🔗 GNU Stow

Этот репозиторий использует GNU Stow для управления symlinks.

**Что это?** Stow - утилита которая:
- Берёт файлы из подпапок (common, macos, linux)
- Создаёт symlinks в родительской папке (~/)

**Зачем?** Чтобы не копировать файлы, а ссылаться на них в git

Пример:
```
Структура в git:
dotfiles/common/.zshrc

После stow:
~/.zshrc → ~/dotfiles/common/.zshrc (symlink)
```

## 📄 Лицензия

MIT

---

**Вопросы?** Смотри файл плана или создавай issues в GitHub!

Удачи с конфигурацией! 🚀
