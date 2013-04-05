#
# Author: Ash <tuxdude.github@gmail.com>
#

test -s ~/.alias && . ~/.alias || true

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

for ext in $HOME/.bashrc-plugins/*.sh; do
    source $ext
done

# Set the terminal window title
set_title () {
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

_is_function () {
    declare -f -F "$1" > /dev/null
    return $?
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

# Hook up git log's bash-completion to git-forest
_git_forest () {
    _git_log
}

# Run git in multiple repos at the same level
gitmulti() {
    for dir in $(find . -maxdepth 2 -name .git | xargs dirname); do cd $dir && pwd && git $@ && echo && cd - > /dev/null; done
}
if [ -z "$IN_CBE" ]; then
    complete -o bashdefault -o default -o nospace -F _git gitmulti 2>/dev/null \
            || complete -o default -o nospace -F _git gitmulti
fi


# EDITOR env var used by multiple programs
export EDITOR=/usr/bin/vim

# Fortune
if [[ -z "${SSH_CONNECTION}" && -z "$IN_CBE" ]]; then
    echo -e '\033[1;36m'
    fortune | cowsay -f tux
    echo -e '\033[0m'
fi

# Grep with colors
if [ -x /usr/bin/dircolors ]; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Less with colors
export LESS='-R'
export LESSOPEN='|pygmentize -g %s'

# Handy aliases
# Source grep aliases
alias tgrep="find . -follow -type f -name \*.txt | xargs grep -H -n $1"
alias hgrep="find . -follow -type f -name \*.h | xargs grep -H -n $1"
alias cgrep="find . -follow -type f -name \*.c | xargs grep -H -n $1"
alias cppgrep="find . -follow -type f -name \*.cpp -o -name \*.c -o -name \*.C -o -name \*.cxx -o -name \*.c++ | xargs grep -H -n $1"
alias srcgrep="find . -follow -type f -name \*.[hcmCSs] -o -name \*.asm -o -name \*.cpp -o -name \*.inc -o -name \*.cxx -o -name \*.c++ -o -name \*.tcl -o -name \*.itcl -o -name \*.pl -o -name \*.sh -o -name \?akefile\* -o -name \*.mk -o -name \*.def -o -name \*commondefs -o -name \*commonrules -o -name ismdefs -o -name ismrules | xargs grep -H -n $1"
alias allgrep="find . -follow -type f | xargs grep -H -n $1"

# Misc aliases
alias vless='vim -u /usr/share/vim/current/macros/less.vim'
alias rebuild_tags='/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .'
alias fixfiles='sudo find . -type f -exec chmod 0644 {} \;'
alias fixdir='sudo find . -type d -exec chmod 0755 {} \;'
alias kbfix='setxkbmap -v 10 -display $DISPLAY -geometry "pc(pc105)" -keycodes "evdev+aliases(qwerty)" -option ctrl:nocaps -option compose:rctrl'
alias xauthfix='xauth extract - :`echo $DISPLAY |awk -F: "{print $2}"` | sudo su -c "xauth merge -"'
alias tmux='tmux -2'
alias picocom='picocom -b 115200'

# Powerline Shell prompt
set_powerline_shell_prompt() {
    PS1="$(powerline shell left -r bash_prompt --last_exit_code=$?)\n\$ "
}

# Store tmux envs
store_tmux_envs() {
    if [ -n "$TMUX" ]; then
        tmux_pane=$(tmux display-message -p '#S_#I_#P')
        for env_var in $POWERLINE_ENVS; do
            eval env_var_value='$'$(echo $env_var)
            tmux set-environment POWERLINE_"$tmux_pane"_"$env_var" "$env_var_value"
        done

        # Refresh the tmux client status bar
        tmux refresh-client -S
    fi
}

if [ -z "$IN_CBE" ] && [ -n "$TMUX" ] && { hash powerline 2>/dev/null || [ -e $HOME/.local/bin/powerline ] ;}; then
    export USE_POWERLINE="1"
    export POWERLINE_ENVS="PWD VIRTUAL_ENV SANDBOX_ID BRANCHNAME FLAVOR"
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
export PROMPT_COMMAND="declare -f -F "set_title" > /dev/null && set_title; declare -f -F "store_tmux_envs" > /dev/null && store_tmux_envs"

# Setup virtualenv
export WORKON_HOME=$HOME/.virtualenvs
if hash virtualenvwrapper.sh 2> /dev/null; then
    source $(which virtualenvwrapper.sh)
fi

tmux_start_console() {
    session_name="CONSOLE"
    if tmux -q has-session -t "$session_name"; then
        tmux attach-session -t "$session_name"
    else
        # Window 0
        tmux new-session -d -s "$session_name" -n "picocom ttyS0"
        tmux send-keys -t "$session_name":0 "picocom /dev/ttyS0" Enter

        # Window 1
        tmux new-window -t "$session_name" -n "picocom USB0"
        tmux send-keys -t "$session_name":1 "picocom /dev/ttyUSB0" Enter

        # Window 2
        tmux new-window -t "$session_name" -n "SHELL"

        # Select window 0
        tmux select-window -t "$session_name":0

        # Attach the sesssion
        tmux -2 attach-session -t "$session_name"
    fi
}

tmux_start_dev_station() {
    session_name="DEV"
    if tmux -q has-session -t "$session_name"; then
        tmux attach-session -t "$session_name"
    else
        # Window 0
        tmux new-session -d -s "$session_name" -n "telnet"
        tmux split-window -h
        tmux select-pane -L

        # Window 1
        tmux new-window -t "$session_name" -n "SANDBOX1"
        tmux send-keys -t "$session_name":1 "switch-sandbox1" Enter
        tmux split-window -h
        tmux send-keys -t "$session_name":1 "switch-sandbox1" Enter

        # Window 2
        tmux new-window -t "$session_name" -n "SANDBOX3"
        tmux send-keys -t "$session_name":2 "switch-sandbox3" Enter
        tmux split-window -h
        tmux send-keys -t "$session_name":2 "switch-sandbox3" Enter

        # Window 3
        tmux new-window -t "$session_name" -n "SCRATCH"
        tmux split-window -h

        # Select Window 0
        tmux select-window -t "$session_name":0

        # Attach the sesssion
        tmux -2 attach-session -t "$session_name"
    fi
}
