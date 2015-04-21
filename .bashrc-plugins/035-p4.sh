#
# Author: Ash <tuxdude.io@gmail.com>
#

# List all opened files in the current directory showing relative path names
# in the output
p4openedlist() {
    p4 opened ... | sed 's/#.*//' | xargs p4 where | sed 's/.* //' | cut -d '/' -f $(($(echo $PWD | sed s'/\// /g' | wc -w)+2))-
}

# p4 aliases
alias p4clidiff='P4DIFF="colordiff -u" p4 diff'
alias p4vimdiff='P4DIFF="vimdiff -f" p4 diff'
alias p4gvimdiff='P4DIFF="gvimdiff -f" p4 diff'
