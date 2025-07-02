#!/bin/bash
# set -euo pipefail

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

# echo "$@" > ~/txt

place_id=$(echo "$1" | sed 's/%3D/=/g' | grep -oE 'placeId=[0-9]+' | sed 's/.*=//' || true)

if [[ -z "$place_id" ]]; then
    CHOICE=$(zenity --list --title="Use OpenGL?" --text="placeId not found, select OpenGL mode manually" --column="" "False" "True")

    if [ -z "$CHOICE" ]; then
        exit 0
    fi

    if [ "$CHOICE" = "True" ]; then
        sed -i 's/"use_opengl": false/"use_opengl": true/' "$CONFIG_PATH"
    elif [ "$CHOICE" = "False" ]; then
        sed -i 's/"use_opengl": true/"use_opengl": false/' "$CONFIG_PATH"
    fi
else
    if grep -qw "$place_id" "$PLACEID_LIST"; then
        sed -i 's/"use_opengl": false/"use_opengl": true/' "$CONFIG_PATH"
        # zenity --info --title="Sober OpenGL Toggle"  --text="✅ placeId $place_id found\nOpenGL enabled"
    else
        sed -i 's/"use_opengl": true/"use_opengl": false/' "$CONFIG_PATH"
        # zenity --info --title="Sober OpenGL Toggle" --text="⚠️ placeId $place_id not found\nOpenGL disabled"
    fi
fi

flatpak run org.vinegarhq.Sober "$@"
