. "$HOME/.cargo/env"

# yabai
switchTo () {
    id="$(yabai -m query --windows | jq --arg app "$1" -c 'map(select(.app == $app))')" && \
    space_id="$(echo "$id" | jq '.[].space' )" && \
    win_id="$(echo "$id" | jq '.[].id' )" && \
    yabai -m space --focus "${space_id}" && \
    yabai -m window --focus "${win_id}"
}
