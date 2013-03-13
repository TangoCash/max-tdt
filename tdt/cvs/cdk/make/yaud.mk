#
# BOOTSTRAP
#
$(DEPDIR)/bootstrap: \
$(DEPDIR)/%bootstrap: \
	%$(FILESYSTEM) \
	| %$(GLIBC) \
	%$(CROSS_LIBGCC) \
	%$(GLIBC) \
	%$(GLIBC_DEV) \
	%$(BINUTILS) \
	%$(BINUTILS_DEV) \
	%$(GMP) \
	%$(MPFR) \
	%$(MPC) \
	%$(ZLIB) \
	%$(ZLIB_DEV) \
	%$(ZLIB_BIN) \
	%$(LIBSTDC) \
	%$(LIBSTDC_DEV)
	@[ "x$*" = "x" ] && touch $@ || true

#
# BARE-OS
#
$(DEPDIR)/bare-os: \
$(DEPDIR)/%bare-os: \
	%bootstrap \
	%$(LIBTERMCAP) \
	%$(NCURSES_BASE) \
	%$(NCURSES) \
	%$(BASE_PASSWD) \
	%$(MAKEDEV) \
	%$(BASE_FILES) \
	%module_init_tools \
	%busybox \
	\
	%$(SYSVINIT) \
	%$(SYSVINITTOOLS) \
	%$(INITSCRIPTS) \
	%$(NETBASE) \
	%$(BC) \
	%$(DISTRIBUTIONUTILS) \
	\
	%u-boot-utils \
	%diverse-tools
#	%openrdate

#
# NET-UTILS
#
$(DEPDIR)/net-utils: \
$(DEPDIR)/%net-utils: \
	%$(NETKIT_FTP) \
	%autofs \
	%portmap \
	%$(NFSSERVER) \
	%vsftpd \
	%$(CIFS)
#	%opkg

#
# DISK-UTILS
#
$(DEPDIR)/disk-utils: \
$(DEPDIR)/%disk-utils: \
	%e2fsprogs \
	%$(XFSPROGS) \
	%util-linux \
	%jfsutils \
	%$(SG3)

#
# YAUD NONE
#
yaud-none: \
	bare-os \
	linux-kernel \
	net-utils \
	disk-utils \
	driver \
	misc-tools
	@TUXBOX_YAUD_CUSTOMIZE@

#
# YAUD
#
yaud-neutrino: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino release_neutrino
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-twin: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-twin release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-mp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-mp-exp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-mp-exp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2-exp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-hd2-exp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf remote firstboot enigma2-pli-nightly enigma2-plugins release
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-xbmc-nightly: yaud-none host_python boot-elf firstboot xbmc-nightly release_xbmc
	@TUXBOX_YAUD_CUSTOMIZE@

