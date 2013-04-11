#
# Author: Ash <tuxdude.github@gmail.com>
#

reload_bashrc() {
    if [ -f ~/.reload_bashrc ]; then
        if (( $(stat -c "%Y" ~/.reload_bashrc) > $RELOAD_BASHRC_MTIME )); then
            echo "Reloading ~/.bashrc !"
            source ~/.bashrc
        fi
    fi
}

if [ -f ~/.reload_bashrc ]; then
    export RELOAD_BASHRC_MTIME=$(stat -c "%Y" ~/.reload_bashrc )
else
    # Fallback to mtime of ~/.bashrc
    export RELOAD_BASHRC_MTIME=$(stat -c "%Y" ~/.bashrc )
fi

export PROMPT_COMMAND="$PROMPT_COMMAND; declare -f -F 'reload_bashrc' > /dev/null && reload_bashrc"
