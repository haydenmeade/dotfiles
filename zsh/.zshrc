# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path changes
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$HOME/.local/pact/bin:$PATH
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
export CONFIG_DIR=$HOME/.config/lazygit

. "$HOME/.cargo/env"

export BROWSER="open"
export KITTY_LISTEN_ON=unix:/tmp/mykitty
export HOMEBREW_NO_ENV_HINTS=true

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export DISABLE_AUTO_TITLE=true
export SAVEHIST=999999
export HISTIGNORE="&:ls:[bf]g:nvim:n:exit:pwd:clear:mount:umount:[ \t]*"

export COMPOSE_BAKE=true

export ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=( 
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

function set_window_title() {
  window_title="\e]0;%(4~|.../%3~|%~)\a"
  print -Pn "$window_title"
}
precmd_functions+=( set_window_title )

# User configuration

export EDITOR='nvim'

export {http,https,all}_proxy=http://localhost:3128
export {HTTP,HTTPS,ALL}_PROXY=$http_proxy
export NO_PROXY="199.36.153.4,*.run.app,spanner.googleapis.com,,*.googleapis.com"
export no_proxy="199.36.153.4,*.run.app,spanner.googleapis.com,,*.googleapis.com"
# export http_proxy=
# export https_proxy=
# export HTTP_PROXY=
# export HTTPS_PROXY=

export GONOPROXY='github.service.anz/*,github.com/anzx/*'
export GONOSUMDB='github.service.anz/*,github.com/anzx/*'

export GOPROXY='https://platform-gomodproxy.services.x.gcp.anz,https://platform-gomodproxy.services.x.gcpnp.anz,https://proxy.golang.org,https://artifactory.gcp.anz/artifactory/go,direct'
export APIS_DIR=$HOME/anz/apis
export ANZX_APIS_DIR=$HOME/anz/apis

# Configure various tools to use internally issued certs
#  Python libraries
export REQUESTS_CA_BUNDLE=/opt/homebrew/etc/openssl@3/cert.pem
export HTTPLIB2_CA_CERTS=${REQUESTS_CA_BUNDLE}
export GRPC_DEFAULT_SSL_ROOTS_FILE_PATH=${REQUESTS_CA_BUNDLE}  # For gRPC-based libraries
#  Python & gsutil/boto
export ca_certificates_file=${REQUESTS_CA_BUNDLE}
export REQUESTS_CA_BUNDLE=${REQUESTS_CA_BUNDLE}
#  curl
export CURL_CA_BUNDLE=${REQUESTS_CA_BUNDLE}
#  Golang
export SSL_CERT_FILE=${REQUESTS_CA_BUNDLE} 
#  gcloud
export CLOUDSDK_AUTH_CORE_CUSTOM_CA_CERTS_FILE=${REQUESTS_CA_BUNDLE}
export NODE_EXTRA_CA_CERTS=${REQUESTS_CA_BUNDLE}

unsetproxy () { 
 export http_proxy=
 export https_proxy=
 export HTTP_PROXY=
 export HTTPS_PROXY=
}

open_nvim() {
    if jobs | grep -q "nvim"; then
        fg %?nvim
    else
        nvim "$@"
    fi
}
alias n='open_nvim'

cdls () { 
    if [[ -z "$PS1" ]]; then
        cd "$@"
    else
        cd "$@" && eza -la; 
    fi
}

dot () {
    cd ~/dotfiles/ && open_nvim
}
notes () {
    cd ~/notes/ && open_nvim
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

tidy (){
    fd go.mod --hidden --exclude .git -x bash -c "cd {//} && pwd && go mod tidy"
}
update_go (){
    sudo rm -rf /usr/local/go  && GO_VERSION=$(curl -s 'https://go.dev/dl/?mode=json' | sed -n 's/.*"version": "go\([0-9.]*\)".*/\1/p' | head -1) && curl -L "https://go.dev/dl/go${GO_VERSION}.darwin-arm64.tar.gz" | sudo tar -C /usr/local -xzf - && go version
}
token_sit (){
    TOKEN="$(curl --request POST \
        --url https://joker.identity-services-sit-fr.apps.x.gcpnp.anz/ig-int/jwt \
        --header 'Content-Type: application/json' \
        --data '{
          "realm": "/system",
          "anz_token_type": "SystemJWT",
          "scopes": [
              "aegis-introspect"
          ],
          "aud": "https://fabric.anz.com",
          "scope": [
              "https://fabric.anz.com/scopes/appactivity:write",
              "https://fabric.anz.com/scopes/commandcentre:dismiss",
              "https://fabric.anz.com/scopes/commandcentre:read",
              "https://fabric.anz.com/scopes/commandcentre:publish",
              "https://fabric.anz.com/scopes/commandcentre:update"
          ],
          "rqf": {
              "persona": {
                  "_id": "e069158e-0e51-4916-8727-47a76fb56722",
                  "type": "retail"
              },
              "sub": "e069158e-0e51-4916-8727-47a76fb56722",
              "ocvid": "1001308754"
          },
          "expires_in": 600
      }' | \
        jq '.access_token' | \
        tr -d '"')"
      export TOKEN
}

dcleanup(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

alias py='python3'
alias l='eza -la'
alias ls='eza -la'
alias lg='lazygit'
alias cd='cdls'
alias cat=bat
alias bb='brew bundle'

alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git pull'
alias gu='git pull --autostash origin master:master'
alias gcl='git clone'
alias ji='jira issue list -a$(jira me)'
alias c='pbcopy'
alias reauth='gcloud auth login --update-adc && gcloud auth configure-docker'
alias gomodtidy_all='for f in $(find . -name go.mod)
do (cd $(dirname $f); go mod tidy)
done'

alias claude='CLAUDE_CODE_USE_VERTEX=1 CLOUD_ML_REGION=us-east5 ANTHROPIC_VERTEX_PROJECT_ID=anz-x-claude-dev-727b NO_PROXY=us-east5-aiplatform.googleapis.com,artifactory.gcp.anz claude'

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
function killv() {
    killall AppSSOAgent
    kill `ps augx | awk '/Microsoft Teams/ ''{print $2}'`  
    kill `ps augx | awk '/Outlook/ ''{print $2}'`  
    kill `ps augx | awk '/Outlook/ ''{print $2}'`  
    kill `ps augx | awk '/Spotify/ ''{print $2}'`  
}
function watchcomponentlogs(){
    while true ; do
        if [[ "$(docker inspect -f '{{.State.Running}}' commandcentre_component)" == "true" ]]; then
            docker logs -f commandcentre_component
            sleep 0.1;
        fi
        until [[ "$(docker inspect -f '{{.State.Running}}' commandcentre_component)" == "true" ]]; do
            sleep 0.1;
        done;
    done
}
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
# bindkey '^R'   fzf-history-widget
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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
