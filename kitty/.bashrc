#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export TERM=kitty

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias t="tmux"
alias tks="tmux kill-session -t"
# PS1='[\u@\h \W]\$ '
PS1='\[\e[1;32m\]\u\[\e[1;32m\]@\h\[\e[1;32m\] \w\[\e[0m\] \$ '
function hg(){
  history | grep "$@"
}

