# SPDX-License-Identifier: GPL-2.0-or-later
# Matthew Wang (https://github.com/asakous)
PKG_NAME="race"
PKG_VERSION="fc41e50aeff2be5c9d5c70757a2d77c4ecf13ef1"
PKG_SHA256="fed9499ca024a402df068a50b3822249bf05f4e010f0cca686e5a5c68f817be1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/RACE"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="RACE-NGPC-Emulator-PSP to the libretro API."
PKG_LONGDESC="RACE-NGPC-Emulator-PSP to the libretro API."

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

make_target() {
  make -f Makefile platform=classic_armv7_a7
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp race_libretro.so $INSTALL/usr/lib/libretro/
}
