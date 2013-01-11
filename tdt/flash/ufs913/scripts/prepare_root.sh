#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPKERNELDIR=$4
TMPFWDIR=$5

cp -a $RELEASEDIR/* $TMPROOTDIR

cd $TMPROOTDIR/dev/
$TMPROOTDIR/var/etc/init.d/makedev start
cd -

mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

mv $TMPROOTDIR/boot/audio.elf $TMPFWDIR/audio.elf
mv $TMPROOTDIR/boot/video.elf $TMPFWDIR/video.elf

rm -f $TMPROOTDIR/boot/*

echo "/dev/mtdblock8	/boot	jffs2	defaults	0	0" >> $TMPROOTDIR/var/etc/fstab
#echo "/dev/mtdblock10	/swap	jffs2	defaults	0	0" >> $TMPROOTDIR/var/etc/fstab
