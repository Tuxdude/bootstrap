#
# Author: Ash <tuxdude.io@gmail.com>
#

# Make perl modules installed by brew accessible to all
if [[ $OSTYPE == darwin* ]]; then
    export PERL5LIB="/usr/local/lib/perl5/site_perl/"
fi
