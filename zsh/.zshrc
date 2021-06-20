if [[ -s "$HOME/.zshrc.local" ]]; then
    source $HOME/.zshrc.local
fi

# compiling
export MAKEFLAGS='--no-print-directory'

# history
HISTFILE=$HOME/.zhistory
SAVEHIST=999999
HISTSIZE=999999
setopt HIST_IGNORE_SPACE

# bash-like forward and backward word
export WORDCHARS=''

# colors
autoload -U colors && colors
PS1="λ %~> "

# general
alias la='ls -lah'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

