# Uri's macOS setup

> 🇪🇸 [Leer en español](README.es.md)

A friendly tour of the tools, shell tweaks, and apps I rely on every day on macOS. This is a showcase, not a tutorial — but if you actually want to clone and install the same setup, [`./install.sh`](install.sh) handles it in one shot. See [advanced-readme.md](advanced-readme.md) for the technical details.

> If you're a friend who's curious what I use: keep reading. If you want to actually replicate the setup, jump to [advanced-readme.md](advanced-readme.md).

---

## The shell

I replaced bash with **zsh** — faster, smarter completion, recursive path expansion (`/u/lo/b` → `/usr/local/bin`), better history, and infinitely more customizable. On top of that, [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) gives me a sane way to manage plugins and themes.

### Powerlevel10k prompt

The prompt shows: current directory, git status (commits to push/pull, dirty files, stashes), how long the last command took, and a few system stats. Loads instantly thanks to its async rendering — you can start typing before the shell finishes booting.

![Powerlevel10k prompt styles](https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png)

*Lean, Classic, and Rainbow styles, all configurable via `p10k configure`.*

[Project →](https://github.com/romkatv/powerlevel10k)

### Autosuggestions and syntax highlighting

- **`zsh-autosuggestions`** — greys out a guess from your history. <kbd>→</kbd> accepts it.
- **`zsh-syntax-highlighting`** — colors valid commands green and broken ones red *before* you hit enter, so typos are obvious at a glance.

[![zsh-autosuggestions demo](https://asciinema.org/a/37390.png)](https://asciinema.org/a/37390)

*Click for the asciinema cast.*

---

## Better defaults for everyday commands

The basics — `ls`, `cat`, `cd` — replaced with modern equivalents.

| What I type | What actually runs | Why |
|---|---|---|
| `ls` | [`eza`](https://github.com/eza-community/eza) | Colors, icons, git status all baked in |
| `cat` | [`bat`](https://github.com/sharkdp/bat) | Syntax highlighting + line numbers + paging |
| `z <name>` | [`zoxide`](https://github.com/ajeetdsouza/zoxide) | Smart `cd` that learns your habits |

### eza

A drop-in `ls` replacement with icons, colors, and git status integration.

![eza](https://raw.githubusercontent.com/eza-community/eza/main/docs/images/screenshots.png)

### bat

`cat` with syntax highlighting and automatic paging for long files.

![bat](https://imgur.com/rGsdnDe.png)

### zoxide

`z <fragment>` jumps to the most-frequently-used directory matching the fragment. After a few weeks you stop typing `cd`.

![zoxide demo](https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp)

```sh
z dotfiles      # → ~/dotfiles
z stat          # → ~/some/path/with/stats/
z foo bar       # multi-fragment match
```

### thefuck

Mistyped a command? Type `fuck` and it suggests a fix.

![thefuck demo](https://raw.githubusercontent.com/nvbn/thefuck/master/example.gif)

[Project →](https://github.com/nvbn/thefuck)

---

## Aliases

Defined in [zsh/aliases.zsh](zsh/aliases.zsh). All built on top of `eza`.

| Alias | Expands to | Use case |
|---|---|---|
| `ls` | `eza --icons --group-directories-first` | The new ls |
| `la` / `lla` | `ls -la` | Long listing, all files |
| `ld` | `ls -D` | Directories only |
| `lt` | `ls --tree` | Tree view |
| `lgs` | `ls --git` | With git status icons |
| `ltgs` | `ls --git --tree=3` | Tree view + git status, 3 levels deep |
| `lsgs` | `ls --git -l` | Long listing with git status |
| `cat` | `bat` | Syntax-highlighted cat |

Oh My Zsh ships hundreds of additional aliases via its `git` plugin — `gst`, `gco`, `gcam`, `gp`, etc. Run `alias` in the shell to see the full list.

---

## Custom fzf widgets

Four interactive pickers I built on top of [`fzf`](https://github.com/junegunn/fzf), all sharing the same full-bordered preview style. Source in [zsh/functions.zsh](zsh/functions.zsh).

### `fd` — jump to a directory

Fuzzy-search every subdirectory of the current path and `cd` into the chosen one. Live tree preview on the right.

<!-- TODO docs/fd-widget.png — screenshot of `fd` running with the dir list on the left and the eza tree preview on the right -->
![fd widget](docs/fd-widget.png)

### `fh` — re-run a command from history

Browse your shell history and re-run any past command. Live preview shows the full command with syntax highlighting.

<!-- TODO docs/fh-widget.png — screenshot of `fh` mid-search, with one command highlighted and previewed -->
![fh widget](docs/fh-widget.png)

### `fkill` — pick a process to kill

Multi-select processes with <kbd>Tab</kbd>; <kbd>Enter</kbd> sends `kill -9`. Pass a different signal as the first arg (e.g. `fkill 15`).

<!-- TODO docs/fkill-widget.png — screenshot of fkill with a couple of marked processes -->
![fkill widget](docs/fkill-widget.png)

### `fbr` — checkout a git branch

Local + remote branches with a `git log` preview of whichever is highlighted.

<!-- TODO docs/fbr-widget.png — screenshot of fbr in a real repo with the log preview showing recent commits -->
![fbr widget](docs/fbr-widget.png)

---

## Apps I install (Homebrew casks)

| App | What it is |
|---|---|
| [Brave](https://brave.com/) | Privacy-respecting browser, my daily driver |
| [iTerm2](https://iterm2.com/) | Terminal replacement: split panes, in-line search, profiles, hotkey window |
| [Raycast](https://www.raycast.com/) | Spotlight on steroids — clipboard history, calculator, snippets, custom scripts |
| [Stats](https://github.com/exelban/stats) | CPU / RAM / disk / network / battery in the menu bar |
| [NearDrop](https://github.com/grishka/NearDrop) | Quick Share / Nearby Share for macOS — send & receive files from Android |
| [scrcpy](https://github.com/Genymobile/scrcpy) | Mirror & control an Android device from your Mac, over USB or Wi-Fi |
| [Claude Code](https://www.anthropic.com/claude-code) | CLI AI agent for coding |
| [android-platform-tools](https://developer.android.com/tools/releases/platform-tools) | `adb`, `fastboot`, etc. |

The Stats configuration produces this menu bar:

![Stats menu bar](docs/stats-menubar.png)

---

## Dev tools running in the background

These mostly run as services or get invoked by other tools — I rarely think about them.

| Tool | What it gives me |
|---|---|
| [`postgresql@14`](https://www.postgresql.org/) | Local Postgres database |
| [`redis`](https://redis.io/) | Local cache / message queue |
| [`nginx`](https://nginx.org/) | Local reverse proxy for HTTPS dev domains |
| [`nvm`](https://github.com/nvm-sh/nvm) | Multiple Node.js versions side-by-side |
| [`gnupg`](https://gnupg.org/) + [`pinentry-mac`](https://github.com/GPGTools/pinentry) | Sign git commits & tags with GPG |
| [`mkcert`](https://github.com/FiloSottile/mkcert) | Trusted local TLS certificates with no browser warnings |
| [`nss`](https://wiki.mozilla.org/NSS) | Required by mkcert for Firefox's certificate store |
| [`gh`](https://cli.github.com/) | GitHub from the command line |
| [`fzf`](https://github.com/junegunn/fzf) | The fuzzy finder my custom widgets are built on |
| [`thefuck`](https://github.com/nvbn/thefuck) | Auto-fix the previous mistyped command |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |

---

## VS Code

`./install.sh` also installs ~100 VS Code extensions on a fresh machine, listed in [vscode-extensions.txt](vscode-extensions.txt). The major stacks:

- **Web/JS**: ESLint, Prettier, TailwindCSS, GitLens, Pretty TS Errors
- **PHP/Laravel**: Intelephense, Blade Formatter, Laravel Goto-* helpers
- **Flutter/Dart**: Dart, Flutter, bloc, awesome-flutter-snippets
- **Python**: Pylance, Ruff, Jupyter
- **AI**: Claude Code, GitHub Copilot Chat, Codeium, ChatGPT
- **DX**: Docker, EditorConfig, Material Icon Theme, Code Spell Checker

---

## A note on fonts

Most of the icon-rendering above (in eza, the p10k prompt, etc.) requires a [Nerd Font](https://www.nerdfonts.com/font-downloads) to display correctly. I use **MesloLGS Nerd Font**; **Hack Nerd Font** also works well. Set it in iTerm2 → Profiles → Text → Font.

---

## Going deeper

Everything above is documented technically — installation, file structure, what's intentionally not committed (SSH keys, GPG private keys, `.zsh_history`), how to sync changes from your live config back into the repo — in [advanced-readme.md](advanced-readme.md).
