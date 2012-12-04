#
# Author: Ash <tuxdude.github@gmail.com>
#

DELPHINUS_HOME="$HOME/github-repos/delphinus"
DELPHINUS_BIN="$DELPHINUS_HOME/dist/host-gcc/bin"
DELPHINUS_LIBS="$DELPHINUS_HOME/dist/host-gcc/lib"
export LD_LIBRARY_PATH=$(path_remove "$LD_LIBRARY_PATH" "$DELPHINUS_LIBS"):$DELPHINUS_LIBS
export PATH=$(path_remove "$PATH" "$DELPHINUS_BIN"):$DELPHINUS_BIN

alias clocdelphinus='cloc --by-file-by-lang --force-lang="make",mk .'
