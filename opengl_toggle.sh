#!/bin/bash

BIN_DIR="$HOME/.local/bin"
SCRIPT_PATH="$BIN_DIR/sober_toggle_opengl"
DESKTOP_FILE="$HOME/.local/share/applications/sober-toggle-opengl.desktop"

mkdir -p "$BIN_DIR"

# Проверка наличия jq
if ! command -v jq &> /dev/null; then
    echo "🚨 jq не установлен! Установите jq, чтобы скрипт работал."
    exit 1
fi

cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/bash

CONFIG="$HOME/.var/app/org.vinegarhq.Sober/config/sober/config.json"

current_value=$(jq -r '.use_opengl' "$CONFIG")
echo "Текущее значение use_opengl: $current_value"
echo

echo "Выберите действие:"
select opt in "Включить OpenGL" "Выключить OpenGL"; do
    case $REPLY in
        1)
            jq '.use_opengl = true' "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
            echo "OpenGL включён."
            break
            ;;
        2)
            jq '.use_opengl = false' "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
            echo "OpenGL выключен."
            break
            ;;
        *)
            echo "Неверный выбор."
            ;;
    esac
done
EOF

chmod +x "$SCRIPT_PATH"

# .desktop-файл
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Sober OpenGL Toggle
Comment=Включает или выключает OpenGL для Sober
Exec=$SCRIPT_PATH
Icon=utilities-terminal
Terminal=True
Type=Application
Categories=Utility;
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Установка завершена."
echo "📂 Скрипт установлен в: $SCRIPT_PATH"
echo "🖥 Ярлык добавлен: $DESKTOP_FILE"
