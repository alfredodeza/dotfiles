# Before anything, we call compinit so completion works
autoload -Uz compinit; compinit

virtual_envs=(/Users/adeza/python /opt/devel /Users/alfredo/python)

# at some point I should make something out of this
#plugins=(git django med pytest python)
# FIXME
if [[ -e ~/.zsh ]]; then
    source ~/.zsh/python/python.plugin.zsh
    source ~/.zsh/pytest/pytest.plugin.zsh
fi

# Cache time for uber fast completion
zstyle ':completion:*' use-cache on

# Get homebrew's path first and then other custom bits
export PATH=/usr/local/bin:$PATH:/usr/local/sbin:/usr/local/mysql/bin:/Users/adeza/bin:/Users/adeza/bin/google_appengine:/usr/texbin

# source IP's and private shortcuts
if [[ -e ~/.zshrc-private ]]; then
    source ~/.zshrc-private
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# I hate autocorrect
unsetopt correctall

# load me some colors please so I can use them later
autoload -U colors && colors

setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*'  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# cd aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."


#
# Function Time!
#

ssh-copy-key() {
    ssh ${1} "echo `cat ~/.ssh/id_rsa.pub` >> ~/.ssh/authorized_keys"
}


alias bitch='sudo '

# make ls colors! regardless of the OS! fantastic!
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=if-tty' || alias ls='ls -G'


alias pg='ps aux | grep -v grep | grep $1'
alias pgi='ps aux | grep -v grep | grep -i $1'
alias \:q='exit'
alias \:Q='exit'
alias cls='clear; ls'
alias Vimrc='mvim ~/.vimrc'
alias vimrc='vim ~/.vimrc'
alias gst='git status'

# I hate you LDAP completion of usernames
zstyle ':completion:*' users {adeza,root,cmg}

# Build/Compile Correctly and faster
export ARCHFLAGS="-arch x86_64"
export MAKEOPTS="-j17"

# CMG specific
export DEVELDIR=/opt/devel
export CMG_CONF=/opt/conf/fe1.json
export CMG_LOCAL_VIRTUALENV_VERSION=1

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  NORMAL_MODE="%{$fg[red]%}ᓆ%{$reset_color%}"
  INSERT_MODE="ᓆ"
fi

function zle-line-init zle-keymap-select {
 VIMODE="${${KEYMAP/vicmd/$NORMAL_MODE}/(main|viins)/$INSERT_MODE}"
 zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# If I am in a sub-shell from Vim, let me know
# otherwise I keep forgetting
if [ "$(env | grep VIM)" ]; then
    FROM_VIM="%{$fg[red]%}[vim]%{$reset_color%}"
    PS1="$PS1{$FROM_VIM}"
fi

bindkey -v

# Make sure Ctrl-R works
bindkey '^R' history-incremental-search-backward

# Make backspace work like vim
bindkey '^?' backward-delete-char

# When using arrows, match what I have already typed
# for history search
bindkey -M viins "\e[A" history-search-backward
bindkey -M viins "\e[B" history-search-forward  # Down arrow
bindkey -M vicmd "k"    up-line-or-search
bindkey -M vicmd "j"    up-line-or-search

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# Load vcs_info
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' stagedstr '*'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' formats '[%F{yellow}%b%u%F{reset}]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn
precmd () { vcs_info }

PROMPT='${FROM_VIM}${vcs_info_msg_0_}%{$fg[green]%} %30<..<${PWD/#$HOME/~}%<< %{$reset_color%}${VIMODE} '

