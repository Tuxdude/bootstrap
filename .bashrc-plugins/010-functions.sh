#
# Author: Ash <tuxdude.io@gmail.com>
#

# Check if the first argument is a bash function
_is_function () {
    declare -f -F "$1" > /dev/null
    return $?
}

# Usage: path_remove $PATH_VAR $wildcard
path_remove() {
    sep="$IFS"
    IFS=':'
    t=($1)
    n=${#t[*]}
    a=()
    for (( i=0; i<n; i++ )); do
        p="${t[i]%%$2}"
        [ "${p}" ] && a[i]="${p}"
    done
    echo "${a[*]}"
    IFS="$sep"
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

# List the git repository URLs, for all the repositories present
# under a given directory
list_all_vim_plugin_repo_urls() {
    for dir in ~/.vim/bundle/*/; do
        if [ -d "$dir/.git" ]; then
            git -C "$dir" config remote.origin.url
        fi
    done
}

# Write the vim plugin repo info to the config file
update_vim_plugin_repo_info() {
    list_all_vim_plugin_repo_urls | sort > ~/.vim/pluginlist.config
}
