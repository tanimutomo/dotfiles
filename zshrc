export LANG="en_US.UTF-8"

# INPORTS {{{
source ~/.zplug/init.zsh
# }}}

# PLUGINS {{{
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-autosuggestions"
zplug load
setopt nonomatch
export ZSH_HIGHLIGHT_STYLES[path]='fg=081'
# }}}


# HISTORY {{{
# history
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
# }}}


# COLOR {{{
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
# }}}


# PROMPT {{{
# prompt
PROMPT='
%F{cyan}%n@%m / %*
%F{yellow}%(5~,%-1~/.../%2~,%~)%f
%F{cyan}%B●%b%f'

# vcs_info
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[ %b ]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT='${vcs_info_msg_0_} '$RPROMPT
# }}}


# ALIAS {{{

# cd
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

# kronos
# export PATH=$HOME/.usr/kronos/bin:$PATH
alias kronos-update='pip3 uninstall kronos-ml && python3 setup.py build && python3 setup.py install && source ~/.zshrc && which kronos'
alias kronos-update-pypi='pip3 uninstall kronos-ml && pip3 --no-cache-dir install --upgrade --index-url https://test.pypi.org/simple/ kronos-ml'

# ls alias
alias ll='ls -alh'

# vim alias
alias v='vim'
alias vi='vim'

# docker
alias d='docker'
# デフォルトだと見切れるので、表示項目を変更しています。
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

# path for gcc and g++
alias gcc='gcc-9'
alias g++='g++-9'

# GHQ
alias glocal='cd $(ghq root)/$(ghq list | peco)'
alias gremote='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

# zip
alias untargz='tar -zxvf'

# ssh
alias diana='ssh diana'
alias chasca='ssh chasca'
alias bacchus='ssh bacchus'
# }}}


# PECO {{{
# peco
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
bindkey '^E' peco-cdr
# }}}


# COMPLETION {{{
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
# }}}


# ENVIRONMENT {{{
# homebrew
export PATH=$HOME/.usr/local/bin:$PATH
export PATH=$HOME/.homebrew/bin:$PATH
export PATH=$HOME/.homebrew/bin/zsh:$PATH
export PATH="/Users/tanimu/.homebrew/opt/grep/libexec/gnubin:$PATH"

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# pyenv environment and path
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# execop
. $HOME/.execop.zsh

# JAVA HOME
export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
export PATH=$JAVA_HOME/bin:$PATH
# }}}


