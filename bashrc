# ~/.bashrc: executed by bash(1) for non-login shells.

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


### PECO ###################################################

function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^T' peco-cdr

############################################################



# local
export PATH=$HOME/.local/bin:$PATH

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# for go lang
if [ -x "`which go`" ]; then
  export GOPATH=$HOME/go
  export PATH="$GOPATH/bin:$PATH"
fi

### ALIAS ##################################################

# cd
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

# kronos
# export PATH=$HOME/.usr/kronos/bin:$PATH
alias kronos-update='pip3 uninstall kronos-ml && python3 setup.py build && python3 setup.py install && source ~/.zshrc && which kronos'
alias kronos-update-pypi='pip3 uninstall kronos-ml && pip3 --no-cache-dir install --upgrade --index-url https://test.pypi.org/simple/ kronos-ml'

# ls
alias ll='ls -alh'

# vim
alias v='vim'
alias vi='vim'

# docker
alias d='docker'
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"'
alias dc='docker-compose'

# git
alias g="git"
alias gst='git status --short --branch'
alias gad='git add'
alias gcm='git commit -m'
alias gcam='git commit --amend --no-edit'
alias gpull='git pull'
alias gpush='git push'
# logを見やすく
alias gl='git log --abbrev-commit --no-merges --date=short --date=iso'
# grep
alias glg='git log --abbrev-commit --no-merges --date=short --date=iso --grep'
alias gd='git diff'
alias gb='git branch'
alias gck='git checkout'

# gcc and g++
alias gcc='gcc-9'
alias g++='g++-9'

# zip
alias untargz='tar -zxvf'
alias untar='tar -xvf'

# aws
alias awsp="source _awsp"

# rails
alias be='bundle exec'
alias ber='bundle exec rails'
alias berc='bundle exec rails console'
alias bers='bundle exec rails server'
alias bspec='bundle exec rspec'
alias brubo="bundle exec rubocop"

# ghq
alias gr="ghq get"

# kube
alias kc="kubectl"
alias kx="kubectx"
alias kt="kubetail"

############################################################


#### FUNCTIONS #############################################

# aws switch role
aws-switch() {
    export AWS_PROFILE=$1
    aws sts get-caller-identity
}

# load .env file
lenv() {
    if [ -z "$1" ]; then
        echo "Please specify path to .env (arg1)"
        return
    fi
    export $(cat $1 | grep -v ^# | xargs)
}

# change git branch
function cgb {
    local b="$( git branch | peco )"
    if [ ! -z "$b" ] ; then
        git checkout "${b:2:${#b}}"
    fi
}

# ghq
export GHQ_ROOT='/Users/tanimu/.repo/src'

# change repository
function cr {
    local r="$( ghq list | peco )"
    if [ ! -z "$r" ]; then
        cd "$(ghq root)/$r"
    fi
}

# browse repository
function br {
    hub browse $(ghq list | peco | cut -d "/" -f 2,3)
}

# git push origin current branch
function gpushoc {
    local cb=$(git symbolic-ref --short HEAD)
    if [ -z "$cb" ]; then
        echo "Not found current branch"
        return
    fi
    git push origin $cb
}

# git pull origin current branch
function gpulloc {
    local cb=$(git symbolic-ref --short HEAD)
    if [ -z "$cb" ]; then
        echo "Not found current branch"
        return
    fi
    git pull origin $cb
}

# open git repository with vscode
function vs {
    local r="$( ghq list | peco )"
    if [ ! -z "$r" ]; then
        code "$(ghq root)/$r"
    fi
}

# open file with vim
function vf {
    local r="$( fd | peco )"
    if [ ! -z "$r" ]; then
        vim "$r"
    fi
}

############################################################


