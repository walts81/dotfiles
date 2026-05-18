alias ..='cd ..'
alias vi='nvim'
alias ....='cd ../../../'
alias ...='cd ../..'
alias la='eza -ah --group-directories-first --icons=auto'
alias lsa='ls -a'
alias ls='eza -lhg --group-directories-first --icons=auto --git'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias l='eza -h --group-directories-first --icons=auto'
alias vim='nvim'
alias cp='rsync -ah --info=progress2 --inplace --partial --stats'
alias cd='zd'
alias cpssh='rsync -avzP --progress -e ssh'
alias catx='bat -pp'
alias cat='bat'
alias speedtest='speedtest-go'
alias yt='yt-x --preview --disown-streaming-process --search'
alias ta='tmux attach-session -t'
alias station-42='docker exec -it fieldstation42 python3 /app/station_42.py'
alias field-player='/home/jwalters/docker/field-station-42/scripts/player_with_keyboard.sh'
alias idrive='/opt/IDriveForLinux/bin/idrive'
alias ta='tmux attach-session'
alias tl='tmux list-sessions'
alias openclaw='echo "OpenClaw WebUI via http://localhost:18789" && ssh -N -L 18789:127.0.0.1:18789 jwalters@10.168.3.202'

# Function to create custom session name
tc() {
  if [ -n "${1:-}" ]; then
    SESSION_NAME="$1"
  else
    base="tmp"
    SESSION_NAME="$base"
    n=1
    while tmux has-session -t "$SESSION_NAME" 2>/dev/null; do
      n=$((n + 1))
      SESSION_NAME="${base}${n}"
    done
  fi

  tmux new-session -s "$SESSION_NAME"
}

# Function to launch a 4-pane quadrant layout with a custom session name
tq() {
  # If no name is provided, start at "tmp" and increment if needed.
  if [ -n "${1:-}" ]; then
    SESSION_NAME="$1"
  else
    base="tmp"
    SESSION_NAME="$base"
    n=1
    while tmux has-session -t "$SESSION_NAME" 2>/dev/null; do
      n=$((n + 1))
      SESSION_NAME="${base}${n}"
    done
  fi

  tmux new-session -d -s "$SESSION_NAME" \; \
    split-window -h \; \
    split-window -v \; \
    select-pane -t 0 \; \
    split-window -v "/home/jwalters/.opencode/bin/opencode" \; \
    select-pane -t 1 \; \
    select-layout tiled \; \
    attach-session -t "$SESSION_NAME"
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

pv() {
  local cmd
  printf -v cmd '%q ' mpv --force-window=yes --player-operation-mode=pseudo-gui -- "$@"
  nohup hyprctl dispatch exec "[float; center] ${cmd% }" \
    >/dev/null 2>&1 </dev/null &
  disown
}
