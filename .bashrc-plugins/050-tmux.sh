#
# Author: Ash <tuxdude.github@gmail.com>
#

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
