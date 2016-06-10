#
# Author: Ash <tuxdude.io@gmail.com>
#

if [ "$HOSTNAME" == "WingSaber" ]; then
    ANDROID_ROOT=/sandbox/android
elif [ "$HOSTNAME" == "OptimusPrime" ]; then
    ANDROID_ROOT=/data/android
elif [ "$HOSTNAME" == "Suse1520" ]; then
    ANDROID_ROOT=/misc/android
fi

export ANDROID_HVPROTO=ddm

export USE_CCACHE=1
