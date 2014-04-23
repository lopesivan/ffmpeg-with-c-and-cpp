gst-launch -v --gst-debug-level=2 videotestsrc \
! ffmpegcolorspace \
! timeoverlay halign=right valign=top \
! clockoverlay halign=left valign=top time-format="%Y/%m/%d %H:%M:%S" \
! textoverlay text="LivecamMobile" \
	! queue ! videoscale method=1 ! video/x-raw-yuv,width=640,height=480 \
	! queue ! videorate ! video/x-raw-yuv,framerate=10/1 \
	! queue max-size-bytes=20971520 \
! x264enc bitrate=600 key-int-max=90 profile=main ! mpegtsmux \
! souphttpclientsink \
location=http://localhost:8080/stream0stream0
