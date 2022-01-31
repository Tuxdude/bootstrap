#
# Author: Ash <tuxdude.io@gmail.com>
#

export GOROOT="$HOME/.local/go"
goroot_bin="$GOROOT/bin"
export PATH=$goroot_bin:$(path_remove "$PATH" "$goroot_bin")
gopath_bin="$HOME/go/bin"
export PATH=$gopath_bin:$(path_remove "$PATH" "$gopath_bin")
