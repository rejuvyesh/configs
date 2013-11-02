# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch hist_ignore_space
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rejuvyesh/.zshrc'

autoload -Uz compinit
compinit
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

# Extended Options
setopt nobanghist
setopt hist_reduce_blanks
setopt hist_ignore_all_dups
setopt hist_verify
setopt share_history
setopt extended_history
setopt interactivecomments


# startx
# if [[ $(tty) = /dev/tty1 ]] && [[ -z "$DISPLAY" ]]; then
#     exec startx
# fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
