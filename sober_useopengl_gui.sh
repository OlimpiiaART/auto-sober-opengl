#!/bin/bash

CONFIG_PATH="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

if [ ! -f "$CONFIG_PATH" ]; then
    zenity --error --text="❌ Файл конфигурации не найден:\n$CONFIG_PATH"
    exit 1
fi

CHOICE=$(zenity --list --title="Use OpenGL?" --text="" --column="" "False" "True")

if [ -z "$CHOICE" ]; then
    exit 0
fi

if [ "$CHOICE" = "True" ]; then
    sed -i 's/"use_opengl": false/"use_opengl": true/' "$CONFIG_PATH"
elif [ "$CHOICE" = "False" ]; then
    sed -i 's/"use_opengl": true/"use_opengl": false/' "$CONFIG_PATH"
fi

flatpak run org.vinegarhq.Sober "$@"
