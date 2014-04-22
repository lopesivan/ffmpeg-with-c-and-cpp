#!/bin/bash
# ----------------------------------------------------------------------------
__debug__=0; __help__=0
__usage__=0
__clean__=0
# ----------------------------------------------------------------------------
[ "$1" = '--gui'   ] && { __gui__=1; shift;   }
[ "$1" = '-h'      ] && { __help__=1; shift;  }
[ "$1" = '--help'  ] && { __help__=1; shift;  }
[ "$1" = '-d'      ] && { __debug__=1; ECHO=echo;shift; }
[ "$1" = '--debug' ] && { __debug__=1; ECHO=echo;shift; }
[ "$1" = '--usage' ] && { __usage__=1; shift; }
[ "$1" = '--clean' ] && { __clean__=1; shift; }
# ----------------------------------------------------------------------------

##############################################################################
##############################################################################
##############################################################################

# vi:set nu nowrap:
# gnu.sh: Gen Makefiles.

# $Id:$
# Federal University of Rio de Janeiro
#      Author: Ivan carlos da Silva Lopes
#        Mail: lopesivan (dot) ufrj (at) gmail (dot) com
#     License: gpl
#    Language: Shell Script
#        File: gnu.sh
#        Date: Sun 06 Mar 2011 10:14:38 PM BRT
# Description:
#
#
if [ $__clean__ -eq 1 ]; then
	#__clean__ has value equal 1
	#__clean__ ON

	rm *.bkl Makefile *.o *.d
	rm -rf .deps/ aclocal.m4 build.bkl config.status INSTALL autoconf_inc.m4  cfg/ config.sub  install-sh  src.tgz autom4te.cache  config.guess  configure Makefile bk-deps config.log Makefile.in
	rm *.ppm
	exit 0
fi

haml_file=*.haml
haml $haml_file && haml $haml_file > build.bkl

format=gnu
f=*.bkl
# ----------------------------------------------------------------------------
$ECHO bakefile \
	-f $format \
	$f -o Makefile
# ----------------------------------------------------------------------------
exit 0
