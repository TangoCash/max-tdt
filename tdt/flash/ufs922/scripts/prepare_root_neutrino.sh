#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPSTORAGEDIR=$4
TMPKERNELDIR=$5

find $RELEASEDIR -mindepth 1 -maxdepth 1 -exec cp -at$TMPROOTDIR -- {} +

cd $TMPROOTDIR/dev/
$TMPROOTDIR/var/etc/init.d/makedev start
cd -

# mini rcS fürs root
rm -rf $TMPROOTDIR/etc
mkdir -p $TMPROOTDIR/etc/init.d
cp -f $TMPROOTDIR/var/etc/inittab $TMPROOTDIR/etc
cp -f $CURDIR/scripts/rcS $TMPROOTDIR/etc/init.d
chmod 755 $TMPROOTDIR/etc/init.d/rcS

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

# var kopieren und leeren
cp -a $TMPROOTDIR/var/* $TMPSTORAGEDIR/
rm -rf $TMPROOTDIR/var/*

