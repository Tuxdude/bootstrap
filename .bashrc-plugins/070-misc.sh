#
# Author: Ash <tuxdude.github@gmail.com>
#

# EDITOR env var used by multiple programs
export EDITOR="$(which vim)"

# Less with colors
export LESS='-R'
export LESSOPEN='|pygmentize -g %s'

# grep with colors
export GREP_OPTIONS='--color=auto'

# Use vim as the Pager for man
# ft=man            - Color the man page
# ts=8              - Tab width matches less
# nonu              - Removes line numbers if set
# nolist            - Disables listchars and hence trailing whitespaces/extra
#                     tabs are not highlighted
# nnoremap i <nop>  - Do not enter insert mode on i
# nmap q :q!<cr>     - Map q to :q
export MANPAGER="/bin/sh -c \"col -b | vim -MRn -c 'set ft=man ts=8 nomod nolist nonu noma' -c 'nnoremap i <nop>' -c 'nmap q :q!<cr>' -\""

# Disable SGR codes output by grotty when run from terminal
export GROFF_NO_SGR=1
