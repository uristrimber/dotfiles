# dotfiles — advanced

> Looking for the friendly tour of what these tools actually do? See [README.md](README.md) (English) or [README.es.md](README.es.md) (español).

Personal macOS setup: zsh + Oh My Zsh + Powerlevel10k, Homebrew, iTerm2, and a Brewfile that captures every formula, cask, and VS Code extension currently installed.

## Bootstrap a fresh Mac

```bash
git clone https://github.com/uristrimber/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer is idempotent — safe to re-run after pulling updates.

## What it does

1. Installs Xcode Command Line Tools (if missing).
2. Installs Homebrew (if missing).
3. Runs `brew bundle` against [Brewfile](Brewfile) — formulae, casks, taps.
4. Installs VS Code extensions listed in [vscode-extensions.txt](vscode-extensions.txt) (skipped if `code` CLI isn't on PATH).
5. Installs [Oh My Zsh](https://ohmyz.sh/), [Powerlevel10k](https://github.com/romkatv/powerlevel10k), and the [zsh-shift-select](https://github.com/jirutka/zsh-shift-select) custom plugin.
6. Symlinks the dotfiles into `$HOME` (existing files are renamed `.backup`).
7. Imports the iTerm2 preferences plist.
8. Sets the default shell to Homebrew's zsh.

Stats settings are imported through the Stats app itself — see [Importing Stats settings](#importing-stats-settings) below.

## Layout

```text
.
├── Brewfile               # formulae, casks, taps
├── vscode-extensions.txt  # VS Code extension IDs (one per line)
├── install.sh             # bootstrap script
├── home/                  # files that live directly in $HOME
│   ├── .zshrc
│   ├── .zprofile
│   ├── .p10k.zsh
│   └── .gitconfig
├── zsh/                   # auto-sourced by .zshrc → ~/.zsh
│   ├── aliases.zsh
│   ├── env.zsh
│   ├── functions.zsh      # fd, fh, fkill, fbr (fzf-powered)
│   └── path.zsh
└── config/
    ├── git/ignore         # global gitignore
    ├── iterm2/com.googlecode.iterm2.plist
    └── stats/Stats.plist  # Stats menu-bar app (exelban/stats)
```

The Stats configuration produces this menu bar layout:

![Stats menu bar preview](docs/stats-menubar.png)

Drop new files into `zsh/` (matching `*.zsh`) and they're sourced automatically — no `.zshrc` edits needed.

## Importing Stats settings

`defaults import` doesn't reliably take effect for Stats because of macOS's preference cache, so import the settings through the app instead:

1. Make sure Stats is installed (`brew bundle` handles this) and launched at least once — its menu-bar icon (toggle/sliders, far right) should be visible.
2. Click the Stats icon in the menu bar to open the popup, then click the **gear** icon in the popup's bottom-right to open **Settings**.
3. In the sidebar, scroll to the bottom and select **Settings** (or **Application**, depending on the version).
4. Click **Import** and pick `~/dotfiles/config/stats/Stats.plist`.
5. Confirm the prompt — Stats will reload with the imported configuration.

## Updating from the source machine

After changing a config locally, sync it back into the repo and commit:

```bash
cp ~/.zshrc ~/dotfiles/home/.zshrc
cp ~/.zsh/*.zsh ~/dotfiles/zsh/
brew bundle dump --file=~/dotfiles/Brewfile --force --describe
sed -i '' '/^vscode /d' ~/dotfiles/Brewfile
code --list-extensions > ~/dotfiles/vscode-extensions.txt
plutil -convert xml1 -o ~/dotfiles/config/iterm2/com.googlecode.iterm2.plist \
  ~/Library/Preferences/com.googlecode.iterm2.plist
defaults export eu.exelban.Stats ~/dotfiles/config/stats/Stats.plist
cd ~/dotfiles && git add -A && git commit -m "sync"
```

## NOT included (and why)

- `~/.ssh/` — private keys. Generate fresh on each machine.
- `~/.gnupg/` — private GPG signing key. Export via `gpg --export-secret-keys` and move it manually through a secure channel.
- `~/.zsh_history` — may contain pasted secrets in the future, never worth versioning.
- `~/.iterm2_shell_integration.zsh` — vendor file, regenerated on first iTerm2 run.
- `~/.oh-my-zsh/` — installer takes care of it; only your custom additions are tracked.
