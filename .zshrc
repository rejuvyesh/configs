HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=100000

bindkey -e


# url-quote-magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

source ~/.zsh/options.sh
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



# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

