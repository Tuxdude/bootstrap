#
# Author: Ash <tuxdude.io@gmail.com>
#

# source kubernetes bash completion if installed
if hash kubectl 2>/dev/null; then
  source <(kubectl completion bash)
fi
