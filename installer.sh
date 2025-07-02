#!/bin/bash
set -euo pipefail

INSTALL_PATH="/opt/sober_useopengl_gui.sh"
DESKTOP_FILE="/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications/org.vinegarhq.Sober.desktop"

if ! command -v zenity &>/dev/null; then
    echo "Ошибка: zenity не установлен. Установите zenity и повторите."
    exit 1
fi

sudo mkdir -p "$(dirname "$INSTALL_PATH")"

sudo curl -sSL https://raw.githubusercontent.com/OlimpiiaART/sober_opengl/refs/heads/main/sober_useopengl_gui.sh -o "$INSTALL_PATH"
sudo chmod 755 "$INSTALL_PATH"

sudo cp "$DESKTOP_FILE" "/tmp/org.vinegarhq.Sober.desktop.backup.$(date +%Y%m%d%H%M%S)"

sudo sed -i 's|^Exec=.*|Exec=/usr/bin/python3 '"$INSTALL_PATH"' %u|' "$DESKTOP_FILE"

if command -v update-desktop-database >/dev/null; then
    sudo update-desktop-database /usr/share/applications/ 2>/dev/null || true
    sudo update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
fi

echo "✅ Установка завершена. Скрипт установлен в $INSTALL_PATH"
