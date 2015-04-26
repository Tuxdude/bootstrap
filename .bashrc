#
# Author: Ash <tuxdude.io@gmail.com>
#

if [ -n "$PROFILE_BASHRC" ]; then
    PS4='+ $(date "+%s.%N")\011 '
    profileInfoFile="/tmp/bashstart.$$.log"
    echo "Writing profile information to => $profileInfoFile"
    exec 3>&2 2>$profileInfoFile
    set -x
fi

# Don't do anything for non-interactive shells
[ -z "$PS1" ] && return

[ -s ~/.alias ] && . ~/.alias || true

source $HOME/.profile

for ext in $HOME/.bashrc-plugins/*.sh; do
    source $ext
done

if [ -n "$PROFILE_BASHRC" ]; then
    set +x
    exec 2>&3 3>&-
fi
