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
alias cp='rsync -ah --info=progress2 --inplace --partial'
alias cd='zd'
alias cpssh='rsync -avzP --progress -e ssh'
alias catx='batcat -pp'
alias cat='batcat'
alias yt='yt-x --preview --disown-streaming-process --search'

alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'

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

	tmux new-session -d -s "$SESSION_NAME" "opencode" \; \
		split-window -h \; \
		split-window -v \; \
		select-pane -t 0 \; \
		split-window -v \; \
		select-pane -t 0 \; \
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
