# Make a dir and cd into it
md () {
  mkdir -p $1
  cd $1
}

# Move into a dir and show it's contents
function c        () { cd -- "$@"; ls -q --color=auto; }

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
    # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
      # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}

# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }
# Copy SSH public key
alias cbssh="cb ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"

# cp with progress bar
cp_p()
{
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
    | awk '{
        count += $NF
            if (count % 10 == 0) {
               percent = count / total_size * 100
               printf "%3d%% [", percent
               for (i=0;i<=percent;i++)
                  printf "="
               printf ">"
               for (i=percent;i<100;i++)
                  printf " "
               printf "]\r"
            }
         }
         END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

# tmux
alias scratchpad="tm scratchpad"
function tm() {
  if [[ $# -ge 1 ]]; then
    tmux attach -t $1 || tmux new-session -s $1 \; set default-path "$(pwd)" \; set -g -a update-environment ' PWD'
  else
    tmux new-session \; set default-path "$(pwd)" \; set -g -a update-environment ' PWD'
  fi
}

# colored man-pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;32m") \
    LESS_TERMCAP_md=$(printf "\e[1;32m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;31m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;31m") \
    man "$@"
}

# systemd shortcuts (stolen from Prezto)
user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment
)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $user_commands; do; alias usc-$c="systemctl --user $c"; done

unset user_commands

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment
)

for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done

unset sudo_commands

function usage() {
  du -h --summarize "$@"
}
# pack folder
function pack-7z() {
  for dir in $*; do
    echo "packing `usage $dir`..."
    7z -mx9 a $dir.7z $dir && rm -rf $dir
  done
}
function pack-xz() {
  for dir in $*; do
    echo "packing `usage $dir`..."
    XZ_OPT=-9 tar -c -v --xz -f $dir.tar.xz $dir
  done
}
function pack-tar() {
  for dir in $*; do
    echo "packing `usage $dir`..."
    tar -vczf $dir.tar.gz $dir && rm -rf $dir
  done
}
function pack-large() {
  for dir in "$*"; do
    echo "packing `usage $dir`..."
    lrztar -z $dir && rm -rf $dir
  done
}
alias pack="pack-7z"

function ppt2pdf() {
  loimpress --headless --convert-to pdf "$@"
}

function bu() {
  (cd ~/.bundle; try bundle update; bundle clean --force; )
}

# scan dir for thumbs
function sx() { sxiv -trq "$@" 2>/dev/null &!}

# mirror
function mirror() {
  wget --mirror --no-parent --adjust-extension --restrict-file-names=windows --convert-links -p -w 15 -P ~/archive/www/ "$@"
}
