# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jwalters/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/jwalters/.fzf/bin"
fi

source <(fzf --zsh)
