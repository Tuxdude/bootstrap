#
# Author: Ash <tuxdude.github@gmail.com>
#

test -s ~/.alias && . ~/.alias || true

for ext in $HOME/.bashrc-plugins/*.sh; do
    source $ext
done
