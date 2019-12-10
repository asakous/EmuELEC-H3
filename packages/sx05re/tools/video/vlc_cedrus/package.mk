# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="vlc_cedrus"
PKG_VERSION="11d59d183f69cd783e1950614dccbf77abe499ac"
PKG_REV="20190822"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/chickli/vlc"
PKG_URL="https://github.com/chickli/vlc.git"
PKG_DEPENDS_TARGET="toolchain "
PKG_SHORTDESC="media-codec"
PKG_LONGDESC="media-codec"
PKG_AUTORECONF="yes"
PKG_TOOLCHAIN="make"
GET_HANDLER_SUPPORT="git"
PKG_CONFIGURE_OPTS_TARGET=""
PKG_CONFIGURE_OPTS_HOST=""


configure_target() {
#export CFLAGS="$CFLAGS -Wno-error=strict-aliasing"
/bootstrap
./configure --host=armv7ve-libreelec-linux-gnueabi --prefix= $SYSROOT_PREFIX/usr/bin/ --enable-cedar
}

#make_target() {
#cd $PKG_BUILD/sunxi-cedarx/SOURCE
#make ARCH=arm
#}
#post_makeinstall_target() {
#  rm -fr $INSTALL/usr/share/applications
#  rm -fr $INSTALL/usr/share/icons
#  rm -fr $INSTALL/usr/share/kde4
#  rm -f $INSTALL/usr/bin/rvlc
#  rm -f $INSTALL/usr/bin/vlc-wrapper
#
#  mkdir -p $INSTALL/usr/config
#    mv -f $INSTALL/usr/lib/vlc $INSTALL/usr/config
#    ln -sf /storage/.config/vlc $INSTALL/usr/lib/vlc
#}
#post_makeinstall_target() {
#    mkdir -p $TOOLCHAIN/include/cedrus
#    cp -rf $PKG_BUILD/cedrus.h $TOOLCHAIN/include/cedrus
#    cp -rf $PKG_BUILD/cedrus_regs.h $TOOLCHAIN/include/cedrus
#    cp -rf $PKG_BUILD/libcedrus.so.1 $TOOLCHAIN/lib
#    ln -sf  $TOOLCHAIN/lib/libcedrus.so.1 $TOOLCHAIN/lib/libcedrus.so
#    mkdir -p $SYSROOT_PREFIX/usr/include/cedrus
#    cp -rf $INSTALL/usr/lib $SYSROOT_PREFIX/usr/lib
#    cp -rf $INSTALL/usr/include $SYSROOT_PREFIX/usr/include/cedrus
#
#}

