#!/bin/bash
#                      __ __       ___
#                     /\ \\ \    /'___`\
#                     \ \ \\ \  /\_\ /\ \
#                      \ \ \\ \_\/_/// /__
#                       \ \__ ,__\ // /_\ \
#                        \/_/\_\_//\______/
#                           \/_/  \/_____/
#                                         Algoritimos
#
#
#       Author: Ivan carlos da Silva Lopes
#         Mail: ivanlopes (at) 42algoritimos (dot) com (dot) br
#      License: gpl
#        Site: http://www.42algoritmos.com.br
#       Phone: +1 561 801 7985
#    Language: Shell Script
#        File: mkindex.sh
#        Date: Mon 27 May 2013 02:38:32 AM BRT
# Description:
#	

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

# ----------------------------------------------------------------------------

for f in *.ts *.m3u8; do
	echo remove $f
	rm $f
done

ip=$(ifconfig | 
	awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}' | 
	head -1)

cat <<EOF > index.html
<video id='myVideo' src='http://${ip}/ios/stream_multi.m3u8' controls width="640" height="360"  /></video>

<SCRIPT LANGUAGE="JavaScript">
<!--
window.onload = function() {
var pElement = document.getElementById("myVideo");
pElement.load();
pElement.play();
};
//-->
</SCRIPT>
EOF
# ----------------------------------------------------------------------------
exit 0
