if [[ -s "$HOME/.zshrc.local" ]]; then
    source $HOME/.zshrc.local
fi

# compiling
export MAKEFLAGS='-j4'

# history
HISTFILE=.zhistory
SAVEHIST=999999
HISTSIZE=999999

# colors
autoload -U colors && colors
PS1=$'\e[1;33mλ %~> \e[0m'
LS_COLORS=$LS_COLORS:'di=0;34:fi=0;32:ln=1;33:' ; export LS_COLORS

# general
alias la='ls -lah'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias cd..='cd ..'
alias ..='cd ..'
alias whatismyip='curl ifconfig.co'
alias 'nwemacs'='emacs -nw'

extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xjf $1		;;
			*.tar.gz)	tar xzf $1		;;
			*.bz2)		bunzip2 $1		;;
			*.rar)		rar x $1		;;
			*.gz)		gunzip $1		;;
			*.tar)		tar xf $1		;;
			*.tbz2)		tar xjf $1		;;
			*.tgz)		tar xzf $1		;;
			*.zip)		unzip $1		;;
			*.Z)		uncompress $1	;;
			*)			echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

