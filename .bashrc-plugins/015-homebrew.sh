#
# Author: Ash <tuxdude.io@gmail.com>
#

# Homebrew (if it exists) will be installed only in one of these 3 locations
if [ -x /usr/local/bin/brew ]; then
    homebrew_home="/usr/local"
elif [ -x "$HOME/.homebrew/bin/brew" ]; then
    homebrew_home="$HOME/.homebrew"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    homebrew_home="$HOME/.linuxbrew"
fi

# If Homebrew was detected, add its bin directory to PATH
if [ -n "$homebrew_home" ]; then
    homebrew_bin="$homebrew_home/bin"
    homebrew_sbin="$homebrew_home/sbin"
    homebrew_man="$homebrew_home/man"
    homebrew_info="$homebrew_home/info"
    export PATH=$homebrew_sbin:$(path_remove "$PATH" "$homebrew_sbin")
    export PATH=$homebrew_bin:$(path_remove "$PATH" "$homebrew_bin")
    export MANPATH=$homebrew_man:$(path_remove "$MANPATH" "$homebrew_man")
    export INFOPATH=$homebrew_info:$(path_remove "$INFOPATH" "$homebrew_info")
    unset homebrew_bin homebrew_sbin homebrew_man homebrew_info

    # On OSX, use the coreutils binaries instead of the system supplied ones
    if [[ $OSTYPE == darwin* ]]; then
        coreutils_bin="$homebrew_home/opt/coreutils/libexec/gnubin"
        coreutils_man="$homebrew_home/opt/coreutils/libexec/gnuman"
        gnutar_bin="$homebrew_home/opt/gnu-tar/libexec/gnubin"
        gnutar_man="$homebrew_home/opt/gnu-tar/libexec/gnuman"
        export PATH=$coreutils_bin:$gnutar_bin:$(paths_remove "$PATH" "$coreutils_bin" "$gnutar_bin")
        export MANPATH=$coreutils_man:$gnutar_man:$(paths_remove "$MANPATH" "$coreutils_man" "$gnutar_man")
        unset coreutils_bin
        unset coreutils_man
        unset gnutar_bin
        unset gnutar_man
    fi

    unset homebrew_home homebrew_bin

    # Do not send any analytics
    export HOMEBREW_NO_ANALYTICS=1
    brew analytics off
fi
