# =========================================================================
#     This makefile was generated by
#     Bakefile 0.2.9 (http://www.bakefile.org)
#     Do not modify, all changes will be overwritten!
# =========================================================================




prefix = /usr/local
exec_prefix = ${prefix}
datarootdir = ${prefix}/share
INSTALL = /usr/bin/install -c
EXEEXT = 
SETFILE = 
BK_DEPS = /workspace/learning/learning-ffmpeg-with-c-and-cpp/tutorial/02.a/bk-deps
srcdir = .
LIBS = 
CC = gcc
CFLAGS = -g -O2 -Wall   -I/usr/local/include   -D_GNU_SOURCE=1 -D_REENTRANT -I/usr/include/SDL  
CPPFLAGS = 
LDFLAGS =  -pthread -L/usr/local/lib -lavformat -lavcodec -ldl -lX11 -lXext -lXfixes -lva -ljack -lasound -lSDL -lxvidcore -lx264 -lvpx -lvorbisenc -lvorbis -ltheoraenc -ltheoradec -logg -lspeex -lopencore-amrwb -lopencore-amrnb -lmp3lame -lfaac -lbz2 -lz -lswscale -lavutil -lm     -lSDL  

### Variables: ###

DESTDIR = 
TUTORIAL02_CFLAGS =  $(____DEBUG_0_p)   -I./include  $(CPPFLAGS) $(CFLAGS)
TUTORIAL02_OBJECTS =  \
	tutorial02_queue.o \
	tutorial02_list.o \
	tutorial02_stack.o \
	tutorial02_tutorial02.o

### Conditionally set variables: ###

#CCC = $(CC)
CCC = $(BK_DEPS) $(CC)
__tutorial02___mac_setfilecmd = @true
#__tutorial02___mac_setfilecmd = \
#	$(SETFILE) -t APPL tutorial02$(EXEEXT)
____DEBUG_0_p = -DNDEBUG
#____DEBUG_0_p = 

### Targets: ###

all: tutorial02$(EXEEXT)

install: 

uninstall: 

install-strip: install

clean: 
	rm -rf ./.deps ./.pch
	rm -f ./*.o
	rm -f tutorial02$(EXEEXT)

distclean: clean
	rm -f config.cache config.log config.status bk-deps bk-make-pch shared-ld-sh Makefile

tutorial02$(EXEEXT): $(TUTORIAL02_OBJECTS)
	$(CC) -o $@ $(TUTORIAL02_OBJECTS)   $(LDFLAGS)  $(LIBS)
	
	$(__tutorial02___mac_setfilecmd)

tutorial02_queue.o: $(srcdir)/src/queue.c
	$(CCC) -c -o $@ $(TUTORIAL02_CFLAGS) $(srcdir)/src/queue.c

tutorial02_list.o: $(srcdir)/src/list.c
	$(CCC) -c -o $@ $(TUTORIAL02_CFLAGS) $(srcdir)/src/list.c

tutorial02_stack.o: $(srcdir)/src/stack.c
	$(CCC) -c -o $@ $(TUTORIAL02_CFLAGS) $(srcdir)/src/stack.c

tutorial02_tutorial02.o: $(srcdir)/src/tutorial02.c
	$(CCC) -c -o $@ $(TUTORIAL02_CFLAGS) $(srcdir)/src/tutorial02.c


# Include dependency info, if present:
-include ./.deps/*.d

.PHONY: all install uninstall clean distclean
