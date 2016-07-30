
#
# Author: Ash <tuxdude.io@gmail.com>
#

# Node Version Manager
if hash brew 2> /dev/null; then
    # Explicitly set the NVM_DIR to avoid confusing nvm
    export NVM_DIR="$(readlink -f $(brew --prefix nvm))"

    # BEGIN UGLY HACK
    # This lets us initialize nvm, node and any other global node binaries on demand (lazily)
    # to save on shell startup time
    declare -a NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)

    NODE_GLOBALS+=("node")
    NODE_GLOBALS+=("nvm")

    # Bootstrap nvm on demand
    load_nvm() {
        source "$NVM_DIR/nvm.sh"

        # Set the version of node to use from ~/.nvmrc if available
        nvm use 2> /dev/null 1>&2 || true

        # Do not reload nvm again
        export NVM_LOADED=1
    }

    for node_cmd in "${NODE_GLOBALS[@]}"; do
        eval "${node_cmd}() { unset -f ${node_cmd}; [ -z \${NVM_LOADED+x} ] && load_nvm; ${node_cmd} \$@; }"
    done
    # END UGLY HACK

    # Bash completion for nvm
    source $NVM_DIR/etc/bash_completion.d/nvm
fi
