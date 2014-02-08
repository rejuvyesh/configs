# GTD

# full todo list
alias t="noglob todo.sh -d ~/.todo.cfg"
alias ta="t add"
alias td="t do"
alias trm="t rm"

# only what is relevant today
alias now="noglob todo.sh -d ~/.todo-today.cfg"
alias n="now"
alias nl="now ls"
alias na="now add"
alias nd="now do"
alias nrm="now rm"

# idea file
alias idea="noglob todo.sh -d ~/.todo-ideas.cfg"
alias ideas="idea ls"
alias ia="idea add"
alias id="idea do"
alias il="idea ls"
alias irm="idea rm"

# timetrap
# time intervals
function tid() {
    if [[ $# -eq 0 ]]; then
        arg="all"
    else
        arg=($*)
    fi
    ti display --context $arg --start 'today 0:00'
}
function tiy() {
    if [[ $# -eq 0 ]]; then
        arg="all"
    else
        arg=($*)
    fi
    ti display --context $arg --start 'yesterday 0:00' --stop 'yesterday 23:59:59'
}
function tiw() {
    if [[ $# -eq 0 ]]; then
        arg="all"
    else
        arg=($*)
    fi
    ti display --context $arg --start 'last monday'
}
function tim() {
    if [[ $# -eq 0 ]]; then
        arg="all"
    else
        arg=($*)
    fi
    ti display --context $arg --start 'first day this month'
}
function tilm() {
    if [[ $# -eq 0 ]]; then
        arg="all"
    else
        arg=($*)
    fi
    ti display --context $arg --start 'first day last month' --stop 'first day this month'
}

function ti_past() {
    if [[ $# -lt 1 || $# -gt 4 ]]; then
        echo "usage: ti_past [context] start [end] [task]"
        return 1
    fi
    if [[ $# -gt 1 ]]; then
        ti sheet $1
        ti in -a $2 $4
    else
        ti in -a $1 $4
    fi
    if [[ $# -gt 2 ]]; then
        ti out -a $3
    fi
}

# shortcuts
alias ti="noglob ti"
alias tin="ti in"
alias tio="ti out"
alias to="tio"
alias tir="ti now"

