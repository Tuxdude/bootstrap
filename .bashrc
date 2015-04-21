#
# Author: Ash <tuxdude.io@gmail.com>
#

# Don't do anything for non-interactive shells
[ -z "$PS1" ] && return

[ -s ~/.alias ] && . ~/.alias || true

source $HOME/.profile

for ext in $HOME/.bashrc-plugins/*.sh; do
    source $ext
done
