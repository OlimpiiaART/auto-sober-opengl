#!/bin/bash
# set -euo pipefail

INSTALL_PATH="$HOME/.local/bin/sober_use_opengl.sh"
DESKTOP_FILE="/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications/org.vinegarhq.Sober.desktop"

if ! command -v zenity &>/dev/null; then
    echo "Error: zenity is not installed. Install zenity and repeat."
    exit 1
fi

if [[ ! -f "$HOME/.config/sober-opengl-placeids.txt" ]]; then
    echo "129279692364812," > "$HOME/.config/sober-opengl-placeids.txt"
fi

if [[ ! -f "$DESKTOP_FILE" ]]; then
    echo "Error: The desktop startup file was not found: $DESKTOP_FILE."
    echo "Install Sober."
    exit 1
fi

mkdir -p "$(dirname "$INSTALL_PATH")"

curl -sSL https://raw.githubusercontent.com/OlimpiiaART/sober_opengl/refs/heads/main/sober_use_opengl.sh -o "$INSTALL_PATH"
chmod 755 "$INSTALL_PATH"

sudo cp "$DESKTOP_FILE" "/tmp/org.vinegarhq.Sober.desktop.backup.$(date +%Y%m%d%H%M%S)"

sudo sed -i "s|^Exec=.*|Exec=$INSTALL_PATH %u|" "$DESKTOP_FILE"

# little useless
# if command -v update-desktop-database >/dev/null; then
#     sudo update-desktop-database /usr/share/applications/ 2>/dev/null || true
#     sudo update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
# fi

echo "✅ The installation is complete. The script is installed in $INSTALL_PATH"
