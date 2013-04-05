#
# Author: Ash <tuxdude.github@gmail.com>
#

# Run git in multiple repos at the same level
gitmulti() {
    for dir in $(find . -maxdepth 2 -name .git | xargs dirname); do cd $dir && pwd && git $@ && echo && cd - > /dev/null; done
}
if [ -z "$IN_CBE" ]; then
    complete -o bashdefault -o default -o nospace -F _git gitmulti 2>/dev/null \
            || complete -o default -o nospace -F _git gitmulti
fi
