dnl ### begin block 00_header[build.bkl] ###
dnl
dnl This macro was generated by
dnl Bakefile 0.2.9 (http://www.bakefile.org)
dnl Do not modify, all changes will be overwritten!

BAKEFILE_AUTOCONF_INC_M4_VERSION="0.2.9"

dnl ### begin block 20_COND_DEBUG_0[build.bkl] ###
    COND_DEBUG_0="#"
    if test "x$DEBUG" = "x0" ; then
        COND_DEBUG_0=""
    fi
    AC_SUBST(COND_DEBUG_0)
dnl ### begin block 20_COND_DEBUG_1[build.bkl] ###
    COND_DEBUG_1="#"
    if test "x$DEBUG" = "x1" ; then
        COND_DEBUG_1=""
    fi
    AC_SUBST(COND_DEBUG_1)
dnl ### begin block 20_COND_DEPS_TRACKING_0[build.bkl] ###
    COND_DEPS_TRACKING_0="#"
    if test "x$DEPS_TRACKING" = "x0" ; then
        COND_DEPS_TRACKING_0=""
    fi
    AC_SUBST(COND_DEPS_TRACKING_0)
dnl ### begin block 20_COND_DEPS_TRACKING_1[build.bkl] ###
    COND_DEPS_TRACKING_1="#"
    if test "x$DEPS_TRACKING" = "x1" ; then
        COND_DEPS_TRACKING_1=""
    fi
    AC_SUBST(COND_DEPS_TRACKING_1)
dnl ### begin block 20_COND_PLATFORM_MAC_0[build.bkl] ###
    COND_PLATFORM_MAC_0="#"
    if test "x$PLATFORM_MAC" = "x0" ; then
        COND_PLATFORM_MAC_0=""
    fi
    AC_SUBST(COND_PLATFORM_MAC_0)
dnl ### begin block 20_COND_PLATFORM_MAC_1[build.bkl] ###
    COND_PLATFORM_MAC_1="#"
    if test "x$PLATFORM_MAC" = "x1" ; then
        COND_PLATFORM_MAC_1=""
    fi
    AC_SUBST(COND_PLATFORM_MAC_1)
