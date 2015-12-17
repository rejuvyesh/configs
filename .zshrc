HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=100000

bindkey -e

autoload -U compinit zmv
compinit -u -d ~/.zcompdump-$ZSH_VERSION

# url-quote-magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

source ~/.zsh/zsh_aliases
source ~/.zsh/zsh_prompt
source ~/.zsh/zsh_env
source ~/.zsh/functions.sh
source ~/.zsh/ls_colors.sh
source ~/.zsh/key-bindings.sh
source ~/.zsh/title.sh
source ~/.zsh/syntax.sh
source ~/.zsh/completions.sh
source ~/.zsh/gtd.sh
source ~/.zsh/dirs.sh

[[ -s ~/.zsh/local.sh ]] && source ~/.zsh/local.sh


# Extended Options
setopt nobanghist
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_verify
setopt share_history
setopt extended_history
setopt append_history

setopt interactivecomments
setopt nohup
setopt no_bg_nice
setopt extendedglob
setopt prompt_subst

setopt no_chase_links
setopt no_chase_dots

setopt list_packed
setopt correct
setopt hash_list_all

setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

