HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=100000

source ~/.zsh/options.sh
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
        for key in $HOME/.ssh/*.pub; do
            ssh-add ${key:r}
        done
    fi
}

export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
if test -z "${XDG_RUNTIME_DIR}"; then
    export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi
export NO_AT_BRIDGE=1

systemctl --user import-environment PATH

[[ -s ~/.zsh/local.sh ]] && source ~/.zsh/local.sh

# startx
if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
    startx 2>! "$HOME"/.xsession-errors
fi
