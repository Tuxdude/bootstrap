#
# Author: Ash <tuxdude.io@gmail.com>
#

# Setup virtualenv
export WORKON_HOME=$HOME/.virtualenvs
if hash virtualenvwrapper.sh 2> /dev/null; then
    source $(which virtualenvwrapper.sh)
fi
