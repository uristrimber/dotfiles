#!/usr/bin/env bash
# Bootstrap a fresh macOS install from this dotfiles repo.
# Idempotent: safe to re-run.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "==> Dotfiles: $DOTFILES"

# 1. Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "==> Installing Xcode Command Line Tools (accept the GUI prompt)"
  xcode-select --install
  read -rp "Press enter once Xcode CLT is installed..."
fi

# 2. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# 3. Brewfile (formulae, casks, taps)
echo "==> brew bundle"
brew bundle --file="$DOTFILES/Brewfile"

# 3b. VS Code extensions
if command -v code >/dev/null 2>&1; then
  echo "==> Installing VS Code extensions"
  while IFS= read -r ext; do
    [[ -z "$ext" || "$ext" == \#* ]] && continue
    code --install-extension "$ext" --force
  done < "$DOTFILES/vscode-extensions.txt"
else
  echo "==> Skipping VS Code extensions: 'code' CLI not on PATH."
  echo "    Install VS Code, then run \"Shell Command: Install 'code' command in PATH\""
  echo "    from the Command Palette, then re-run this script."
fi

# 4. Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 5. Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  echo "==> Cloning powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# 6. zsh-shift-select plugin
SHIFT_SEL_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-shift-select"
if [[ ! -d "$SHIFT_SEL_DIR" ]]; then
  echo "==> Cloning zsh-shift-select"
  git clone --depth=1 https://github.com/jirutka/zsh-shift-select.git "$SHIFT_SEL_DIR"
fi

# 7. Symlink dotfiles
link() {
  local src="$1" dest="$2"
  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    echo "==> Backing up existing $dest -> $dest.backup"
    mv "$dest" "$dest.backup"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "    linked $dest -> $src"
}

echo "==> Linking dotfiles"
link "$DOTFILES/home/.zshrc"     "$HOME/.zshrc"
link "$DOTFILES/home/.zprofile"  "$HOME/.zprofile"
link "$DOTFILES/home/.p10k.zsh"  "$HOME/.p10k.zsh"
link "$DOTFILES/home/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/zsh"             "$HOME/.zsh"
link "$DOTFILES/config/git/ignore" "$HOME/.config/git/ignore"

# 8. iTerm2 preferences
if [[ -f "$DOTFILES/config/iterm2/com.googlecode.iterm2.plist" ]]; then
  echo "==> Importing iTerm2 preferences"
  echo "    Quit iTerm2 first if it's open, then press enter."
  read -r
  defaults import com.googlecode.iterm2 \
    "$DOTFILES/config/iterm2/com.googlecode.iterm2.plist"
fi

# 9. Default shell -> zsh (homebrew version)
BREW_ZSH="$(brew --prefix)/bin/zsh"
if [[ -x "$BREW_ZSH" ]] && [[ "$SHELL" != "$BREW_ZSH" ]]; then
  echo "==> Setting default shell to $BREW_ZSH"
  if ! grep -qx "$BREW_ZSH" /etc/shells; then
    echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$BREW_ZSH"
fi

cat <<'EOF'

==> Bootstrap complete. Next steps:
  1. Restart your terminal (or `exec zsh`).
  2. Run `p10k configure` if you want to re-tune the prompt.
  3. Set up your SSH and GPG keys (NOT included in this repo):
       ssh-keygen -t ed25519 -C "your_email"
       gpg --full-generate-key
     Then update ~/.gitconfig signingkey if it changed.
  4. `gh auth login` to sign in to GitHub.

EOF
