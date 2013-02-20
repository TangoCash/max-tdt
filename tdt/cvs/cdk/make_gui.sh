#!/bin/bash

CURDIR=`pwd`
KATIDIR=${CURDIR%/cvs/cdk}

CONFIGPARAM=" \
 --enable-maintainer-mode \
 --prefix=$KATIDIR/tufsbox \
 --with-cvsdir=$KATIDIR/cvs \
 --with-customizationsdir=$KATIDIR/custom \
 --with-flashscriptdir=$KATIDIR/flash \
 --with-archivedir=$HOME/Archive \
 --enable-ccache"

##############################################

# config.guess generates different answers for some packages
# Ensure that all packages use the same host by explicitly specifying it.

# First obtain the triplet
AM_VER=`automake --version | awk '{print $NF}' | grep -oEm1 "^[0-9]+.[0-9]+"`
host_alias=`/usr/share/automake-${AM_VER}/config.guess`

# Then undo Suse specific modifications, no harm to other distribution
case `echo ${host_alias} | cut -d '-' -f 1` in
	i?86) VENDOR=pc ;;
	*   ) VENDOR=unknown ;;
esac
host_alias=`echo ${host_alias} | sed -e "s/suse/${VENDOR}/"`

# And add it to the config parameters.
CONFIGPARAM="${CONFIGPARAM} --host=${host_alias} --build=${host_alias}"

##############################################

DIALOG=${DIALOG:-`which dialog`}
tempfile=/tmp/test$$
height=30
width=65
listheight=25

if [ -z "${DIALOG}" ]; then
	echo "Please install dialog package." 1>&2
	exit 1
fi

##############################################
${DIALOG} --msgbox \
"\n\
  _______                     _____              _     _         _\n\
 |__   __|                   |  __ \            | |   | |       | |\n\
    | | ___  __ _ _ __ ___   | |  | |_   _  ____| | __| |_  __ _| | ___ ___\n\
    | |/ _ \/ _\` | '_ \` _ \  | |  | | | | |/  __| |/ /| __|/ _\` | |/ _ | __|\n\
    | |  __/ (_| | | | | | | | |__| | |_| |  (__|   < | |_| (_| | |  __|__ \\\n\
    |_|\___|\__,_|_| |_| |_| |_____/ \__,_|\____|_|\_\ \__|\__,_|_|\___|___/\n\
\n\
                     Press OK to configure yout environment\n" 0 0
clear
##############################################
${DIALOG} --menu "\n Select Target:\n " $height $width $listheight \
1	"Kathrein UFS-910" \
3	"Kathrein UFS-912" \
4	"Kathrein UFS-922" \
5	"Topfield 7700 HDPVR" \
6	"Fortis based (HDBOX)" \
7	"SpiderBox HL-101" \
8	"Edision Argus vip" \
9	"Cuberevo (IPBOX 9000)" \
10	"Cuberevo mini (IPBOX 900)" \
11	"Cuberevo mini2 (IPBOX 910)" \
12	"Cuberevo 250 (IPBOX 91)" \
13	"Cuberevo 9500HD (7000HD)" \
14	"Cuberevo 2000HD" \
15	"Cuberevo mini_fta (200HD)" \
16	"Homecast 5101" \
17	"Octagon 1008" \
18	"SPARK" \
19	"Atevio7500" \
20	"SPARK7162" \
21	"IPBOX9900" \
22	"IPBOX99" \
23	"IPBOX55" \
24	"Fortis HS7810A" \
25	"B4Team ADB 5800S" \
26	"Fortis HS7110" \
27	"WHITEBOX" \
28	"Kathrein UFS-913" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then clear; rm $tempfile; exit; fi

REPLY=`cat $tempfile`

