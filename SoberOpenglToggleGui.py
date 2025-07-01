import tkinter as tk
import subprocess
import json
import os
import sys

CONFIG_PATH = os.path.expanduser("~/.var/app/org.vinegarhq.Sober/config/sober/config.json")

def set_opengl(value: bool):
    try:
        with open(CONFIG_PATH, "r") as f:
            config = json.load(f)
    except Exception as e:
        print(f"Ошибка чтения конфига: {e}")
        sys.exit(1)

    config["use_opengl"] = value

    try:
        with open(CONFIG_PATH, "w") as f:
            json.dump(config, f, indent=4)
    except Exception as e:
        print(f"Ошибка записи конфига: {e}")
        sys.exit(1)

    subprocess.Popen(["flatpak", "run", "org.vinegarhq.Sober"] + sys.argv[1:])

    root.destroy()


root = tk.Tk()
root.title("Sober OpenGL Toggle")

label = tk.Label(root, text="Use OpenGL:", font=("Arial", 20, "bold"))
label.pack(pady=15)

frame = tk.Frame(root)
frame.pack(pady=5)

btn_on = tk.Button(frame, text="True", width=10, font=("Arial", 14), command=lambda: set_opengl(True))
btn_on.pack(side="left", padx=10)

btn_off = tk.Button(frame, text="False", width=10, font=("Arial", 14), command=lambda: set_opengl(False))
btn_off.pack(side="right", padx=10)

root.mainloop()