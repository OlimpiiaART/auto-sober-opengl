#!/bin/bash
set -euo pipefail

CONFIG_PATH="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"
PLACEID_LIST="$HOME/.config/sober-opengl-placeids.txt"

[[ -f "$CONFIG_PATH" ]] || {
    zenity --error --text="Config not found: $CONFIG_PATH"
    exit 1
}

[[ -f "$PLACEID_LIST" ]] || touch "$PLACEID_LIST"

[[ -n "${1:-}" ]] || {
    zenity --error --text="No roblox-player string passed."
    exit 1
}

place_id=$(echo "${1##*placelauncherurl:}" | cut -d'+' -f1 | \
    sed -e 's/%3A/:/g' -e 's/%2F/\//g' -e 's/%3D/=/g' -e 's/%26/\&/g' -e 's/%3F/?/g' | \
    grep -oP 'placeId=\K[0-9]+')


if [[ -z "$place_id" ]]; then
    zenity --error --text="placeId not found"
    exit 1
fi

if grep -qw "$place_id" "$PLACEID_LIST"; then
    sed -i 's/"use_opengl": false/"use_opengl": true/' "$CONFIG_PATH"
    #zenity --info --title="Sober OpenGL Toggle"  --text="✅ placeId $place_id found\nOpenGL enabled"
else
    sed -i 's/"use_opengl": true/"use_opengl": false/' "$CONFIG_PATH"
    #zenity --info --title="Sober OpenGL Toggle" --text="⚠️ placeId $place_id not found\nOpenGL disabled"
fi

flatpak run org.vinegarhq.Sober "$@"
