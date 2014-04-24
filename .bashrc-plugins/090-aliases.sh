#
# Author: Ash <tuxdude.github@gmail.com>
#

# Handy aliases

# Basic ones
alias ls='ls --color=auto'

# Source grep aliases
alias tgrep="find . -follow -type f -name \*.txt | xargs grep -H -n $1"
alias hgrep="find . -follow -type f -name \*.h | xargs grep -H -n $1"
alias cgrep="find . -follow -type f -name \*.c | xargs grep -H -n $1"
alias cppgrep="find . -follow -type f -name \*.cpp -o -name \*.c -o -name \*.C -o -name \*.cxx -o -name \*.c++ | xargs grep -H -n $1"
alias srcgrep="find . -follow -type f -name \*.[hcmCSs] -o -name \*.asm -o -name \*.cpp -o -name \*.inc -o -name \*.cxx -o -name \*.c++ -o -name \*.tcl -o -name \*.itcl -o -name \*.pl -o -name \*.sh -o -name \?akefile\* -o -name \*.mk -o -name \*.def -o -name \*commondefs -o -name \*commonrules -o -name ismdefs -o -name ismrules | xargs grep -H -n $1"
alias allgrep="find . -follow -type f | xargs grep -H -n $1"

# Misc aliases
alias vless='vim -u /usr/share/vim/current/macros/less.vim'
alias rebuild_tags='/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .'
alias fixfiles='sudo find . -type f -exec chmod 0644 {} \;'
alias fixdir='sudo find . -type d -exec chmod 0755 {} \;'
alias kbfix='setxkbmap -v 10 -display $DISPLAY -geometry "pc(pc105)" -keycodes "evdev+aliases(qwerty)" -option ctrl:nocaps -option compose:rctrl'
alias xauthfix='xauth extract - :`echo $DISPLAY |awk -F: "{print $2}"` | sudo su -c "xauth merge -"'
alias tmux='tmux -2'
alias picocom='picocom -b 115200'
alias hd='od -Ax -tx1z -v'
alias scpresume='rsync --partial --progress --archive --human-readable --compress --rsh=ssh --verbose'
alias diff='colordiff'

# ack exists as 'ack-grep' on linux but as 'ack' on OS X
if [[ $OSTYPE == linux* ]]; then
    alias ack='ack-grep'
fi
