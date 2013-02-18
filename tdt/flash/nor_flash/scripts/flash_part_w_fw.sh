#!/bin/bash

CURDIR=$1
TUFSBOXDIR=$2
OUTDIR=$3
TMPKERNELDIR=$4
TMPROOTDIR=$5
TMPVARDIR=$6
EXP=$7

echo "CURDIR       = $CURDIR"
echo "TUFSBOXDIR   = $TUFSBOXDIR"
echo "OUTDIR       = $OUTDIR"
echo "TMPKERNELDIR = $TMPKERNELDIR"
echo "TMPROOTDIR   = $TMPROOTDIR"
echo "TMPVARDIR    = $TMPVARDIR"

MKFSJFFS2=$TUFSBOXDIR/host/bin/mkfs.jffs2
MKSQUASHFS=$CURDIR/../common/mksquashfs4.0
SUMTOOL=$TUFSBOXDIR/host/bin/sumtool
PAD=$CURDIR/../common/pad

if [ -f $TMPROOTDIR/etc/hostname ]; then
	HOST=`cat $TMPROOTDIR/etc/hostname`
elif [ -f $TMPVARDIR/etc/hostname ]; then
	HOST=`cat $TMPVARDIR/etc/hostname`
fi

gitversion=`git log | grep "^commit" | wc -l`
#gitversion="rev$(($gitversion-1))"
#gitversion="_rev$gitversion"
gitversion="_BASE-rev`(cd $CURDIR/../../ && git log | grep "^commit" | wc -l)`_HAL-rev`(cd $CURDIR/../../cvs/apps/libstb-hal$EXP && git log | grep "^commit" | wc -l)`_NMP$EXP-rev`(cd $CURDIR/../../cvs/apps/neutrino-mp$EXP && git log | grep "^commit" | wc -l)`"
OUTFILE=$OUTDIR/miniFLASH_$HOST$gitversion.img

if [ ! -e $OUTDIR ]; then
  mkdir $OUTDIR
fi

if [ -e $OUTFILE ]; then
  rm -f $OUTFILE
  rm -f $OUTFILE.md5
fi

# Definition size of kernel, root, var and erase size
case "$HOST" in
	ufs910) echo "Creating flash image for $HOST..."
		SIZE_KERNEL=0x190000
		SIZE_ROOT=0xB40000
		SIZE_VAR=0x2F0000
		ERASE_SIZE=0x10000
	;;
	ufs922) echo "Creating flash image for $HOST..."
		SIZE_KERNEL=0x1A0000
		SIZE_ROOT=0xB40000
		SIZE_VAR=0x2E0000
		ERASE_SIZE=0x10000
	;;
	fortis) echo "Creating flash image for $HOST..."
		SIZE_KERNEL=0x200000
		SIZE_ROOT=0xC00000
		SIZE_VAR=0x11C0000
		ERASE_SIZE=0x20000
	;;
	octagon1008) echo "Creating flash image for $HOST..."
		SIZE_KERNEL=0x200000
		SIZE_ROOT=0xC00000
		SIZE_VAR=0x11C0000
		ERASE_SIZE=0x20000
	;;
	*) echo "Creating flash image for <$HOST -> ufs910>..."
		SIZE_KERNEL=0x190000
		SIZE_ROOT=0xB40000
		SIZE_VAR=0x2F0000
		ERASE_SIZE=0x10000
	;;
esac

# --- KERNEL ---
cp $TMPKERNELDIR/uImage $CURDIR/uImage
$PAD $SIZE_KERNEL $CURDIR/uImage $CURDIR/mtd_kernel.pad.bin

# --- ROOT ---
# Create a squashfs partition for root
echo "MKSQUASHFS $TMPROOTDIR $CURDIR/mtd_root.bin -noappend -comp gzip -always-use-fragments -b 262144"
$MKSQUASHFS $TMPROOTDIR $CURDIR/mtd_root.bin -noappend -comp gzip -always-use-fragments -b 262144 > /dev/null
echo "PAD $SIZE_ROOT $CURDIR/mtd_root.bin $CURDIR/mtd_root.pad.bin"
$PAD $SIZE_ROOT $CURDIR/mtd_root.bin $CURDIR/mtd_root.pad.bin

# --- VAR ---
# Create a jffs2 partition for var
echo "MKFSJFFS2 -qUfv -p$SIZE_VAR -e$ERASE_SIZE -r $TMPVARDIR -o $CURDIR/mtd_var.bin"
$MKFSJFFS2 -qUfv -p$SIZE_VAR -e$ERASE_SIZE -r $TMPVARDIR -o $CURDIR/mtd_var.bin
echo "SUMTOOL -v -p -e $ERASE_SIZE -i $CURDIR/mtd_var.bin -o $CURDIR/mtd_var.sum.bin"
$SUMTOOL -v -p -e $ERASE_SIZE -i $CURDIR/mtd_var.bin -o $CURDIR/mtd_var.sum.bin
echo "$PAD $SIZE_VAR $CURDIR/mtd_var.sum.bin $CURDIR/mtd_var.sum.pad.bin"
$PAD $SIZE_VAR $CURDIR/mtd_var.sum.bin $CURDIR/mtd_var.sum.pad.bin

# --- update.img ---
#Merge all 3 together
cat $CURDIR/mtd_kernel.pad.bin >> $OUTFILE
cat $CURDIR/mtd_root.pad.bin >> $OUTFILE
cat $CURDIR/mtd_var.sum.pad.bin >> $OUTFILE

rm -f $CURDIR/uImage
rm -f $CURDIR/mtd_root.bin
rm -f $CURDIR/mtd_var.bin
rm -f $CURDIR/mtd_var.sum.bin

SIZE=`stat mtd_kernel.pad.bin -t --format %s`
SIZE=`printf "0x%x" $SIZE`
if [[ $SIZE > "$SIZE_KERNEL" ]]; then
  echo -e "\e[31mKERNEL TO BIG. $SIZE instead of $SIZE_KERNEL\e[0m" > /dev/stderr
fi

SIZE=`stat mtd_root.pad.bin -t --format %s`
SIZE=`printf "0x%x" $SIZE`
if [[ $SIZE > "$SIZE_ROOT" ]]; then
  echo -e "\e[31mROOT TO BIG. $SIZE instead of $SIZE_ROOT\e[0m" > /dev/stderr
fi

SIZE=`stat mtd_var.sum.pad.bin -t --format %s`
SIZE=`printf "0x%x" $SIZE`
if [[ $SIZE > "$SIZE_VAR" ]]; then
  echo -e "\e[31mVAR TO BIG. $SIZE instead of $SIZE_VAR\e[0m" > /dev/stderr
fi

rm -f $CURDIR/mtd_kernel.pad.bin
rm -f $CURDIR/mtd_root.pad.bin
rm -f $CURDIR/mtd_var.sum.pad.bin

md5sum -b $OUTFILE | awk -F' ' '{print $1}' > $OUTFILE.md5
zip -j $OUTFILE.zip $OUTFILE $OUTFILE.md5
