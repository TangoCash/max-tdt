#
# NFS-UTILS
#
$(DEPDIR)/nfs_utils.do_prepare: bootstrap e2fsprogs libevent libnfsidmap @DEPENDS_nfs_utils@
	@PREPARE_nfs_utils@
	touch $@

$(DEPDIR)/nfs_utils.do_compile: $(DEPDIR)/nfs_utils.do_prepare
	cd @DIR_nfs_utils@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--target=$(target) \
			CC_FOR_BUILD=$(target)-gcc \
			--disable-gss \
			--disable-nfsv41 \
			--without-tcp-wrappers && \
		$(MAKE)
	touch $@

$(DEPDIR)/nfs_utils: \
$(DEPDIR)/%nfs_utils: $(NFS_UTILS_ADAPTED_ETC_FILES:%=root/etc/%) $(DEPDIR)/nfs_utils.do_compile
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/{default,init.d} && \
	cd @DIR_nfs_utils@ && \
		@INSTALL_nfs_utils@
	( cd root/etc && for i in $(NFS_UTILS_ADAPTED_ETC_FILES); do \
		[ -f $$i ] && $(INSTALL) -m644 $$i $(prefix)/$*cdkroot/etc/$$i || true; \
		[ "$${i%%/*}" = "init.d" ] && chmod 755 $(prefix)/$*cdkroot/etc/$$i || true; done )
	@DISTCLEANUP_nfs_utils@
	[ "x$*" = "x" ] && touch $@ || true

#
# libevent
#
$(DEPDIR)/libevent.do_prepare: bootstrap @DEPENDS_libevent@
	@PREPARE_libevent@
	touch $@

$(DEPDIR)/libevent.do_compile: $(DEPDIR)/libevent.do_prepare
	cd @DIR_libevent@ && \
		$(BUILDENV) \
		./configure --prefix=$(prefix)/$*cdkroot/usr/ --host=$(target) && \
		$(MAKE)
	touch $@

$(DEPDIR)/libevent: \
$(DEPDIR)/%libevent: $(DEPDIR)/libevent.do_compile
	cd @DIR_libevent@ && \
		@INSTALL_libevent@
	@DISTCLEANUP_libevent@
	[ "x$*" = "x" ] && touch $@ || true

#
# libnfsidmap
#
$(DEPDIR)/libnfsidmap.do_prepare: bootstrap @DEPENDS_libnfsidmap@
	@PREPARE_libnfsidmap@
	touch $@

$(DEPDIR)/libnfsidmap.do_compile: $(DEPDIR)/libnfsidmap.do_prepare
	cd @DIR_libnfsidmap@ && \
		$(BUILDENV) \
		ac_cv_func_malloc_0_nonnull=yes ./configure --prefix=$(prefix)/$*cdkroot/usr/ --host=$(target) && \
		$(MAKE)
	touch $@

$(DEPDIR)/libnfsidmap: \
$(DEPDIR)/%libnfsidmap: $(DEPDIR)/libnfsidmap.do_compile
	cd @DIR_libnfsidmap@ && \
		@INSTALL_libnfsidmap@
	@DISTCLEANUP_libnfsidmap@
	[ "x$*" = "x" ] && touch $@ || true

#
# vsftpd
#
$(DEPDIR)/vsftpd.do_prepare: bootstrap @DEPENDS_vsftpd@
	@PREPARE_vsftpd@
	touch $@

$(DEPDIR)/vsftpd.do_compile: $(DEPDIR)/vsftpd.do_prepare
	cd @DIR_vsftpd@ && \
		$(MAKE) clean && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/vsftpd: \
$(DEPDIR)/%vsftpd: $(DEPDIR)/vsftpd.do_compile
	cd @DIR_vsftpd@ && \
		@INSTALL_vsftpd@
		cp $(buildprefix)/root/etc/vsftpd.conf $(targetprefix)/etc
	@DISTCLEANUP_vsftpd@
	[ "x$*" = "x" ] && touch $@ || true

#
# ETHTOOL
#
$(DEPDIR)/ethtool.do_prepare: bootstrap @DEPENDS_ethtool@
	@PREPARE_ethtool@
	touch $@

$(DEPDIR)/ethtool.do_compile: $(DEPDIR)/ethtool.do_prepare
	cd @DIR_ethtool@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--libdir=$(targetprefix)/usr/lib \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/ethtool: \
$(DEPDIR)/%ethtool: $(DEPDIR)/ethtool.do_compile
	cd @DIR_ethtool@ && \
		@INSTALL_ethtool@
	@DISTCLEANUP_ethtool@
	[ "x$*" = "x" ] && touch $@ || true

#
# SAMBA
#
$(DEPDIR)/samba.do_prepare: bootstrap @DEPENDS_samba@
	@PREPARE_samba@
	touch $@

$(DEPDIR)/samba.do_compile: $(DEPDIR)/samba.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_samba@ && \
		cd source3 && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--with-automount \
			--with-smbmount \
			--with-configdir=/etc/samba \
			--with-privatedir=/etc/samba/private \
			--with-mandir=/usr/share/man \
			--with-piddir=/var/run \
			--with-logfilebase=/var/log \
			--with-lockdir=/var/lock \
			--with-swatdir=/usr/share/swat \
			--disable-cups && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/samba: \
