bindkey -e

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search


bindkey '^[[3~' delete-char
bindkey '[1~'  beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[5~' beginning-of-history
bindkey '^[[6~' end-of-history
bindkey '^[[33~' backward-kill-word
