#
# Author: Ash <tuxdude.io@gmail.com>
#

export GOPATH="$HOME/.local/go"
gopath_bin="$GOPATH/bin"
export PATH=$gopath_bin:$(path_remove "$PATH" "$gopath_bin")
