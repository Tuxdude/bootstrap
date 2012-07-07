# Sample .profile for SuSE Linux
# rewritten by Christian Steinruecken <cstein@suse.de>
# Modified by Ash <tuxdude.github@gmail.com>
#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile || true

# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
#export LANG=de_DE.UTF-8	# uncomment this line for German output
#export LANG=fr_FR.UTF-8	# uncomment this line for French output
#export LANG=es_ES.UTF-8	# uncomment this line for Spanish output
#export LANG=en_US

export JAVA_HOME=/usr/lib64/jvm/java-1.6.0-sun-1.6.0
export PATH=$JAVA_HOME/bin:$PATH:/sbin
