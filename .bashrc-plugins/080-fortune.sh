#
# Author: Ash <tuxdude.io@gmail.com>
#

# Fortune
if [[ -z "${SSH_CONNECTION}" && -z "$FORTUNE_TOLD" ]]; then
    echo -e '\033[1;36m'
    fortune | cowsay -f tux
    echo -e '\033[0m'
    export FORTUNE_TOLD="1"
fi
