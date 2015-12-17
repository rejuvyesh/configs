#!/bin/sh
#
# File: ls_colors.sh
#
# Created: Saturday, April 19 2014 by rejuvyesh <mail@rejuvyesh.com>
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
#

# fancy ls_colors
#
# meta:
# 0 = Default Colour
# 1 = Bold
# 4 = Underlined
# 5 = Flashing Text
# 7 = Reverse Field
#
# foreground:
# 30 = Black
# 90 = Dark Grey
# 31 = Red
# 91 = Light Red
# 32 = Green
# 92 = Light Green
# 33 = Orange
# 93 = Yellow
# 34 = Blue
# 94 = Light Blue
# 35 = Purple
# 95 = Light Purple
# 36 = Cyan
# 96 = Turquoise
# 37 = Grey
#
# background:
# 40 = Black
# 100 = Dark Grey
# 41 = Red
# 101 = Light Red
# 42 = Green
# 102 = Light Green
# 43 = Orange
# 103 = Yellow
# 44 = Blue
# 104 = Light Blue
# 45 = Purple
# 105 = Light Purple
# 46 = Cyan
# 106 = Turquoise
# 47 = Grey

typeset -A ls_color_hash
ls_color_hash=(
  # basics
  "bd" "40;33;01"
  "cd" "40;33;01"
  "di" "00;36"
  "do" "01;35"
  "ex" "01;32"
  "fi" "00"
  "ln" "01;36"
  "no" "00"
  "or" "40;31;01"
  "ow" "34;42"
  "pi" "40;33"
  "sg" "30;43"
  "so" "01;35"
  "st" "37;44"
  "su" "37;41"
  "tw" "30;42"

  # archives
  "*.7z" "01;31"
  "*.Z" "01;31"
  "*.bz" "01;31"
  "*.bz2" "01;31"
  "*.cpio" "01;31"
  "*.deb" "01;31"
  "*.gz" "01;31"
  "*.lzh" "01;31"
  "*.rar" "01;31"
  "*.rpm" "01;31"
  "*.tar" "01;31"
  "*.tbz2" "01;31"
  "*.tgz" "01;31"
  "*.xz" "01;31"
  "*.z" "01;31"
  "*.zip" "01;31"

  # code (similar to "ex")
  "*.c" "00;32"
  "*.cpp" "00;32"
  "*.go" "00;32"
  "*.h" "00;32"
  "*.hs" "00;32"
  "*.jar" "00;32"
  "*.java" "00;32"
  "*.py" "00;32"
  "*.rb" "00;32"
  "*.sh" "00;32"

  # images
  "*.bmp" "01;35"
  "*.gif" "01;35"
  "*.jpe" "01;35"
  "*.jpeg" "01;35"
  "*.jpg" "01;35"
  "*.pbm" "01;35"
  "*.pcx" "01;35"
  "*.pgm" "01;35"
  "*.png" "01;35"
  "*.ppm" "01;35"
  "*.tga" "01;35"
  "*.tif" "01;35"
  "*.tiff" "01;35"
  "*.xbm" "01;35"
  "*.xpm" "01;35"

  # movies
  "*.asf" "01;33"
  "*.avi" "01;33"
  "*.flv" "01;33"
  "*.m2v" "01;33"
  "*.m4v" "01;33"
  "*.mkv" "01;33"
  "*.mov" "01;33"
  "*.mp4" "01;33"
  "*.mp4v" "01;33"
  "*.mpeg" "01;33"
  "*.mpg" "01;33"
  "*.ogm" "01;33"
  "*.rm" "01;33"
  "*.rmvb" "01;33"
  "*.vob" "01;33"
  "*.wmv" "01;33"
  "*.xcf" "01;33"

  # audio
  "*.aac" "00;36"
  "*.flac" "00;36"
  "*.m4a" "00;36"
  "*.mid" "00;36"
  "*.midi" "00;36"
  "*.mka" "00;36"
  "*.mp3" "00;36"
  "*.mpc" "00;36"
  "*.ogg" "00;36"
  "*.ra" "00;36"
  "*.wav" "00;36"
)
for key in ${(k)ls_color_hash}
do
  export LS_COLORS="$key=${ls_color_hash[$key]}:$LS_COLORS"
done
