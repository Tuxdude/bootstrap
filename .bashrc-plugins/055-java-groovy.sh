#
# Author: Ash <tuxdude.io@gmail.com>
#

# On OS X, JAVA_HOME will not be set automatically
# Use the java_home utility to set JAVA_HOME automatically

if [[ $OSTYPE == darwin* ]]; then
    REQUESTED_JAVA_VERSION="1.8"
    FALLBACK_JAVA_HOME="$HOME/jdk1.7.0_80.jdk/Contents/Home"
    if POSSIBLE_JAVA_HOME="$(/usr/libexec/java_home -v $REQUESTED_JAVA_VERSION 2>/dev/null)"; then
        export JAVA_HOME="$POSSIBLE_JAVA_HOME"
        export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"
    elif [ -e "$FALLBACK_JAVA_HOME" ]; then
        export JAVA_HOME="$FALLBACK_JAVA_HOME"
        export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"
    else
        echo "Did not find any installed JDK for version $REQUESTED_JAVA_VERSION"
    fi

    # Use Groovy from homebrew
    if hash brew 2>/dev/null; then
        export GROOVY_HOME="$(brew --prefix)/opt/groovy/libexec"
    fi
fi

# Helper to format java code.
function java_format() {
    JAVA_FORMAT_DOWNLOAD_URL="https://github.com/google/google-java-format/releases/download/google-java-format-1.3/google-java-format-1.3-all-deps.jar"
    JAVA_FORMAT_DEST_DIR="$HOME/.config/lib/java"
    JAVA_FORMAT_DEST_FILE="google-java-format-1.3-all-deps.jar"
    if [ ! -f $JAVA_FORMAT_DEST_DIR/$JAVA_FORMAT_DEST_FILE ]; then
      mkdir -p $JAVA_FORMAT_DEST_DIR && wget -O $JAVA_FORMAT_DEST_DIR/$JAVA_FORMAT_DEST_FILE $JAVA_FORMAT_DOWNLOAD_URL
    fi
    java -jar $JAVA_FORMAT_DEST_DIR/$JAVA_FORMAT_DEST_FILE --replace $@
}
