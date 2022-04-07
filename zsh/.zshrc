# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path changes
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

alias luamake=/home/hayden/lua-language-server/3rd/luamake/luamake
. "$HOME/.cargo/env"
# GoLang
export GOROOT=/home/hayden/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/hayden/go
export PATH=$GOPATH/bin:$PATH

# WSL
export PATH=$PATH:/mnt/c/Windows/System32/
export BROWSER='/mnt/c/Windows/explorer.exe'

export NVM_DIR="$HOME/.nvm"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE=true

ZSH_THEME="powerlevel10k/powerlevel10k"

# Add wisely, as too many plugins slow down shell startup.
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

plugins=( 
  evalcache 
  zsh-nvm 
  git
  npm
  zsh-autosuggestions
)
#macos

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# rbenv caching
_evalcache rbenv init - zsh
# rbenv init - zsh
# rbenv global 3.1.1 && rbenv rehash

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
source /usr/share/doc/fzf/examples/key-bindings.zsh
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
