# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="media-codec"
PKG_VERSION="c9837392b17524a3f8fa304402d7cd11e443e8f7"
PKG_REV="20190822"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/allwinner-zh/media-codec"
PKG_URL="https://github.com/mlegenovic/media-codec.git"
PKG_DEPENDS_TARGET="toolchain "
PKG_SHORTDESC="media-codec"
PKG_LONGDESC="media-codec"
PKG_AUTORECONF="yes"
PKG_TOOLCHAIN="manual"
GET_HANDLER_SUPPORT="git"


configure_target() {
cd $PKG_BUILD/sunxi-cedarx/SOURCE
export CFLAGS="$CFLAGS -Wno-error=strict-aliasing"
./bootstrap
./configure --enable-static --host=armv7ve-libreelec-linux-gnueabi
}

make_target() {
cd $PKG_BUILD/sunxi-cedarx/SOURCE
make ARCH=arm
}
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
