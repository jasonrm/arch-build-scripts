#!/bin/bash
export PACKAGER="Jason R. McNeil <jason@jasonrm.net>"

# This might not be required in the future
dhcpcd host0

pacman --sync --sysupgrade --refresh --noconfirm

useradd -g users -G wheel -s /bin/bash build
mkdir -p /home/build && chown -R build:users /home/build
chown -R build:users /build

cd /build

if [[ -f ./pre_build.sh ]]; then
    ./pre_build.sh || exit 1
fi

sudo -u build makepkg --force --cleanbuild --noconfirm --syncdeps || exit 1

if [[ -f ./post_build.sh ]]; then
    ./post_build.sh || exit 1
fi
