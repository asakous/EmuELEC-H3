# SPDX-License-Identifier: GPL-2.0-or-later
# Matthew Wang (https://github.com/asakous)
PKG_NAME="smsplus-gx"
PKG_VERSION="e280f31989c513be874d8424b7f771cbf9d57a24"
PKG_SHA256="8662d61ea5cea1624644c5f3844ed6df4a90d6d9bff551165db13789212f4458"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/smsplus-gx"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="SMSPlus-GX RS97 to the libretro API."
PKG_LONGDESC="SMSPlus-GX RS97 to the libretro API."

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp smsplus_libretro.so $INSTALL/usr/lib/libretro/
}
