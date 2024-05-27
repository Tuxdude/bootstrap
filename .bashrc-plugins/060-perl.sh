#
# Author: Ash <tuxdude.io@gmail.com>
#

# Make perl modules installed by brew accessible to all
if [[ $OSTYPE == darwin* ]]; then
    if hash brew 2>/dev/null; then
        export PERL5LIB="$(brew --prefix)/lib/perl5/site_perl"
        if brew ls --versions git >/dev/null; then
            export PERL5LIB="$PERL5LIB:$(dirname $(brew list git | grep 'Git.pm'))"
        fi
    fi
fi
