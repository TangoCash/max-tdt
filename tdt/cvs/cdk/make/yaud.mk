#
# BOOTSTRAP
#
$(DEPDIR)/bootstrap: \
	$(FILESYSTEM) \
	| $(GLIBC_DEV) \
	$(CROSS_LIBGCC) \
	libz \
	$(BINUTILS) \
	$(BINUTILS_DEV) \
	$(GMP) \
	$(MPFR) \
	$(MPC) \
	$(LIBSTDC) \
	$(LIBSTDC_DEV)
	touch $@

#
# BARE-OS
#
$(DEPDIR)/bare-os: \
	bootstrap \
	$(LIBTERMCAP) \
	$(NCURSES_BASE) \
	$(NCURSES) \
	$(NCURSES_DEV) \
	$(BASE_PASSWD) \
	$(MAKEDEV) \
	$(BASE_FILES) \
	module_init_tools \
	busybox \
	\
	$(INITSCRIPTS) \
	$(NETBASE) \
	$(BC) \
	$(SYSVINIT) \
	$(SYSVINITTOOLS) \
	$(DISTRIBUTIONUTILS) \
	\
	u-boot-utils \
	diverse-tools
	touch $@

#	openrdate

#
# NET-UTILS
#
$(DEPDIR)/net-utils: \
	$(NETKIT_FTP) \
	autofs \
	portmap \
	$(NFSSERVER) \
	vsftpd \
	$(CIFS)
	touch $@
#	opkg

#
# DISK-UTILS
#
$(DEPDIR)/disk-utils: \
	e2fsprogs \
	$(XFSPROGS) \
	jfsutils \
	$(SG3)
	touch $@

#
# YAUD NONE
#
$(DEPDIR)/yaud-none: \
	bare-os \
	linux-kernel \
	net-utils \
	disk-utils \
	driver \
	misc-tools
	touch $@

#
# YAUD
#
yaud-neutrino: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-twin: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-twin release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-twin-next: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-twin-next release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-mp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-exp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-mp-exp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-plugins: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-mp neutrino-mp-plugins release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-exp-plugins: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-mp-exp neutrino-mp-plugins release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2-exp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-hd2-exp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf remote firstboot enigma2-pli-nightly enigma2-plugins release
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-xbmc-nightly: yaud-none host_python boot-elf firstboot xbmc-nightly release_xbmc
	@TUXBOX_YAUD_CUSTOMIZE@
