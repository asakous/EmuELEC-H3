#!/bin/bash
INSTALL="/home/asako/EmuELEC/build.EmuELEC-H3.arm-3.1/image/system"
MODVER=$(basename $(ls -d ${INSTALL}/usr/lib/kernel-overlays/base/lib/modules/*))
echo $MODVER
