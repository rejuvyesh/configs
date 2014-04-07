# completion

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only

# ignore completion for non-existant functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# complete ../
zstyle ':completion:*:cd:*' special-dirs ..

# use a cache
zstyle ':completion:*' use-cache on

# Case insensitivity, partial matching, substitution
zstyle ':completion:*' matcher-list 'm:{A-Z}={a-z}' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true

# always rehash not found commands
zstyle ':acceptline:*' rehash true

# sudo completion
zstyle ':completion:*:sudo:*' command-path $path

fpath=(~/.zsh/pass-completion $fpath)
fpath=(~/.zsh/gibo-completion $fpath)
