#
# Author: Ash <tuxdude.github@gmail.com>
#

PYTHON_PATHS="/opt/python/python3.3 /opt/python/python3.2 /opt/python/python3.1 /opt/python/python2.7 /opt/python/python2.6"

for path in $PYTHON_PATHS; do
    export PATH=$(path_remove "$PATH" "$path/bin"):$path/bin
done
unset PYTHON_PATHS
