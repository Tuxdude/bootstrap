# Sample .profile for SuSE Linux
# rewritten by Christian Steinruecken <cstein@suse.de>
# Modified by Ash <tuxdude.io@gmail.com>
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

if [ -n "$PROFILE_SOURCED" ]; then
    if [[ $OSTYPE == darwin* && $(which stat) == '/usr/bin/stat' ]]; then
        # On OS X always ensure we have these entries at the top of the PATH
        # Tmux for instance overrides PATH before starting the shell
        export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    fi
    return
fi

test -z "$PROFILEREAD" && . /etc/profile || true

# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
#export LANG=de_DE.UTF-8	# uncomment this line for German output
#export LANG=fr_FR.UTF-8	# uncomment this line for French output
#export LANG=es_ES.UTF-8	# uncomment this line for Spanish output
export LANG=en_US.UTF-8

if [[ $OSTYPE == linux* ]]; then
    export PATH="$HOME/.linuxbrew/bin:$HOME/.local/bin:$HOME/.local/sbin:$JAVA_HOME/bin:$PATH:/sbin:/usr/sbin:/usr/games"
    export MANPATH="$HOME/.linuxbrew/share/man"
    export INFOPATH="$HOME/.linuxbrew/share/info"
elif [[ $OSTYPE == darwin* ]]; then
    export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/local/opt/coreutils/libexec/gnubin:$PATH:/sbin:/usr/sbin:/usr/games"
else
    echo "Unknown OS"
fi

export MANPATH="$MANPATH:$HOME/.local/share/man"

# Set the flag that .profile was sourced
export PROFILE_SOURCED=1
