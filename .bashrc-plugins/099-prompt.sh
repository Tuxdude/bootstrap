#
# Author: Ash <tuxdude.io@gmail.com>
#

if [ -n "$TMUX" ]; then
    if [ "$OVERRIDE_CUSTOM_PROMPT" != "1" ]; then
        export PS1="\[\033[0;33m\]\w\[\033[0m\]\n\$ "
    fi
else
    # Fallback to a much simpler but Custom prompt
    if [ "$OVERRIDE_CUSTOM_PROMPT" != "1" ]; then
        export PS1="<\[\033[1;31m\]\@\[\033[0m\]> \[\033[1;32m\]\u\[\033[0;36m\]@\[\033[1;34m\]\h:\[\033[0;33m\]\w\[\033[0m\]\n\$ "
    fi
fi

# We cannot call a function here since functions are not exported in sudo
# but PROMPT_COMMAND is
export PROMPT_COMMAND="declare -f -F 'set_title' > /dev/null && set_title; declare -f -F 'store_tmux_envs' > /dev/null && store_tmux_envs"
