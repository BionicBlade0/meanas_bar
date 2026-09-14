import argparse
import os
import requests
import subprocess


parser = argparse.ArgumentParser()
parser.add_argument("path", metavar="path", type=str)
arg = parser.parse_args()


path: str = arg.path
name: str = path.split("/")[-1]
LOCATION: str = "/mnt/hiroshi/Documents/Wallpapers/New Anime/"

if name not in set(os.listdir(LOCATION)):
    response: requests.models.Response = requests.get(path)
    with open(LOCATION + name, "wb") as file:
        file.write(response.content)

# HYPRPAPER
subprocess.run(f"hyprctl hyprpaper wallpaper ,{LOCATION+name}", shell=True)

HYPRPAPER_CONFIG_PATH: str = "/home/hiroshi/.config/hypr/hyprpaper.conf"
hyprpaper_config: str = r"""
splash = false

wallpaper {
    monitor = 
    path =
}
"""

hyprpaper_config = hyprpaper_config.replace("path =", f"path = {LOCATION}{name}")

with open(HYPRPAPER_CONFIG_PATH, "w") as hyprpaper_config_file:
    hyprpaper_config_file.write(hyprpaper_config)

# HYPRLOCK
HYPRLOCK_CONFIG_PATH: str = "/home/hiroshi/.config/hypr/hyprlock.conf"
hyprlock_config: str = r"""
# # BACKGROUND
background {
    monitor =
    path =
    blur_size = 4
    blur_passes = 2
}

# shape {
#     monitor =
#     size = 3840, 2160
#     color = rgba(0, 0, 0, 0.7)
#     position = 0, 0
# }

# GENERAL
general {
    hide_cursor = true
    disable_loading_bar = true
    # fractional_scaling = 1
}

# INPUT FIELD
input-field {
    monitor =
    dots_size = 0.2
    size = 300, 100
    outer_color = rgba(0, 0, 0, 0)
    inner_color = rgba(0, 0, 0, 0)
    font_color = rgb(255, 255, 255)
    check_color = rgba(0, 0, 0, 0)
    fail_color = rgba(0, 0, 0, 0) # if authentication failed, changes outer_color and fail message color
    halign = center
    valign = center
    position = 0, -100
    placeholder_text =  # Text rendered in the input box when it's empty.
    capslock_color = rgba(0, 0, 0, 0)
    # outline_thickness = 3
}

# DATE
label {
  monitor =
  text = cmd[update:1000] echo "$(date +"%A, %B %d")"
  font_size = 40
  font_family = Fira Code Bold
  position = 0, 200
  halign = center
  valign = center
}

# TIME
label {
  monitor =
  text = cmd[update:1000] echo "$(date +"%-I:%M %p")"
  font_size = 100
  font_family = Fire Code Bold
  position = 0, 100
  halign = center
  valign = center
}
"""

hyprlock_config = hyprlock_config.replace("path =", f"path = {LOCATION}{name}")

with open(HYPRLOCK_CONFIG_PATH, "w") as hyprlock_config_file:
    hyprlock_config_file.write(hyprlock_config)
