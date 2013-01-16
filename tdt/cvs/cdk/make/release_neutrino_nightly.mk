#
# auxiliary targets for model-specific builds
#

#
# release_common_utils
#
release_neutrino_common_utils:
#	remove the slink to busybox
	rm -f $(prefix)/release_neutrino/sbin/halt
	cp -f $(targetprefix)/sbin/halt $(prefix)/release_neutrino/sbin/
	cp $(buildprefix)/root/release/umountfs $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/rc $(prefix)/release_neutrino/etc/init.d/
	cp $(buildprefix)/root/release/sendsigs $(prefix)/release_neutrino/etc/init.d/
	chmod 755 $(prefix)/release_neutrino/etc/init.d/umountfs
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rc
	chmod 755 $(prefix)/release_neutrino/etc/init.d/sendsigs
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc0.d
	ln -s ../init.d $(prefix)/release_neutrino/etc/rc.d
	ln -fs halt $(prefix)/release_neutrino/sbin/reboot
	ln -fs halt $(prefix)/release_neutrino/sbin/poweroff
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(prefix)/release_neutrino/etc/rc.d/rc0.d/S90halt
	mkdir -p $(prefix)/release_neutrino/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(prefix)/release_neutrino/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(prefix)/release_neutrino/etc/rc.d/rc6.d/S90reboot

#
# release_cube_common
#
release_neutrino_cube_common:
	cp $(buildprefix)/root/release/halt_cuberevo $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(buildprefix)/root/release/reboot_cuberevo $(prefix)/release_neutrino/etc/init.d/reboot
	chmod 777 $(prefix)/release_neutrino/etc/init.d/reboot
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/bin/eeprom $(prefix)/release_neutrino/bin
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox/micom.ko $(prefix)/release_neutrino/lib/modules/
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx21143}.fw
	rm -f $(prefix)/release_neutrino/bin/tffpctl
	rm -f $(prefix)/release_neutrino/bin/vfdctl
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/tfd2mtd

#
# release_cube_common_tunner
#
release_neutrino_cube_common_tunner:
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(prefix)/release_neutrino/lib/modules/

#
# release_cuberevo_9500hd
#
release_neutrino_cuberevo_9500hd: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo-9500hd" > $(prefix)/release_neutrino/etc/hostname

#
# release_cuberevo_2000hd
#
release_neutrino_cuberevo_2000hd: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo-2000hd" > $(prefix)/release_neutrino/etc/hostname

#
# release_cuberevo_250hd
#
release_neutrino_cuberevo_250hd: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo-250hd" > $(prefix)/release_neutrino/etc/hostname

#
# release_cuberevo_mini_fta
#
release_neutrino_cuberevo_mini_fta: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo-mini-fta" > $(prefix)/release_neutrino/etc/hostname

#
# release_cuberevo_mini2
#
release_neutrino_cuberevo_mini2: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo-mini2" > $(prefix)/release_neutrino/etc/hostname

#
# release_cuberevo_mini
#
release_neutrino_cuberevo_mini: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo-mini" > $(prefix)/release_neutrino/etc/hostname

#
# release_cuberevo
#
release_neutrino_cuberevo: release_neutrino_common_utils release_neutrino_cube_common release_neutrino_cube_common_tunner
	echo "cuberevo" > $(prefix)/release_neutrino/etc/hostname

