# Before anything, we call compinit so completion works
autoload -Uz compinit; compinit

virtual_envs=($HOME/python $HOME/.virtualenvs)
virtualenvshome="$HOME/.virtualenvs"

zle_highlight=(region:standout special:standout suffix:bold isearch:underline)

export PIP_DOWNLOAD_CACHE=$HOME/.pip_cache

# at some point I should make something out of this
#plugins=(git django med pytest python)
# FIXME
# XXX Seriously now. I will not add another thing
# here until I fix this shit
if [[ -e $HOME/.zsh ]]; then
    source $HOME/.zsh/python/python.plugin.zsh
    source $HOME/.zsh/pytest/pytest.plugin.zsh
    source $HOME/.zsh/python/python.completion.zsh
    source $HOME/.zsh/vi/zle_vi_visual.zsh
fi

# Cache time for uber fast completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.zsh/cache

# Get homebrew's path first and then other custom bits
export PATH=/usr/local/bin:$PATH:/usr/local/sbin:/usr/local/mysql/bin:$HOME/bin:$HOME/bin/google_appengine:/usr/texbin

# By default, zsh delays 'Esc' to get into normal mode by half
# a second. Reduce this to 0.1s
export KEYTIMEOUT=1

# source IP's and private shortcuts
if [[ -e $HOME/.zshrc-private ]]; then
    source $HOME/.zshrc-private
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Remember previous directories
DIRSTACKSIZE=10
DIRSTACKFILE=$HOME/.zdirs
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}


setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

## This reverts the +/- operators.
setopt pushdminus

# I hate autocorrect
unsetopt correctall

# load me some colors please so I can use them later
autoload -U colors && colors

setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
setopt  globcomplete
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
zstyle ':completion:*:approximate:*' max-errors 2 numeric
zstyle -e ':completion:*:approximate:*'  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Partial color matching on TAB
highlights='${PREFIX:+=(#bi)($PREFIX:t)(?)*==$color[blue]=00}':${(s.:.)LS_COLORS}}
zstyle -e ':completion:*' list-colors 'reply=( "'$highlights'" )'
zstyle -e ':completion:*:-command-:*:commands' list-colors 'reply=( "'$highlights'" )'
unset highlights

# fix weird matching
setopt nonomatch

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
    if [ $2 ]; then
        key=$2
    else
        key="$HOME/.ssh/id_rsa.pub"
    fi
    cat "$key" | ssh ${1} 'umask 0077; mkdir -p .ssh; cat >> .ssh/authorized_keys'
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

vsed() {
  # call vim on a file (or glob) to perform a search and replace operation
  # with confirmation. Does not save automagically. Example usage:
  #     vsed foo bar *.py
  # Will search for 'foo' and replace it with 'bar' in all matching *.py files.
  # It also supports globbing for recursive files:
  #     vsed foo bar **/*.py
  search=$1
  replace=$2
  shift
  shift
  vim -c "bufdo! set eventignore-=Syntax| %s/$search/$replace/gce" $*

}


# I hate you LDAP completion of usernames
zstyle ':completion:*' users {adeza,root,cmg}

# Build/Compile Correctly and faster
export ARCHFLAGS="-arch i386 -arch x86_64"
#export ARCHFLAGS="-arch x86_64"
export MAKEOPTS="-j17"

export LESS=FRSXQ

# Load PythonStartup File
export PYTHONSTARTUP=$HOME/dotfiles/pythonstartup.py

export EDITOR=`which vim`

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
bindkey -M viins "\e[A" history-beginning-search-backward # Up arrow
bindkey -M viins "\e[B" history-beginning-search-forward  # Down arrow
bindkey -M vicmd "k"    up-line-or-search
bindkey -M vicmd "j"    up-line-or-search
bindkey -M viins "\e[Z" reverse-menu-complete

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# Load vcs_info
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' stagedstr '*'
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' formats '[%F{yellow}%b%c%u%F{reset}]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn hg
precmd () { vcs_info }

PROMPT='${FROM_VIM}$(hostname -s)${vcs_info_msg_0_}%{$fg[green]%} %30<..<${PWD/#$HOME/~}%<< %{$reset_color%}${VIMODE} '
