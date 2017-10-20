# X keyboard settings
xrdb ~/.Xresources
setxkbmap -option "ctrl:nocaps"
xset r rate 150 80
xsetroot -cursor_name left_ptr

# Disable touchpad when typing
syndaemon -t -d -i 1

export TERM=xterm-256color

# Background Image
CURRENT_WALLPAPER="~/documents/img/wall.jpg"
feh --bg-scale $CURRENT_WALLPAPER

# Window manager
exec stumpwm