#
# release_common_ipbox
#
release_neutrino_common_ipbox:
	cp $(buildprefix)/root/release/halt_ipbox $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/siinfo/siinfo.ko $(prefix)/release_neutrino/lib/modules/
	cp -f $(buildprefix)/root/release/fstab_ipbox $(prefix)/release_neutrino/etc/fstab
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	cp -dp $(buildprefix)/root/etc/lircd_ipbox.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -p $(buildprefix)/root/release/lircd_ipbox $(prefix)/release_neutrino/usr/bin/lircd
	rm -f $(prefix)/release_neutrino/lib/firmware/*
	rm -f $(prefix)/release_neutrino/lib/modules/boxtype.ko
	rm -f $(prefix)/release_neutrino/lib/modules/bpamem.ko
	rm -f $(prefix)/release_neutrino/lib/modules/ramzswap.ko
	rm -f $(prefix)/release_neutrino/lib/modules/simu_button.ko
	rm -f $(prefix)/release_neutrino/lib/modules/stmvbi.ko
	rm -f $(prefix)/release_neutrino/lib/modules/stmvout.ko
	rm -f $(prefix)/release_neutrino/bin/gotosleep
	rm -f $(prefix)/release_neutrino/etc/network/interfaces
	echo "config.usage.hdd_standby=0" >> $(prefix)/release_neutrino/etc/enigma2/settings

#
# release_ipbox9900
#
release_neutrino_ipbox9900: release_neutrino_common_utils release_neutrino_common_ipbox
	echo "ipbox9900" > $(prefix)/release_neutrino/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/rmu/rmu.ko $(prefix)/release_neutrino/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release_neutrino/usr/bin/tvmode

#
# release_ipbox99
#
release_neutrino_ipbox99: release_neutrino_common_utils release_neutrino_common_ipbox
	echo "ipbox99" > $(prefix)/release_neutrino/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox $(prefix)/release_neutrino/usr/bin/tvmode

#
# release_ipbox55
#
release_neutrino_ipbox55: release_neutrino_common_utils release_neutrino_common_ipbox
	echo "ipbox55" > $(prefix)/release_neutrino/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/ipbox55/front.ko $(prefix)/release_neutrino/lib/modules/
	cp -p $(buildprefix)/root/release/tvmode_ipbox55 $(prefix)/release_neutrino/usr/bin/tvmode

#
# release_ufs910
#
release_neutrino_ufs910: release_neutrino_common_utils
	echo "ufs910" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd/vfd.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_neutrino/boot/video.elf
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,stv6306}.fw
	mv $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx21143.fw $(prefix)/release_neutrino/lib/firmware/dvb-fe-cx24116.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_neutrino/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	rm -f $(prefix)/release_neutrino/bin/vdstandby

#
# release_ufs912
#
release_neutrino_ufs912: release_neutrino_common_utils
	echo "ufs912" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_ufs913
#
release_neutrino_ufs913: release_neutrino_common_utils
	echo "ufs913" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs912 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_ufs922
#
release_neutrino_ufs922: release_neutrino_common_utils
	echo "ufs922" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_ufs $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/micom/micom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/ufs922_fan/fan_ctrl.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_spark
#
release_neutrino_spark: release_neutrino_common_utils
	echo "spark" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_spark $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	[ -e $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko ] && cp $(buildprefix)/root/release/encrypt_spark$(KERNELSTMLABEL).ko $(prefix)/release_neutrino/lib/modules/encrypt.ko || true
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
	rm -f $(prefix)/release_neutrino/bin/vdstandby
	cp -dp $(buildprefix)/root/etc/lircd_spark.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release_neutrino/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release_neutrino/sbin

#
# release_spark7162
#
release_neutrino_spark7162: release_neutrino_common_utils
	echo "spark7162" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_spark7162 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp -f $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/i2c_spi/i2s.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep
	rm -f $(prefix)/release_neutrino/bin/vdstandby
	cp -dp $(buildprefix)/root/etc/lircd_spark7162.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	cp -f $(buildprefix)/root/sbin/flashcp $(prefix)/release_neutrino/sbin
	cp -f $(buildprefix)/root/sbin/flash_* $(prefix)/release_neutrino/sbin
	cp -f $(buildprefix)/root/sbin/nand* $(prefix)/release_neutrino/sbin

#
# release_fortis_hdbox
#
release_neutrino_fortis_hdbox: release_neutrino_common_utils
	echo "fortis" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	rm -f $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote

#
# release_atevio7500
#
release_neutrino_atevio7500: release_neutrino_common_utils
	echo "atevio7500" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_fortis_hdbox $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/multituner/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7105.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7105.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_neutrino/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_neutrino/lib/firmware/
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/lib/modules/boxtype.ko
	rm -f $(prefix)/release_neutrino/lib/modules/mpeg2hw.ko

#
# release_octagon1008
#
release_neutrino_octagon1008: release_neutrino_common_utils
	echo "octagon1008" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_octagon1008 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_neutrino/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_neutrino/lib/firmware/
	rm -f $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote

#
# release_hs7810a
#
release_neutrino_hs7810a: release_neutrino_common_utils
	echo "hs7810a" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_hs7810a $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_hs7110
#
release_neutrino_hs7110: release_neutrino_common_utils
	echo "hs7110" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_hs7110 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_whitebox
#
release_neutrino_whitebox: release_neutrino_common_utils
	echo "whitebox" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_whitebox $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/lnb/lnb.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7111.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/boot/audio_7111.elf $(prefix)/release_neutrino/boot/audio.elf
	mv $(prefix)/release_neutrino/lib/firmware/component_7111_mb618.fw $(prefix)/release_neutrino/lib/firmware/component.fw
	rm $(prefix)/release_neutrino/lib/firmware/component_7105_pdk7105.fw
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_hl101
#
release_neutrino_hl101: release_neutrino_common_utils
	echo "hl101" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_hl101 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/proton/proton.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(targetprefix)/lib/firmware/dvb-fe-avl2108.fw $(prefix)/release_neutrino/lib/firmware/
	cp $(targetprefix)/lib/firmware/dvb-fe-stv6306.fw $(prefix)/release_neutrino/lib/firmware/
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	cp -dp $(buildprefix)/root/etc/lircd_hl101.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_adb_box
#
release_neutrino_adb_box: release_neutrino_common_utils
	echo "Adb_Box" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_adb_box $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/adb_box_fan/cooler.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec_adb_box/cec_ctrl.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/dvbt/as102/dvb-as102.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_neutrino/boot/video.elf
	cp $(buildprefix)/root/firmware/as102_data1_st.hex $(prefix)/release_neutrino/lib/firmware/
	cp $(buildprefix)/root/firmware/as102_data2_st.hex $(prefix)/release_neutrino/lib/firmware/
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl6222,cx24116,cx21143}.fw
	cp -f $(buildprefix)/root/release/fstab_adb_box $(prefix)/release_neutrino/etc/fstab
	cp -dp $(buildprefix)/root/etc/lircd_adb_box.conf $(prefix)/release_neutrino/etc/lircd.conf
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/lircd
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_vip1_v2
#
release_neutrino_vip1_v2: release_neutrino_common_utils
	echo "Edision-v2" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_vip2 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/aotom/aotom.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx24116,cx21143,stv6306}.fw
	cp -f $(buildprefix)/root/release/fstab_vip2 $(prefix)/release_neutrino/etc/fstab
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_neutrino/sbin/
	cp $(targetprefix)/bin/stslave $(prefix)/release_neutrino/bin
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_neutrino/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	rm -f $(prefix)/release_neutrino/bin/evremote
	rm -f $(prefix)/release_neutrino/bin/gotosleep

#
# release_vip2_v1
#
release_neutrino_vip2_v1: release_neutrino_vip1_v2
	echo "Edision-v1" > $(prefix)/release_neutrino/etc/hostname

#
# release_hs5101
#
release_neutrino_hs5101: release_neutrino_common_utils
	echo "hs5101" > $(prefix)/release_neutrino/etc/hostname
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button_hs5101/button.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/vfd_hs5101/vfd.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7100.elf $(prefix)/release_neutrino/boot/video.elf
	cp -dp $(targetprefix)/etc/lircd.conf $(prefix)/release_neutrino/etc/
	cp -p $(targetprefix)/usr/bin/lircd $(prefix)/release_neutrino/usr/bin/
	rm -f $(prefix)/release_neutrino/lib/firmware/dvb-fe-{avl2108,avl6222,cx21143,stv6306}.fw
	rm -f $(prefix)/release_neutrino/bin/vdstandby

#
# release_tf7700
#
release_neutrino_tf7700: release_neutrino_common_utils
	echo "tf7700" > $(prefix)/release_neutrino/etc/hostname
	cp $(buildprefix)/root/release/halt_tf7700 $(prefix)/release_neutrino/etc/init.d/halt
	chmod 755 $(prefix)/release_neutrino/etc/init.d/halt
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontcontroller/tffp/tffp.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/frontends/*.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/boot/video_7109.elf $(prefix)/release_neutrino/boot/video.elf
	cp -f $(buildprefix)/root/release/fstab_tf7700 $(prefix)/release_neutrino/etc/fstab
	cp -f $(targetprefix)/sbin/shutdown $(prefix)/release_neutrino/sbin/
	rm -f $(prefix)/release_neutrino/bin/gotosleep


#
# release_base
#
# the following target creates the common file base
release_neutrino_base:
	rm -rf $(prefix)/release_neutrino || true
	$(INSTALL_DIR) $(prefix)/release_neutrino && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/{bin,boot,dev,dev.static,etc,hdd,lib,media,mnt,proc,ram,root,sbin,swap,sys,tmp,usr,var} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/{fonts,init.d,network} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/etc/network/{if-down.d,if-post-down.d,if-pre-up.d,if-up.d} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/lib/modules && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/hdd/{movie,music,picture} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/media/{dvd,nfs,usb} && \
	ln -sf /hdd $(prefix)/release_neutrino/media/hdd && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/mnt/{hdd,nfs,usb} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/{bin,lib,share} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/{fonts,tuxbox,udhcpc,zoneinfo} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/tuxbox/neutrino && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/logo && \
	ln -sf /usr/share $(prefix)/release_neutrino/share && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var/{bin,boot,etc,httpd,lib,plugins,tuxbox,update} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var/tuxbox/config && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var/tuxbox/config/{locale,zapit} && \
	$(INSTALL_DIR) $(prefix)/release_neutrino/var/httpd/logos && \
	export CROSS_COMPILE=$(target)- && \
		$(MAKE) install -C @DIR_busybox@ CONFIG_PREFIX=$(prefix)/release_neutrino && \
	touch $(prefix)/release_neutrino/var/etc/.firstboot && \
	cp -a $(targetprefix)/bin/* $(prefix)/release_neutrino/bin/ && \
	ln -sf /bin/showiframe $(prefix)/release_neutrino/usr/bin/showiframe && \
	cp -dp $(targetprefix)/usr/bin/sdparm $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/init $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/killall5 $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/portmap $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/mke2fs $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext2 && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext3 && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext4 && \
	ln -sf /sbin/mke2fs $(prefix)/release_neutrino/sbin/mkfs.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/e2fsck $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext2 && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext3 && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext4 && \
	ln -sf /sbin/e2fsck $(prefix)/release_neutrino/sbin/fsck.ext4dev && \
	cp -dp $(targetprefix)/sbin/fsck.nfs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/sfdisk $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/tune2fs $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/etc/init.d/portmap $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(buildprefix)/root/etc/init.d/udhcpc $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/sbin/MAKEDEV $(prefix)/release_neutrino/sbin/MAKEDEV && \
	cp -f $(buildprefix)/root/release/makedev $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(targetprefix)/boot/uImage $(prefix)/release_neutrino/boot/ && \
	cp $(targetprefix)/boot/audio.elf $(prefix)/release_neutrino/boot/audio.elf && \
	cp -a $(targetprefix)/dev/* $(prefix)/release_neutrino/dev/ && \
	cp -dp $(targetprefix)/etc/fstab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/group $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/host.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/hostname $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/hosts $(prefix)/release_neutrino/etc/ && \
	cp $(buildprefix)/root/etc/inetd.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/inittab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/localtime $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/mtab $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/passwd $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/profile $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/protocols $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/resolv.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/services $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/shells $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/shells.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/vsftpd.conf $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/var/etc/.version $(prefix)/release_neutrino/ && \
	ln -sf /.version $(prefix)/release_neutrino/var/etc/.version && \
	cp -dp $(targetprefix)/etc/timezone.xml $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/vdstandby.cfg $(prefix)/release_neutrino/etc/ && \
	cp -dp $(targetprefix)/etc/network/interfaces $(prefix)/release_neutrino/etc/network/ && \
	cp -dp $(targetprefix)/etc/network/options $(prefix)/release_neutrino/etc/network/ && \
	cp -dp $(targetprefix)/etc/init.d/umountfs $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/etc/init.d/sendsigs $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/reboot $(prefix)/release_neutrino/etc/init.d/ && \
	cp -aR $(buildprefix)/root/usr/share/udhcpc/* $(prefix)/release_neutrino/usr/share/udhcpc/ && \
	cp -aR $(buildprefix)/root/usr/share/zoneinfo/* $(prefix)/release_neutrino/usr/share/zoneinfo/ && \
	echo "576i50" > $(prefix)/release_neutrino/etc/videomode && \
	cp $(buildprefix)/root/release/rcS_stm23_neutrino$(if $(TF7700),_$(TF7700))$(if $(OCTAGON1008),_$(OCTAGON1008))$(if $(FORTIS_HDBOX),_$(FORTIS_HDBOX))$(if $(ATEVIO7500),_$(ATEVIO7500))$(if $(HS7810A),_$(HS7810A))$(if $(HS7110),_$(HS7110))$(if $(WHITEBOX),_$(WHITEBOX))$(if $(HL101),_$(HL101))$(if $(VIP1_V2),_$(VIP1_V2))$(if $(VIP2_V1),_$(VIP2_V1))$(if $(ADB_BOX),_$(ADB_BOX))$(if $(UFS910),_$(UFS910))$(if $(UFS912),_$(UFS912))$(if $(UFS913),_$(UFS913))$(if $(UFS922),_$(UFS922))$(if $(CUBEREVO),_$(CUBEREVO))$(if $(CUBEREVO_MINI),_$(CUBEREVO_MINI))$(if $(CUBEREVO_MINI2),_$(CUBEREVO_MINI2))$(if $(CUBEREVO_MINI_FTA),_$(CUBEREVO_MINI_FTA))$(if $(CUBEREVO_250HD),_$(CUBEREVO_250HD))$(if $(CUBEREVO_2000HD),_$(CUBEREVO_2000HD))$(if $(CUBEREVO_9500HD),_$(CUBEREVO_9500HD))$(if $(SPARK),_$(SPARK))$(if $(SPARK7162),_$(SPARK7162)) $(prefix)/release_neutrino/etc/init.d/rcS
	chmod 755 $(prefix)/release_neutrino/etc/init.d/rcS && \
	cp $(buildprefix)/root/release/mountvirtfs $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/mme_check $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/mountall $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/hostname $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/vsftpd $(prefix)/release_neutrino/etc/init.d/ && \
	cp -dp $(targetprefix)/usr/sbin/vsftpd $(prefix)/release_neutrino/usr/bin/ && \
	cp $(buildprefix)/root/release/bootclean.sh $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/network $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/release/networking $(prefix)/release_neutrino/etc/init.d/ && \
	cp $(buildprefix)/root/bootscreen/bootlogo.mvi $(prefix)/release_neutrino/var/boot/ && \
	cp $(buildprefix)/root/bin/autologin $(prefix)/release_neutrino/bin/ && \
	cp -p $(targetprefix)/usr/bin/killall $(prefix)/release_neutrino/usr/bin/ && \
	cp -dp $(targetprefix)/bin/hotplug $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/blkid $(prefix)/release_neutrino/sbin/ && \
	cp $(buildprefix)/root/release/getfb.awk $(prefix)/release_neutrino/etc/init.d/ && \
	cp -p $(targetprefix)/usr/bin/ffmpeg $(prefix)/release_neutrino/sbin/ && \
	cp -dp $(targetprefix)/sbin/mkfs $(prefix)/release_neutrino/sbin/

if !ENABLE_UFS910
	cp -dp $(targetprefix)/sbin/jfs_fsck $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/jfs_fsck $(prefix)/release_neutrino/sbin/fsck.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_mkfs $(prefix)/release_neutrino/sbin/ && \
	ln -sf /sbin/jfs_mkfs $(prefix)/release_neutrino/sbin/mkfs.jfs && \
	cp -dp $(targetprefix)/sbin/jfs_tune $(prefix)/release_neutrino/sbin/
endif

#
# Player
#
if ENABLE_PLAYER191
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvbi.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmvout.ko $(prefix)/release_neutrino/lib/modules/
	cd $(targetprefix)/lib/modules/$(KERNELVERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(prefix)/release_neutrino/lib/modules/; \
			sh4-linux-strip --strip-unneeded $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		else \
			touch $(prefix)/release_neutrino/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";
endif

#
# modules
#
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/avs/avs.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/bpamem/bpamem.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/boxtype/boxtype.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/compcache/ramzswap.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/e2_proc/e2_proc.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshell/embxshell.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/embxshm/embxshm.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/multicom/mme/mme_host.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/simu_button/simu_button.ko $(prefix)/release_neutrino/lib/modules/
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/stgfb/stmfb/stmfb.ko $(prefix)/release_neutrino/lib/modules/
if !ENABLE_VIP2_V1
if !ENABLE_SPARK
if !ENABLE_SPARK7162
	cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cic/*.ko $(prefix)/release_neutrino/lib/modules/
endif
endif
endif
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/button/button.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cec/cec.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/cpu_frequ/cpu_frequ.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/led/led.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti/pti.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/pti_np/pti.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/smartcard/smartcard.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko ] && cp $(kernelprefix)/linux-sh4/fs/autofs4/autofs4.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/net/tun.ko ] && cp $(kernelprefix)/linux-sh4/drivers/net/tun.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/ftdi_sio.ko $(prefix)/release_neutrino/lib/modules/ftdi.ko || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/pl2303.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko ] && cp $(kernelprefix)/linux-sh4/drivers/usb/serial/usbserial.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko ] && cp $(kernelprefix)/linux-sh4/fs/fuse/fuse.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/ntfs/ntfs.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko ] && cp $(kernelprefix)/linux-sh4/fs/cifs/cifs.ko $(prefix)/release_neutrino/lib/modules || true
if !ENABLE_UFS910
	[ -e $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/jfs/jfs.ko $(prefix)/release_neutrino/lib/modules || true
endif
	[ -e $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfsd/nfsd.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/exportfs/exportfs.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs_common/nfs_acl.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko ] && cp $(kernelprefix)/linux-sh4/fs/nfs/nfs.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl871x/8712u.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/extra/wireless/rtl8192cu/8192cu.ko $(prefix)/release_neutrino/lib/modules || true
	[ -e $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/mini_fo/mini_fo.ko ] && cp $(targetprefix)/lib/modules/$(KERNELVERSION)/kernel/fs/mini_fo/mini_fo.ko $(prefix)/release_neutrino/lib/modules || true

#
# lib usr/lib
#
	cp -R $(targetprefix)/lib/* $(prefix)/release_neutrino/lib/
	rm -f $(prefix)/release_neutrino/lib/*.{a,o,la}
	chmod 755 $(prefix)/release_neutrino/lib/*

	cp -R $(targetprefix)/usr/lib/* $(prefix)/release_neutrino/usr/lib/
	rm -rf $(prefix)/release_neutrino/usr/lib/{engines,enigma2,gconv,ldscripts,libxslt-plugins,pkgconfig,python$(PYTHON_VERSION),sigc++-1.2,X11}
	rm -f $(prefix)/release_neutrino/usr/lib/*.{a,o,la}
	chmod 755 $(prefix)/release_neutrino/usr/lib/*

#
# fw_printenv / fw_setenv
#
	if [ -e $(targetprefix)/usr/sbin/fw_printenv ]; then \
		cp -dp $(targetprefix)/usr/sbin/fw_* $(prefix)/release_neutrino/usr/sbin/; \
	fi

#
# fonts
#
	cp -aR $(targetprefix)/usr/share/fonts $(prefix)/release_neutrino/usr/share/

#
# neutrino
#
	mkdir -p $(prefix)/release_neutrino/usr/local/bin
	cp $(targetprefix)/usr/local/bin/neutrino $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/pzapit $(prefix)/release_neutrino/usr/local/bin/
	cp $(targetprefix)/usr/local/bin/sectionsdcontrol $(prefix)/release_neutrino/usr/local/bin/
	mkdir -p $(prefix)/release_neutrino/usr/local/sbin
	cp $(targetprefix)/usr/local/sbin/udpstreampes $(prefix)/release_neutrino/usr/local/sbin/

#
# channellist / tuxtxt
#
	cp -aR $(targetprefix)/var/tuxbox/config/* $(prefix)/release_neutrino/var/tuxbox/config
	cp -aR $(buildprefix)/root/usr/local/share/config/zapit $(prefix)/release_neutrino/var/tuxbox/config
	cp $(buildprefix)/root/etc/tuxbox/tuxtxt2.conf $(prefix)/release_neutrino/var/tuxbox/config/tuxtxt

#
# iso-codes
#
	cp -aR $(targetprefix)/usr/local/share/iso-codes $(prefix)/release_neutrino/usr/share/

#
# httpd/icons/locale/themes
#
	cp -aR $(targetprefix)/usr/share/tuxbox/neutrino/* $(prefix)/release_neutrino/usr/share/tuxbox/neutrino

#
#
#
	mv -f $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/scan.jpg $(prefix)/release_neutrino/var/boot/
	ln -s /var/boot/scan.jpg $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/
	mv -f $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/mp3.jpg $(prefix)/release_neutrino/var/boot/
	ln -s /var/boot/mp3.jpg $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/
	rm -f $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/mp3-?.jpg
	mv -f $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/shutdown.jpg $(prefix)/release_neutrino/var/boot/
	ln -s /var/boot/shutdown.jpg $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/
	mv -f $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/radiomode.jpg $(prefix)/release_neutrino/var/boot/
	ln -s /var/boot/radiomode.jpg $(prefix)/release_neutrino/usr/share/tuxbox/neutrino/icons/

#
# Delete unnecessary files
#
	rm -rf $(prefix)/release_neutrino/lib/autofs
	rm -rf $(prefix)/release_neutrino/lib/modules/$(KERNELVERSION)
	rm -rf $(prefix)/release_neutrino/usr/lib/alsa-lib
	rm -rf $(prefix)/release_neutrino/usr/lib/alsaplayer
	rm -f $(prefix)/release_neutrino/usr/lib/libgmp*
	rm -f $(prefix)/release_neutrino/usr/lib/libmpfr*
	rm -f $(prefix)/release_neutrino/usr/lib/libexpat*
	rm -f $(prefix)/release_neutrino/usr/lib/libfontconfig*
	rm -f $(prefix)/release_neutrino/usr/lib/libtermcap*
	rm -f $(prefix)/release_neutrino/usr/lib/libmenu*
	rm -f $(prefix)/release_neutrino/usr/lib/libpanel*
	rm -f $(prefix)/release_neutrino/usr/lib/libdvdcss*
	rm -f $(prefix)/release_neutrino/usr/lib/libdvdnav*
	rm -f $(prefix)/release_neutrino/usr/lib/libdvdread*
	rm -f $(prefix)/release_neutrino/lib/libncurses*
	rm -f $(prefix)/release_neutrino/lib/libSegFault*
	rm -f $(prefix)/release_neutrino/lib/libthread_db*
	rm -f $(prefix)/release_neutrino/usr/lib/libthread_db*
	rm -f $(prefix)/release_neutrino/lib/libanl*
	rm -f $(prefix)/release_neutrino/usr/lib/libanl*
	rm -rf $(prefix)/release_neutrino/lib/m4-nofpu/

	rm -f $(prefix)/release_neutrino/usr/lib/libcurses.so
	rm -f $(prefix)/release_neutrino/usr/lib/libncurses.so
	rm -f $(prefix)/release_neutrino/usr/lib/libopkg*
	rm -f $(prefix)/release_neutrino/lib/modules/lzo*.ko

#
# AUTOFS
#
	if [ -d $(prefix)/release_neutrino/usr/lib/autofs ]; then \
		cp -f $(targetprefix)/usr/sbin/automount $(prefix)/release_neutrino/usr/sbin/; \
		cp -f $(buildprefix)/root/release/auto.hotplug $(prefix)/release_neutrino/etc/; \
		cp -f $(buildprefix)/root/release/auto.network $(prefix)/release_neutrino/etc/; \
		cp -f $(buildprefix)/root/release/autofs $(prefix)/release_neutrino/etc/init.d/; \
	fi

#
# GRAPHLCD
#
	if [ -e $(prefix)/release_neutrino/usr/lib/libglcddrivers.so ]; then \
		cp -f $(targetprefix)/etc/graphlcd.conf $(prefix)/release_neutrino/etc/graphlcd.conf; \
		rm -f $(prefix)/release_neutrino/usr/lib/libglcdskin.so*; \
	fi

#
# Delete unnecessary plugins and files
#


#
# The main target depends on the model.
# IMPORTANT: it is assumed that only one variable is set. Otherwise the target name won't be resolved.
#
$(DEPDIR)/release_neutrino_nightly: \
$(DEPDIR)/%release_neutrino_nightly: release_neutrino_base release_neutrino_$(TF7700)$(HL101)$(VIP1_V2)$(VIP2_V1)$(UFS910)$(UFS912)$(UFS913)$(UFS922)$(SPARK)$(SPARK7162)$(OCTAGON1008)$(FORTIS_HDBOX)$(ATEVIO7500)$(HS7810A)$(HS7110)$(WHITEBOX)$(CUBEREVO)$(CUBEREVO_MINI)$(CUBEREVO_MINI2)$(CUBEREVO_MINI_FTA)$(CUBEREVO_250HD)$(CUBEREVO_2000HD)$(CUBEREVO_9500HD)$(ADB_BOX)
	touch $@

#
# FOR YOUR OWN CHANGES use these folder in cdk/own_build/neutrino-hd
#
	cp -RP $(buildprefix)/own_build/neutrino-hd/* $(prefix)/release_neutrino/
	rm -f $(prefix)/release_neutrino/for_your_own_changes

# nicht die feine Art, aber funktioniert ;)
	rm -f $(prefix)/release_neutrino/var/tuxbox/config/neutrino.conf
	cp -dpfr $(prefix)/release_neutrino/etc $(prefix)/release_neutrino/var
	rm -fr $(prefix)/release_neutrino/etc
	ln -sf /var/etc $(prefix)/release_neutrino

	ln -s /tmp $(prefix)/release_neutrino/lib/init
	ln -s /tmp $(prefix)/release_neutrino/var/lib/urandom
	ln -s /tmp $(prefix)/release_neutrino/var/lock
	ln -s /tmp $(prefix)/release_neutrino/var/log
	ln -s /tmp $(prefix)/release_neutrino/var/run
	ln -s /tmp $(prefix)/release_neutrino/var/tmp

#
# sh4-linux-strip all
#
	find $(prefix)/release_neutrino/ -name '*' -exec sh4-linux-strip --strip-unneeded {} &>/dev/null \;

#
# release-clean
#
release_neutrino_nightly-clean:
	rm -f $(DEPDIR)/release_neutrino_nightly
