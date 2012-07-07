#
# Author: Ash <tuxdude.github@gmail.com>
#

DELPHINUS_HOME=$HOME/delphinus/delphinus-code/trunk
DELPHINUS_LIBS=$DELPHINUS_HOME/dist/x86_64-suse-linux/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DELPHINUS_LIBS

alias clocdelphinus='cloc --by-file-by-lang --force-lang="make",mk .'
