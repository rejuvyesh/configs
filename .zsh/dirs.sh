#!/bin/sh
#
# File: dirs.sh
#
# Created: Monday, December 16 2013 by rejuvyesh <mail@rejuvyesh.com>
# License: GNU GPL 3 <http://www.gnu.org/copyleft/gpl.html>
#

# named directories
typeset -A NAMED_DIRS

NAMED_DIRS=(
    dev       ~/dev
    scripts   ~/dev/scripts
    mtba      ~/dev/matlab/mtba
    com       ~/dev/www/rejuvyesh.com
)

for key in ${(k)NAMED_DIRS}
do
    # only add paths that actually exist
    if [[ -d ${NAMED_DIRS[$key]} ]]; then
        hash -d $key=${NAMED_DIRS[$key]}
    fi
done

function lsdirs () {
    for key in ${(k)NAMED_DIRS}
    do
        printf "%15s --> %s\n" $key ${NAMED_DIRS[$key]}
    done | sort -b
}