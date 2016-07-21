#
# Author: Ash <tuxdude.io@gmail.com>
#

export GOROOT="$HOME/.local/go"
gopath_bin="$GOROOT/bin"
export PATH=$gopath_bin:$(path_remove "$PATH" "$gopath_bin")
