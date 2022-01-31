#
# Author: Ash <tuxdude.io@gmail.com>
#

export GOROOT="$HOME/.local/go"
goroot_bin="$GOROOT/bin"
export PATH=$goroot_bin:$(path_remove "$PATH" "$goroot_bin")
