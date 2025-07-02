#!/bin/bash
# set -euo pipefail

CONFIG_PATH="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"
PLACEID_LIST="$HOME/.config/sober-opengl-placeids.txt"

[[ -f "$CONFIG_PATH" ]] || {
    zenity --error --text="Config not found: $CONFIG_PATH"
    exit 1
}

[[ -f "$PLACEID_LIST" ]] || echo "129279692364812," > "$PLACEID_LIST"

update_opengl_setting() {
    if [[ $1 == true ]]; then
        sed -i 's/"use_opengl": false/"use_opengl": true/' "$CONFIG_PATH"
    else
        sed -i 's/"use_opengl": true/"use_opengl": false/' "$CONFIG_PATH"
    fi
}

prompt_opengl_choice() {
    CHOICE=$(zenity --list --title="Use OpenGL?" --text="$1" --column="" "False" "True")
    case "$CHOICE" in
        True) update_opengl_setting true ;;
        False) update_opengl_setting false ;;
        *) exit 0 ;;
    esac
}

if [[ -z "${1:-}" ]]; then
    prompt_opengl_choice "You have launched the Sober client, select OpenGL mode manually"
    flatpak run org.vinegarhq.Sober "$@"
    exit 0
fi

place_id=$(echo "$1" | sed 's/%3D/=/g' | grep -oE 'placeId=[0-9]+' | sed 's/.*=//' || true)

if [[ -z "$place_id" ]]; then
    prompt_opengl_choice "placeId not found, select OpenGL mode manually"
else
    if grep -qw "$place_id" "$PLACEID_LIST"; then
        update_opengl_setting true
        # zenity --info --title="Sober OpenGL Toggle" --text="✅ placeId $place_id found\nOpenGL enabled"
    else
        update_opengl_setting false
        # zenity --info --title="Sober OpenGL Toggle" --text="⚠️ placeId $place_id not found\nOpenGL disabled"
    fi
fi

flatpak run org.vinegarhq.Sober "$@"
