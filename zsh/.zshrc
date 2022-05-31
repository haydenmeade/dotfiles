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
export CONFIG_DIR=$HOME/.config/lazygit

. "$HOME/.cargo/env"

export BROWSER="open"
export KITTY_LISTEN_ON=unix:/tmp/mykitty
export HOMEBREW_NO_ENV_HINTS=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE=true

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=( 
  git
  npm
  ruby
  brew
  asdf
  direnv
  extract
  zsh-autosuggestions
  fd
  ripgrep
  fzf
  gem
  gh
  golang
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'

cdls () { 
    if [[ -z "$PS1" ]]; then
        z "$@"
    else
        z "$@" && exa -la; 
    fi
}

dot () {
    z ~/dotfiles/ && nvim
}
notes () {
    z ~/notes/ && nvim
}

culture_amp (){
    local CA_ROOT_DIR=$(fd --type directory . ~/ca --max-depth 1 | fzf --header "CHOOSE PROJECT TO WORK IN")
    echo $CA_ROOT_DIR

    local dir="$CA_ROOT_DIR"
    if [[ -d "$CA_ROOT_DIR/src" ]]; then
        dir="$CA_ROOT_DIR/src"
    fi
    if [[ -d "$CA_ROOT_DIR/v2_src" ]]; then
        dir="$CA_ROOT_DIR/v2_src"
    fi

    z $dir
}

can (){
    culture_amp
    nvim
}

ca (){
    culture_amp
    exa -la
    asdf current
}

# jira-cli https://github.com/ankitpokhrel/jira-cli
function work-on-issue() {
    issue=$(jira issue list --columns key,summary,assignee,status --plain | fzf --header "PLEASE SELECT AN ISSUE TO WORK ON" )
    echo ""
    echo $issue
    issue=${issue// /-}
    issue=$(echo $issue )
    read issueKey issueSummary issueAssignee issueStatus <<< "$issue"
    issueSummary=$(echo $issueSummary | sed -e 's|\([A-Z][^A-Z]\)| \1|g' -e 's|\([a-z]\)\([A-Z]\)|\1 \2|g' | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -s '-')
    
    branchname=$(echo $issueKey-$issueSummary | tr -s '-')
    shortname=$(echo $branchname | head -c 60)
    # echo $branchname

    # Mark as in progress
    issueStatus=$(echo $issueStatus | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -s '-')
    echo $issueStatus

    # Assign 
    if [[ $issueAssignee != "Hayden-Meade" ]]; then
        echo "Do you want to assign to self? (Y/n)? " 
        read -n 1 assign
        [ -z "$assign" ] && assign="y"  # if 'yes' have to be default choice
        if [[ $assign == "y" ]]; then
            jira issue assign $issueKey $(jira me)
        fi
    fi

    # mark as in progress
    if [[ $issueStatus == "to-do" || $issueStatus == "" ]]; then
        echo "Do you want to mark as in progress? (Y/n)? " 
        read -n 1 mark
        [ -z "$mark" ] && mark="y"  # if 'yes' have to be default choice
        if [[ $mark == "y" ]]; then
            jira issue move $issueKey "In Progress"
        fi
    fi

    # Git Branch:
    echo "Do you want to create git branch? (Y/n)? " 
    read -n 1 gitb
    [ -z "$gitb" ] && gitb="y"  # if 'yes' have to be default choice
    if [[ $gitb != "y" ]]; then
        return
    fi
    if [[ ! -z "$shortname" ]]; then
        git fetch
        existing=$(git branch -a | grep -v remotes | grep $shortname | head -n 1)
        if [[ ! -z "$existing" ]]; then
            echo "Using existing git branch"
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
            # git push --set-upstream origin $branchname
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
alias bb='brew bundle'
alias de='direnv allow .'

alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias ji='jira issue list -a$(jira me)'
alias c='pbcopy'

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
if [[ -f ~/.zshprv ]]; then
    source $HOME/.zshprv
fi

# aws profiles
use_aws_profile(){
  prn=$1
  export $(aws-vault exec $prn -- env | sort | grep -E 'AWS_(ACC|SECR|SESS)')
}
alias awsdev='use_aws_profile dev-admin'

bindkey -v

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

export ZVM_NORMAL_MODE_CURSOR=bbl

# +-------------+
# | zsh-vi-mode |
# +-------------+

# The zsh-vi-mode plugin causes my FZF mapping to disappear, 
# because it has a hook that is run after this script, that 
# reinitializes the keymap. => we set it again in the
# zvm_after_init hook.
# check out: https://github.com/jeffreytse/zsh-vi-mode
source "$ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.zsh"
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

eval "$(zoxide init zsh)"

# dir in title
# case $TERM in
#     xterm*)
#         precmd () {print -Pn "\e]0;%(4~|.../%3~|%~)\a"}
#         ;;
# esac

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

