#
# Author: Ash <tuxdude.io@gmail.com>
#

# On OS X, JAVA_HOME will not be set automatically
# Use the java_home utility to set JAVA_HOME automatically

if [[ $OSTYPE == darwin* ]]; then
    REQUESTED_JAVA_VERSION="1.7"
    if POSSIBLE_JAVA_HOME="$(/usr/libexec/java_home -v $REQUESTED_JAVA_VERSION 2>/dev/null)"; then
        export JAVA_HOME="$POSSIBLE_JAVA_HOME"
    else
        echo "Did not find any installed JDK for version $REQUESTED_JAVA_VERSION"
    fi

    # Use Groovy from homebrew
    export GROOVY_HOME="/usr/local/opt/groovy/libexec"
fi
