# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path changes
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

. "$HOME/.cargo/env"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE=true

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=( 
  git
  npm
  asdf
  zsh-autosuggestions
  macos
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

cdls () { 
    if [[ -z "$PS1" ]]; then
        builtin cd "$@"
    else
        builtin cd "$@" && exa -la; 
    fi
}

dot () {
    builtin cd ~/dotfiles/ && nvim
}

# TODO test this out
function work-on-issue() {
    issue=$(gh issue list | fzf --header "PLEASE SELECT AN ISSUE TO WORK ON" | awk -F '\t' '{ print $1 }')
    sanitized=$(gh issue view $issue --json "title" | jq -r ".title" | tr '[:upper:]' '[:lower:]' | tr -s -c "a-z0-9\n" "-" | head -c 60)
    branchname=$issue-$sanitized
    shortname=$(echo $branchname | head -c 30)
    if [[ ! -z "$shortname" ]]; then
        git fetch
        existing=$(git branch -a | grep -v remotes | grep $shortname | head -n 1)
        if [[ ! -z "$existing" ]]; then
            sh -c "git switch $existing"
        else
            bold=$(tput bold)
            normal=$(tput sgr0)
            echo "${bold}Please confirm new branch name:${normal}"
            vared branchname
            base=$(git branch --show-current)
            echo "${bold}Please confirm the base branch:${normal}"
            vared base
            git checkout -b $branchname origin/$base
            git push --set-upstream origin $branchname
        fi
    fi
}

alias py='python3'
alias n='nvim'
alias l='exa -la'
alias ls='exa -la'
alias lg='lazygit'
alias cd='cdls'
alias cat=bat

alias gs='git status'
alias ga='git add .'
alias gc='git commit'

# useful defaults:
# alias ~/cd=cd ~
# alias -='cd -'
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

# fzf command history search
# source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fzf-history-widget-accept() {
  fzf-history-widget
  # zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^R'   fzf-history-widget-accept
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}


# function git_clone_or_update() {
#   git clone "$1" "$2" 2>/dev/null && print 'Update status: Success' || (cd "$2"; git pull)
# }

bindkey '^ ' autosuggest-accept
bindkey '^n' autosuggest-accept

# dir in title
settitle() { printf "\e]0;$@\a" }
dir_in_title() { settitle $PWD }
chpwd_functions=(dir_in_title)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# CultureAmp
# unalias g
# # Load custom executable functions
# for function in ~/.zsh/functions/*; do
#   source $function
# done
#
# # Extra files in ~/.zsh/configs/pre, ~/.zsh/configs, and ~/.zsh/configs/post.
# # These are loaded first, second, and third, respectively.
# _load_settings() {
#   _dir="$1"
#   if [ -d "$_dir" ]; then
#     if [ -d "$_dir/pre" ]; then
#       for config in "$_dir"/pre/**/*~*.zwc(N-.); do
#         . $config
#       done
#     fi
#
#     for config in "$_dir"/**/*(N-.); do
#       case "$config" in
#         "$_dir"/(pre|post)/*|*.zwc)
#           :
#           ;;
#         *)
#           . $config
#           ;;
#       esac
#     done
#
#     if [ -d "$_dir/post" ]; then
#       for config in "$_dir"/post/**/*~*.zwc(N-.); do
#         . $config
#       done
#     fi
#   fi
# }
# _load_settings "$HOME/.zsh/configs"
#
# # Local config
# [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
#
# # Aliases
# [[ -f ~/.aliases ]] && source ~/.aliases
#
