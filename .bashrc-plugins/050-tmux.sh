#
# Author: Ash <tuxdude.github@gmail.com>
#

# Store tmux envs
store_tmux_envs() {
    if [ -n "$TMUX" -a -n "$TMUX_PANE" ]; then
        local tmux_pane=$(tmux display-message -pt $TMUX_PANE '#{session_name}_#{window_index}_#{pane_index}')
        for env_var in $POWERLINE_ENVS; do
            eval local env_var_value='$'$(echo $env_var)
            tmux set-environment POWERLINE_"$tmux_pane"_"$env_var" "$env_var_value"
        done

        # Refresh the tmux client status bar
        # This could fail if there is no open client, but a command is
        # run using send-key, hence it is okay even if it fails
        tmux refresh-client -S 2>/dev/null || true
    fi
}

# Fix the tmux DISPLAY environment variable
fixtmuxdisplay() {
    export $(tmux show-environment DISPLAY) > /dev/null
    export $(tmux show-environment XAUTHORITY) > /dev/null
    export $(tmux show-environment WINDOWID) > /dev/null
}

tmux_create_4_pane_window() {
    if [ "$#" -ne 2 ]; then
        return
    fi
    if [ $2 -ne 0 ]; then
        tmux new-session -d -s "$1"
    else
        tmux new-window -t "$1"
    fi
    tmux split-window -h
    tmux split-window -v
    tmux select-pane -L
    tmux split-window -v
}

tmux_start_dev_station() {
    local session_name="DEV"
    if tmux -q has-session -t "$session_name" 2>/dev/null; then
        tmux -2 attach-session -t "$session_name"
    else
        # Window 0
        tmux_create_4_pane_window "$session_name" 1

        # Window 1
        tmux_create_4_pane_window "$session_name" 0

        # Window 2
        tmux_create_4_pane_window "$session_name" 0

        # Window 3
        tmux_create_4_pane_window "$session_name" 0

        # Window 4
        tmux_create_4_pane_window "$session_name" 0

        # Window 5
        tmux_create_4_pane_window "$session_name" 0

        # Window 6
        tmux_create_4_pane_window "$session_name" 0

        # Select Window 0
        tmux select-window -t "$session_name":0

        # Attach the sesssion
        tmux -2 attach-session -t "$session_name"
    fi
}
