# =========================================================================
#     This makefile was generated by
#     Bakefile 0.2.9 (http://www.bakefile.org)
#     Do not modify, all changes will be overwritten!
# =========================================================================



# -------------------------------------------------------------------------
# These are configurable options:
# -------------------------------------------------------------------------

# C compiler 
CC = gcc

# Standard flags for CC 
CFLAGS ?= 

# Standard preprocessor flags (common for CC and CXX) 
CPPFLAGS ?= 

# Standard linker flags 
LDFLAGS ?= 

# Set to 1 to build debug version [0,1]
DEBUG ?= 0



# -------------------------------------------------------------------------
# Do not modify the rest of this file!
# -------------------------------------------------------------------------

### Variables: ###

CPPDEPS = -MT$@ -MF`echo $@ | sed -e 's,\.o$$,.d,'` -MD -MP
TUTORIAL02_CFLAGS = $(____DEBUG_0_p) $(____DEBUG_1_2) $(____DEBUG_3) \
	-I./include `pkg-config --cflags libavformat libavcodec libswscale libavutil \
	sdl` $(CPPFLAGS) $(CFLAGS)
TUTORIAL02_OBJECTS =  \
	tutorial02_queue.o \
	tutorial02_list.o \
	tutorial02_stack.o \
	tutorial02_tutorial02.o

### Conditionally set variables: ###

ifeq ($(DEBUG),0)
____DEBUG_0_p = -DNDEBUG
endif
ifeq ($(DEBUG),1)
____DEBUG_0_p = 
endif
ifeq ($(DEBUG),0)
____DEBUG_1_2 = -O2
endif
ifeq ($(DEBUG),1)
____DEBUG_1_2 = -O0
endif
ifeq ($(DEBUG),0)
____DEBUG_3 = 
endif
ifeq ($(DEBUG),1)
____DEBUG_3 = -g
endif


### Targets: ###

all: tutorial02

install: 

uninstall: 

clean: 
	rm -f ./*.o
	rm -f ./*.d
	rm -f tutorial02

tutorial02: $(TUTORIAL02_OBJECTS)
	$(CC) -o $@ $(TUTORIAL02_OBJECTS)  $(____DEBUG_3) `pkg-config --libs libavformat libavcodec libswscale libavutil sdl` $(LDFLAGS)

tutorial02_queue.o: ./src/queue.c
	$(CC) -c -o $@ $(TUTORIAL02_CFLAGS) $(CPPDEPS) $<

tutorial02_list.o: ./src/list.c
	$(CC) -c -o $@ $(TUTORIAL02_CFLAGS) $(CPPDEPS) $<

tutorial02_stack.o: ./src/stack.c
	$(CC) -c -o $@ $(TUTORIAL02_CFLAGS) $(CPPDEPS) $<

tutorial02_tutorial02.o: ./src/tutorial02.c
	$(CC) -c -o $@ $(TUTORIAL02_CFLAGS) $(CPPDEPS) $<

.PHONY: all install uninstall clean


# Dependencies tracking:
-include ./*.d
