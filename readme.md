# Introduction
An opinionated hyprland bar inspired by waybar.

# Features
## The Good
- Good aesthetics

## The Bad
- Lack of settings (anything needs changing, go into the code)

# Dependencies
## Required
- hyprland
- quickshell
- Font Awesome
- Fira Code

## Optional
- python (wallhaven and weather will not work)
- requests (python module `pip install requests`)
- hyprpaper (related to wallpaper)
- hyprlock (related to wallpaper)

# Setup
- In the terminal execute `cd /config/directory && quickshell -d --config /config/directory`.
- Add the following to your `hyprland.lua` config file for blur effects.
```
hl.layer_rule({
    name = "quickshell_blur",
    match = {
        namespace = "quickshell"
    },

    blur = true
})

hl.layer_rule({
    name = "quickshell_popup_blur",
    match = {
        namespace = "quickshell_popup"
    },

    blur = true,
    no_anim = true,
    ignore_alpha = 0

})
```

# Troubleshoot
- The bar is configured for 1080p. If too small or large, go to `shell.qml` and change the value of `property int scale:` to any integer you see fit. If fractional scaling required, then change `propert int scale` to `property double scale`, and put the value as any fraction (not recommended though).

# Showcase
![](/showcase.png)