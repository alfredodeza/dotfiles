# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
#export ZSH_THEME="alfredo"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""  

virtual_envs=(/Users/adeza/python /opt/devel /Users/alfredo/python)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git django med pytest python)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/local/mysql/bin:/Users/adeza/bin:/Users/adeza/bin/google_appengine

# source IP's and private shortcuts
#source ~/.zsh_private

# I hate autocorrect 
unsetopt correctall

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' \
        max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# go back!
alias cdd='cd -'

# cd aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."


#
# Function Time!
#

# change to python package directory
cdp() {
    cd $(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__))")
}

ssh-copy-key() {
    ssh ${1} "echo `cat ~/.ssh/id_rsa.pub` >> ~/.ssh/authorized_keys"
}



alias bitch='sudo '
alias ls='gls --color=if-tty'

export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

alias pg='ps aux | grep -v grep | grep $1'
alias pgi='ps aux | grep -v grep | grep -i $1'
alias \:q='exit'
alias cls='clear; ls'
alias Vimrc='mvim ~/.vimrc'
alias vimrc='vim ~/.vimrc'

PROMPT='%{$fg[cyan]%}%n@mac $(git_prompt_info) %{$fg[yellow]%}%~ %{$reset_color%}$ ' 

# SSH Aliases
alias @vm="ssh cmg@localhost -p2222 -Y"

source ~/.zshrc-private

# I hate you LDAP completion of usernames
zstyle ':completion:*' users {adeza,root,cmg}

# Build/Compile Correctly
export ARCHFLAGS="-arch i386 -arch x86_64"

# CMG specific
export DEVELDIR=/opt/devel
export CMG_LOCAL_VIRTUALENV_VERSION=1
