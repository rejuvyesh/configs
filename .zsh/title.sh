# title handling

function title() {
  # escape '%' chars in $1, make nonprintables visible
  local a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
    screen*)
      print -Pn "\e]2;$a @$2\a" # plain xterm title
      print -Pn "\ek$a\e\\" # screen title (in ^A")
      ;;
    rxvt*|xterm*)
      print -Pn "\e]2;$a @$2\a" # plain xterm title
      ;;
  esac
}

function precmd() {
  vcs_info 'prompt'
  title "zsh" "%m"
}

# set simple screen title just before program is executed
function preexec() {
  case $TERM in
    screen*)
      local CMD=${1[(wr)^(*=*|sudo|-*)]}
      echo -ne "\ek$CMD\e\\"
      ;;
  esac
} 
