# aliases

#waskr 
alias @waskr='cd /Users/alfredo/waskr/waskr'

# color
alias ls='ls -G'
alias ll='ls -lhG'

# go back!
alias cdd='cd -'

#updatedb
alias updatedb='/usr/libexec/locate.updatedb'

# Most used grep combo
alias grepp='grep -Hirn'

#shootq 
export PATH=$PATH:/usr/local/bin:/usr/local/mysql/bin:/Users/alfredo/bin

# fix stupid ZSH history
alias hist="fc -l -50"
alias histt="fc -l -2000"

# cd aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# we hate PYC files!
export PYTHONDONTWRITEBYTECODE=1

# Lines configured by zsh-newuser-install
export HISTFILE=~/.histfile
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
setopt appendhistory autocd extendedglob
unsetopt beep notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/alfredo/.zshrc'

# End of lines added by compinstall

# Custom stuff
setopt EXTENDED_HISTORY
setopt MENUCOMPLETE
setopt ALL_EXPORT

# correct commands
setopt correct

# for completion this needs:
autoload -U compinit
compinit -C

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show


# command not found
function preexec() {
	command="${1%% *}"
}

function precmd() {
	(($?)) && [ -n "$command" ] && [ -x /usr/lib/command-not-found ] && {
		whence -- "$command" >& /dev/null ||
			/usr/bin/python /usr/lib/command-not-found -- "$command"
		unset command
	}
}

# prompt

PROMPT="[%n@%m %~%3 ]$ "

# color grep
export GREP_COLOR=32
alias grep='grep --color'

