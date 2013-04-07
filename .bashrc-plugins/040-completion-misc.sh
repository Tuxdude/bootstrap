#
# Author: Ash <tuxdude.github@gmail.com>
#

# Hook up git log's bash-completion to git-forest
_git_forest () {
    _git_log
}

if [ -z "$IN_CBE" ]; then
# Hook up git's bash-completion to gitmulti
    complete -o bashdefault -o default -o nospace -F _git gitmulti 2>/dev/null \
            || complete -o default -o nospace -F _git gitmulti

# Hook up scp's bash-completion to scpresume
    complete -o bashdefault -o default -o nospace -F _scp scpresume 2>/dev/null \
            || complete -o default -o nospace -F _scp scpresume
fi
