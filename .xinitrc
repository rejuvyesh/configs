#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# set the cursor
xsetroot -cursor_name left_ptr &

# load for terminal
xrdb merge /home/rejuvyesh/.Xresources

setxkbmap -option 'ctrl:nocaps,compose:ralt'

# add terminus font
xset +fp /usr/share/fonts/local
xset fp rehash
xset b 100 5000 50

# mpd
/usr/bin/mpd --no-daemon &

# emacs
/usr/bin/emacs --daemon

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
# compose key
export $GTK_IM_MODULE="xim"
export $QT_IM_MODULE="xim"

# # urxvt
urxvt -e tmux &

# wifi
wicd-client --tray & >/dev/null

# fancy window fading
compton -f -I 0.10 -O 0.10 -D 5 -b

WM="awesome"
exec dbus-launch --auto-syntax --exit-with-session $WM
