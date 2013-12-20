# Make a dir and cd into it
md () {
    mkdir -p $1
    cd $1
}

# Move into a dir and show it's contents
function c        () { cd -- "$@"; ls -q --color=auto; }

function compress () {
#!/bin/sh
#Thanks to "Wicked Cool Shell Scripts: 101 Scripts for Linux, Mac OS X, and Unix Systems"
# bestcompress - given a file, try compressing it with all the available
#  compression tools and keep the compressed file that's smallest, reporting
#  the result to the user. If '-a' isn't specified, it skips compressed
#  files in the input stream.
        Z="zip"
        gz="gzip"
        bz="bzip2"
        Zout="/tmp/bestcompress.$$.zip"
        gzout="/tmp/bestcompress.$$.gz"
        bzout="/tmp/bestcompress.$$.bz"
        skipcompressed=1
        if [ "$1" = "-a" ]
        then
                skipcompressed=0 ;
                shift
        fi
        if [ $# -eq 0 ]
        then
                echo "Usage: $0 [-a] file or files to optimally compress" >&2;
        fi
        trap "/bin/rm -f -- $Zout $gzout $bzout" EXIT
        for name
        do
                if [ ! -f "$name" ] ; then
                        echo "$0: file $name not found. Skipped." >&2
                        continue
                fi
                if [ "$(echo $name | egrep '(\.zip$|\.gz$|\.bz2$)')" != "" ] ; then
                        if [ $skipcompressed -eq 1 ] ; then
                                echo "Skipped file ${name}: it's already compressed."
                                continue
                        else
                                echo "Warning: Trying to double-compress $name"
                        fi
                fi
                $Z < "$name" > $Zout &
                $gz < "$name" > $gzout &
                $bz < "$name" > $bzout &
                wait    # run compressions in parallel for speed. Wait until all are done
                smallest="$(ls -l "$name" $Zout $gzout $bzout | \
   awk '{print $5"="NR}' | sort -n | cut -d= -f2 | head -1)"
                case "$smallest" in
                        1 ) echo "No space savings by compressing $name. Left as-is."
                                ;;
                        2 ) echo Best compression is with compress. File renamed ${name}.zip
                                mv $Zout "${name}.zip" ; rm -f -- "$name"
                                ;;
                        3 ) echo Best compression is with gzip. File renamed ${name}.gz
                                mv $gzout "${name}.gz" ; rm -f -- "$name"
                                ;;
                        4 ) echo Best compression is with bzip2. File renamed ${name}.bz2
                                mv $bzout "${name}.bz2" ; rm -f -- "$name"
                esac
        done
}

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

# pack folder
function pack-7z() {
    for dir in $*; do
        echo "packing $dir..."
        7z -mx9 a $dir.7z $dir && rm -rf $dir
    done
}
function pack-tar() {
    for dir in $*; do
        echo "packing $dir..."
        tar -vczf $dir.tar.gz $dir && rm -rf $dir
    done
}
alias pack="pack-7z"

function j () {
    if [[ ${@} = -* ]]
    then
        autojump ${@}
        return
    fi
    local new_path="$(autojump ${@})"
    if [ -d "${new_path}" ]
    then
        echo -e "\\033[31m${new_path}\\033[0m"
        cd "${new_path}"
    else
        echo "autojump: directory '${@}' not found"
        echo "Try \`autojump --help\` for more information."
        false
    fi
}

function ppt2pdf() {
    loimpress --headless --convert-to pdf "$@"
}
