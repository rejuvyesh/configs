# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch hist_ignore_space
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rejuvyesh/.zshrc'

autoload -Uz compinit zmv
compinit -u -d ~/.zcompdump-$ZSH_VERSION

# url-quote-magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# End of lines added by compinstall

##########################
# Additions by Rejuvyesh #
##########################

source ~/.zsh/zsh_aliases
source ~/.zsh/zsh_prompt
source ~/.zsh/zsh_env
source ~/.zsh/functions.sh
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

# make spaces saner
export IFS=$'\t'$'\n'$'\0'

# added by travis gem
[ -f /home/rejuvyesh/.travis/travis.sh ] && source /home/rejuvyesh/.travis/travis.sh


