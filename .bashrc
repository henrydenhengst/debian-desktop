# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable color support for ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Useful aliases for sysadmin work
alias ll='ls -lhF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade'
alias ports='sudo netstat -tulnpe'
alias ipinfo='ip a'
alias dfh='df -h'
alias duh='du -h --max-depth=1'
alias myip='curl ifconfig.me'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias gco='git checkout'
alias gb='git branch'

# Prompt with colors and Git branch
parse_git_branch() {
  git branch 2>/dev/null | sed -n '/\* /s///p'
}

PS1='\e[1;32m\u@\h\e[0m:\e[1;34m\w\e[0;33m$(parse_git_branch)\e[0m\$ '

# Editor
export EDITOR=vim

# Less cluttered history
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend

# Autocomplete improvements
bind "set completion-ignore-case on"

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi