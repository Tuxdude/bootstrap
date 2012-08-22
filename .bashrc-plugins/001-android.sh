#
# Author: Ash <tuxdude.github@gmail.com>
#

if [ "$HOSTNAME" == "WingSaber" ]; then
    ANDROID_ROOT=/sandbox/android
elif [ "$HOSTNAME" == "OptimusPrime" ]; then
    ANDROID_ROOT=/data/android
elif [ "$HOSTNAME" == "Suse1520" ]; then
    ANDROID_ROOT=/misc/android
fi

export USE_CCACHE=1

gmake() {
    if [[ $PWD == $ANDROID_ROOT/* || $PWD == "$ANDROID_ROOT" ]]
    then
        $HOME/bin/gmake-381 $@
    else
        /usr/bin/gmake $@
    fi
}

_override_android_make() {
    if [[ $PWD == $ANDROID_ROOT/* || $PWD == "$ANDROID_ROOT" ]]; then
        $HOME/bin/make-381 $@
    elif [ "$OVERRIDE_WORK_MAKE" == 1 ]; then
        _override_work_make $@
    else
        /usr/bin/make $@
    fi
}
