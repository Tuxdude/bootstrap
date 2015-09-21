#!/bin/bash

__my_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref cur prev words cword
}

__debug()
{
    if [[ -n ${BASH_COMP_DEBUG_FILE} ]]; then
        echo "$*" >> "${BASH_COMP_DEBUG_FILE}"
    fi
}

__index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__handle_reply()
{
    __debug "${FUNCNAME}"
    case $cur in
        -*)
            compopt -o nospace
            local allflags
            if [ ${#must_have_one_flag[@]} -ne 0 ]; then
                allflags=("${must_have_one_flag[@]}")
            else
                allflags=("${flags[*]} ${two_word_flags[*]}")
            fi
            COMPREPLY=( $(compgen -W "${allflags[*]}" -- "$cur") )
            [[ $COMPREPLY == *= ]] || compopt +o nospace
            return 0;
            ;;
    esac

    # check if we are handling a flag with special work handling
    local index
    __index_of_word "${prev}" "${flags_with_completion[@]}"
    if [[ ${index} -ge 0 ]]; then
        ${flags_completion[${index}]}
        return
    fi

    # we are parsing a flag and don't have a special handler, no completion
    if [[ ${cur} != "${words[cword]}" ]]; then
        return
    fi

    local completions
    if [[ ${#must_have_one_flag[@]} -ne 0 ]]; then
        completions=("${must_have_one_flag[@]}")
    elif [[ ${#must_have_one_noun[@]} -ne 0 ]]; then
        completions=("${must_have_one_noun[@]}")
    else
        completions=("${commands[@]}")
    fi
    COMPREPLY=( $(compgen -W "${completions[*]}" -- "$cur") )

    if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
        declare -F __custom_func >/dev/null && __custom_func
    fi
}

# The arguments should be in the form "ext1|ext2|extn"
__handle_filename_extension_flag()
{
    local ext="$1"
    _filedir "@(${ext})"
}

__handle_flag()
{
    __debug "${FUNCNAME}: c is $c words[c] is ${words[c]}"

    # if a command required a flag, and we found it, unset must_have_one_flag()
    local flagname=${words[c]}
    # if the word contained an =
    if [[ ${words[c]} == *"="* ]]; then
        flagname=${flagname%=*} # strip everything after the =
        flagname="${flagname}=" # but put the = back
    fi
    __debug "${FUNCNAME}: looking for ${flagname}"
    if __contains_word "${flagname}" "${must_have_one_flag[@]}"; then
        must_have_one_flag=()
    fi

    # skip the argument to a two word flag
    if __contains_word "${words[c]}" "${two_word_flags[@]}"; then
        c=$((c+1))
        # if we are looking for a flags value, don't show commands
        if [[ $c -eq $cword ]]; then
            commands=()
        fi
    fi

    # skip the flag itself
    c=$((c+1))

}

__handle_noun()
{
    __debug "${FUNCNAME}: c is $c words[c] is ${words[c]}"

    if __contains_word "${words[c]}" "${must_have_one_noun[@]}"; then
        must_have_one_noun=()
    fi

    nouns+=("${words[c]}")
    c=$((c+1))
}

__handle_command()
{
    __debug "${FUNCNAME}: c is $c words[c] is ${words[c]}"

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]}"
    else
        next_command="_${words[c]}"
    fi
    c=$((c+1))
    __debug "${FUNCNAME}: looking for ${next_command}"
    declare -F $next_command >/dev/null && $next_command
}

__handle_word()
{
    if [[ $c -ge $cword ]]; then
        __handle_reply
	return
    fi
    __debug "${FUNCNAME}: c is $c words[c] is ${words[c]}"
    if [[ "${words[c]}" == -* ]]; then
	__handle_flag
    elif __contains_word "${words[c]}" "${commands[@]}"; then
        __handle_command
    else
        __handle_noun
    fi
    __handle_word
}

_hugo_server()
{
    last_command="hugo_server"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--appendPort")
    flags+=("--bind=")
    flags+=("--disableLiveReload")
    flags+=("--help")
    flags+=("-h")
    flags+=("--meminterval=")
    flags+=("--memstats=")
    flags+=("--port=")
    two_word_flags+=("-p")
    flags+=("--watch")
    flags+=("-w")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_version()
{
    last_command="hugo_version"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_config()
{
    last_command="hugo_config"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_check_ulimit()
{
    last_command="hugo_check_ulimit"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_check()
{
    last_command="hugo_check"
    commands=()
    commands+=("ulimit")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_benchmark()
{
    last_command="hugo_benchmark"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--count=")
    two_word_flags+=("-n")
    flags+=("--cpuprofile=")
    flags+=("--help")
    flags+=("-h")
    flags+=("--memprofile=")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_convert_toJSON()
{
    last_command="hugo_convert_toJSON"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_convert_toTOML()
{
    last_command="hugo_convert_toTOML"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_convert_toYAML()
{
    last_command="hugo_convert_toYAML"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_convert()
{
    last_command="hugo_convert"
    commands=()
    commands+=("toJSON")
    commands+=("toTOML")
    commands+=("toYAML")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")
    flags+=("--output=")
    two_word_flags+=("-o")
    flags+=("--unsafe")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_new_site()
{
    last_command="hugo_new_site"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("-f")
    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_new_theme()
{
    last_command="hugo_new_theme"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_new()
{
    last_command="hugo_new"
    commands=()
    commands+=("site")
    commands+=("theme")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--format=")
    two_word_flags+=("-f")
    flags+=("--help")
    flags+=("-h")
    flags+=("--kind=")
    two_word_flags+=("-k")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_list_drafts()
{
    last_command="hugo_list_drafts"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_list_future()
{
    last_command="hugo_list_future"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_list()
{
    last_command="hugo_list"
    commands=()
    commands+=("drafts")
    commands+=("future")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_undraft()
{
    last_command="hugo_undraft"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_genautocomplete()
{
    last_command="hugo_genautocomplete"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--completionfile=")
    flags+=("--help")
    flags+=("-h")
    flags+=("--type=")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_gendoc()
{
    last_command="hugo_gendoc"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--dir=")
    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo_help()
{
    last_command="hugo_help"
    commands=()

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--help")
    flags+=("-h")

    must_have_one_flag=()
    must_have_one_noun=()
}

_hugo()
{
    last_command="hugo"
    commands=()
    commands+=("server")
    commands+=("version")
    commands+=("config")
    commands+=("check")
    commands+=("benchmark")
    commands+=("convert")
    commands+=("new")
    commands+=("list")
    commands+=("undraft")
    commands+=("genautocomplete")
    commands+=("gendoc")
    commands+=("help")

    flags=()
    two_word_flags=()
    flags_with_completion=()
    flags_completion=()

    flags+=("--baseUrl=")
    two_word_flags+=("-b")
    flags+=("--buildDrafts")
    flags+=("-D")
    flags+=("--buildFuture")
    flags+=("-F")
    flags+=("--cacheDir=")
    flags+=("--config=")
    flags_with_completion+=("--config")
    flags_completion+=("__handle_filename_extension_flag json|js|yaml|yml|toml|tml")
    flags+=("--destination=")
    two_word_flags+=("-d")
    flags+=("--disableRSS")
    flags+=("--disableSitemap")
    flags+=("--editor=")
    flags+=("--help")
    flags+=("-h")
    flags+=("--ignoreCache")
    flags+=("--log")
    flags+=("--logFile=")
    flags+=("--noTimes")
    flags+=("--pluralizeListTitles")
    flags+=("--source=")
    two_word_flags+=("-s")
    flags+=("--stepAnalysis")
    flags+=("--theme=")
    two_word_flags+=("-t")
    flags+=("--uglyUrls")
    flags+=("--verbose")
    flags+=("-v")
    flags+=("--verboseLog")
    flags+=("--watch")
    flags+=("-w")

    must_have_one_flag=()
    must_have_one_noun=()
}

__start_hugo()
{
    local cur prev words cword
    if declare -F _init_completions >/dev/null 2>&1; then
        _init_completion || return
    else
        __my_init_completion || return
    fi

    local c=0
    local flags=()
    local two_word_flags=()
    local flags_with_completion=()
    local flags_completion=()
    local commands=("hugo")
    local must_have_one_flag=()
    local must_have_one_noun=()
    local last_command
    local nouns=()

    __handle_word
}

complete -F __start_hugo hugo
# ex: ts=4 sw=4 et filetype=sh
