# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null \
        | fzf +m \
              --style=full \
              --border --border-label=' fd · cd to directory ' \
              --input-label=' filter ' \
              --header-label=' directories ' \
              --preview 'eza --tree --level=2 --color=always --icons {} 2>/dev/null || ls -la {}' \
              --preview-window='right,50%,border-rounded') &&
  cd "$dir"
}

# fh - search in your command history and execute selected command
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) \
          | fzf +s --tac \
                --style=full \
                --border --border-label=' fh · history ' \
                --input-label=' filter ' \
                --header-label=' commands ' \
                --preview 'echo {} | sed "s/ *[0-9]* *//" | bat --color=always --language=bash --plain' \
                --preview-window='down,30%,border-rounded,wrap' \
          | sed 's/ *[0-9]* *//')
}

# fkill - pick a process and kill it
fkill() {
  local pid
  pid=$(ps -ef | sed 1d \
        | fzf -m \
              --style=full \
              --border --border-label=' fkill · kill process ' \
              --input-label=' filter ' \
              --header-label=' processes ' \
        | awk '{print $2}')
  [ -n "$pid" ] && echo "$pid" | xargs kill -${1:-9}
}

# fbr - checkout git branch (local + remote)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" \
           | fzf +m \
                 --style=full \
                 --border --border-label=' fbr · checkout branch ' \
                 --input-label=' filter ' \
                 --header-label=' branches ' \
                 --preview 'git log --oneline --color=always $(echo {} | sed "s#remotes/##" | sed "s/^[* ]*//") | head -30' \
                 --preview-window='right,60%,border-rounded') &&
  git checkout $(echo "$branch" | sed "s#remotes/[^/]*/##" | sed "s/^[* ]*//")
}
