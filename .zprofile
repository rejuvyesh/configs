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

[[ -s ~/.zsh/local.sh ]] && source ~/.zsh/local.sh

# keychain
eval $(keychain --eval -Q --agents ssh --quiet id_rsa cse)
