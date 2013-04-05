#
# Author: Ash <tuxdude.github@gmail.com>
#

# Fortune
if [[ -z "${SSH_CONNECTION}" && -z "$IN_CBE" ]]; then
    echo -e '\033[1;36m'
    fortune | cowsay -f tux
    echo -e '\033[0m'
fi
