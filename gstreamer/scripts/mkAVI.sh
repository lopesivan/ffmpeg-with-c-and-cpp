#!/bin/bash

ECHO=echo
[ "$1" = '-on' ] &&  { ECHO=""; shift;   }

ConfigureEnv() {
	LAUNCH=gst-launch  # Como o gstreamer pode possuir versões diferentes
                       # eu uso uma variável para representar o launch do
                       # gstreamer.

	w=$(vgrabbj -s /dev/video0 2>&1 | sed -n 's/MaxWidth.*: \(.*\)/\1/p')
	h=$(vgrabbj -s /dev/video0 2>&1 | sed -n 's/MaxHeight.*: \(.*\)/\1/p')

	w=1280
	h=720

	output=video.avi                 # <1>

	DEBUG="-v --gst-debug-level=2"
	# Podemos usar  o número de buffers para pegar uma imagem de nosso vídeo,
	# como por exemplo, fazendo o NB ser igual a 1. Como no exemplo abaixo:
	# SCREENSHOT DE TELA
	# gst-launch-0.10 ximagesrc num-buffers=1
	# ! ffmpegcolorspace
	# ! pngenc
	# ! filesink location=screenshot.png
	#
	# Mas o interessante mesmo é usar este valor para determinar o tempo do
	# vídeo. Vejamos, para um NB igual a 150, temos que um buffer vale 1024,
	# logo o seu tamanho é de 150*1024, dividindo pela frequencia 30kHz, temos
	# um tempo de 5 segundos.
	#
	#  - sendo F a frequencia e seu valor é 30720
	#  - sendo S o tamanho de 1 buffer
	#  - Tempo de gravação do vídeo
	#
	#     NB x S
	#   ----------  = T
	#       F
	#
	#   para um T = 23.5 segundos, temos
	#
    #            F x T      30720 x 23.5
	#    NB =   -------- = -------------   =  705
	#              S          1024
	#
	#    NB =  705
	#
    # $ ffmpeg -i video.avi
    # Input #0, avi, from 'video.avi':
    # Duration: 00:00:23.50, start: 0.000000, bitrate: 442375 kb/s
    # Stream #0.0: Video: rawvideo, yuyv422, 1280x720, 30 tbr, 30 tbn, 30 tbc
	#
	time_in_seconds=$1
	NB=$(echo "30720*${time_in_seconds}/1024" | bc)

}

ConfigureGstreamer() {
    #
	# Definindo vídeo.
	#
	VELEM="videotestsrc"                   # <2>
	VELEM="videotestsrc pattern=10"        # <2>
	VELEM="videotestsrc num-buffers=${NB}" # <3>
	VELEM="videotestsrc is-live=1 num-buffers=${NB}" # <3>
	VCAPS="video/x-raw-yuv, width=$w, height=$h"
	VENC=

	#
	# Argumentos que alteram o formato da entrada de vídeo.
	#
	VARG1="timeoverlay halign=right valign=top"
	VARG2="textoverlay font-desc=\"Sans 24\" text=\"CHANNEL 1\" valign=top halign=left shaded-background=true"
	VARG3="textoverlay font-desc=\"Sans 24\" text=\"Mobile Channel\" shaded-background=true"
	OVERL="$VARG1 ! $VARG2 ! $VARG3"

    #
	# audiotestsrc num-buffers=150
	# By default each buffer contains 1024 samples: samplesperbuffer Which
    # means you are generating 150*1024=153600 samples. Asuming 44.1kHz,
    # the duration would be 153600/44100=3.48 seconds.
	# So if you need 5 seconds audio, you need 5*44100=220500 samples. with
	# samplesperbuffer==1024, this means 220500/1024=215.33 buffers. (ie 215
    # or 216 buffers).
	# It would be easier if you set samplesperbuffer to 441, then you need
    # exactly 100 buffers for every second audio:
	# audiotestsrc num-buffers=500 samplesperbuffer=441
    #

    #
	# Definindo áudio.
	#
	AELEM=
	ACAPS=
	AENC=

    #
	# Definindo Mux.
	#
	MUX="avimux"
}

StartStream() {
	PIPELINE="
$LAUNCH $DEBUG
	$VELEM
      ! $VCAPS
      ! queue
      ! videorate
	  ! aspectratiocrop aspect-ratio=16/9
      ! $OVERL
      ! mux.
    $MUX
        name=mux
      ! queue
      ! filesink
        location=${output}
"

$ECHO $PIPELINE
echo

}

main() {
	ConfigureEnv $1
	ConfigureGstreamer
	StartStream
}

# ----------------------------------------------------------------------------
NUMBEROFBUFFERS=$1
main $NUMBEROFBUFFERS
# ----------------------------------------------------------------------------
exit 0

