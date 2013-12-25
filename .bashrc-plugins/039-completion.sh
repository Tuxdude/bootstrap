#
# Author: Ash <tuxdude.github@gmail.com>
#

# Enable bash completion (Ubuntu requires this)
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
# OS X has bash completion installed in a different location
elif hash brew 2>/dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi
