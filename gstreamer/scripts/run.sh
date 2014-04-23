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
#        File: a.sh
#        Date: Mon 27 May 2013 02:04:31 AM BRT
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

echo Inicializando Encoder

> $PWD/1.running

PRODUCER=mk_ogv_WITHOUT_pipe_channel1.sh
CONSUMER="ruby http_streamer.rb config-recommended-iphone-16x9-multirate.yml"

# ----------------------------------------------------------------------------
echo Start source of media ...

./${PRODUCER} -on 20 &
PRODUCER_LASTPID=$!
echo "${PRODUCER_LASTPID}"

echo Start encode and stream ...
${CONSUMER}

kill -9 "${PRODUCER_LASTPID}"

# ----------------------------------------------------------------------------
exit 0
