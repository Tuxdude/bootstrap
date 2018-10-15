#
# Author: Ash <tuxdude.io@gmail.com>
#

# This file is read only by the login shell. Interactive
# shells on the other hand will onyl read .bashrc.

# This file is idempotent and can be invoked multiple times
# without breaking anything.

test -z "$PROFILEREAD" && source /etc/profile || true

export LANG=en_US.UTF-8

source $HOME/.profile-functions

# It is possible that /etc/profile overwrote $PATH entirely at this point
# So always update $PATH as required.
if [[ $OSTYPE == linux* ]]; then
    reduced_paths="$(paths_remove $PATH $HOME/.local/bin $HOME/.local/sbin $JAVA_HOME/bin /sbin /usr/sbin /usr/games)"
    export PATH="$HOME/.local/bin:$HOME/.local/sbin:$JAVA_HOME/bin:$reduced_paths:/sbin:/usr/sbin:/usr/games"
elif [[ $OSTYPE == darwin* ]]; then
    reduced_paths="$(paths_remove $PATH $HOME/.local/bin $HOME/.local/sbin /sbin /usr/sbin /usr/games)"
    export PATH="$HOME/.local/bin:$HOME/.local/sbin:$reduced_paths:/sbin:/usr/sbin:/usr/games"
else
    echo "Unknown OS"
fi

# Same goes for $MANPATH.
export MANPATH="$(path_remove $MANPATH $HOME/.local/share/man):$HOME/.local/share/man"
