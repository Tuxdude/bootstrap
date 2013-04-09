#
# Author: Ash <tuxdude.github@gmail.com>
#

# Don't do anything for non-interactive shells
[ -z "$PS1" ] && return

test -s ~/.alias && . ~/.alias || true

for ext in $HOME/.bashrc-plugins/*.sh; do
    source $ext
done
