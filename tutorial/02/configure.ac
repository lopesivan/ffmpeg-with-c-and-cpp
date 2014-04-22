AC_PREREQ(2.53)
AC_INIT([tutorial02], [1.0], [author@example.com])

dnl pass some unique file file to AC_CONFIG_SRCDIR
AC_CONFIG_SRCDIR([autoconf_inc.m4])
AC_CANONICAL_HOST

AM_INIT_AUTOMAKE($PACKAGE_NAME,$PACKAGE_VERSION)

AC_ARG_ENABLE(debug,
              [  --enable-debug          Enable debugging information],
              USE_DEBUG="$enableval", USE_DEBUG="no")

if test $USE_DEBUG = yes ; then
  DEBUG=1
  dnl Bakefile doesn't touch {C,CPP,CXX,LD}FLAGS in autoconf format, we
  dnl have to do it ourselves. This will work with many compilers
  dnl (but not all, proper configure script would check if the compiler
  dnl supports it):
  CFLAGS="$CFLAGS -ggdb -DDEBUG"
else
  DEBUG=0
fi

dnl checando os headers.
AC_HEADER_STDC
AC_CHECK_HEADERS([sys/types.h])
AC_CHECK_HEADERS([signal.h])
AC_CHECK_HEADERS([getopt.h])

dnl checando as funções
AC_FUNC_MALLOC
AC_CHECK_FUNCS([memmove memset strrchr strtol])

dnl definindo os parametros que serão passados para o comando pkg-config.
dnl checando as funções
PKG_PROG_PKG_CONFIG
PKG_CHECK_MODULES(FFMPEG, libavformat libavcodec libswscale libavutil)
PKG_CHECK_MODULES(SDL, sdl)

AC_SUBST(FFMPEG_CFLAGS)
AC_SUBST(FFMPEG_LIBS)

AC_SUBST(SDL_CFLAGS)
AC_SUBST(SDL_LIBS)

AC_SUBST(PACKAGE_VERSION)

dnl configurando CFLAGS e LDFLAGS
CFLAGS="$CFLAGS -Wall"
CFLAGS="$CFLAGS $FFMPEG_CFLAGS"
LDFLAGS="$LDFLAGS $FFMPEG_LIBS"

AC_BAKEFILE([m4_include(autoconf_inc.m4)])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
