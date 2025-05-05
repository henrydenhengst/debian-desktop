# ~/.bashrc

# Exit if not interactive
[[ $- != *i* ]] && return

# Enable color support for common commands
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Sysadmin aliases
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

# Editor
export EDITOR=vim

# History settings
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
shopt -s histappend

# Autocomplete enhancements
bind "set completion-ignore-case on"

# Bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
