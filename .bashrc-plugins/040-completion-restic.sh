#
# Author: Ash <tuxdude.io@gmail.com>
#

_restic_bash_completion() {
    if hash restic 2> /dev/null; then
        local comp_file=$(mktemp)
        restic generate --bash-completion ${comp_file:?} >/dev/null
        source ${comp_file:?}
        rm ${comp_file:?}
    fi
}

_restic_bash_completion && unset -f _restic_bash_completion
