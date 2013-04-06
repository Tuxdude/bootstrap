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
        # This could fail if there is no open client, but a command is
        # run using send-key, hence it is okay even if it fails
        tmux refresh-client -S 2>/dev/null || true
    fi
}

tmux_start_console() {
    session_name="CONSOLE"
    if tmux -q has-session -t "$session_name" 2>/dev/null; then
        tmux -2 attach-session -t "$session_name"
    else
        # Window 0
        tmux new-session -d -s "$session_name" -n "picocom ttyS0"
        tmux send-keys -t "$session_name":0 "picocom /dev/ttyS0" Enter
        usleep 500000

        # Window 1
        tmux new-window -t "$session_name" -n "picocom USB0"
        tmux send-keys -t "$session_name":1 "picocom /dev/ttyUSB0" Enter
        usleep 500000

        # Window 2
        tmux new-window -t "$session_name" -n "SHELL"
        usleep 500000

        # Select window 0
        tmux select-window -t "$session_name":0

        # Attach the sesssion
        tmux -2 attach-session -t "$session_name"
    fi
}

tmux_start_dev_station() {
    session_name="DEV"
    if tmux -q has-session -t "$session_name" 2>/dev/null; then
        tmux -2 attach-session -t "$session_name"
    else
        # Window 0
        tmux new-session -d -s "$session_name" -n "telnet"
        tmux split-window -h
        tmux select-pane -L

        # Window 1
        tmux new-window -t "$session_name" -n "SANDBOX1"
        tmux send-keys -t "$session_name":1 "switch-sandbox1" Enter
        usleep 500000
        tmux split-window -h
        tmux send-keys -t "$session_name":1 "switch-sandbox1" Enter
        usleep 500000

        # Window 2
        tmux new-window -t "$session_name" -n "SANDBOX3"
        tmux send-keys -t "$session_name":2 "switch-sandbox3" Enter
        usleep 500000
        tmux split-window -h
        tmux send-keys -t "$session_name":2 "switch-sandbox3" Enter
        usleep 500000

        # Window 3
        tmux new-window -t "$session_name" -n "SCRATCH"
        usleep 500000
        tmux split-window -h
        usleep 500000

        # Select Window 0
        tmux select-window -t "$session_name":0

        # Attach the sesssion
        tmux -2 attach-session -t "$session_name"
    fi
}
