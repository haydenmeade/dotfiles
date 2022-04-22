# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Path changes
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH

. "$HOME/.cargo/env"

export BROWSER="open"

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

settitle(){print -Pn "\e]0;%(4~|.../%3~|%~)\a"}
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
notes () {
    builtin cd ~/notes/ && nvim
}

culture_amp (){
    local CA_ROOT_DIR=$(fd --type directory . ~/ca --max-depth 1 | fzf --header "CHOOSE PROJECT TO WORK IN")
    echo $CA_ROOT_DIR

    local dir="$CA_ROOT_DIR"
    if [[ -d "$CA_ROOT_DIR/src" ]]; then
        dir="$CA_ROOT_DIR/src"
    fi

    cd $dir
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

    if [[ $issueStatus == "TO-DO" ]]; then
        read -t 3 -n 1 -p "Do you want to mark as in progress? (y/n)? " mark
        [ -z "$mark" ] && mark="y"  # if 'yes' have to be default choice
        if [[ $mark == "y" ]]; then
            jira issue assign $issueKey $(jira me)
        fi
    fi
    # Assign 
    if [[ $issueAssignee != "Hayden-Meade" ]]; then
        read -t 3 -n 1 -p "Do you want to assign to self? (y/n)? " assign
        [ -z "$assign" ] && assign="y"  # if 'yes' have to be default choice
        if [[ $assign == "y" ]]; then
            jira issue assign $issueKey $(jira me)
        fi
    fi

    # Git Branch:
    read -t 3 -n 1 -p "Do you want to create git branch? (y/n)? " gitb
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

alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias ji='jira issue list -a$(jira me)'

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

bindkey '^ ' autosuggest-accept
bindkey '^n' autosuggest-accept

# dir in title
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%(4~|.../%3~|%~)\a"}
        ;;
esac

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
