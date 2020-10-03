export LANG="en_US.UTF-8"

### INPORTS ################################################

source ~/.zplug/init.zsh

############################################################


### PLUGINS ################################################

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-autosuggestions"
zplug load
setopt nonomatch
export ZSH_HIGHLIGHT_STYLES[path]='fg=081'

############################################################


### HISTORY ################################################

HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=100000

# share .zshhistory
setopt inc_append_history
setopt share_history

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both 
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

############################################################


### COLORS #################################################

# LS_COLORS
# eval `dircolors -b`
# eval `dircolors ${HOME}/.dircolors`

# remove file mark
unsetopt list_types

# color at completion
autoload colors
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# less
export LESS='-R'

# man
export MANPAGER='less -R'
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;33m") \
        LESS_TERMCAP_md=$(printf "\e[1;36m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

############################################################


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


### COMPLETION #############################################

# 補完機能有効にする
autoload -U compinit
compinit -u

# 補完候補に色つける
autoload -U colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# 単語の入力途中でもTab補完を有効化
setopt complete_in_word
# 補完候補をハイライト
zstyle ':completion:*:default' menu select=1
# キャッシュの利用による補完の高速化
zstyle ':completion::complete:*' use-cache true
# 大文字、小文字を区別せず補完する
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完リストの表示間隔を狭くする
setopt list_packed

setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

# コマンドの打ち間違いを指摘してくれる
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "
# pip
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip3

############################################################


### PROMPT #################################################

# PROMPT='
# %F{cyan}%n@%m / %*
# %F{yellow}%(5~,%-1~/.../%2~,%~)%f
# %F{cyan}%B● %b%f'
# ●

# vcs_info
# autoload -Uz vcs_info
# setopt prompt_subst
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
# zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
# zstyle ':vcs_info:*' formats "%F{green}%c%u[ %b ]%f"
# zstyle ':vcs_info:*' actionformats '[%b|%a]'
# precmd () { vcs_info }
# RPROMPT='${vcs_info_msg_0_} '$RPROMPT

fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit

# optionally define some options
PURE_CMD_MAX_EXEC_TIME=10

# change the path color
zstyle :prompt:pure:path color blue

# change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color cyan

# turn on git stash status
zstyle :prompt:pure:git:stash show yes

# turn on execution time
zstyle :promplt:pure:execution_time show yes

prompt pure

############################################################


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
alias br='bundle exec rails'
alias brc='bundle exec rails console'
alias brs='bundle exec rails server'
alias bs='bundle exec rspec'
alias brubo="bundle exec rubocop"

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
    local b="$( gb | peco )"
    if [ ! -z "$b" ] ; then
        git checkout "${b:2:${#b}}"
    fi
}

# ghq
export GHQ_ROOT='/Users/tanimu/.ghq'
# change git repository
function cgr {
    local r="$( ghq list | peco )"
    if [ ! -z "$r" ]; then
        cd "$(ghq root)/$r"
    fi
}

# git push origin current branch
function gpoc {
    local cb=$(git symbolic-ref --short HEAD)
    if [ -z "$cb" ]; then
        echo "Not found current branch"
        return
    fi
    git push origin $cb
}

############################################################


#### GO ####################################################

export GOPATH=$HOME/.go

function cgor {
    local dir="$( ls -1d ${GOPATH}/src/github.com/*/* | peco )"
    if [ ! -z "$dir" ] ; then
        cd "$dir"
    fi
}

############################################################


#### SERVERLESS ############################################

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

############################################################


#### PATH CONFIGURATION ###########################################

### More down, Higher Priority ###

# homebrew
export PATH=$HOME/.homebrew/bin:$PATH

# mysql@5.7
export PATH=$HOME/.homebrew/opt/mysql@5.7/bin:$PATH

# local
export PATH=$HOME/.local/bin:$PATH

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# pyenv environment and path
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# ruby and rbenv
export PATH=$HOME/.rbenv/shims:$PATH
eval "$(rbenv init -)"
# export RUBYOPT='-W:no-deprecated -W:no-experimental'

# nodenv 
export NODENV_ROOT=$HOME/.nodenv
export PATH=$NODENV_ROOT/bin:$PATH
eval "$(nodenv init -)"

# rust
export PATH=$HOME/.cargo/bin:$PATH

# GO
export PATH=$(go env GOPATH)/bin:$PATH

# wantedly
export PATH=$HOME/.wantedly/bin:$PATH

# Gooogle Cloud SDK
if [ -f '/Users/tanimu/.lib/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/tanimu/.lib/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/tanimu/.lib/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/tanimu/.lib/google-cloud-sdk/completion.zsh.inc'; fi
export CLOUDSDK_PYTHON=$HOME/.pyenv/versions/2.7.16/bin/python

# costom_commands
export PATH=$HOME/.commands:$PATH

############################################################

