#
# Author: Ash <tuxdude.io@gmail.com>
#

if [[ $OSTYPE == darwin* ]]; then
    mysql_home="/usr/local/mysql"
    mysql_bin="$mysql_home/bin"
    mysql_lib="$mysql_home/lib"
    export PATH=$(path_remove "$PATH" "$mysql_bin"):$mysql_bin
    export DYLD_LIBRARY_PATH=$(path_remove "DYLD_LIBRARY_PATH" "$mysql_lib"):$mysql_lib
    unset mysql_home mysql_bin mysql_lib
fi
