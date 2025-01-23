#
# Author: Ash <tuxdude.io@gmail.com>
#

if hash manpath 2>/dev/null; then
    export MANPATH="$(manpath -g)"
fi
