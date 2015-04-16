
#
# Author: Ash <tuxdude.github@gmail.com>
#

# Node Version Manager
if hash brew 2> /dev/null; then
    # Bootstrap nvm
    source "$(brew --prefix nvm)/nvm.sh"
    # Bash completion for nvm
    source $NVM_DIR/etc/bash_completion.d/nvm
    # Set the version of node to use from ~/.nvmrc if available
    nvm use 2> /dev/null 1>&2 || true
fi
