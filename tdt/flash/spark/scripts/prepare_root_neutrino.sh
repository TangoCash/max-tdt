#!/bin/bash

CURDIR=$1
RELEASEDIR=$2
TMPROOTDIR=$3
TMPKERNELDIR=$4

cp -a $RELEASEDIR/* $TMPROOTDIR
cp $RELEASEDIR/.version $TMPROOTDIR

cd $TMPROOTDIR/dev/
if [ -e $TMPROOTDIR/var/etc/init.d/makedev ]; then
	$TMPROOTDIR/var/etc/init.d/makedev start
else
	$TMPROOTDIR/etc/init.d/makedev start
fi
cd -

# --- BOOT ---
mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage
