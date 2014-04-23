gst-launch -v --gst-debug-level=2 videotestsrc \
! ffmpegcolorspace \
! x264enc bitrate=600 key-int-max=90 profile=main \
! souphttpclientsink \
location=http://localhost:8080/stream0stream0
