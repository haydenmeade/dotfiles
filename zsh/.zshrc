# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# settitle(){print -Pn "\e]0;%(4~|.../%3~|%~)\a"}
# print -Pn "\e]0;%(4~|.../%3~|%~)\a"
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

function precmd () {
  window_title="\e]0;%(4~|.../%3~|%~)\a"
  print -Pn "$window_title"
}

# Path changes
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.local/pact/bin:$PATH
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export CONFIG_DIR=$HOME/.config/lazygit

. "$HOME/.cargo/env"

export BROWSER="open"
export KITTY_LISTEN_ON=unix:/tmp/mykitty
export HOMEBREW_NO_ENV_HINTS=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE=true
SAVEHIST=99999

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=( 
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'

export http_proxy=http://localhost:3128
export https_proxy=http://localhost:3128
export HTTP_PROXY=http://localhost:3128
export HTTPS_PROXY=http://localhost:3128
export no_proxy=*.a.run.app
export NO_PROXY=*.a.run.app
# export http_proxy=
# export https_proxy=
# export HTTP_PROXY=
# export HTTPS_PROXY=

cdls () { 
    if [[ -z "$PS1" ]]; then
        cd "$@"
    else
        cd "$@" && exa -la; 
    fi
}

dot () {
    cd ~/dotfiles/ && nvim
}
notes () {
    cd ~/notes/ && nvim
}

anz_repo (){
    local ROOT_DIR=$(fd --type directory . ~/anz --max-depth 1 | fzf --header "CHOOSE PROJECT TO WORK IN")
    echo "$ROOT_DIR"

    local dir="$ROOT_DIR"
    if [[ -d "$ROOT_DIR/src" ]]; then
        dir="$ROOT_DIR/src"
    fi

    cd "$dir"
}

an (){
    anz_repo
    nvim
}

a (){
    anz_repo
}

alias py='python3'
alias n='nvim'
alias l='exa -la'
alias ls='exa -la'
alias lg='lazygit'
alias cd='cdls'
alias cat=bat
alias bb='brew bundle'
alias de='direnv allow .'

alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git pull'
alias gcl='git clone'
alias ji='jira issue list -a$(jira me)'
alias c='pbcopy'
alias reauth='gcloud auth login --update-adc && gcloud auth configure-docker'
alias gomodtidy_all='for f in $(find . -name go.mod)
do (cd $(dirname $f); go mod tidy)
done'

# useful defaults:
# alias ~/cd=cd ~
alias -- -="cd -"
# alias ...=../..
# alias ....=../../..
# alias .....=../../../..
# alias ......=../../../../..
# alias 1='cd -1'
# alias 2='cd -2'
# alias 3='cd -3'
# alias 4='cd -4'
# alias 5='cd -5'
# alias 6='cd -6'
# alias 7='cd -7'
# alias 8='cd -8'
# alias 9='cd -9'
# alias _='sudo '
find-rename-regex() (
  set -eu
  find_and_replace="$1"
  PATH="$(echo "$PATH" | sed -E 's/(^|:)[^\/][^:]*//g')" \
    find . -depth -execdir rename "${2:--n}" "s/${find_and_replace}" '{}' \;
)

if [[ -f ~/.zshprv ]]; then
    source $HOME/.zshprv
fi

# aws profiles
use_aws_profile(){
  prn=$1
  export $(aws-vault exec $prn -- env | sort | grep -E 'AWS_(ACC|SECR|SESS)')
}
alias awsdev='use_aws_profile dev-admin'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# bindkey -v
# fzf command history search
# source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^R'   fzf-history-widget
bindkey '^ '   autosuggest-accept

# Quick edit
vzv() {
    fzf -1 -m --preview 'bat --color=always {}' </dev/tty | xargs -r -o $EDITOR;
}
 # Search with fzf and open selected file with Vim
zle -N vzv vzv
bindkey '^v' vzv

# export ZVM_NORMAL_MODE_CURSOR=bbl

# +-------------+
# | zsh-vi-mode |
# +-------------+

# The zsh-vi-mode plugin causes my FZF mapping to disappear, 
# because it has a hook that is run after this script, that 
# reinitializes the keymap. => we set it again in the
# zvm_after_init hook.
# check out: https://github.com/jeffreytse/zsh-vi-mode
# source "$ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.zsh"
# zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

eval "$(zoxide init zsh)"

# dir in title
# case $TERM in
#     xterm*)
#         precmd () {print -Pn "\e]0;%(4~|.../%3~|%~)\a"}
#         ;;
# esac

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

source /Users/meadeh/.docker/init-zsh.sh || true # Added by Docker Desktop
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
