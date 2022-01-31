# Default Theme

if patched_font_in_use; then
    TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
    TMUX_POWERLINE_SEPARATOR_LEFT_THIN=""
    TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
    TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=""
else
    TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
    TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
    TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
    TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'234'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'231'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}

# See man tmux.conf for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveinences

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
    TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
        "#[$(format inverse)]" \
        "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR" \
        " #I#F " \
        "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
        " #W " \
        "#[$(format regular)]" \
        "$TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR"
    )
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
    TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
        "$(format regular)"
    )
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
    TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
        "#[$(format regular)]" \
        "  #I#{?window_flags,#F, } " \
        "$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN" \
        " #W "
    )
fi

# Format: segment_name background_color foreground_color [non_default_separator]

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
    TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
        "vcs_branch 4 231" \
        "vcs_compare 55 231" \
        "vcs_staged 28 231" \
        "vcs_modified 52 231" \
        "vcs_others 244 231" \
    )
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
    TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
        "hostname 89 231" \
    )
fi
