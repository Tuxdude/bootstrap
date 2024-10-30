#
# Author: Ash <tuxdude.io@gmail.com>
#

_dive_completions()
{
    local cur prev words cword
    _init_completion -n : || return

    case "$cur" in
        -*)
            COMPREPLY=( $( compgen -W '$(_parse_help "$1")' -- "$cur" ) )
            ;;
        *)
            COMPREPLY=( $(compgen -W "$(docker images --format '{{.Repository}}:{{.Tag}}')" -- "$cur") )
            __ltrim_colon_completions "$cur"
            ;;
    esac
}

complete -F _dive_completions dive
