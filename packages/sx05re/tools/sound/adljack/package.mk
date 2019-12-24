# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="adljack"
PKG_VERSION="8a1da749826479d38f03467fe84ef6e0fecf0dce"
PKG_LICENSE="boost Software License - Version 1.0 - August 17th, 2003"
PKG_SITE="https://github.com/jpcima/adljack"
PKG_URL="https://github.com/jpcima/adljack.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="OPL3/OPN2 synthesizer using ADLMIDI and OPNMIDI, for Jack and cross-platform audio"
PKG_BUILD_FLAGS="+pic"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="cmake"

pre_configure_target() {
  PKG_CMAKE_OPTS_TARGET=" -DCMAKE_BUILD_TYPE=Release -DCURSES_INCLUDE_DIR=$SYSROOT_PREFIX/usr/include/ -DCURSES_LIBRARY=$SYSROOT_PREFIX/usr/lib/libncurses.a"
}

