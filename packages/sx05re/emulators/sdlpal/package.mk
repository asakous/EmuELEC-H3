################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="sdlpal"
PKG_VERSION="49fa44a5526d9fec17b817c5f35c069b5c44797d"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/sdlpal/sdlpal"
PKG_URL="https://github.com/sdlpal/sdlpal.git"
PKG_DEPENDS_TARGET="toolchain gl4es"
PKG_PRIORITY="optional"
PKG_SHORTDESC="SDLPAL is an SDL-based open-source cross-platform reimplementation of the classic Chinese RPG game Xiān jiàn Qí Xiá Zhuàn (Chinese: 仙剑奇侠传/仙劍奇俠傳) (also known as Chinese Paladin or Legend of Sword and Fairy, or PAL for short)"
PKG_LONGDESC="SDLPAL is an SDL-based open-source cross-platform reimplementation of the classic Chinese RPG game Xiān jiàn Qí Xiá Zhuàn (Chinese: 仙剑奇侠传/仙劍奇俠傳) (also known as Chinese Paladin or Legend of Sword and Fairy, or PAL for short)"

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"
GET_HANDLER_SUPPORT="git"

#PKG_MAKE_OPTS_TARGET="all"
make_target() {
    cd $PKG_BUILD/unix
    make -j2  HOST="armv7ve-libreelec-linux-gnueabi-"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin/sdlpal
  cp -f $PKG_BUILD/unix/sdlpal $INSTALL/usr/bin/sdlpal
}

#post_unpack() {
#cd $PKG_BUILD
#git submodule update --init
#}

pre_configure_target() {
sed -i -e "s/sdl2-config/\$\{LIB_PREFIX\}\/bin\/sdl2-config/" $PKG_BUILD/unix/Makefile
LDFLAGS="$LDFLAGS -Wl,-rpath='$LIB_PREFIX\/lib\/\'"
export LIB_PREFIX=${LIB_PREFIX}
}










