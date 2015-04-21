#
# Author: Ash <tuxdude.io@gmail.com>
#

# Run git in multiple repos at the same level
gitmulti() {
    for dir in $(find . -maxdepth 2 -name .git | xargs dirname); do cd $dir && pwd && git $@ && echo && cd - > /dev/null; done
}
