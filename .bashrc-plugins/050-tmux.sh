#
# Author: Ash <tuxdude.io@gmail.com>
#

eval $(ssh-agent -s) >/dev/null

# Store tmux envs
store_tmux_envs() {
    if [ -n "$TMUX" -a -n "$TMUX_PANE" ]; then
        local tmux_pane=$(tmux display-message -pt $TMUX_PANE '#{session_name}_#{window_index}_#{pane_index}')

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

tmux_with_ssh_auth_sock() {
    SSH_AUTH_SOCK="$1" tmux ${@:2}
}

tmux_create_4_pane_window() {
    if [ "$#" -ne 3 ]; then
        return
    fi
    if [ $2 -ne 0 ]; then
        tmux_with_ssh_auth_sock "$3" new-session -d -s "$1"
    else
        tmux_with_ssh_auth_sock "$3" new-window -t "$1"
    fi

    tmux_with_ssh_auth_sock "$3" split-window -h
    tmux_with_ssh_auth_sock "$3" split-window -v
    tmux_with_ssh_auth_sock "$3" select-pane -L
    tmux_with_ssh_auth_sock "$3" split-window -v
}

tmux_start_dev_station() {
    local session_name="DEV"

    if tmux_setup_ssh_auth_sock "$session_name" 2>/dev/null; then
        local ssh_auth_sock_updated="$SSH_AUTH_SOCK_UPDATED"
        unset SSH_AUTH_SOCK_UPDATED
    else
        local ssh_auth_sock_updated="$SSH_AUTH_SOCK"
    fi

    if tmux -q has-session -t "$session_name" 2>/dev/null; then
        tmux_with_ssh_auth_sock "$ssh_auth_sock_updated" detach-client -s "$session_name" 2>/dev/null || true
        tmux_with_ssh_auth_sock "$ssh_auth_sock_updated" -2 attach-session -t "$session_name"
    else
        # Window 0
        tmux_create_4_pane_window "$session_name" 1 $ssh_auth_sock_updated

        if [ "${LITE_HOST}" -ne 1 ]; then
            # Window 1
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 2
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 3
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 4
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 5
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 6
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 7
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Window 8
            tmux_create_4_pane_window "$session_name" 0 $ssh_auth_sock_updated

            # Select Window 0
            tmux_with_ssh_auth_sock "$ssh_auth_sock_updated" select-window -t "$session_name":0

            # Attach the sesssion
            tmux_with_ssh_auth_sock "$ssh_auth_sock_updated" -2 attach-session -t "$session_name"
        fi
    fi
}

# This is the location where the tmux powerline repository will be checked out.
export TMUX_POWERLINE_DIR="/data/dev-stuff/git-repos/tmux-powerline"

# The URI of the tmux powerline repository.
export TMUX_POWERLINE_REPO="github:Tuxdude/tmux-powerline"

export TMUX_POWERLINE_BASE_DIR="$(dirname $TMUX_POWERLINE_DIR)"

# List the git repository URLs, for the tmux powerline repositories.
tmux_powerline_list_repo_urls() {
    git -C "$TMUX_POWERLINE_DIR" config remote.origin.url
}

tmux_powerline_get_repos() {
    if [ -n "$ADDON_GIT_REPOS_USE_HTTPS_URLS" ]; then
        echo "$TMUX_POWERLINE_REPO" | sed 's/github:/https:\/\/github.com\//g'
    else
        echo "$TMUX_POWERLINE_REPO"
    fi
}

# Download/Update all the tmux powerline.
tmux_powerline_update() {
    mkdir -p $(dirname $TMUX_POWERLINE_BASE_DIR)
    for repo in $(tmux_powerline_get_repos); do
        repoDirName="$(basename $repo)"
        repoFullPath="$TMUX_POWERLINE_BASE_DIR/$repoDirName"
        if [ -d "$repoFullPath" ]; then
            # If the directory already exists, update it
            echo "Trying to update $repo"
            git fetch-and-rebase "$repoFullPath"
        else
            # Else do a fresh clone
            echo "Installing $repo"
            git clone "$repo" "$repoFullPath"
        fi
    done
}

# Create/update the symlinks.
tmux_powerline_sync_symlinks() {
    mkdir -p ~/.local/bin
    echo "Symlinking $TMUX_POWERLINE_DIR/$powerline.sh -> ~/.local/bin/tmux-powerline"
    ln -sf "$TMUX_POWERLINE_DIR/powerline.sh" ~/.local/bin/tmux-powerline
}

# Use the config file to setup the tmux powerline repositories, the symlinks and any additional
# installation if required.
tmux_powerline_setup() {
    tmux_powerline_sync_symlinks && tmux_powerline_update
}
