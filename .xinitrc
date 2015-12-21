#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# load relevant zsh settings
. $HOME/.zsh/zsh_env

# load for terminal
xrdb merge $HOME/.Xresources

# Remap caps to ctrl
setxkbmap -option 'ctrl:nocaps,compose:menu'

# add terminus font
xset +fp /usr/share/fonts/local
xset fp rehash
xset b 100 5000 50

# wallpaper
wallpaper.sh &

# mpd-scribble Last-FM
pidof mpdscribble >& /dev/null
if [ $? -ne 0 ]; then
    mpdscribble &
fi

unclutter -root -idle 1f &

## qt + gtk
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# wifi
cmst -w 10 & >/dev/null

# restore current-reads
restore zathura &

# dropbox
dropbox start &

# Start wiki
cd $HOME/src/www/wiki && ./start.sh &

# Start arbtt-graph
cd $HOME/src/www/arbtt-graph/ && ./arbtt-serve.py &

# reminders
remind -z -k'notify-send --icon=dialog-information "Reminder" %s &' ~/Documents/spoiler/reminders.txt &

WM="awesome"
# WM="xmonad"
exec dbus-launch --auto-syntax --exit-with-session $WM
