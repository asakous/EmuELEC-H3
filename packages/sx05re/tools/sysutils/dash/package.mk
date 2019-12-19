# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="dash"
PKG_VERSION="afe0e0152e4dc12d84be3c02d6d62b0456d68580"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/tklauser/dash"
PKG_URL="https://github.com/tklauser/dash.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="DASH Shell."
PKG_TOOLCHAIN="autotools"
GET_HANDLER_SUPPORT="git"

#makeinstall_target() {
#mkdir -p $INSTALL/usr/bin
#cp $PKG_BUILD/.${TARGET_NAME}/src/stdbuf $INSTALL/usr/bin/
#cp $PKG_BUILD/.${TARGET_NAME}/src/timeout $INSTALL/usr/bin/
#cp $PKG_BUILD/.${TARGET_NAME}/src/sort $INSTALL/usr/bin/
#mkdir -p $INSTALL/usr/lib/coreutils
#cp $PKG_BUILD/.${TARGET_NAME}/src/libstdbuf.so $INSTALL/usr/lib/coreutils/
#}