case "$REPLY" in
	 1) TARGET="--enable-ufs910";BOXTYPE="--with-boxtype=ufs910";;
	 3) TARGET="--enable-ufs912";BOXTYPE="--with-boxtype=ufs912";;
	 4) TARGET="--enable-ufs922";BOXTYPE="--with-boxtype=ufs922";;
	 5) TARGET="--enable-tf7700";BOXTYPE="--with-boxtype=tf7700";;
	 6) TARGET="--enable-fortis_hdbox";BOXTYPE="--with-boxtype=fortis_hdbox";;
	 7) TARGET="--enable-hl101";BOXTYPE="--with-boxtype=hl101";;
	 8) TARGET="--enable-vip";BOXTYPE="--with-boxtype=vip";;
	 9) TARGET="--enable-cuberevo";BOXTYPE="--with-boxtype=cuberevo";;
	10) TARGET="--enable-cuberevo_mini";BOXTYPE="--with-boxtype=cuberevo_mini";;
	11) TARGET="--enable-cuberevo_mini2";BOXTYPE="--with-boxtype=cuberevo_mini2";;
	12) TARGET="--enable-cuberevo_250hd";BOXTYPE="--with-boxtype=cuberevo_250hd";;
	13) TARGET="--enable-cuberevo_9500hd";BOXTYPE="--with-boxtype=cuberevo_9500hd";;
	14) TARGET="--enable-cuberevo_2000hd";BOXTYPE="--with-boxtype=cuberevo_2000hd";;
	15) TARGET="--enable-cuberevo_mini_fta";BOXTYPE="--with-boxtype=cuberevo_mini_fta";;
	16) TARGET="--enable-homecast5101";BOXTYPE="--with-boxtype=homecast5101";;
	17) TARGET="--enable-octagon1008";BOXTYPE="--with-boxtype=octagon1008";;
	18) TARGET="--enable-spark";BOXTYPE="--with-boxtype=spark";;
	19) TARGET="--enable-atevio7500";BOXTYPE="--with-boxtype=atevio7500";;
	20) TARGET="--enable-spark7162";BOXTYPE="--with-boxtype=spark7162";;
	21) TARGET="--enable-ipbox9900";BOXTYPE="--with-boxtype=ipbox9900";;
	22) TARGET="--enable-ipbox99";BOXTYPE="--with-boxtype=ipbox99";;
	23) TARGET="--enable-ipbox55";BOXTYPE="--with-boxtype=ipbox55";;
	24) TARGET="--enable-hs7810a";BOXTYPE="--with-boxtype=hs7810a";;
	25) TARGET="--enable-adb_box";BOXTYPE="--with-boxtype=adb_box";;
	26) TARGET="--enable-hs7110";BOXTYPE="--with-boxtype=hs7110";;
	27) TARGET="--enable-whitebox";BOXTYPE="--with-boxtype=whitebox";;
	28) TARGET="--enable-ufs913";BOXTYPE="--with-boxtype=ufs913";;
	 *) TARGET="--enable-ufs910";BOXTYPE="--with-boxtype=ufs910";;
esac
CONFIGPARAM="$CONFIGPARAM $TARGET $BOXTYPE"
clear

case "$REPLY" in
	8)	${DIALOG} --menu "\n Select Model: \n " $height $width $listheight \
		1	"VIP1 v1 [ single tuner + 2 CI + 2 USB ]" \
		2	"VIP1 v2 [ single tuner + 2 CI + 1 USB + plug & play tuner (dvb-s2/t/c) ]" \
		3	"VIP2 v1 [ twin tuner ]" \
		2> ${tempfile}

		opt=${?}
		if [ $opt != 0 ]; then clear; rm $tempfile; exit; fi

		REPLY=`cat $tempfile`

		case "$REPLY" in
			1) MODEL="--enable-hl101";;
			2) MODEL="--enable-vip1_v2";;
			3) MODEL="--enable-vip2_v1";;
			*) MODEL="--enable-vip2_v1";;
		esac
		CONFIGPARAM="$CONFIGPARAM $MODEL"
		clear
		;;
	*)
esac

##############################################

