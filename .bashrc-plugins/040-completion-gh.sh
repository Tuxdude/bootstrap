#
# Author: Ash <tuxdude.io@gmail.com>
#

# source gh bash completion if installed
if hash gh 2>/dev/null; then
    source <(gh completion -s bash)
fi
