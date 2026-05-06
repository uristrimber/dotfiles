# Mi setup de Mac

> 🇬🇧 [Read in English](README.en.md)

Una guía amistosa de cómo tengo armada la Mac — qué herramientas uso, qué hace cada una, y por qué me sirven. La idea es más mostrar que tutoriar, pero si te quedás con ganas, [`./install.sh`](install.sh) te deja una Mac vacía igualita a la mía con un solo comando. Ver [advanced-readme.md](advanced-readme.md) para el detalle técnico.

> Si caíste acá porque te mostré algo y te llamó la atención: seguí leyendo. Si querés clonar y darle, andá directo a [advanced-readme.md](advanced-readme.md).

---

## La consola

Cambié bash por **zsh** — más rápido, autocompletado más copado, expansión recursiva del path (`/u/lo/b` se expande a `/usr/local/bin`), historial mejorado y miles de cosas más para customizar. Arriba de eso le metí [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) que es un framework para manejar plugins y temas sin volverse loco.

### El prompt: Powerlevel10k

El prompt te muestra: directorio actual, status de git (commits para pushear/pullear, archivos sin commitear, stashes), cuánto tardó el último comando, y algunas estadísticas del sistema. Carga al toque gracias al *instant prompt* — podés empezar a escribir comandos antes de que termine de bootear la consola.

![Estilos del prompt p10k](https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png)

*Estilos Lean, Classic y Rainbow — todos configurables corriendo `p10k configure`.*

