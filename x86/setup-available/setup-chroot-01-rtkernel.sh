#!/bin/bash

url=https://aur.archlinux.org/cgit/aur.git/snapshot/linux-rt.tar.gz

cd
source install-conf.sh

cd /home/aur/
mkdir setup-rtkernel
cd setup-rtkernel

wget ${url}

tar -zxvf linux-rt.tar.gz
cd linux-rt

chown aur:users -R /home/aur/setup-rtkernel

sudo -u aur makepkg -s

pacman -U --noconfirm *.pkg.tar.xz

cd
