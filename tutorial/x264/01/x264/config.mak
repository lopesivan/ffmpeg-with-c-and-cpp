SRCPATH=.
prefix=/usr/local
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
libdir=${exec_prefix}/lib
includedir=${prefix}/include
ARCH=X86_64
SYS=LINUX
CC=gcc
CFLAGS=-Wshadow -O3 -ffast-math -m64  -Wall -I. -I$(SRCPATH) -std=gnu99  -I/usr/local/include    -I/usr/local/include   -fomit-frame-pointer -fno-tree-vectorize
DEPMM=-MM -g0
DEPMT=-MT
LD=gcc -o 
LDFLAGS=-m64  -lm -lpthread
LIBX264=libx264.a
AR=ar rc 
RANLIB=ranlib
STRIP=strip
AS=yasm
ASFLAGS= -f elf -m amd64 -DHIGH_BIT_DEPTH=0 -DBIT_DEPTH=8
RC=
RCFLAGS=
EXE=
HAVE_GETOPT_LONG=1
DEVNULL=/dev/null
PROF_GEN_CC=-fprofile-generate
PROF_GEN_LD=-fprofile-generate
PROF_USE_CC=-fprofile-use
PROF_USE_LD=-fprofile-use
default: cli
install: install-cli
LDFLAGSCLI = -L.  -pthread -L/usr/local/lib -lavformat -lavcodec -ldl -lX11 -lXext -lXfixes -lva -ljack -lasound -lSDL -lxvidcore -lx264 -lvpx -lvorbisenc -lvorbis -ltheoraenc -ltheoradec -logg -lspeex -lopencore-amrwb -lopencore-amrnb -lmp3lame -lfaac -lbz2 -lz -lswscale -lavutil -lm    -L/usr/local/lib -lswscale -lavutil -lm   
CLI_LIBX264 = $(LIBX264)