${DIALOG} --menu "\n Select Kernel: \n " $height $width $listheight \
1	"STM 24 P0207" \
2	"STM 24 P0209" \
3	"STM 24 P0210" \
4	"STM 24 P0211" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then clear; rm $tempfile; exit; fi

REPLY=`cat $tempfile`

case "$REPLY" in
	1)  KERNEL="--enable-stm24 --enable-p0207";STMFB="stm24";;
	2)  KERNEL="--enable-stm24 --enable-p0209";STMFB="stm24";;
	3)  KERNEL="--enable-stm24 --enable-p0210";STMFB="stm24";;
	4)  KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";;
	*)  KERNEL="--enable-stm24 --enable-p0211";STMFB="stm24";;
esac
CONFIGPARAM="$CONFIGPARAM $KERNEL"
clear

##############################################

${DIALOG} --defaultno --yesno "\n Kernel Debug: \n Activate debug (y/N)? \n" 0 0
REPLY=${?}
[ "$REPLY" == "0" ] && CONFIGPARAM="$CONFIGPARAM --enable-debug"
clear

##############################################

cd ../driver/
echo "# Automatically generated config: don't edit" > .config
echo "#" >> .config
echo "export CONFIG_ZD1211REV_B=y" >> .config
echo "export CONFIG_ZD1211=n" >> .config
cd - &>/dev/null

##############################################

${DIALOG} --menu "\n Select Player: \n " $height $width $listheight \
1	"Player 191 (stmfb-3.1_stm24_0102)" \
2	"Player 191 (stmfb-3.1_stm24_0104)" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then clear; rm $tempfile; exit; fi

REPLY=`cat $tempfile`

case "$REPLY" in
	1) PLAYER="--enable-player191"
		cd ../driver/include/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s player2_191 player2
		ln -s stmfb-3.1_stm24_0102 stmfb
		cd - &>/dev/null

		cd ../driver/
		if [ -L player2 ]; then
			rm player2
		fi
		ln -s player2_191 player2
		echo "export CONFIG_PLAYER_191=y" >> .config
		cd - &>/dev/null

		cd ../driver/stgfb
		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s stmfb-3.1_stm24_0102 stmfb
		cd - &>/dev/null
		MULTICOM="--enable-multicom324"
		cd ../driver/include/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s ../multicom-3.2.4/include multicom
		cd - &>/dev/null

		cd ../driver/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s multicom-3.2.4 multicom
		echo "export CONFIG_MULTICOM324=y" >> .config
		cd - &>/dev/null
	;;
	2) PLAYER="--enable-player191"
		cd ../driver/include/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s player2_191 player2
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null

		cd ../driver/
		if [ -L player2 ]; then
			rm player2
		fi
		ln -s player2_191 player2
		echo "export CONFIG_PLAYER_191=y" >> .config
		cd - &>/dev/null

		cd ../driver/stgfb
		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null
		MULTICOM="--enable-multicom324"
		cd ../driver/include/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s ../multicom-3.2.4/include multicom
		cd - &>/dev/null

		cd ../driver/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s multicom-3.2.4 multicom
		echo "export CONFIG_MULTICOM324=y" >> .config
		cd - &>/dev/null
	;;
	*) PLAYER="--enable-player191"
		cd ../driver/include/
		if [ -L player2 ]; then
			rm player2
		fi

		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s player2_191 player2
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null

		cd ../driver/
		if [ -L player2 ]; then
			rm player2
		fi
		ln -s player2_191 player2
		echo "export CONFIG_PLAYER_191=y" >> .config
		cd - &>/dev/null

		cd ../driver/stgfb
		if [ -L stmfb ]; then
			rm stmfb
		fi
		ln -s stmfb-3.1_stm24_0104 stmfb
		cd - &>/dev/null
		MULTICOM="--enable-multicom324"
		cd ../driver/include/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s ../multicom-3.2.4/include multicom
		cd - &>/dev/null

		cd ../driver/
		if [ -L multicom ]; then
			rm multicom
		fi

		ln -s multicom-3.2.4 multicom
		echo "export CONFIG_MULTICOM324=y" >> .config
		cd - &>/dev/null
	;;