$(DEPDIR)/%samba: $(DEPDIR)/samba.do_compile
	cd @DIR_samba@ && \
		cd source3 && \
		$(MAKE) $(MAKE_OPTS) installservers installbin installcifsmount installman installscripts installdat installmodules \
			SBIN_PROGS="bin/smbd bin/nmbd bin/winbindd" DESTDIR=$(prefix)/$*cdkroot/ prefix=./. && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/samba && \
		$(INSTALL) -c -m644 ../examples/smb.conf.default $(prefix)/$*cdkroot/etc/samba/smb.conf
	@DISTCLEANUP_samba@
	[ "x$*" = "x" ] && touch $@ || true

samba_ADAPTED_FILES = /etc/samba/smb.conf /etc/init.d/samba
samba_INITD_FILES = samba
ETC_RW_FILES += samba/smb.conf init.d/samba

#
# NETIO
#
$(DEPDIR)/netio.do_prepare: bootstrap @DEPENDS_netio@
	@PREPARE_netio@
	touch $@

$(DEPDIR)/netio.do_compile: $(DEPDIR)/netio.do_prepare
	cd @DIR_netio@ && \
		$(MAKE_OPTS) \
		$(MAKE) all O=.o X= CFLAGS="-DUNIX" LIBS="$(LDFLAGS) -lpthread" OUT=-o
	touch $@

$(DEPDIR)/netio: \
$(DEPDIR)/%netio: $(DEPDIR)/netio.do_compile
	cd @DIR_netio@ && \
		$(INSTALL) -d $(prefix)/$*cdkroot/usr/bin && \
		@INSTALL_netio@
	@DISTCLEANUP_netio@
	[ "x$*" = "x" ] && touch $@ || true

#
# LIGHTTPD
#
$(DEPDIR)/lighttpd.do_prepare: bootstrap @DEPENDS_lighttpd@
	@PREPARE_lighttpd@
	touch $@

$(DEPDIR)/lighttpd.do_compile: $(DEPDIR)/lighttpd.do_prepare
	cd @DIR_lighttpd@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix= \
			--exec-prefix=/usr \
			--datarootdir=/usr/share && \
		$(MAKE)
	touch $@

$(DEPDIR)/lighttpd: \
$(DEPDIR)/%lighttpd: $(DEPDIR)/lighttpd.do_compile
	cd @DIR_lighttpd@ && \
		@INSTALL_lighttpd@
	cd @DIR_lighttpd@ && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/lighttpd && \
		$(INSTALL) -c -m644 doc/lighttpd.conf $(prefix)/$*cdkroot/etc/lighttpd && \
		$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && \
		$(INSTALL) -c -m644 doc/rc.lighttpd.redhat $(prefix)/$*cdkroot/etc/init.d/lighttpd
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/lighttpd && $(INSTALL) -m755 root/etc/lighttpd/lighttpd.conf $(prefix)/$*cdkroot/etc/lighttpd
	$(INSTALL) -d $(prefix)/$*cdkroot/etc/init.d && $(INSTALL) -m755 root/etc/init.d/lighttpd $(prefix)/$*cdkroot/etc/init.d
	@DISTCLEANUP_lighttpd@
	[ "x$*" = "x" ] && touch $@ || true

#
# NETKIT_FTP
#
$(DEPDIR)/netkit_ftp.do_prepare: bootstrap ncurses libreadline @DEPENDS_netkit_ftp@
	@PREPARE_netkit_ftp@
	touch $@

$(DEPDIR)/netkit_ftp.do_compile: $(DEPDIR)/netkit_ftp.do_prepare
	cd @DIR_netkit_ftp@ && \
		$(BUILDENV) \
		./configure \
			--with-c-compiler=$(target)-gcc \
			--prefix=/usr \
			--installroot=$(prefix)/$*cdkroot && \
		$(MAKE)
	touch $@

$(DEPDIR)/netkit_ftp: \
$(DEPDIR)/%netkit_ftp: $(DEPDIR)/netkit_ftp.do_compile
	cd @DIR_netkit_ftp@ && \
		@INSTALL_netkit_ftp@
	@DISTCLEANUP_netkit_ftp@
	[ "x$*" = "x" ] && touch $@ || true

#
# WIRELESS_TOOLS
#
$(DEPDIR)/wireless_tools.do_prepare: bootstrap @DEPENDS_wireless_tools@
	@PREPARE_wireless_tools@
	touch $@

$(DEPDIR)/wireless_tools.do_compile: $(DEPDIR)/wireless_tools.do_prepare
	cd @DIR_wireless_tools@ && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/wireless_tools: \
$(DEPDIR)/%wireless_tools: $(DEPDIR)/wireless_tools.do_compile
	cd @DIR_wireless_tools@ && \
		@INSTALL_wireless_tools@
	@DISTCLEANUP_wireless_tools@
	[ "x$*" = "x" ] && touch $@ || true

#
# WPA_SUPPLICANT
#
$(DEPDIR)/wpa_supplicant.do_prepare: bootstrap wireless_tools openssl openssl-dev @DEPENDS_wpa_supplicant@
	@PREPARE_wpa_supplicant@
	touch $@

$(DEPDIR)/wpa_supplicant.do_compile: Patches/wpa_supplicant.config $(DEPDIR)/wpa_supplicant.do_prepare
	cd @DIR_wpa_supplicant@/wpa_supplicant && \
		$(INSTALL) -m 644 ../../$(word 1,$^) .config && \
		$(MAKE) $(MAKE_OPTS)
	touch $@

$(DEPDIR)/wpa_supplicant: \
$(DEPDIR)/%wpa_supplicant: $(DEPDIR)/wpa_supplicant.do_compile
	cd @DIR_wpa_supplicant@/wpa_supplicant && \
		@INSTALL_wpa_supplicant@
	@DISTCLEANUP_wpa_supplicant@
	[ "x$*" = "x" ] && touch $@ || true
