#!/bin/sh
haml=*.haml
bkl=build.bkl

haml $haml $bkl
bakefile -f autoconf $bkl
aclocal -I . -I /usr/local/share/aclocal/
autoconf
bakefilize --copy
exit 0
