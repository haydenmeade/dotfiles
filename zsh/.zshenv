. "$HOME/.cargo/env"

export {http,https,all}_proxy=http://localhost:3128
export {HTTP,HTTPS,ALL}_PROXY=$http_proxy

# osascript
switchToOsa () {
    osascript -e 'activate application "'"$1"'"'
}

# yabai
switchToYabai () {
    id="$(yabai -m query --windows | jq --arg app "$1" -c '(map(select(.app == $app)) | first)')" 
    space_id="$(echo "$id" | jq '.space' )" 
    win_id="$(echo "$id" | jq '.id' )" 
    curr_space_id="$(yabai -m query --spaces | jq -c 'map(select(."has-focus" == true))')"
    if [[ curr_space_id != space_id ]]; then
        yabai -m space --focus "${space_id}" 
    fi
    yabai -m window --focus "${win_id}"
}

# Load API tokens and secrets (not tracked in git)
if [[ -f $HOME/.zshsecrets ]]; then
    source $HOME/.zshsecrets
fi