[Proyecto →](https://github.com/romkatv/powerlevel10k)

### zsh-autosuggestions

Te muestra en gris una sugerencia basada en tu historial mientras tipeás. Apretás <kbd>→</kbd> y la aceptás.

[![demo zsh-autosuggestions](https://asciinema.org/a/37390.png)](https://asciinema.org/a/37390)

*Hacé click en la imagen para ver el cast de asciinema.*

### zsh-syntax-highlighting

Te colorea verde los comandos válidos y rojo los rotos *antes* de apretar enter, así los typos cantan.

| Sin el plugin | Con el plugin |
|---|---|
| ![antes](https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master/images/before1.png) | ![después](https://raw.githubusercontent.com/zsh-users/zsh-syntax-highlighting/master/images/after1.png) |

---

## Reemplazos para los comandos de siempre

Los básicos — `ls`, `cat`, `cd` — todos reemplazados por versiones modernas.

| Lo que escribo | Lo que corre realmente | Por qué |
|---|---|---|
| `ls` | [`eza`](https://github.com/eza-community/eza) | Colores, íconos, status de git, todo incluido |
| `cat` | [`bat`](https://github.com/sharkdp/bat) | Syntax highlighting + números de línea + paginado |
| `z <nombre>` | [`zoxide`](https://github.com/ajeetdsouza/zoxide) | `cd` que aprende qué carpetas usás más |

### eza

Reemplazo directo de `ls` — íconos, colores, y el estado de los archivos en git, todo en una.

![eza](https://raw.githubusercontent.com/eza-community/eza/main/docs/images/screenshots.png)

### bat

`cat` con syntax highlighting, números de línea y paginado automático cuando el archivo es largo.

![bat](https://imgur.com/rGsdnDe.png)

### zoxide

`z <pedacito>` te lleva al directorio más usado que matchee el pedazo. Después de unas semanas, dejás de escribir `cd`.

![demo zoxide](https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp)

```sh
z dotfiles      # → ~/dotfiles
z stat          # → ~/algun/path/con/stats/
z foo bar       # match con varios términos
```

### thefuck

¿Te equivocaste tipeando un comando? Escribís `fuck` y te tira la corrección.

![demo thefuck](https://raw.githubusercontent.com/nvbn/thefuck/master/example.gif)

[Proyecto →](https://github.com/nvbn/thefuck)

---

## Mis aliases

Definidos en [zsh/aliases.zsh](zsh/aliases.zsh). Todos arriba de `eza`.

| Alias | Equivale a | Para qué |
|---|---|---|
| `ls` | `eza --icons --group-directories-first` | El nuevo ls |
| `la` / `lla` | `ls -la` | Listado largo, con archivos ocultos |
| `ld` | `ls -D` | Solo directorios |
| `lt` | `ls --tree` | Vista de árbol |
| `lgs` | `ls --git` | Con íconos del status de git |
| `ltgs` | `ls --git --tree=3` | Árbol + git, hasta 3 niveles |
| `lsgs` | `ls --git -l` | Listado largo + git |
| `cat` | `bat` | cat con highlighting |

Oh My Zsh trae también un montón de aliases extra mediante el plugin `git` — `gst`, `gco`, `gcam`, `gp`, etc. Corré `alias` en la consola para ver la lista completa.

---

## Mis funciones fzf

Cuatro pickers interactivos que me armé arriba de [`fzf`](https://github.com/junegunn/fzf), todos con el mismo estilo de border y preview. Código en [zsh/functions.zsh](zsh/functions.zsh).

### `fd` — saltar a un directorio

Hacés fuzzy search por cualquier subdirectorio del path actual y te tira el `cd` automágico. Preview en árbol del lado derecho.

<!-- TODO docs/fd-widget.png — screenshot de `fd` corriendo con la lista de directorios a la izquierda y el preview de eza tree a la derecha -->
![fd](docs/fd-widget.png)

### `fh` — re-correr un comando del historial

Buscás cualquier comando que hayas tipeado y lo volvés a correr. El preview te muestra el comando completo con highlighting.

<!-- TODO docs/fh-widget.png — screenshot de `fh` con varios comandos del historial y uno seleccionado en el preview -->
![fh](docs/fh-widget.png)

### `fkill` — matar un proceso

Multi-select con <kbd>Tab</kbd>; <kbd>Enter</kbd> manda `kill -9`. Si querés mandar otra señal, la pasás como argumento (ej: `fkill 15`).

### `fbr` — checkout de una branch

Branches locales y remotas, con preview del `git log` de la que tengas seleccionada.

<!-- TODO docs/fbr-widget.png — screenshot de fbr corriendo en un repo real con el log de preview -->
![fbr](docs/fbr-widget.png)

---

## Apps que tengo instaladas (Homebrew casks)

| App | Qué es |
|---|---|
| [Brave](https://brave.com/) | Browser que respeta la privacidad. El que uso día a día. |
| [iTerm2](https://iterm2.com/) | Reemplazo de Terminal: paneles divididos, search interno, profiles, hotkey window. |
| [Raycast](https://www.raycast.com/) | Spotlight pero potenciado — clipboard history, calculadora, snippets, scripts custom. |
| [Stats](https://github.com/exelban/stats) | CPU / RAM / disco / red / batería en la barra de menú. |
| [Rectangle](https://rectangleapp.com/) | Tiling de ventanas con atajos de teclado (mitades, cuartos, pantalla completa, etc.). Alternativa con gestos de trackpad: [Swish](https://highlyopinionated.co/swish/) (pago). |
| [Mos](https://mos.caldis.me/) | Suaviza el scroll de la rueda del mouse y te deja tener dirección de scroll independiente para mouse y trackpad. |
| [KeyClu](https://sergii.tatarenkov.name/keyclu/support/) | Te muestra los atajos de teclado de la app activa cuando mantenés una hotkey — buenísimo para aprender shortcuts. |
| [NearDrop](https://github.com/grishka/NearDrop) | Quick Share / Nearby Share para macOS — mandar y recibir archivos desde Android. |
| [scrcpy](https://github.com/Genymobile/scrcpy) | Espejar y controlar un Android desde la Mac (USB o WiFi). |
| [android-platform-tools](https://developer.android.com/tools/releases/platform-tools) | `adb`, `fastboot`, etc. |

### Cómo se ve KeyClu

Mantenés la hotkey en cualquier app y te aparece un overlay translúcido con todos los atajos agrupados por menú — buscable y con scroll:

![Overlay de KeyClu](https://raw.githubusercontent.com/Anze/KeyCluCask/main/img/screenshot_2.png)

### Cómo se ve Stats

Los widgets de la barra de menú te muestran en vivo CPU / RAM / disco / red / batería con números y mini-gráficos — elegís cuáles querés ver y qué tan compactos los querés:

![Widgets de Stats en la barra de menú](https://serhiy.s3.eu-central-1.amazonaws.com/Github_repo/stats/menus%3Fv2.3.2.png?v1)

Si hacés click en cualquiera, te abre un popup con detalles, historial, top de procesos e info por componente:

![Popups de Stats](https://serhiy.s3.eu-central-1.amazonaws.com/Github_repo/stats/popups%3Fv2.3.2.png?v3)

### `scrcpy-select` — elegir dispositivo cuando hay varios Android conectados

`scrcpy` solo no anda si tenés más de un Android conectado (por ejemplo un celu por USB y un emulador corriendo, o dos celus, o USB + ADB por WiFi). Este wrapper te lista todos los dispositivos que devuelve `adb devices -l` con su modelo, le elegís uno por número, y te tira scrcpy sobre ese.

```sh
$ scrcpy-select
Select a device:
0: Pixel_8 [4A0PR2A...]
1: SM-G991U [R5CN...]
Enter number: 1

Launching scrcpy for SM-G991U [R5CN...]
```

Código en [bin/scrcpy-select](bin/scrcpy-select). `install.sh` lo symlinkea a `~/bin` (que ya está en el PATH).

---

## Layout de teclado custom

Tengo un layout custom llamado **"U.S. but Spanish too"**. Es básicamente el QWERTY de USA, pero apretando <kbd>Option</kbd> + una vocal (o `n`) te tira la letra acentuada directo — sin tener que hacer la dance de dead-keys.

| Combo | Sale | Combo | Sale |
|---|---|---|---|
| <kbd>⌥</kbd>+<kbd>A</kbd> | á | <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>A</kbd> | Á |
| <kbd>⌥</kbd>+<kbd>E</kbd> | é | <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>E</kbd> | É |
| <kbd>⌥</kbd>+<kbd>I</kbd> | í | <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>I</kbd> | Í |
| <kbd>⌥</kbd>+<kbd>O</kbd> | ó | <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>O</kbd> | Ó |
| <kbd>⌥</kbd>+<kbd>U</kbd> | ú | <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>U</kbd> | Ú |
| <kbd>⌥</kbd>+<kbd>N</kbd> | ñ | <kbd>⌥</kbd>+<kbd>⇧</kbd>+<kbd>N</kbd> | Ñ |
| <kbd>⌥</kbd>+<kbd>1</kbd> | ¡ | <kbd>⌥</kbd>+<kbd>/</kbd> | ¿ |

Los archivos están en [config/keyboard-layouts/](config/keyboard-layouts/). `install.sh` los copia automáticamente; si lo querés instalar a mano sin correr el installer:

1. Copiá `U.S. but Spanish too.keylayout` (y opcionalmente el `.icns` con el ícono) a `~/Library/Keyboard Layouts/`. Si la carpeta no existe, la creás.
2. Abrí **Ajustes del Sistema → Teclado → Entrada de texto → Fuentes de entrada → Editar → +**, andá hasta **Otros** y elegí "U.S. but Spanish too".
3. Cambiás al layout desde el menú de fuentes de entrada en la barra de menú (o con <kbd>Ctrl</kbd>+<kbd>Espacio</kbd>).

---

## Herramientas de dev en background

Cosas que corren como servicios o las usan otras herramientas — casi nunca pienso en ellas.

| Herramienta | Para qué |
|---|---|
| [`nginx`](https://nginx.org/) | Reverse proxy local para dominios HTTPS de dev |
| [`nvm`](https://github.com/nvm-sh/nvm) | Múltiples versiones de Node al mismo tiempo |
| [`gnupg`](https://gnupg.org/) + [`pinentry-mac`](https://github.com/GPGTools/pinentry) | Firmar commits y tags con GPG |
| [`mkcert`](https://github.com/FiloSottile/mkcert) | Certificados TLS locales sin warnings en el browser |
| [`gh`](https://cli.github.com/) | GitHub desde la consola |
| [`fzf`](https://github.com/junegunn/fzf) | El fuzzy finder donde están armadas mis funciones |
| [`thefuck`](https://github.com/nvbn/thefuck) | Te corrige el último comando mal escrito |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | `cd` con memoria |

---

## VS Code

`./install.sh` también instala ~100 extensiones de VS Code en una Mac fresca, listadas en [vscode-extensions.txt](vscode-extensions.txt). Los stacks principales:

- **Web/JS**: ESLint, Prettier, TailwindCSS, GitLens, Pretty TS Errors
- **PHP/Laravel**: Intelephense, Blade Formatter, Laravel Goto-* helpers
- **Flutter/Dart**: Dart, Flutter, bloc, awesome-flutter-snippets
- **Python**: Pylance, Ruff, Jupyter
- **IA**: GitHub Copilot Chat, Codeium, ChatGPT
- **DX**: Docker, EditorConfig, Material Icon Theme, Code Spell Checker

---

## Notita sobre fuentes

Para que se vean bien los íconos de eza, del prompt p10k, etc., necesitás una [Nerd Font](https://www.nerdfonts.com/font-downloads). Yo uso **MesloLGS Nerd Font**; **Hack Nerd Font** también queda piola. Lo configurás en iTerm2 → Profiles → Text → Font.

---

## ¿No sabés qué app usar?

¿No sabés qué app de calendario usar, qué navegador, qué app de IA, qué app de backup, qué app de clipboard history o cliente de mail? Te dejo [esta mega spreadsheet](https://docs.google.com/spreadsheets/d/1HtJN4oQ6oBDFmFaF4Qeq5vCGEU1g-KB1DEz5Sp_OwXo/edit?usp=sharing) que compara bastantes herramientas para macOS, con ventajas y desventajas.

---

## Recomendados que todavía no probé

Herramientas que me chiflaron pero que aún no testeé — las dejo acá para que ni yo ni vos las olvidemos:

- **[FineTune](https://github.com/ronitsingh10/FineTune)** — control de volumen por app independiente, boost hasta 4× para apps que suenan bajito, ruteo a varias salidas, EQ y corrección para auriculares. Free y open source, vive en la barra de menú. Posible reemplazo para lo que `Stats > volumen` y el mezclador del sistema no llegan a hacer.
- **[AltTab](https://alt-tab-macos.netlify.app/)** — alt-tab estilo Windows para macOS, con thumbnails de cada ventana de todos los spaces. Free.
- **[BetterDisplay](https://github.com/waydabber/BetterDisplay)** (la versión Pro es paga) — para domar monitores externos: resoluciones arbitrarias, HiDPI en monitores no-Retina, override de brillo/contraste/gamma por display. Hace buen combo con **[MonitorControl](https://github.com/MonitorControl/MonitorControl)** (free, brillo y volumen en la barra de menú para displays externos).
- **[Alfred](https://www.alfredapp.com/)** — el Spotlight replacement original, la alternativa a Raycast. El core es gratis; el Powerpack (workflows, clipboard history, snippets) es pago.

---

## Para los más limados

Si querés clonar y darle, está todo el detalle técnico en [advanced-readme.md](advanced-readme.md): cómo funciona `install.sh`, qué *no* está commiteado (claves SSH, GPG, etc.), y cómo sincronizar cambios desde tu setup en vivo de vuelta al repo.

---

## ¿Tenés recomendaciones o comentarios?

Si hay alguna herramienta que usás todo el tiempo y me falta acá, o alguna parte que no se entiende, me copa que me digas. Abrí un [issue en GitHub](https://github.com/uristrimber/dotfiles/issues) o escribime por donde habitualmente nos hablamos.
