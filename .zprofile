HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch hist_ignore_space
autoload -Uz compinit zmv
compinit -u -d ~/.zcompdump-$ZSH_VERSION

setopt nobanghist
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_verify
setopt share_history
setopt extended_history
setopt interactivecomments
setopt nohup
setopt no_bg_nice

setopt no_chase_links
setopt no_chase_dots

setopt list_packed
setopt correct
setopt hash_list_all

setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome

source ~/.zsh/zsh_aliases
source ~/.zsh/zsh_env
source ~/.zsh/functions.sh
source ~/.zsh/syntax.sh

function start_ssh_agent() {
    local ssh_env="$XDG_CACHE_HOME/ssh-env"

    if pgrep "ssh-agent" >/dev/null; then
        source "$ssh_env"
    else
        ssh-agent | command grep -Fv 'echo' > "$ssh_env"
        source "$ssh_env"
        ssh-add
    fi
}

export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share

start_ssh_agent

[[ -s ~/.zsh/local.sh ]] && source ~/.zsh/local.sh

# startx
if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
    startx 2>! "$XDG_RUNTIME_DIR"/xsession-errors
fi
