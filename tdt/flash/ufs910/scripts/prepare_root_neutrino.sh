#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPSTORAGEDIR=$4
TMPKERNELDIR=$5

find $RELEASEDIR -mindepth 1 -maxdepth 1 -exec cp -at$TMPROOTDIR -- {} +

cd $TMPROOTDIR/dev/
if [ -e $TMPROOTDIR/var/etc/init.d/makedev ]; then
	$TMPROOTDIR/var/etc/init.d/makedev start
else
	$TMPROOTDIR/etc/init.d/makedev start
fi
cd -

mkdir $TMPROOTDIR/root_rw
mkdir $TMPROOTDIR/storage
cp ../common/init_mini_fo $TMPROOTDIR/sbin/
chmod 777 $TMPROOTDIR/sbin/init_mini_fo

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

# --- STORAGE FOR MINI_FO ---
mkdir $TMPSTORAGEDIR/root_ro

