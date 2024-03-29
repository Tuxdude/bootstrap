#
# Author: Ash <tuxdude.io@gmail.com>
#

# Check if the first argument is a bash function
_is_function () {
    declare -f -F "$1" > /dev/null
    return $?
}

# Set the terminal window title
set_title() {
    if [ -z "$1" ]; then
        if [ -n "$WINDOW_TITLE" ]; then
            echo -ne "\033]0;$WINDOW_TITLE\007"
        elif [ -z "${SSH_CONNECTION}" ]; then
            echo -ne "\033]0;${PWD}\007"
        else
            echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
        fi
    fi
}

# Sort du's output by size
duf() {
    du -c -sk "$@" | sort -n | while read size fname; do
        for unit in k M G T P E Z Y; do
            if [ $size -lt 1024 ]; then
                echo -e "${size}${size_fraction}${unit}\t${fname}"
                break;
            fi
            frac=$(echo "scale=0; $size % 1024" | bc)
            size_fraction=$(echo "scale=3; $frac / 1024" | bc)
            size=$(echo "scale=0; $size / 1024" | bc)
        done
    done
}

# Find last modified files
lastmod() {
    if [ -z "$1" ]; then
        find . -type f -print0 | xargs -0 stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
    else
        find $1 -type f -print0 | xargs -0 stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
    fi
}

listparts() {
  lsblk --tree --output NAME,TRAN,TYPE,PTTYPE,SIZE,PARTLABEL,PARTUUID,FSTYPE,MOUNTPOINT,FSAVAIL,FSUSE%,LABEL,UUID $@
}

listdisks() {
  lsblk --nodeps --output NAME,TYPE,TRAN,SUBSYSTEMS,VENDOR,MODEL,SERIAL,SIZE,STATE $@
}
