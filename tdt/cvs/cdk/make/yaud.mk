#
#
#
min-prepare-yaud std-prepare-yaud max-prepare-yaud: \
%prepare-yaud:
	-rm -rf $(prefix)/$*cdkroot
	-rm -rf $(prefix)/$*cdkroot-rpmdb

#
# BOOTSTRAP
#
$(DEPDIR)/min-bootstrap $(DEPDIR)/std-bootstrap $(DEPDIR)/max-bootstrap $(DEPDIR)/bootstrap: \
$(DEPDIR)/%bootstrap: \
	%$(CCACHE) \
	%$(FILESYSTEM) \
	| %$(GLIBC) \
	%$(CROSS_LIBGCC) \
	%$(GLIBC) \
	%$(GLIBC_DEV) \
	%$(LIBFFI) \
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
min-bare-os std-bare-os max-bare-os bare-os: \
%bare-os: \
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
	%openrdate \
	%$(NETBASE) \
	%$(BC) \
	%$(DISTRIBUTIONUTILS) \
	\
	%u-boot-utils \
	%diverse-tools

#
#
#
min-net-utils std-net-utils max-net-utils net-utils: \
%net-utils: \
	%$(NETKIT_FTP) \
	%autofs \
	%portmap \
	%$(NFSSERVER) \
	%vsftpd \
	%ethtool \
	%opkg \
	%grep \
	%$(CIFS)

#
#
#
min-disk-utils std-disk-utils max-disk-utils disk-utils: \
%disk-utils: \
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

yaud-neutrino-hd: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-hd release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-neutrino-hd2-exp: yaud-none lirc stslave \
		boot-elf remote firstboot neutrino-hd2-exp release_neutrino_nightly
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-nightly: yaud-none host_python lirc stslave \
		boot-elf remote firstboot enigma2-nightly release
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf remote firstboot enigma2-pli-nightly enigma2-plugins release
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-xbmc-nightly: yaud-none host_python boot-elf firstboot xbmc-nightly release_xbmc
	@TUXBOX_YAUD_CUSTOMIZE@
