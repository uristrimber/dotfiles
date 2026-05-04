# dotfiles

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
3. Runs `brew bundle` against [Brewfile](Brewfile) — formulae, casks, taps, VS Code extensions.
4. Installs [Oh My Zsh](https://ohmyz.sh/), [Powerlevel10k](https://github.com/romkatv/powerlevel10k), and the [zsh-shift-select](https://github.com/jirutka/zsh-shift-select) custom plugin.
5. Symlinks the dotfiles into `$HOME` (existing files are renamed `.backup`).
6. Imports the iTerm2 preferences plist.
7. Sets the default shell to Homebrew's zsh.

## Layout

```
.
├── Brewfile              # all installed formulae/casks/taps/vscode-extensions
├── install.sh            # bootstrap script
├── home/                 # files that live directly in $HOME
│   ├── .zshrc
│   ├── .zprofile
│   ├── .p10k.zsh
│   └── .gitconfig
├── zsh/                  # auto-sourced by .zshrc → ~/.zsh
│   ├── aliases.zsh
│   ├── env.zsh
│   ├── functions.zsh     # fd, fh, fkill, fbr (fzf-powered)
│   └── path.zsh
└── config/
    ├── git/ignore        # global gitignore
    └── iterm2/com.googlecode.iterm2.plist
```

Drop new files into `zsh/` (matching `*.zsh`) and they're sourced automatically — no `.zshrc` edits needed.

## Updating from the source machine

After changing a config locally, sync it back into the repo and commit:

```bash
cp ~/.zshrc ~/dotfiles/home/.zshrc
cp ~/.zsh/*.zsh ~/dotfiles/zsh/
brew bundle dump --file=~/dotfiles/Brewfile --force --describe
plutil -convert xml1 -o ~/dotfiles/config/iterm2/com.googlecode.iterm2.plist \
  ~/Library/Preferences/com.googlecode.iterm2.plist
cd ~/dotfiles && git add -A && git commit -m "sync"
```

## NOT included (and why)

- `~/.ssh/` — private keys. Generate fresh on each machine.
- `~/.gnupg/` — private GPG signing key. Export via `gpg --export-secret-keys` and move it manually through a secure channel.
- `~/.zsh_history` — may contain pasted secrets in the future, never worth versioning.
- `~/.iterm2_shell_integration.zsh` — vendor file, regenerated on first iTerm2 run.
- `~/.oh-my-zsh/` — installer takes care of it; only your custom additions are tracked.
