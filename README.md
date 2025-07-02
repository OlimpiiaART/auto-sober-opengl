# Automatic Sober OpenGL Toggle Installer

This installer script sets up a helper script to automatic toggle OpenGL usage the Sober.

---

## How to add OpenGL inclusion for Roblox place

To enable OpenGL for specific games, add their **placeIds** to the whitelist file `~/.config/sober-opengl-placeids.txt`. Each **placeId** should be placed after the previous one, separated by commas!

Example of whitelist file: `123456789,987654321,129279692364812`

---

## Installation

Open your terminal and run the following command. 

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/OlimpiiaART/sober_opengl/main/installer.sh)"
```

**Note:** This script requires root privileges, so you may be prompted for your password.

---

## Requirements
(tested on Arch Linux)

* `zenity` (for GUI dialogs)
* Flatpak installed with the Sober app (`org.vinegarhq.Sober`)
