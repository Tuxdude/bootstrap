#
# Author: Ash <tuxdude.io@gmail.com>
#

# Hook up git log's bash-completion to git-forest
_git_forest () {
    _git_log
}

# pip bash completion (increases start up time)
# So define a function to load pip completion manually
load_pip_completion() {
    unset -f load_pip_completion
    if hash pip 2> /dev/null; then
        eval "$(pip completion --bash)"
    fi
}

# aws bash completion
if hash aws_completer 2> /dev/null; then
    complete -C "$(which aws_completer)" aws
fi

# Hook up git's bash-completion to gitmulti
complete -o bashdefault -o default -o nospace -F _git gitmulti 2>/dev/null \
        || complete -o default -o nospace -F _git gitmulti

# Hook up scp's bash-completion to scpresume
complete -o bashdefault -o default -o nospace -F _scp scpresume 2>/dev/null \
        || complete -o default -o nospace -F _scp scpresume

# kubectl bash completion
if hash kubectl 2> /dev/null; then
    source <(kubectl completion bash)
fi
