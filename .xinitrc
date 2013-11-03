# # set the cursor
 xsetroot -cursor_name left_ptr &

#run systemd as user instance
#/usr/lib/systemd/systemd --usfr &

# # load for terminal
xrdb merge /home/rejuvyesh/.Xresources

setxkbmap -option ctrl:nocaps

# # add terminus font
 xset +fp /usr/share/fonts/local
 xset fp rehash
 xset b 100 5000 50
# #launch redshift
#redshift -l 26.4583:80.3173 -t 5500:4000 -m randr &
/usr/bin/mpd --no-daemon &

/usr/bin/emacs --daemon 
# # wallpaper
wallpaper.sh &
eval "$(gpg-agent --daemon)" &
# mpd-scribble Last-FM
pidof mpdscribble >& /dev/null
if [ $? -ne 0 ]; then
    mpdscribble &
fi

unclutter -root -idle 1f &

## qt + gtk
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# # urxvt
urxvt -e tmux &

# wifi
wicd-client --tray & >/dev/null

# fancy window fading
compton -f -I 0.10 -O 0.10 -D 5 -b

eval "$(gpg-agent --daemon)" &

python2 /home/rejuvyesh/firewall-auth.pyc >& /dev/null

# #start xmonad
# WM="start_xmonad.sh"
 WM="awesome"
 exec $WM
