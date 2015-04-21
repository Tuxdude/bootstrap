#
# Author: Ash <tuxdude.io@gmail.com>
#

# Append to history
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=20000

# Update LINES and COLUMNS to reflect the window size after each command
shopt -s checkwinsize

# Enable directory expansion for variables
# Example : 'ls $MY_DIR <Tab>' will expand MY_DIR
if ((BASH_VERSINFO[0] == 4)) && ((BASH_VERSINFO[1] >= 2 )) && ((BASH_VERSINFO[2] >= 20)) || \
   ((BASH_VERSINFO[0] >= 5)); then
    shopt -s direxpand
fi
