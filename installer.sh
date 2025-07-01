#!/bin/bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Ошибка: скрипт должен запускаться с правами root."
    exit 1
fi

INSTALL_PATH="/opt/sober_useopengl_gui.py"
DESKTOP_FILE="/var/lib/flatpak/app/org.vinegarhq.Sober/current/active/export/share/applications/org.vinegarhq.Sober.desktop"

if ! command -v python3 &>/dev/null; then
    echo "Ошибка: python3 не установлен. Установите python3 и повторите."
    exit 1
fi

if ! python3 -c "import tkinter" &>/dev/null; then
    echo "Ошибка: модуль tkinter не найден в python3. Установите tkinter и повторите. Arch - tk, Debian/Ubuntu - python3-tk, Fedora - python3-tkinter"
    exit 1
fi

mkdir -p "$(dirname "$INSTALL_PATH")"

curl -sSL https://raw.githubusercontent.com/OlimpiiaART/sober_opengl/refs/heads/main/SoberOpenglToggleGui.py -o "$INSTALL_PATH"
chmod 755 "$INSTALL_PATH"

cp "$DESKTOP_FILE" "/tmp/org.vinegarhq.Sober.desktop.backup.$(date +%Y%m%d%H%M%S)"

sed -i 's|^Exec=.*|Exec=/usr/bin/python3 '"$INSTALL_PATH"' %u|' "$DESKTOP_FILE"

# Обновляем кэш ярлыков, если команда есть
command -v update-desktop-database >/dev/null && {
    update-desktop-database /usr/share/applications/ 2>/dev/null || true
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
}

echo "✅ Установка завершена. Скрипт установлен в $INSTALL_PATH"
