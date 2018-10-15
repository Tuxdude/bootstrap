#
# Author: Ash <tuxdude.io@gmail.com>
#

# Check if the first argument is a bash function
_is_function () {
    declare -f -F "$1" > /dev/null
    return $?
}

# Set the terminal window title
set_title() {
    if [ -z "$1" ]; then
        if [ -n "$WINDOW_TITLE" ]; then
            echo -ne "\033]0;$WINDOW_TITLE\007"
        elif [ -z "${SSH_CONNECTION}" ]; then
            echo -ne "\033]0;${PWD}\007"
        else
            echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
        fi
    fi
}

# Sort du's output by size
duf() {
    du -sk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}

# Find last modified files
lastmod() {
    if [ -z "$1" ]; then
        find . -type f -print0 | xargs -0 stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
    else
        find $1 -type f -print0 | xargs -0 stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
    fi
}
