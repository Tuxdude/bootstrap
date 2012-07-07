#
# Author: Ash <tuxdude.github@gmail.com>
#

test -s ~/.alias && . ~/.alias || true

for ext in $HOME/.bashrc-plugins/*.sh; do
    source $ext
done

# Set the terminal window title
settitle () {
    if [ -z "$1" ] ; then
        if [ -z "${SSH_CONNECTION}" ]; then
            export PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
        else
            export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        fi
    fi
}

make() {
    if [ "$OVERRIDE_ANDROID_MAKE" == "1" ]; then
        _override_android_make $@
    elif [ "$OVERRIDE_WORK_MAKE" == 1 ]; then
        _override_work_make $@
    else
        /usr/bin/make $@
    fi
}

# Custom prompt
if [ "$OVERRIDE_CUSTOM_PROMPT" != "1" ]; then
    export PS1="<\[\033[1;31m\]\@\[\033[0m\]> \[\033[1;32m\]\u\[\033[0;36m\]@\[\033[1;34m\]\h:\[\033[0;33m\]\w\[\033[0m\]\n\$ "
fi

# EDITOR env var used by multiple programs
export EDITOR=/usr/bin/vim

# Fortune
if [[ -z "${SSH_CONNECTION}" && -z "$IN_CBE" ]]; then
    echo -e '\033[1;36m'
    fortune | cowsay -f tux
    echo -e '\033[0m'
fi

# Grep with colors
if [ -x /usr/bin/dircolors ]; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Handy aliases
# Source grep aliases
alias tgrep="find . -follow -type f -name \*.txt | xargs grep -H -n $1"
alias hgrep="find . -follow -type f -name \*.h | xargs grep -H -n $1"
alias cgrep="find . -follow -type f -name \*.c | xargs grep -H -n $1"
alias cppgrep="find . -follow -type f -name \*.cpp -o -name \*.c -o -name \*.C -o -name \*.cxx -o -name \*.c++ | xargs grep -H -n $1"
alias srcgrep="find . -follow -type f -name \*.[hcmCSs] -o -name \*.asm -o -name \*.cpp -o -name \*.inc -o -name \*.cxx -o -name \*.c++ -o -name \*.tcl -o -name \*.itcl -o -name \*.pl -o -name \*.sh -o -name \?akefile\* -o -name \*.mk -o -name \*.def -o -name \*commondefs -o -name \*commonrules -o -name ismdefs -o -name ismrules | xargs grep -H -n $1"
alias allgrep="find . -follow -type f | xargs grep -H -n $1"

# Misc aliases
alias rebuild_tags='/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .'
alias fixfiles='sudo find . -type f -exec chmod 0644 {} \;'
alias fixdir='sudo find . -type d -exec chmod 0755 {} \;'
alias kbfix='setxkbmap -v 10 -display $DISPLAY -geometry "pc(pc105)" -keycodes "evdev+aliases(qwerty)" -option ctrl:nocaps -option compose:rctrl'

# Set the default title
settitle
