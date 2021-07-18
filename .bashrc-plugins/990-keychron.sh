#
# Author: Ash <tuxdude.io@gmail.com>
#

fixkeychronfnkeys() {
  echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
}