esac
clear
##############################################

${DIALOG} --menu "\n Select Media Framework: \n " $height $width $listheight \
1	"eplayer3" \
2	"gstreamer" \
3	"use build-in" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then clear; rm $tempfile; exit; fi

REPLY=`cat $tempfile`

case "$REPLY" in
	1) MEDIAFW="--enable-eplayer3";;
	2) MEDIAFW="--enable-mediafwgstreamer";;
	3) MEDIAFW="--enable-buildinplayer";;
	*) MEDIAFW="--enable-eplayer3";;
esac
clear

##############################################

${DIALOG} --defaultno --yesno "\n External LCD support: \n Activate (y/N)? \n" 0 0
REPLY=${?}
[ "$REPLY" == "0" ] && EXTERNAL_LCD="--enable-externallcd"
clear

##############################################

${DIALOG} --menu "\n Select Graphic Framework: \n " $height $width $listheight \
1	"Framebuffer" \
2	"DirectFB (Recommended XBMC)" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then clear; rm $tempfile; exit; fi

REPLY=`cat $tempfile`

case "$REPLY" in
	1) GFW="";;
	2) GFW="--enable-graphicfwdirectfb";;
	*) GFW="";;
esac
clear

##############################################

# Check this option if you want to use the version of GCC.
#CONFIGPARAM="$CONFIGPARAM --enable-gcc47"

##############################################

CONFIGPARAM="$CONFIGPARAM $PLAYER $MULTICOM $MEDIAFW $EXTERNAL_LCD $GFW"

#${DIALOG} --msgbox "$CONFIGPARAM" 0 0

##############################################

#./autogen.sh
#./configure $CONFIGPARAM

##############################################

echo $CONFIGPARAM >lastChoice
rm $tempfile

##############################################
clear
${DIALOG} --msgbox \
"\n\
********************************************************************************************\n\
*                                                                                          *\n\
*  SSSSSSSS\\                                       SSSSSS\\                      SS\\        *\n\
*  \\__SS  __|                                     SS  __SS\\                     SS |       *\n\
*     SS | SSSSSS\\  SSSSSSS\\   SSSSSS\\   SSSSSS\\  SS /  \\__| SSSSSS\\   SSSSSSS\\ SSSSSSS\\   *\n\
*     SS | \\____SS\\ SS  __SS\\ SS  __SS\\ SS  __SS\\ SS |       \\____SS\\ SS  _____|SS  __SS\\  *\n\
*     SS | SSSSSSS |SS |  SS |SS /  SS |SS /  SS |SS |       SSSSSSS |\\SSSSSS\\  SS |  SS | *\n\
*     SS |SS  __SS |SS |  SS |SS |  SS |SS |  SS |SS |  SS\\ SS  __SS | \\____SS\\ SS |  SS | *\n\
*     SS |\\SSSSSSS |SS |  SS |\\SSSSSSS |\\SSSSSS  |\\SSSSSS  |\\SSSSSSS |SSSSSSS  |SS |  SS | *\n\
*     \\__| \\_______|\\__|  \\__| \\____SS | \\______/  \\______/  \\_______|\\_______/ \\__|  \\__| *\n\
*                             SS\\   SS |                                                   *\n\
*                             \\SSSSSS  |                                                   *\n\
*                              \\______/                                                    *\n\
*                                                                                          *\n\
********************************************************************************************\n\
\n\
\n\
                            ----------------------------------------\n\
                            Your build environment is ready :-)\n\
                            Your next step could be:\n\
                            ----------------------------------------\n\
                            make yaud-neutrino\n\
                            make yaud-neutrino-mp\n\
                            make yaud-neutrino-mp-exp\n\
                            make yaud-neutrino-hd2-exp\n\
                            make yaud-enigma2-pli-nightly\n\
                            make yaud-xbmc-nightly\n\
                            ----------------------------------------\n" 0 0
##############################################
clear

