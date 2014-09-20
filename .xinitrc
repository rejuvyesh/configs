#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# load for terminal
xrdb merge /home/rejuvyesh/.Xresources

setxkbmap -option 'ctrl:nocaps,compose:menu'

# add terminus font
xset +fp /usr/share/fonts/local
xset fp rehash
xset b 100 5000 50

# mpd
/usr/bin/mpd --no-daemon &

# emacs
#/usr/bin/emacs --daemon

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

# urxvt
urxvt -e tmux &

# volti
volti &

# wifi
wicd-client --tray & >/dev/null

# redshift
# redshift -l 26.4583:80.3173 -t 6500:4500 & >/dev/null
blueshift -c ~/.config/blueshift/comprehensive  &

# fancy window fading
compton -f -I 0.10 -O 0.10 -D 5 -b

# restore current-reads
restore zathura &

# filtered folders
mount_filterfs.sh

WM="xmonad"
exec dbus-launch --auto-syntax --exit-with-session $WM
