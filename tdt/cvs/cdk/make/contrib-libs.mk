#
# libao
#
$(DEPDIR)/libao.do_prepare: bootstrap @DEPENDS_libao@
	@PREPARE_libao@
	touch $@

$(DEPDIR)/libao.do_compile: $(DEPDIR)/libao.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libao@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libao: \
$(DEPDIR)/%libao: $(DEPDIR)/libao.do_compile
	cd @DIR_libao@ && \
		@INSTALL_libao@
	@DISTCLEANUP_libao@
	[ "x$*" = "x" ] && touch $@ || true

#
# libboost
#
$(DEPDIR)/libboost: bootstrap @DEPENDS_libboost@
	@PREPARE_libboost@
	cd @DIR_libboost@ && \
		@INSTALL_libboost@
	@DISTCLEANUP_libboost@
	touch $@

#
# libz
#
#$(DEPDIR)/libz.do_prepare: bootstrap binutils binutils-dev @DEPENDS_libz@
#	@PREPARE_libz@
#	touch $@
#
#$(DEPDIR)/libz.do_compile: $(DEPDIR)/libz.do_prepare
#	cd @DIR_libz@ && \
#		ln -sf /bin/true ./ldconfig; \
#		$(BUILDENV) \
#		./configure \
#			--prefix=/usr \
#			--shared && \
#		$(MAKE) all
#	touch $@
#
#$(DEPDIR)/libz: \
#$(DEPDIR)/%libz: $(DEPDIR)/libz.do_compile
#	cd @DIR_libz@ && \
#		@INSTALL_libz@
#	@DISTCLEANUP_libz@
#	[ "x$*" = "x" ] && touch $@ || true

#
# libreadline
#
$(DEPDIR)/libreadline.do_prepare: bootstrap ncurses-dev @DEPENDS_libreadline@
	@PREPARE_libreadline@
	touch $@

$(DEPDIR)/libreadline.do_compile: $(DEPDIR)/libreadline.do_prepare
	cd @DIR_libreadline@ && \
		autoconf && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			bash_cv_must_reinstall_sighandlers=no \
			bash_cv_func_sigsetjmp=present \
			bash_cv_func_strcoll_broken=no \
			bash_cv_have_mbstate_t=yes \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libreadline: \
$(DEPDIR)/%libreadline: $(DEPDIR)/libreadline.do_compile
	cd @DIR_libreadline@ && \
		@INSTALL_libreadline@
	@DISTCLEANUP_libreadline@
	[ "x$*" = "x" ] && touch $@ || true

#
# libfreetype
#
$(DEPDIR)/libfreetype.do_prepare: bootstrap @DEPENDS_libfreetype@
	@PREPARE_libfreetype@
	touch $@

$(DEPDIR)/libfreetype.do_compile: $(DEPDIR)/libfreetype.do_prepare
	cd @DIR_libfreetype@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libfreetype: \
$(DEPDIR)/%libfreetype: $(DEPDIR)/libfreetype.do_compile
	cd @DIR_libfreetype@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < builds/unix/freetype-config > $(crossprefix)/bin/freetype-config && \
		chmod 755 $(crossprefix)/bin/freetype-config && \
		ln -sf $(crossprefix)/bin/freetype-config $(crossprefix)/bin/$(target)-freetype-config && \
		ln -sf $(targetprefix)/usr/include/freetype2/freetype $(targetprefix)/usr/include/freetype && \
		@INSTALL_libfreetype@
		rm -f $(targetprefix)/usr/bin/freetype-config
	@DISTCLEANUP_libfreetype@
	[ "x$*" = "x" ] && touch $@ || true

#
# lirc
#
$(DEPDIR)/lirc.do_prepare: bootstrap @DEPENDS_lirc@
	@PREPARE_lirc@
	touch $@

$(DEPDIR)/lirc.do_compile: $(DEPDIR)/lirc.do_prepare
	cd @DIR_lirc@ && \
		$(BUILDENV) \
		ac_cv_path_LIBUSB_CONFIG= \
		CFLAGS="$(TARGET_CFLAGS) -D__KERNEL_STRICT_NAMES" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--sbindir=\$${exec_prefix}/bin \
			--mandir=\$${prefix}/share/man \
			--with-kerneldir=$(buildprefix)/$(KERNEL_DIR) \
			--without-x \
			--with-devdir=/dev \
			--with-moduledir=/lib/modules \
			--with-major=61 \
			--with-driver=userspace \
			--enable-debug \
			--with-syslog=LOG_DAEMON \
			--enable-sandboxed && \
		$(MAKE) all
	touch $@

$(DEPDIR)/lirc: \
$(DEPDIR)/%lirc: $(DEPDIR)/lirc.do_compile
	cd @DIR_lirc@ && \
		@INSTALL_lirc@
	@DISTCLEANUP_lirc@
	[ "x$*" = "x" ] && touch $@ || true

#
# libjpeg
#
$(DEPDIR)/libjpeg.do_prepare: bootstrap @DEPENDS_libjpeg@
	@PREPARE_libjpeg@
	touch $@

$(DEPDIR)/libjpeg.do_compile: $(DEPDIR)/libjpeg.do_prepare
	cd @DIR_libjpeg@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-shared \
			--enable-static \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libjpeg: \
$(DEPDIR)/%libjpeg: $(DEPDIR)/libjpeg.do_compile
	cd @DIR_libjpeg@ && \
		@INSTALL_libjpeg@
	@DISTCLEANUP_libjpeg@
	[ "x$*" = "x" ] && touch $@ || true

#
# libpng12
#
$(DEPDIR)/libpng12.do_prepare: bootstrap @DEPENDS_libpng12@
	@PREPARE_libpng12@
	touch $@

$(DEPDIR)/libpng12.do_compile: $(DEPDIR)/libpng12.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libpng12@ && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libpng12: \
$(DEPDIR)/%libpng12: $(DEPDIR)/libpng12.do_compile
	cd @DIR_libpng12@ && \
		sed -e "s,^prefix=,prefix=$(PKDIR)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		@INSTALL_libpng12@
		rm -f $(PKDIR)/usr/bin/libpng*-config
	@DISTCLEANUP_libpng12@
	[ "x$*" = "x" ] && touch $@ || true

#
# libpng
#
$(DEPDIR)/libpng.do_prepare: bootstrap @DEPENDS_libpng@
	@PREPARE_libpng@
	touch $@

$(DEPDIR)/libpng.do_compile: $(DEPDIR)/libpng.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libpng@ && \
		./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		export ECHO="echo" && \
		echo "Echo cmd =" $(ECHO) && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libpng: \
$(DEPDIR)/%libpng: $(DEPDIR)/libpng.do_compile
	cd @DIR_libpng@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < libpng-config > $(crossprefix)/bin/libpng-config && \
		chmod 755 $(crossprefix)/bin/libpng-config && \
		@INSTALL_libpng@
		rm -f $(targetprefix)/usr/bin/libpng*-config
	@DISTCLEANUP_libpng@
	[ "x$*" = "x" ] && touch $@ || true

#
# libungif
#
$(DEPDIR)/libungif.do_prepare: bootstrap @DEPENDS_libungif@
	@PREPARE_libungif@
	touch $@

$(DEPDIR)/libungif.do_compile: $(DEPDIR)/libungif.do_prepare
	cd @DIR_libungif@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libungif: \
$(DEPDIR)/%libungif: $(DEPDIR)/libungif.do_compile
	cd @DIR_libungif@ && \
		@INSTALL_libungif@
	@DISTCLEANUP_libungif@
	[ "x$*" = "x" ] && touch $@ || true

#
# libgif
#
$(DEPDIR)/libgif.do_prepare: bootstrap @DEPENDS_libgif@
	@PREPARE_libgif@
	touch $@

$(DEPDIR)/libgif.do_compile: $(DEPDIR)/libgif.do_prepare
	cd @DIR_libgif@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libgif: \
$(DEPDIR)/%libgif: $(DEPDIR)/libgif.do_compile
	cd @DIR_libgif@ && \
		@INSTALL_libgif@
	@DISTCLEANUP_libgif@
	[ "x$*" = "x" ] && touch $@ || true

#
# libgif_current
#
$(DEPDIR)/libgif_current.do_prepare: bootstrap @DEPENDS_libgif_current@
	@PREPARE_libgif_current@
	touch $@

$(DEPDIR)/libgif_current.do_compile: $(DEPDIR)/libgif_current.do_prepare
	cd @DIR_libgif_current@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--without-x && \
		$(MAKE)
	touch $@

$(DEPDIR)/libgif_current: \
$(DEPDIR)/%libgif_current: $(DEPDIR)/libgif_current.do_compile
	cd @DIR_libgif_current@ && \
		@INSTALL_libgif_current@
	@DISTCLEANUP_libgif_current@
	[ "x$*" = "x" ] && touch $@ || true

#
# libcurl
#
$(DEPDIR)/libcurl.do_prepare: bootstrap openssl rtmpdump @DEPENDS_libcurl@
	@PREPARE_libcurl@
	touch $@

$(DEPDIR)/libcurl.do_compile: $(DEPDIR)/libcurl.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcurl@ && \
		$(BUILDENV) \
		autoreconf -vif -I$(hostprefix)/share/aclocal && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-ssl \
			--disable-debug \
			--disable-verbose \
			--disable-manual \
			--mandir=/usr/share/man \
			--with-random && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libcurl: \
$(DEPDIR)/%libcurl: $(DEPDIR)/libcurl.do_compile
	cd @DIR_libcurl@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < curl-config > $(crossprefix)/bin/curl-config && \
		chmod 755 $(crossprefix)/bin/curl-config && \
		@INSTALL_libcurl@
		rm -f $(targetprefix)/usr/bin/curl-config
	@DISTCLEANUP_libcurl@
	[ "x$*" = "x" ] && touch $@ || true

#
# libfribidi
#
$(DEPDIR)/libfribidi.do_prepare: bootstrap @DEPENDS_libfribidi@
	@PREPARE_libfribidi@
	touch $@

$(DEPDIR)/libfribidi.do_compile: $(DEPDIR)/libfribidi.do_prepare
	cd @DIR_libfribidi@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-memopt && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libfribidi: \
$(DEPDIR)/%libfribidi: $(DEPDIR)/libfribidi.do_compile
	cd @DIR_libfribidi@ && \
		@INSTALL_libfribidi@
	@DISTCLEANUP_libfribidi@
	[ "x$*" = "x" ] && touch $@ || true

#
# libsigc
#
$(DEPDIR)/libsigc.do_prepare: bootstrap libstdc++-dev @DEPENDS_libsigc@
	@PREPARE_libsigc@
	touch $@

$(DEPDIR)/libsigc.do_compile: $(DEPDIR)/libsigc.do_prepare
	cd @DIR_libsigc@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-checks && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libsigc: \
$(DEPDIR)/%libsigc: $(DEPDIR)/libsigc.do_compile
	cd @DIR_libsigc@ && \
		@INSTALL_libsigc@
	@DISTCLEANUP_libsigc@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmad
#
$(DEPDIR)/libmad.do_prepare: bootstrap @DEPENDS_libmad@
	@PREPARE_libmad@
	touch $@

$(DEPDIR)/libmad.do_compile: $(DEPDIR)/libmad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmad@ && \
		aclocal -I $(hostprefix)/share/aclocal && \
		autoconf && \
		autoheader && \
		automake --foreign && \
		libtoolize --force && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-debugging \
			--enable-shared=yes \
			--enable-speed \
			--enable-sso && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libmad: \
$(DEPDIR)/%libmad: $(DEPDIR)/libmad.do_compile
	cd @DIR_libmad@ && \
		@INSTALL_libmad@
	@DISTCLEANUP_libmad@
	[ "x$*" = "x" ] && touch $@ || true

#
# libid3tag
#
$(DEPDIR)/libid3tag.do_prepare: bootstrap @DEPENDS_libid3tag@
	@PREPARE_libid3tag@
	touch $@

$(DEPDIR)/libid3tag.do_compile: $(DEPDIR)/libid3tag.do_prepare
	cd @DIR_libid3tag@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared=yes && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libid3tag: \
$(DEPDIR)/%libid3tag: $(DEPDIR)/libid3tag.do_compile
	cd @DIR_libid3tag@ && \
		@INSTALL_libid3tag@
	@DISTCLEANUP_libid3tag@
	[ "x$*" = "x" ] && touch $@ || true

#
# libvorbisidec
#
$(DEPDIR)/libvorbisidec.do_prepare: bootstrap libogg @DEPENDS_libvorbisidec@
	@PREPARE_libvorbisidec@
	touch $@

$(DEPDIR)/libvorbisidec.do_compile: $(DEPDIR)/libvorbisidec.do_prepare
	cd @DIR_libvorbisidec@ && \
		ACLOCAL_FLAGS="-I . -I $(targetprefix)/usr/share/aclocal" \
		$(BUILDENV) \
		./autogen.sh \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libvorbisidec: $(DEPDIR)/libvorbisidec.do_compile
	cd @DIR_libvorbisidec@ && \
		@INSTALL_libvorbisidec@
	@DISTCLEANUP_libvorbisidec@
	[ "x$*" = "x" ] && touch $@ || true

#
# libglib2
# You need libglib2.0-dev on host system
#
$(DEPDIR)/glib2.do_prepare: bootstrap libffi @DEPENDS_glib2@
	@PREPARE_glib2@
	touch $@

$(DEPDIR)/glib2.do_compile: $(DEPDIR)/glib2.do_prepare
	echo "glib_cv_va_copy=no" > @DIR_glib2@/config.cache
	echo "glib_cv___va_copy=yes" >> @DIR_glib2@/config.cache
	echo "glib_cv_va_val_copy=yes" >> @DIR_glib2@/config.cache
	echo "ac_cv_func_posix_getpwuid_r=yes" >> @DIR_glib2@/config.cache
	echo "ac_cv_func_posix_getgrgid_r=yes" >> @DIR_glib2@/config.cache
	echo "glib_cv_stack_grows=no" >> @DIR_glib2@/config.cache
	echo "glib_cv_uscore=no" >> @DIR_glib2@/config.cache
	cd @DIR_glib2@ && \
		$(BUILDENV) \
		./configure \
			--cache-file=config.cache \
			--disable-gtk-doc \
			--with-threads="posix" \
			--enable-static \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man && \
		$(MAKE) all
	touch $@

$(DEPDIR)/glib2: \
$(DEPDIR)/%glib2: $(DEPDIR)/glib2.do_compile
	cd @DIR_glib2@ && \
		@INSTALL_glib2@
	@DISTCLEANUP_glib2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libiconv
#
$(DEPDIR)/libiconv.do_prepare: bootstrap @DEPENDS_libiconv@
	@PREPARE_libiconv@
	touch $@

$(DEPDIR)/libiconv.do_compile: $(DEPDIR)/libiconv.do_prepare
	cd @DIR_libiconv@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libiconv: \
$(DEPDIR)/%libiconv: $(DEPDIR)/libiconv.do_compile
	cd @DIR_libiconv@ && \
		cp ./srcm4/* $(hostprefix)/share/aclocal/ && \
		@INSTALL_libiconv@
	@DISTCLEANUP_libiconv@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmng
#
$(DEPDIR)/libmng.do_prepare: bootstrap libjpeg lcms @DEPENDS_libmng@
	@PREPARE_libmng@
	touch $@

$(DEPDIR)/libmng.do_compile: $(DEPDIR)/libmng.do_prepare
	cd @DIR_libmng@ && \
		cat unmaintained/autogen.sh | tr -d \\r > autogen.sh && chmod 755 autogen.sh && \
		[ ! -x ./configure ] && ./autogen.sh --help || true && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static \
			--with-zlib \
			--with-jpeg \
			--with-gnu-ld \
			--with-lcms && \
		$(MAKE)
	touch $@

$(DEPDIR)/libmng: \
$(DEPDIR)/%libmng: $(DEPDIR)/libmng.do_compile
	cd @DIR_libmng@ && \
		@INSTALL_libmng@
	@DISTCLEANUP_libmng@
	[ "x$*" = "x" ] && touch $@ || true	

#
# lcms
#
$(DEPDIR)/lcms.do_prepare: bootstrap libjpeg @DEPENDS_lcms@
	@PREPARE_lcms@
	touch $@

$(DEPDIR)/lcms.do_compile: $(DEPDIR)/lcms.do_prepare
	cd @DIR_lcms@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-shared \
			--enable-static && \
		$(MAKE)
	touch $@

$(DEPDIR)/lcms: \
$(DEPDIR)/%lcms: $(DEPDIR)/lcms.do_compile
	cd @DIR_lcms@ && \
		@INSTALL_lcms@
	@DISTCLEANUP_lcms@
	[ "x$*" = "x" ] && touch $@ || true

#
# directfb
#
$(DEPDIR)/directfb.do_prepare: bootstrap freetype @DEPENDS_directfb@
	@PREPARE_directfb@
	touch $@

$(DEPDIR)/directfb.do_compile: $(DEPDIR)/directfb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_directfb@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--disable-sdl \
			--disable-x11 \
			--disable-devmem \
			--disable-multi \
			--with-gfxdrivers=stgfx \
			--with-inputdrivers=linuxinput,enigma2remote \
			--without-software \
			--enable-stmfbdev \
			--disable-fbdev \
			--enable-mme=yes && \
			export top_builddir=`pwd` && \
		$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/directfb: \
$(DEPDIR)/%directfb: $(DEPDIR)/directfb.do_compile
	cd @DIR_directfb@ && \
		@INSTALL_directfb@
	@DISTCLEANUP_directfb@
	[ "x$*" = "x" ] && touch $@ || true

#
# DFB++
#
$(DEPDIR)/dfbpp.do_prepare: bootstrap libjpeg directfb @DEPENDS_dfbpp@
	@PREPARE_dfbpp@
	touch $@

$(DEPDIR)/dfbpp.do_compile: $(DEPDIR)/dfbpp.do_prepare
	cd @DIR_dfbpp@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
			export top_builddir=`pwd` && \
		$(MAKE) all
	touch $@

$(DEPDIR)/dfbpp: \
$(DEPDIR)/%dfbpp: $(DEPDIR)/dfbpp.do_compile
	cd @DIR_dfbpp@ && \
		@INSTALL_dfbpp@
	@DISTCLEANUP_dfbpp@
	[ "x$*" = "x" ] && touch $@ || true

#
# LIBSTGLES
#
$(DEPDIR)/libstgles.do_prepare: bootstrap directfb @DEPENDS_libstgles@
	@PREPARE_libstgles@
	touch $@

$(DEPDIR)/libstgles.do_compile: $(DEPDIR)/libstgles.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libstgles@ && \
	cp --remove-destination $(hostprefix)/share/libtool/config/ltmain.sh . && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/libstgles: \
$(DEPDIR)/%libstgles: $(DEPDIR)/libstgles.do_compile
	cd @DIR_libstgles@ && \
		@INSTALL_libstgles@
	@DISTCLEANUP_libstgles@
	[ "x$*" = "x" ] && touch $@ || true

#
# libexpat
#
$(DEPDIR)/libexpat.do_prepare: bootstrap @DEPENDS_libexpat@
	@PREPARE_libexpat@
	touch $@

$(DEPDIR)/libexpat.do_compile: $(DEPDIR)/libexpat.do_prepare
	cd @DIR_libexpat@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libexpat: \
$(DEPDIR)/%libexpat: $(DEPDIR)/libexpat.do_compile
	cd @DIR_libexpat@ && \
		@INSTALL_libexpat@
	@DISTCLEANUP_libexpat@
	[ "x$*" = "x" ] && touch $@ || true

#
# fontconfig
#
$(DEPDIR)/fontconfig.do_prepare: bootstrap libexpat libfreetype @DEPENDS_fontconfig@
	@PREPARE_fontconfig@
	touch $@

$(DEPDIR)/fontconfig.do_compile: $(DEPDIR)/fontconfig.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_fontconfig@ && \
		libtoolize -f -c && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-arch=sh4 \
			--with-freetype-config=$(crossprefix)/bin/freetype-config \
			--with-expat-includes=$(targetprefix)/usr/include \
			--with-expat-lib=$(targetprefix)/usr/lib \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-docs \
			--without-add-fonts && \
		$(MAKE)
	touch $@

$(DEPDIR)/fontconfig: \
$(DEPDIR)/%fontconfig: $(DEPDIR)/fontconfig.do_compile
	cd @DIR_fontconfig@ && \
		@INSTALL_fontconfig@
	@DISTCLEANUP_fontconfig@
	[ "x$*" = "x" ] && touch $@ || true

#
# libxmlccwrap
#
$(DEPDIR)/libxmlccwrap.do_prepare: bootstrap @DEPENDS_libxmlccwrap@
	@PREPARE_libxmlccwrap@
	touch $@

$(DEPDIR)/libxmlccwrap.do_compile: $(DEPDIR)/libxmlccwrap.do_prepare
	cd @DIR_libxmlccwrap@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libxmlccwrap: \
$(DEPDIR)/%libxmlccwrap: $(DEPDIR)/libxmlccwrap.do_compile
	cd @DIR_libxmlccwrap@ && \
		@INSTALL_libxmlccwrap@ && \
		sed -e "/^dependency_libs/ s,-L/usr/lib,-L$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la && \
		sed -e "/^dependency_libs/ s, /usr/lib, $(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/libxmlccwrap.la
	@DISTCLEANUP_libxmlccwrap@
	[ "x$*" = "x" ] && touch $@ || true

#
# a52dec
#
$(DEPDIR)/a52dec.do_prepare: bootstrap @DEPENDS_a52dec@
	@PREPARE_a52dec@
	touch $@

$(DEPDIR)/a52dec.do_compile: $(DEPDIR)/a52dec.do_prepare
	cd @DIR_a52dec@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=$(targetprefix)/usr && \
		$(MAKE) install
	touch $@

$(DEPDIR)/a52dec: \
$(DEPDIR)/%a52dec: $(DEPDIR)/a52dec.do_compile
	cd @DIR_a52dec@ && \
		@INSTALL_a52dec@
	@DISTCLEANUP_a52dec@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvdcss
#
$(DEPDIR)/libdvdcss.do_prepare: bootstrap @DEPENDS_libdvdcss@
	@PREPARE_libdvdcss@
	touch $@

$(DEPDIR)/libdvdcss.do_compile: $(DEPDIR)/libdvdcss.do_prepare
	cd @DIR_libdvdcss@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--disable-doc && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdcss: \
$(DEPDIR)/%libdvdcss: $(DEPDIR)/libdvdcss.do_compile
	cd @DIR_libdvdcss@ && \
		@INSTALL_libdvdcss@
	@DISTCLEANUP_libdvdcss@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvdnav
#
$(DEPDIR)/libdvdnav.do_prepare: bootstrap libdvdread @DEPENDS_libdvdnav@
	@PREPARE_libdvdnav@
	touch $@

$(DEPDIR)/libdvdnav.do_compile: $(DEPDIR)/libdvdnav.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvdnav@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
			--with-dvdread-config=$(crossprefix)/bin/dvdread-config && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdvdnav: \
$(DEPDIR)/%libdvdnav: $(DEPDIR)/libdvdnav.do_compile
	cd @DIR_libdvdnav@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdnav-config > $(crossprefix)/bin/dvdnav-config && \
		chmod 755 $(crossprefix)/bin/dvdnav-config && \
		@INSTALL_libdvdnav@
		rm -f $(targetprefix)/usr/bin/dvdnav-config
	@DISTCLEANUP_libdvdnav@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvdread
#
$(DEPDIR)/libdvdread.do_prepare: bootstrap @DEPENDS_libdvdread@
	@PREPARE_libdvdread@
	touch $@

$(DEPDIR)/libdvdread.do_compile: $(DEPDIR)/libdvdread.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvdread@ && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
		cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
		autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--enable-static \
			--enable-shared \
			--prefix=/usr && \
		$(MAKE)
	touch $@

$(DEPDIR)/libdvdread: \
$(DEPDIR)/%libdvdread: $(DEPDIR)/libdvdread.do_compile
	cd @DIR_libdvdread@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < misc/dvdread-config > $(crossprefix)/bin/dvdread-config && \
		chmod 755 $(crossprefix)/bin/dvdread-config && \
		@INSTALL_libdvdread@
		rm -f $(targetprefix)/usr/bin/dvdread-config
	@DISTCLEANUP_libdvdread@
	[ "x$*" = "x" ] && touch $@ || true

#
# ffmpeg
#
FFMPEG_CUSTOM_NEU:= \
		--disable-vfp \
		--disable-runtime-cpudetect

FFMPEG_CUSTOM_OLD:= \
		--disable-armvfp \
		--disable-mmi \
		--enable-muxer=aac \
		--enable-encoder=mp3 \
		--enable-encoder=theora \
		--enable-decoder=ljpeg

$(DEPDIR)/ffmpeg.do_prepare: bootstrap libass rtmpdump @DEPENDS_ffmpeg@
	@PREPARE_ffmpeg@
	touch $@

$(DEPDIR)/ffmpeg.do_compile: $(DEPDIR)/ffmpeg.do_prepare
	cd @DIR_ffmpeg@ && \
	PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
	./configure \
		$(FFMPEG_CUSTOM_NEU) \
		--disable-static \
		--enable-shared \
		--enable-cross-compile \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-debug \
		--disable-asm \
		--disable-altivec \
		--disable-amd3dnow \
		--disable-amd3dnowext \
		--disable-mmx \
		--disable-mmxext \
		--disable-sse \
		--disable-sse2 \
		--disable-sse3 \
		--disable-ssse3 \
		--disable-sse4 \
		--disable-sse42 \
		--disable-avx \
		--disable-fma4 \
		--disable-armv5te \
		--disable-armv6 \
		--disable-armv6t2 \
		--disable-neon \
		--disable-vis \
		--disable-inline-asm \
		--disable-yasm \
		--disable-mips32r2 \
		--disable-mipsdspr1 \
		--disable-mipsdspr2 \
		--disable-mipsfpu \
		--disable-indevs \
		--disable-outdevs \
		--disable-muxers \
		--enable-muxer=ogg \
		--enable-muxer=flac \
		--enable-muxer=mp3 \
		--enable-muxer=h261 \
		--enable-muxer=h263 \
		--enable-muxer=h264 \
		--enable-muxer=mpeg1video \
		--enable-muxer=mpeg2video \
		--enable-muxer=image2 \
		--disable-encoders \
		--enable-encoder=aac \
		--enable-encoder=h261 \
		--enable-encoder=h263 \
		--enable-encoder=h263p \
		--enable-encoder=ljpeg \
		--enable-encoder=mjpeg \
		--enable-encoder=png \
		--enable-encoder=mpeg1video \
		--enable-encoder=mpeg2video \
		--disable-decoders \
		--enable-decoder=aac \
		--enable-decoder=mp3 \
		--enable-decoder=theora \
		--enable-decoder=h261 \
		--enable-decoder=h263 \
		--enable-decoder=h263i \
		--enable-decoder=h264 \
		--enable-decoder=mpeg1video \
		--enable-decoder=mpeg2video \
		--enable-decoder=png \
		--enable-decoder=mjpeg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		--enable-protocol=file \
		--enable-encoder=mpeg2video \
		--enable-muxer=mpeg2video \
		--enable-parser=mjpeg \
		--enable-demuxer=mjpeg \
		--enable-decoder=dvbsub \
		--enable-decoder=iff_byterun1 \
		--enable-small \
		--enable-pthreads \
		--enable-bzlib \
		--enable-librtmp \
		--pkg-config="pkg-config" \
		--cross-prefix=$(target)- \
		--target-os=linux \
		--arch=sh4 \
		--extra-cflags="-fno-strict-aliasing" \
		--enable-stripping \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/ffmpeg: \
$(DEPDIR)/%ffmpeg: $(DEPDIR)/ffmpeg.do_compile
	cd @DIR_ffmpeg@ && \
		@INSTALL_ffmpeg@
	@DISTCLEANUP_ffmpeg@
	[ "x$*" = "x" ] && touch $@ || true

#
# libass
#
$(DEPDIR)/libass.do_prepare: bootstrap libfreetype libfribidi @DEPENDS_libass@
	@PREPARE_libass@
	touch $@

$(DEPDIR)/libass.do_compile: $(DEPDIR)/libass.do_prepare
	cd @DIR_libass@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--disable-enca \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/libass: \
$(DEPDIR)/%libass: $(DEPDIR)/libass.do_compile
	cd @DIR_libass@ && \
		@INSTALL_libass@
	@DISTCLEANUP_libass@
	[ "x$*" = "x" ] && touch $@ || true

#
# WebKitDFB
#
$(DEPDIR)/webkitdfb.do_prepare: bootstrap glib2 icu4c libxml2 enchant lite libcurl fontconfig sqlite libsoup cairo libjpeg @DEPENDS_webkitdfb@
	@PREPARE_webkitdfb@
	touch $@

$(DEPDIR)/webkitdfb.do_compile: $(DEPDIR)/webkitdfb.do_prepare
	export PATH=$(buildprefix)/@DIR_icu4c@/host/config:$(PATH) && \
	cd @DIR_webkitdfb@ && \
	$(BUILDENV) \
	./autogen.sh \
		--with-target=directfb \
		--without-gtkplus \
		--host=$(target) \
		--prefix=/usr \
		--with-cairo-directfb \
		--disable-shared-workers \
		--enable-optimizations \
		--disable-channel-messaging \
		--disable-javascript-debugger \
		--enable-offline-web-applications \
		--enable-dom-storage \
		--enable-database \
		--disable-eventsource \
		--enable-icon-database \
		--enable-datalist \
		--disable-video \
		--enable-svg \
		--enable-xpath \
		--disable-xslt \
		--disable-dashboard-support \
		--disable-geolocation \
		--disable-workers \
		--disable-web-sockets \
		--with-networking-backend=soup
	touch $@

$(DEPDIR)/webkitdfb: \
$(DEPDIR)/%webkitdfb: $(DEPDIR)/webkitdfb.do_compile
	cd @DIR_webkitdfb@ && \
		@INSTALL_webkitdfb@
	@DISTCLEANUP_webkitdfb@
	[ "x$*" = "x" ] && touch $@ || true

#
# icu4c
#
$(DEPDIR)/icu4c.do_prepare: bootstrap @DEPENDS_icu4c@
	@PREPARE_icu4c@
	cd @DIR_icu4c@ && \
		rm data/mappings/ucm*.mk; \
		patch -p1 < $(buildprefix)/Patches/icu4c-4_4_1_locales.patch;
	touch $@

$(DEPDIR)/icu4c.do_compile: $(DEPDIR)/icu4c.do_prepare
	echo "Building host icu"
	mkdir -p @DIR_icu4c@/host && \
	cd @DIR_icu4c@/host && \
	sh ../configure --disable-samples --disable-tests && \
	unset TARGET && \
	make
	echo "Building cross icu"
	cd @DIR_icu4c@ && \
	$(BUILDENV) \
	./configure \
		--with-cross-build=$(buildprefix)/@DIR_icu4c@/host \
		--host=$(target) \
		--prefix=/usr \
		--disable-extras \
		--disable-layout \
		--disable-tests \
		--disable-samples
	touch $@

$(DEPDIR)/icu4c: \
$(DEPDIR)/%icu4c: $(DEPDIR)/icu4c.do_compile
	cd @DIR_icu4c@ && \
		unset TARGET && \
		@INSTALL_icu4c@
	@DISTCLEANUP_icu4c@
	[ "x$*" = "x" ] && touch $@ || true

#
# enchant
#
$(DEPDIR)/enchant.do_prepare: bootstrap glib2 @DEPENDS_enchant@
	@PREPARE_enchant@
	touch $@

$(DEPDIR)/enchant.do_compile: $(DEPDIR)/enchant.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_enchant@ && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--with-gnu-ld \
		--disable-aspell \
		--disable-ispell \
		--disable-myspell \
		--disable-zemberek && \
	$(MAKE) LD=$(target)-ld
	touch $@

$(DEPDIR)/enchant: \
$(DEPDIR)/%enchant: $(DEPDIR)/enchant.do_compile
	cd @DIR_enchant@ && \
		@INSTALL_enchant@
	@DISTCLEANUP_enchant@
	[ "x$*" = "x" ] && touch $@ || true

#
# lite
#
$(DEPDIR)/lite.do_prepare: bootstrap directfb @DEPENDS_lite@
	@PREPARE_lite@
	touch $@

$(DEPDIR)/lite.do_compile: $(DEPDIR)/lite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lite@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-debug
	touch $@

$(DEPDIR)/lite: \
$(DEPDIR)/%lite: $(DEPDIR)/lite.do_compile
	cd @DIR_lite@ && \
		@INSTALL_lite@
	@DISTCLEANUP_lite@
	[ "x$*" = "x" ] && touch $@ || true

#
# sqlite
#
$(DEPDIR)/sqlite.do_prepare: bootstrap @DEPENDS_sqlite@
	@PREPARE_sqlite@
	touch $@

$(DEPDIR)/sqlite.do_compile: $(DEPDIR)/sqlite.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sqlite@ && \
	libtoolize -f -c && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-tcl \
		--disable-debug && \
	$(MAKE)
	touch $@

$(DEPDIR)/sqlite: \
$(DEPDIR)/%sqlite: $(DEPDIR)/sqlite.do_compile
	cd @DIR_sqlite@ && \
		@INSTALL_sqlite@
	@DISTCLEANUP_sqlite@
	[ "x$*" = "x" ] && touch $@ || true

#
# libsoup
#
$(DEPDIR)/libsoup.do_prepare: bootstrap @DEPENDS_libsoup@
	@PREPARE_libsoup@
	touch $@

$(DEPDIR)/libsoup.do_compile: $(DEPDIR)/libsoup.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libsoup@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-more-warnings \
		--without-gnome && \
	$(MAKE)
	touch $@

$(DEPDIR)/libsoup: \
$(DEPDIR)/%libsoup: $(DEPDIR)/libsoup.do_compile
	cd @DIR_libsoup@ && \
		@INSTALL_libsoup@
	@DISTCLEANUP_libsoup@
	[ "x$*" = "x" ] && touch $@ || true

#
# pixman
#
$(DEPDIR)/pixman.do_prepare: bootstrap @DEPENDS_pixman@
	@PREPARE_pixman@
	touch $@

$(DEPDIR)/pixman.do_compile: $(DEPDIR)/pixman.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_pixman@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/pixman: \
$(DEPDIR)/%pixman: $(DEPDIR)/pixman.do_compile
	cd @DIR_pixman@ && \
		@INSTALL_pixman@
	@DISTCLEANUP_pixman@
	[ "x$*" = "x" ] && touch $@ || true

#
# cairo
#
$(DEPDIR)/cairo.do_prepare: bootstrap libpng pixman @DEPENDS_cairo@
	@PREPARE_cairo@
	touch $@

$(DEPDIR)/cairo.do_compile: $(DEPDIR)/cairo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_cairo@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-gtk-doc \
		--enable-ft=yes \
		--enable-png=yes \
		--enable-ps=no \
		--enable-pdf=no \
		--enable-svg=no \
		--disable-glitz \
		--disable-xcb \
		--disable-xlib \
		--enable-directfb \
		--program-suffix=-directfb
	touch $@

$(DEPDIR)/cairo: \
$(DEPDIR)/%cairo: $(DEPDIR)/cairo.do_compile
	cd @DIR_cairo@ && \
		@INSTALL_cairo@
	@DISTCLEANUP_cairo@
	[ "x$*" = "x" ] && touch $@ || true

#
# libogg
#
$(DEPDIR)/libogg.do_prepare: bootstrap @DEPENDS_libogg@
	@PREPARE_libogg@
	touch $@

$(DEPDIR)/libogg.do_compile: $(DEPDIR)/libogg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libogg@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/min-libogg $(DEPDIR)/std-libogg $(DEPDIR)/max-libogg \
$(DEPDIR)/libogg: \
$(DEPDIR)/%libogg: $(DEPDIR)/libogg.do_compile
	cd @DIR_libogg@ && \
		@INSTALL_libogg@
	@DISTCLEANUP_libogg@
	[ "x$*" = "x" ] && touch $@ || true

#
# libflac
#
$(DEPDIR)/libflac.do_prepare: bootstrap @DEPENDS_libflac@
	@PREPARE_libflac@
	touch $@

$(DEPDIR)/libflac.do_compile: $(DEPDIR)/libflac.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libflac@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-ogg \
		--disable-oggtest \
		--disable-id3libtest \
		--disable-asm-optimizations \
		--disable-doxygen-docs \
		--disable-xmms-plugin \
		--without-xmms-prefix \
		--without-xmms-exec-prefix \
		--without-libiconv-prefix \
		--without-id3lib \
		--with-ogg-includes=. \
		--disable-cpplibs && \
	$(MAKE)
	touch $@

$(DEPDIR)/libflac: \
$(DEPDIR)/%libflac: $(DEPDIR)/libflac.do_compile
	cd @DIR_libflac@ && \
		@INSTALL_libflac@
	@DISTCLEANUP_libflac@
	[ "x$*" = "x" ] && touch $@ || true


##############################   PYTHON   #####################################

#
# elementtree
#
$(DEPDIR)/elementtree.do_prepare: bootstrap @DEPENDS_elementtree@
	@PREPARE_elementtree@
	touch $@

$(DEPDIR)/elementtree.do_compile: $(DEPDIR)/elementtree.do_prepare
	touch $@

$(DEPDIR)/elementtree: \
$(DEPDIR)/%elementtree: $(DEPDIR)/elementtree.do_compile
	cd @DIR_elementtree@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_elementtree@
	[ "x$*" = "x" ] && touch $@ || true

#
# libxml2
#
$(DEPDIR)/libxml2.do_prepare: bootstrap @DEPENDS_libxml2@
	@PREPARE_libxml2@
	touch $@

$(DEPDIR)/libxml2.do_compile: $(DEPDIR)/libxml2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libxml2@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--with-python=$(hostprefix) \
			--without-c14n \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all 
	touch $@

$(DEPDIR)/libxml2: \
$(DEPDIR)/%libxml2: $(DEPDIR)/libxml2.do_compile
	cd @DIR_libxml2@ && \
		@INSTALL_libxml2@ && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxml2.la,$(targetprefix)/usr/lib/libxml2.la,g" -i $(targetprefix)$(PYTHON_DIR)/site-packages/libxml2mod.la && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xml2-config > $(crossprefix)/bin/xml2-config && \
		chmod 755 $(crossprefix)/bin/xml2-config && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xml2Conf.sh && \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xml2Conf.sh
	@DISTCLEANUP_libxml2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libxslt
#
$(DEPDIR)/libxslt.do_prepare: bootstrap libxml2 @DEPENDS_libxslt@
	@PREPARE_libxslt@
	touch $@

$(DEPDIR)/libxslt.do_compile: $(DEPDIR)/libxslt.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libxslt@ && \
		$(BUILDENV) \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/libxml2" \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr \
			--with-libxml-prefix="$(crossprefix)" \
			--with-libxml-include-prefix="$(targetprefix)/usr/include" \
			--with-libxml-libs-prefix="$(targetprefix)/usr/lib" \
			--with-python=$(hostprefix) \
			--without-crypto \
			--without-debug \
			--without-mem-debug && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libxslt: \
$(DEPDIR)/%libxslt: %libxml2 $(DEPDIR)/libxslt.do_compile
	cd @DIR_libxslt@ && \
		@INSTALL_libxslt@ && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)$(PYTHON_DIR)/site-packages/libxsltmod.la && \
		sed -e "/^dependency_libs/ s,/usr/lib/libexslt.la,$(targetprefix)/usr/lib/libexslt.la,g" -i $(targetprefix)$(PYTHON_DIR)/site-packages/libxsltmod.la && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < xslt-config > $(crossprefix)/bin/xslt-config && \
		chmod 755 $(crossprefix)/bin/xslt-config && \
		sed -e "/^dependency_libs/ s,/usr/lib/libxslt.la,$(targetprefix)/usr/lib/libxslt.la,g" -i $(targetprefix)/usr/lib/libexslt.la && \
		sed -e "/^XML2_LIBDIR/ s,/usr/lib,$(targetprefix)/usr/lib,g" -i $(targetprefix)/usr/lib/xsltConf.sh && \
		sed -e "/^XML2_INCLUDEDIR/ s,/usr/include,$(targetprefix)/usr/include,g" -i $(targetprefix)/usr/lib/xsltConf.sh
	@DISTCLEANUP_libxslt@
	@[ "x$*" = "x" ] && touch $@ || true

#
# lxml
#
$(DEPDIR)/lxml.do_prepare: bootstrap python @DEPENDS_lxml@
	@PREPARE_lxml@
	touch $@

$(DEPDIR)/lxml.do_compile: $(DEPDIR)/lxml.do_prepare
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build \
			--with-xml2-config=$(crossprefix)/bin/xml2-config \
			--with-xslt-config=$(crossprefix)/bin/xslt-config
	touch $@

$(DEPDIR)/lxml: \
$(DEPDIR)/%lxml: $(DEPDIR)/lxml.do_compile
	cd @DIR_lxml@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_lxml@
	[ "x$*" = "x" ] && touch $@ || true

#
# setuptools
#
$(DEPDIR)/setuptools.do_prepare: bootstrap python @DEPENDS_setuptools@
	@PREPARE_setuptools@
	touch $@

$(DEPDIR)/setuptools.do_compile: $(DEPDIR)/setuptools.do_prepare
	cd @DIR_setuptools@ && \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/setuptools: \
$(DEPDIR)/%setuptools: $(DEPDIR)/setuptools.do_compile
	cd @DIR_setuptools@ && \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_setuptools@
	[ "x$*" = "x" ] && touch $@ || true

#
# gdata
#
$(DEPDIR)/gdata.do_prepare: bootstrap setuptools @DEPENDS_gdata@
	@PREPARE_gdata@
	touch $@

$(DEPDIR)/gdata.do_compile: $(DEPDIR)/gdata.do_prepare
	cd @DIR_gdata@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/gdata: \
$(DEPDIR)/%gdata: $(DEPDIR)/gdata.do_compile
	cd @DIR_gdata@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_gdata@
	[ "x$*" = "x" ] && touch $@ || true

#
# twisted
#
$(DEPDIR)/twisted.do_prepare: bootstrap setuptools @DEPENDS_twisted@
	@PREPARE_twisted@
	touch $@

$(DEPDIR)/twisted.do_compile: $(DEPDIR)/twisted.do_prepare
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/twisted: \
$(DEPDIR)/%twisted: $(DEPDIR)/twisted.do_compile
	cd @DIR_twisted@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_twisted@
	[ "x$*" = "x" ] && touch $@ || true

#
# twistetweb2
#
$(DEPDIR)/twistedweb2.do_prepare: bootstrap setuptools @DEPENDS_twistedweb2@
	@PREPARE_twistedweb2@
	touch $@

$(DEPDIR)/twistedweb2.do_compile: $(DEPDIR)/twistedweb2.do_prepare
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python -c "import setuptools; execfile('setup.py')" build
	touch $@

$(DEPDIR)/twistedweb2: \
$(DEPDIR)/%twistedweb2: $(DEPDIR)/twistedweb2.do_compile
	cd @DIR_twistedweb2@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_twistedweb2@
	[ "x$*" = "x" ] && touch $@ || true

#
# pilimaging
#
$(DEPDIR)/pilimaging.do_prepare: bootstrap python @DEPENDS_pilimaging@
	@PREPARE_pilimaging@
	touch $@

$(DEPDIR)/pilimaging.do_compile: $(DEPDIR)/pilimaging.do_prepare
	cd @DIR_pilimaging@ && \
		echo 'JPEG_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' > setup_site.py && \
		echo 'ZLIB_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		echo 'FREETYPE_ROOT = "$(targetprefix)/usr/lib", "$(targetprefix)/usr/include"' >> setup_site.py && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pilimaging: \
$(DEPDIR)/%pilimaging: $(DEPDIR)/pilimaging.do_compile
	cd @DIR_pilimaging@ && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pilimaging@
	[ "x$*" = "x" ] && touch $@ || true

#
# pycrypto
#
$(DEPDIR)/pycrypto.do_prepare: bootstrap setuptools @DEPENDS_pycrypto@
	@PREPARE_pycrypto@
	touch $@

$(DEPDIR)/pycrypto.do_compile: $(DEPDIR)/pycrypto.do_prepare
	cd @DIR_pycrypto@ && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--prefix=/usr
	touch $@

$(DEPDIR)/pycrypto: \
$(DEPDIR)/%pycrypto: $(DEPDIR)/pycrypto.do_compile
	cd @DIR_pycrypto@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pycrypto@
	[ "x$*" = "x" ] && touch $@ || true

#
# pyusb
#
$(DEPDIR)/pyusb.do_prepare: bootstrap setuptools @DEPENDS_pyusb@
	@PREPARE_pyusb@
	touch $@

$(DEPDIR)/pyusb.do_compile: $(DEPDIR)/pyusb.do_prepare
	cd @DIR_pyusb@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyusb: \
$(DEPDIR)/%pyusb: $(DEPDIR)/pyusb.do_compile
	cd @DIR_pyusb@ && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pyusb@
	[ "x$*" = "x" ] && touch $@ || true

#
# pyopenssl
#
$(DEPDIR)/pyopenssl.do_prepare: bootstrap setuptools @DEPENDS_pyopenssl@
	@PREPARE_pyopenssl@
	touch $@

$(DEPDIR)/pyopenssl.do_compile: $(DEPDIR)/pyopenssl.do_prepare
	cd @DIR_pyopenssl@ && \
		CPPFLAGS="$(CPPFLAGS) -I$(targetprefix)/usr/include/python$(PYTHON_VERSION)" \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pyopenssl: \
$(DEPDIR)/%pyopenssl: $(DEPDIR)/pyopenssl.do_compile
	cd @DIR_pyopenssl@ && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pyopenssl@
	[ "x$*" = "x" ] && touch $@ || true

#
# python
#
$(DEPDIR)/python.do_prepare: bootstrap host_python openssl-dev sqlite libreadline bzip2 @DEPENDS_python@
	@PREPARE_python@
	touch $@

$(DEPDIR)/python.do_compile: $(DEPDIR)/python.do_prepare
	( cd @DIR_python@ && \
		CONFIG_SITE= \
		$(BUILDENV) \
		autoreconf -Wcross --verbose --install --force Modules/_ctypes/libffi && \
		autoconf && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--target=$(target) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--enable-shared \
			--disable-ipv6 \
			--without-cxx-main \
			--with-threads \
			--with-pymalloc \
			--with-signal-module \
			--with-wctype-functions \
			HOSTPYTHON=$(hostprefix)/bin/python \
			OPT="$(TARGET_CFLAGS)" && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			PYTHON_MODULES_INCLUDE="$(prefix)/$*cdkroot/usr/include" \
			PYTHON_MODULES_LIB="$(prefix)/$*cdkroot/usr/lib" \
			CROSS_COMPILE_TARGET=yes \
			CROSS_COMPILE=$(target) \
			HOSTARCH=sh4-linux \
			CFLAGS="$(TARGET_CFLAGS) -fno-inline" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			LD="$(target)-gcc" \
			HOSTPYTHON=$(hostprefix)/bin/python \
			HOSTPGEN=$(hostprefix)/bin/pgen \
			all ) && \
	touch $@

$(DEPDIR)/python: \
$(DEPDIR)/%python: $(DEPDIR)/python.do_compile
	( cd @DIR_python@ && \
		$(MAKE) $(MAKE_ARGS) \
			TARGET_OS=$(target) \
			HOSTPYTHON=$(hostprefix)/bin/python \
			HOSTPGEN=$(hostprefix)/bin/pgen \
			install DESTDIR=$(prefix)/$*cdkroot ) && \
	$(LN_SF) ../../libpython$(PYTHON_VERSION).so.1.0 $(prefix)/$*cdkroot$(PYTHON_DIR)/config/libpython$(PYTHON_VERSION).so && \
	$(LN_SF) $(prefix)/$*cdkroot$(PYTHON_INCLUDE_DIR) $(prefix)/$*cdkroot/usr/include/python
	@DISTCLEANUP_python@
	[ "x$*" = "x" ] && touch $@ || true

#
# pythonwifi
#
$(DEPDIR)/pythonwifi.do_prepare: bootstrap setuptools @DEPENDS_pythonwifi@
	@PREPARE_pythonwifi@
	touch $@

$(DEPDIR)/pythonwifi.do_compile: $(DEPDIR)/pythonwifi.do_prepare
	cd @DIR_pythonwifi@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pythonwifi: \
$(DEPDIR)/%pythonwifi: $(DEPDIR)/pythonwifi.do_compile
	cd @DIR_pythonwifi@ && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pythonwifi@
	[ "x$*" = "x" ] && touch $@ || true

#
# pythoncheetah
#
$(DEPDIR)/pythoncheetah.do_prepare: bootstrap setuptools @DEPENDS_pythoncheetah@
	@PREPARE_pythoncheetah@
	touch $@

$(DEPDIR)/pythoncheetah.do_compile: $(DEPDIR)/pythoncheetah.do_prepare
	cd @DIR_pythoncheetah@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/pythoncheetah: \
$(DEPDIR)/%pythoncheetah: $(DEPDIR)/pythoncheetah.do_compile
	cd @DIR_pythoncheetah@ && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_pythoncheetah@
	[ "x$*" = "x" ] && touch $@ || true

#
# zope interface
#
$(DEPDIR)/zope_interface.do_prepare: bootstrap python setuptools @DEPENDS_zope_interface@
	@PREPARE_zope_interface@
	touch $@

$(DEPDIR)/zope_interface.do_compile: $(DEPDIR)/zope_interface.do_prepare
	cd @DIR_zope_interface@ && \
		CC='$(target)-gcc' LDSHARED='$(target)-gcc -shared' \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py build
	touch $@

$(DEPDIR)/zope_interface: \
$(DEPDIR)/%zope_interface: $(DEPDIR)/zope_interface.do_compile
	cd @DIR_zope_interface@ && \
		PYTHONPATH=$(targetprefix)$(PYTHON_DIR)/site-packages \
		$(hostprefix)/bin/python ./setup.py install --root=$(targetprefix) --prefix=/usr
	@DISTCLEANUP_zope_interface@
	[ "x$*" = "x" ] && touch $@ || true



##############################   GSTREAMER + PLUGINS   #########################

#
# GSTREAMER
#
$(DEPDIR)/gstreamer.do_prepare: bootstrap glib2 libxml2 @DEPENDS_gstreamer@
	@PREPARE_gstreamer@
	touch $@

$(DEPDIR)/gstreamer.do_compile: $(DEPDIR)/gstreamer.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gstreamer@ && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-dependency-tracking \
		--disable-check \
		--enable-introspection=no \
		ac_cv_func_register_printf_function=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gstreamer: \
$(DEPDIR)/%gstreamer: $(DEPDIR)/gstreamer.do_compile
	cd @DIR_gstreamer@ && \
		@INSTALL_gstreamer@
	@DISTCLEANUP_gstreamer@
	[ "x$*" = "x" ] && touch $@ || true
	sed -i '/^dependency_libs=/{ s# /usr/lib# $(targetprefix)/usr/lib#g }' $(targetprefix)/usr/lib/gstreamer-0.10/*.la
	sed -i "/^libdir/s|'/usr/lib'|'$(targetprefix)/usr/lib'|" $(targetprefix)/usr/lib/gstreamer-0.10/*.la

#
# GST-PLUGINS-BASE
#
$(DEPDIR)/gst_plugins_base.do_prepare: bootstrap glib2 gstreamer libogg libalsa libvorbis @DEPENDS_gst_plugins_base@
	@PREPARE_gst_plugins_base@
	touch $@

$(DEPDIR)/gst_plugins_base.do_compile: $(DEPDIR)/gst_plugins_base.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_base@ && \
	autoreconf --verbose --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-theora \
		--disable-gnome_vfs \
		--disable-pango \
		--disable-vorbis \
		--disable-x \
		--disable-examples \
		--disable-oggtest \
		--disable-vorbistest \
		--disable-freetypetest \
		--with-gudev \
		--with-audioresample-format=int && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_base: \
$(DEPDIR)/%gst_plugins_base: $(DEPDIR)/gst_plugins_base.do_compile
	cd @DIR_gst_plugins_base@ && \
		@INSTALL_gst_plugins_base@
	@DISTCLEANUP_gst_plugins_base@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-GOOD
#
$(DEPDIR)/gst_plugins_good.do_prepare: bootstrap gstreamer gst_plugins_base libsoup libflac @DEPENDS_gst_plugins_good@
	@PREPARE_gst_plugins_good@
	touch $@

$(DEPDIR)/gst_plugins_good.do_compile: $(DEPDIR)/gst_plugins_good.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_good@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-esd \
		--disable-esdtest \
		--disable-aalib \
		--disable-shout2 \
		--disable-shout2test \
		--disable-x && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_good: \
$(DEPDIR)/%gst_plugins_good: $(DEPDIR)/gst_plugins_good.do_compile
	cd @DIR_gst_plugins_good@ && \
		@INSTALL_gst_plugins_good@
	@DISTCLEANUP_gst_plugins_good@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-BAD
#
$(DEPDIR)/gst_plugins_bad.do_prepare: bootstrap gstreamer gst_plugins_base libmodplug @DEPENDS_gst_plugins_bad@
	@PREPARE_gst_plugins_bad@
	touch $@

$(DEPDIR)/gst_plugins_bad.do_compile: $(DEPDIR)/gst_plugins_bad.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_bad@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-sdl \
		--disable-modplug \
		--disable-mpeg2enc \
		--disable-mplex \
		--disable-vdpau \
		--disable-apexsink \
		--disable-dvdnav \
		--disable-cdaudio \
		--disable-mpeg2enc \
		--disable-mplex \
		--disable-librfb \
		--disable-vdpau \
		--disable-examples \
		--disable-sdltest \
		--disable-curl \
		--disable-rsvg \
		ac_cv_openssldir=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_bad: \
$(DEPDIR)/%gst_plugins_bad: $(DEPDIR)/gst_plugins_bad.do_compile
	cd @DIR_gst_plugins_bad@ && \
		@INSTALL_gst_plugins_bad@
	@DISTCLEANUP_gst_plugins_bad@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-UGLY
#
$(DEPDIR)/gst_plugins_ugly.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_ugly@
	@PREPARE_gst_plugins_ugly@
	touch $@

$(DEPDIR)/gst_plugins_ugly.do_compile: $(DEPDIR)/gst_plugins_ugly.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_ugly@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--disable-mpeg2dec && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_ugly: \
$(DEPDIR)/%gst_plugins_ugly: $(DEPDIR)/gst_plugins_ugly.do_compile
	cd @DIR_gst_plugins_ugly@ && \
		@INSTALL_gst_plugins_ugly@
	@DISTCLEANUP_gst_plugins_ugly@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-FFMPEG
#
$(DEPDIR)/gst_ffmpeg.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_ffmpeg@
	@PREPARE_gst_ffmpeg@
	touch $@

$(DEPDIR)/gst_ffmpeg.do_compile: $(DEPDIR)/gst_ffmpeg.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_ffmpeg@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		\
		--with-ffmpeg-extra-configure=" \
		--disable-ffserver \
		--disable-ffplay \
		--disable-ffmpeg \
		--disable-ffprobe \
		--enable-postproc \
		--enable-gpl \
		--enable-static \
		--enable-pic \
		--disable-protocols \
		--disable-devices \
		--disable-network \
		--disable-hwaccels \
		--disable-filters \
		--disable-doc \
		--enable-optimizations \
		--enable-cross-compile \
		--target-os=linux \
		--arch=sh4 \
		--cross-prefix=$(target)- \
		\
		--disable-muxers \
		--disable-encoders \
		--disable-decoders \
		--enable-decoder=ogg \
		--enable-decoder=vorbis \
		--enable-decoder=flac \
		\
		--disable-demuxers \
		--enable-demuxer=ogg \
		--enable-demuxer=vorbis \
		--enable-demuxer=flac \
		--enable-demuxer=mpegts \
		\
		--disable-bsfs \
		--enable-pthreads \
		--enable-bzlib"
	touch $@

$(DEPDIR)/gst_ffmpeg: \
$(DEPDIR)/%gst_ffmpeg: $(DEPDIR)/gst_ffmpeg.do_compile
	cd @DIR_gst_ffmpeg@ && \
		@INSTALL_gst_ffmpeg@
	@DISTCLEANUP_gst_ffmpeg@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-FLUENDO-MPEGDEMUX
#
$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare: bootstrap gstreamer gst_plugins_base @DEPENDS_gst_plugins_fluendo_mpegdemux@
	@PREPARE_gst_plugins_fluendo_mpegdemux@
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_fluendo_mpegdemux@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-check=no && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_fluendo_mpegdemux: \
$(DEPDIR)/%gst_plugins_fluendo_mpegdemux: $(DEPDIR)/gst_plugins_fluendo_mpegdemux.do_compile
	cd @DIR_gst_plugins_fluendo_mpegdemux@ && \
		@INSTALL_gst_plugins_fluendo_mpegdemux@
	@DISTCLEANUP_gst_plugins_fluendo_mpegdemux@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGIN-SUBSINK
#
$(DEPDIR)/gst_plugin_subsink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly @DEPENDS_gst_plugin_subsink@
	@PREPARE_gst_plugin_subsink@
	touch $@

$(DEPDIR)/gst_plugin_subsink.do_compile: $(DEPDIR)/gst_plugin_subsink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugin_subsink@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugin_subsink: \
$(DEPDIR)/%gst_plugin_subsink: $(DEPDIR)/gst_plugin_subsink.do_compile
	cd @DIR_gst_plugin_subsink@ && \
		@INSTALL_gst_plugin_subsink@
	@DISTCLEANUP_gst_plugin_subsink@
	[ "x$*" = "x" ] && touch $@ || true

#
# GST-PLUGINS-DVBMEDIASINK
#
$(DEPDIR)/gst_plugins_dvbmediasink.do_prepare: bootstrap gstreamer gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly gst_plugin_subsink libdca @DEPENDS_gst_plugins_dvbmediasink@
	@PREPARE_gst_plugins_dvbmediasink@
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink.do_compile: $(DEPDIR)/gst_plugins_dvbmediasink.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gst_plugins_dvbmediasink@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/gst_plugins_dvbmediasink: \
$(DEPDIR)/%gst_plugins_dvbmediasink: $(DEPDIR)/gst_plugins_dvbmediasink.do_compile
	cd @DIR_gst_plugins_dvbmediasink@ && \
		@INSTALL_gst_plugins_dvbmediasink@
	@DISTCLEANUP_gst_plugins_dvbmediasink@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdca
#
$(DEPDIR)/libdca.do_prepare: @DEPENDS_libdca@
	@PREPARE_libdca@
	touch $@

$(DEPDIR)/libdca.do_compile: $(DEPDIR)/libdca.do_prepare
	cd @DIR_libdca@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdca: \
$(DEPDIR)/%libdca: $(DEPDIR)/libdca.do_compile
	cd @DIR_libdca@ && \
		@INSTALL_libdca@
	@DISTCLEANUP_libdca@
	[ "x$*" = "x" ] && touch $@ || true

#
# liborc
#
$(DEPDIR)/liborc.do_prepare: @DEPENDS_liborc@
	@PREPARE_liborc@
	touch $@

$(DEPDIR)/liborc.do_compile: $(DEPDIR)/liborc.do_prepare
	cd @DIR_liborc@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/liborc: \
$(DEPDIR)/%liborc: $(DEPDIR)/liborc.do_compile
	cd @DIR_liborc@ && \
		@INSTALL_liborc@
	@DISTCLEANUP_liborc@
	[ "x$*" = "x" ] && touch $@ || true

##############################   EXTERNAL_LCD   ################################

#
# libusb
#
$(DEPDIR)/libusb.do_prepare: @DEPENDS_libusb@
	@PREPARE_libusb@
	touch $@

$(DEPDIR)/libusb.do_compile: $(DEPDIR)/libusb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libusb@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
		$(MAKE) all
	touch $@

$(DEPDIR)/libusb: \
$(DEPDIR)/%libusb: $(DEPDIR)/libusb.do_compile
	cd @DIR_libusb@ && \
		@INSTALL_libusb@
	@DISTCLEANUP_libusb@
	[ "x$*" = "x" ] && touch $@ || true

#
# graphlcd
#
$(DEPDIR)/graphlcd.do_prepare: bootstrap libusb @DEPENDS_graphlcd@
	[ -d "$(archivedir)/graphlcd-base-touchcol.git" ] && \
	(cd $(archivedir)/graphlcd-base-touchcol.git; git pull ; git checkout touchcol; cd "$(buildprefix)";); \
	@PREPARE_graphlcd@
	touch $@

$(DEPDIR)/graphlcd.do_compile: $(DEPDIR)/graphlcd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_graphlcd@ && \
	$(BUILDENV) \
		$(MAKE) all
	touch $@

$(DEPDIR)/graphlcd: \
$(DEPDIR)/%graphlcd: $(DEPDIR)/graphlcd.do_compile
	cd @DIR_graphlcd@ && \
		@INSTALL_graphlcd@
	@DISTCLEANUP_graphlcd@
	[ "x$*" = "x" ] && touch $@ || true

##############################   LCD4LINUX   ###################################

#
# LCD4LINUX
#--with-python
$(DEPDIR)/lcd4_linux.do_prepare: bootstrap libusbcompat libgd2 libusb2 libdpf @DEPENDS_lcd4_linux@
	@PREPARE_lcd4_linux@
	touch $@

$(DEPDIR)/lcd4_linux.do_compile: $(DEPDIR)/lcd4_linux.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lcd4_linux@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh . && \
	aclocal && \
	libtoolize -f -c && \
	autoheader && \
	automake --foreign && \
	autoconf && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--libdir=$(targetprefix)/usr/lib \
		--includedir=$(targetprefix)/usr/include \
		--oldincludedir=$(targetprefix)/usr/include \
		--prefix=/usr \
		--with-drivers='DPF,SamsungSPF' \
		--with-plugins='all,!dbus,!mpris_dbus,!asterisk,!isdn,!pop3,!ppp,!seti,!huawei,!imon,!kvv,!sample,!w1retap,!wireless,!xmms,!gps,!mpd,!mysql,!qnaplog' \
		--without-ncurses && \
	$(MAKE) all
	touch $@

$(DEPDIR)/lcd4_linux: \
$(DEPDIR)/%lcd4_linux: $(DEPDIR)/lcd4_linux.do_compile
	cd @DIR_lcd4_linux@ && \
		@INSTALL_lcd4_linux@
	@DISTCLEANUP_lcd4_linux@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdpfax
#
$(DEPDIR)/libdpfax.do_prepare: bootstrap libusbcompat @DEPENDS_libdpfax@
	@PREPARE_libdpfax@
	touch $@

$(DEPDIR)/libdpfax.do_compile: $(DEPDIR)/libdpfax.do_prepare
	cd @DIR_libdpfax@ && \
	$(BUILDENV) \
		$(MAKE) all
	touch $@

$(DEPDIR)/libdpfax: \
$(DEPDIR)/%libdpfax: $(DEPDIR)/libdpfax.do_compile
	cd @DIR_libdpfax@ && \
		@INSTALL_libdpfax@
	@DISTCLEANUP_libdpfax@
	[ "x$*" = "x" ] && touch $@ || true

#
# DPFAX
#
$(DEPDIR)/libdpf: bootstrap libusbcompat @DEPENDS_libdpf@
	@PREPARE_libdpf@
	cd @DIR_libdpf@ && \
	$(BUILDENV) \
		$(MAKE) && \
		cp dpf.h $(targetprefix)/usr/include/ && \
		cp sglib.h $(targetprefix)/usr/include/ && \
		cp usbuser.h $(targetprefix)/usr/include/ && \
		cp libdpf.a $(targetprefix)/usr/lib/
	@DISTCLEANUP_libdpf@
	@touch $@
	@TUXBOX_YAUD_CUSTOMIZE@

#
#
# libgd2
#
$(DEPDIR)/libgd2.do_prepare: bootstrap libpng libjpeg libiconv libfreetype @DEPENDS_libgd2@
	@PREPARE_libgd2@
	touch $@

$(DEPDIR)/libgd2.do_compile: $(DEPDIR)/libgd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libgd2@ && \
	chmod +w configure && \
	libtoolize -f -c && \
	autoreconf --force --install -I$(hostprefix)/share/aclocal && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/libgd2: \
$(DEPDIR)/%libgd2: $(DEPDIR)/libgd2.do_compile
	cd @DIR_libgd2@ && \
		@INSTALL_libgd2@
	@DISTCLEANUP_libgd2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libusb2
#
$(DEPDIR)/libusb2.do_prepare: bootstrap @DEPENDS_libusb2@
	@PREPARE_libusb2@
	touch $@

$(DEPDIR)/libusb2.do_compile: $(DEPDIR)/libusb2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libusb2@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libusb2: \
$(DEPDIR)/%libusb2: $(DEPDIR)/libusb2.do_compile
	cd @DIR_libusb2@ && \
		@INSTALL_libusb2@
	@DISTCLEANUP_libusb2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libusbcompat
#
$(DEPDIR)/libusbcompat.do_prepare: bootstrap libusb2 @DEPENDS_libusbcompat@
	@PREPARE_libusbcompat@
	touch $@

$(DEPDIR)/libusbcompat.do_compile: $(DEPDIR)/libusbcompat.do_prepare
	cd @DIR_libusbcompat@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/libusbcompat: \
$(DEPDIR)/%libusbcompat: $(DEPDIR)/libusbcompat.do_compile
	cd @DIR_libusbcompat@ && \
		@INSTALL_libusbcompat@
	@DISTCLEANUP_libusbcompat@
	[ "x$*" = "x" ] && touch $@ || true

##############################   END EXTERNAL_LCD   #############################


#
# eve-browser
#
$(DEPDIR)/evebrowser.do_prepare: bootstrap webkitdfb @DEPENDS_evebrowser@
	svn checkout https://eve-browser.googlecode.com/svn/trunk/ @DIR_evebrowser@
	touch $@

$(DEPDIR)/evebrowser.do_compile: $(DEPDIR)/evebrowser.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_evebrowser@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/evebrowser: \
$(DEPDIR)/%evebrowser: $(DEPDIR)/evebrowser.do_compile
	cd @DIR_evebrowser@ && \
		@INSTALL_evebrowser@ && \
		cp -ar enigma2/HbbTv $(targetprefix)/usr/lib/enigma2/python/Plugins/SystemPlugins/
	@DISTCLEANUP_evebrowser@
	[ "x$*" = "x" ] && touch $@ || true

#
# brofs
#
$(DEPDIR)/brofs.do_prepare: bootstrap @DEPENDS_brofs@
	@PREPARE_brofs@
	touch $@

$(DEPDIR)/brofs.do_compile: $(DEPDIR)/brofs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_brofs@ && \
	$(BUILDENV) \
	$(MAKE) all
	touch $@

$(DEPDIR)/brofs: \
$(DEPDIR)/%brofs: $(DEPDIR)/brofs.do_compile
	cd @DIR_brofs@ && \
		@INSTALL_brofs@
	@DISTCLEANUP_brofs@
	[ "x$*" = "x" ] && touch $@ || true

#
# libcap
#
$(DEPDIR)/libcap.do_prepare: bootstrap @DEPENDS_libcap@
	@PREPARE_libcap@
	touch $@

$(DEPDIR)/libcap.do_compile: $(DEPDIR)/libcap.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcap@ && \
	$(MAKE) \
	DESTDIR=$(prefix)/cdkroot \
	PREFIX=$(prefix)/cdkroot/usr \
	LIBDIR=$(prefix)/cdkroot/usr/lib \
	SBINDIR=$(prefix)/cdkroot/usr/sbin \
	INCDIR=$(prefix)/cdkroot/usr/include \
	BUILD_CC=gcc \
	PAM_CAP=no \
	LIBATTR=no \
	CC=sh4-linux-gcc
	touch $@

$(DEPDIR)/libcap: \
$(DEPDIR)/%libcap: $(DEPDIR)/libcap.do_compile
	@[ "x$*" = "x" ] && touch $@ || true
	cd @DIR_libcap@ && \
		@INSTALL_libcap@ \
		DESTDIR=$(prefix)/cdkroot \
		PREFIX=$(prefix)/cdkroot/usr \
		LIBDIR=$(prefix)/cdkroot/usr/lib \
		SBINDIR=$(prefix)/cdkroot/usr/sbin \
		INCDIR=$(prefix)/cdkroot/usr/include \
		BUILD_CC=gcc \
		PAM_CAP=no \
		LIBATTR=no \
		CC=sh4-linux-gcc
	@DISTCLEANUP_libcap@
	[ "x$*" = "x" ] && touch $@ || true

#
# alsa-lib
#
$(DEPDIR)/libalsa.do_prepare: bootstrap @DEPENDS_libalsa@
	@PREPARE_libalsa@
	touch $@

$(DEPDIR)/libalsa.do_compile: $(DEPDIR)/libalsa.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libalsa@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-debug=no \
		--disable-aload \
		--disable-rawmidi \
		--disable-old-symbols \
		--disable-alisp \
		--disable-hwdep \
		--disable-python && \
	$(MAKE)
	touch $@

$(DEPDIR)/libalsa: \
$(DEPDIR)/%libalsa: $(DEPDIR)/libalsa.do_compile
	cd @DIR_libalsa@ && \
		@INSTALL_libalsa@
	@DISTCLEANUP_libalsa@
	[ "x$*" = "x" ] && touch $@ || true

#
# libopenthreads
#
$(DEPDIR)/libopenthreads.do_prepare: bootstrap @DEPENDS_libopenthreads@
	@PREPARE_libopenthreads@
	[ -d "$(archivedir)/cst-public-libraries-openthreads.git" ] && \
	(cd $(archivedir)/cst-public-libraries-openthreads.git; git pull ; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/cst-public-libraries-openthreads.git" ] || \
	git clone --recursive git://c00lstreamtech.de/cst-public-libraries-openthreads.git $(archivedir)/cst-public-libraries-openthreads.git; \
	cp -ra $(archivedir)/cst-public-libraries-openthreads.git $(buildprefix)/openthreads; \
	cd $(buildprefix)/openthreads && patch -p1 < "$(buildprefix)/Patches/libopenthreads.patch"
	touch $@

$(DEPDIR)/libopenthreads.do_compile: $(DEPDIR)/libopenthreads.do_prepare
	cd @DIR_libopenthreads@ && \
	rm CMakeFiles/* -rf CMakeCache.txt cmake_install.cmake && \
	cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME="Linux" \
		-DCMAKE_INSTALL_PREFIX="" \
		-DCMAKE_C_COMPILER="$(target)-gcc" \
		-DCMAKE_CXX_COMPILER="$(target)-g++" \
		-D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 && \
		find . -name cmake_install.cmake -print0 | xargs -0 \
		sed -i 's@SET(CMAKE_INSTALL_PREFIX "/usr/local")@SET(CMAKE_INSTALL_PREFIX "")@' && \
	$(MAKE)
	touch $@

$(DEPDIR)/libopenthreads: \
$(DEPDIR)/%libopenthreads: $(DEPDIR)/libopenthreads.do_compile
	cd @DIR_libopenthreads@ && \
		@INSTALL_libopenthreads@
	@DISTCLEANUP_libopenthreads@
	[ "x$*" = "x" ] && touch $@ || true

#
# rtmpdump
#
$(DEPDIR)/rtmpdump.do_prepare: bootstrap openssl openssl-dev @DEPENDS_rtmpdump@
	@PREPARE_rtmpdump@
	touch $@

$(DEPDIR)/rtmpdump.do_compile: $(DEPDIR)/rtmpdump.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_rtmpdump@ && \
	cp $(hostprefix)/share/libtool/config/ltmain.sh .. && \
	libtoolize -f -c && \
	$(BUILDENV) \
		make CROSS_COMPILE=$(target)-
	touch $@

$(DEPDIR)/rtmpdump: \
$(DEPDIR)/%rtmpdump: $(DEPDIR)/rtmpdump.do_compile
	cd @DIR_rtmpdump@ && \
		@INSTALL_rtmpdump@
	@DISTCLEANUP_rtmpdump@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdvbsi++
#
$(DEPDIR)/libdvbsipp.do_prepare: bootstrap @DEPENDS_libdvbsipp@
	@PREPARE_libdvbsipp@
	touch $@

$(DEPDIR)/libdvbsipp.do_compile: $(DEPDIR)/libdvbsipp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdvbsipp@ && \
	aclocal -I $(hostprefix)/share/aclocal -I m4 && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdvbsipp: \
$(DEPDIR)/%libdvbsipp: $(DEPDIR)/libdvbsipp.do_compile
	cd @DIR_libdvbsipp@ && \
		@INSTALL_libdvbsipp@
	@DISTCLEANUP_libdvbsipp@
	[ "x$*" = "x" ] && touch $@ || true

#
# tuxtxtlib
#
$(DEPDIR)/tuxtxtlib.do_prepare: bootstrap @DEPENDS_tuxtxtlib@
	@PREPARE_tuxtxtlib@
	touch $@

$(DEPDIR)/tuxtxtlib.do_compile: $(DEPDIR)/tuxtxtlib.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tuxtxtlib@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/etc \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tuxtxtlib: \
$(DEPDIR)/%tuxtxtlib: $(DEPDIR)/tuxtxtlib.do_compile
	cd @DIR_tuxtxtlib@ && \
		@INSTALL_tuxtxtlib@
	@DISTCLEANUP_tuxtxtlib@
	[ "x$*" = "x" ] && touch $@ || true

#
# tuxtxt32bpp
#
$(DEPDIR)/tuxtxt32bpp.do_prepare: tuxtxtlib @DEPENDS_tuxtxt32bpp@
	@PREPARE_tuxtxt32bpp@
	touch $@

$(DEPDIR)/tuxtxt32bpp.do_compile: $(DEPDIR)/tuxtxt32bpp.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tuxtxt32bpp@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign --add-missing && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-boxtype=generic \
		--with-configdir=/etc \
		--with-datadir=/usr/share/tuxtxt \
		--with-fontdir=/usr/share/fonts && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tuxtxt32bpp: \
$(DEPDIR)/%tuxtxt32bpp: $(DEPDIR)/tuxtxt32bpp.do_compile
	cd @DIR_tuxtxt32bpp@ && \
		@INSTALL_tuxtxt32bpp@
	@DISTCLEANUP_tuxtxt32bpp@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdreamdvd
#
$(DEPDIR)/libdreamdvd.do_prepare: bootstrap @DEPENDS_libdreamdvd@
	@PREPARE_libdreamdvd@
	touch $@

$(DEPDIR)/libdreamdvd.do_compile: $(DEPDIR)/libdreamdvd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdreamdvd@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdreamdvd: \
$(DEPDIR)/%libdreamdvd: $(DEPDIR)/libdreamdvd.do_compile
	cd @DIR_libdreamdvd@ && \
		@INSTALL_libdreamdvd@
	@DISTCLEANUP_libdreamdvd@
	[ "x$*" = "x" ] && touch $@ || true

#
# libdreamdvd2
#
$(DEPDIR)/libdreamdvd2.do_prepare: bootstrap @DEPENDS_libdreamdvd2@
	[ -d "libdreamdvd" ] && \
	cd libdreamdvd && git pull; \
	[ -d "libdreamdvd" ] || \
	git clone git://github.com/mirakels/libdreamdvd.git;
	touch $@

$(DEPDIR)/libdreamdvd2.do_compile: $(DEPDIR)/libdreamdvd2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libdreamdvd2@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libdreamdvd2: \
$(DEPDIR)/%libdreamdvd2: $(DEPDIR)/libdreamdvd2.do_compile
	cd @DIR_libdreamdvd2@ && \
		@INSTALL_libdreamdvd2@
	@DISTCLEANUP_libdreamdvd2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmpeg2
#
$(DEPDIR)/libmpeg2.do_prepare: bootstrap @DEPENDS_libmpeg2@
	@PREPARE_libmpeg2@
	touch $@

$(DEPDIR)/libmpeg2.do_compile: $(DEPDIR)/libmpeg2.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmpeg2@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmpeg2: \
$(DEPDIR)/%libmpeg2: $(DEPDIR)/libmpeg2.do_compile
	cd @DIR_libmpeg2@ && \
		@INSTALL_libmpeg2@
	@DISTCLEANUP_libmpeg2@
	[ "x$*" = "x" ] && touch $@ || true

#
# libsamplerate
#
$(DEPDIR)/libsamplerate.do_prepare: bootstrap @DEPENDS_libsamplerate@
	@PREPARE_libsamplerate@
	touch $@

$(DEPDIR)/libsamplerate.do_compile: $(DEPDIR)/libsamplerate.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libsamplerate@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libsamplerate: \
$(DEPDIR)/%libsamplerate: $(DEPDIR)/libsamplerate.do_compile
	cd @DIR_libsamplerate@ && \
		@INSTALL_libsamplerate@
	@DISTCLEANUP_libsamplerate@
	[ "x$*" = "x" ] && touch $@ || true

#
# libvorbis
#
$(DEPDIR)/libvorbis.do_prepare: bootstrap @DEPENDS_libvorbis@
	@PREPARE_libvorbis@
	touch $@

$(DEPDIR)/libvorbis.do_compile: $(DEPDIR)/libvorbis.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libvorbis@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libvorbis: \
$(DEPDIR)/%libvorbis: $(DEPDIR)/libvorbis.do_compile
	cd @DIR_libvorbis@ && \
		@INSTALL_libvorbis@
	@DISTCLEANUP_libvorbis@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmodplug
#
$(DEPDIR)/libmodplug.do_prepare: bootstrap @DEPENDS_libmodplug@
	@PREPARE_libmodplug@
	touch $@

$(DEPDIR)/libmodplug.do_compile: $(DEPDIR)/libmodplug.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmodplug@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmodplug: \
$(DEPDIR)/%libmodplug: $(DEPDIR)/libmodplug.do_compile
	cd @DIR_libmodplug@ && \
		@INSTALL_libmodplug@
	@DISTCLEANUP_libmodplug@
	[ "x$*" = "x" ] && touch $@ || true

#
# tiff
#
$(DEPDIR)/tiff.do_prepare: bootstrap @DEPENDS_tiff@
	@PREPARE_tiff@
	touch $@

$(DEPDIR)/tiff.do_compile: $(DEPDIR)/tiff.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_tiff@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/tiff: \
$(DEPDIR)/%tiff: $(DEPDIR)/tiff.do_compile
	cd @DIR_tiff@ && \
		@INSTALL_tiff@
	@DISTCLEANUP_tiff@
	[ "x$*" = "x" ] && touch $@ || true

#
# lzo
#
$(DEPDIR)/lzo.do_prepare: bootstrap @DEPENDS_lzo@
	@PREPARE_lzo@
	touch $@

$(DEPDIR)/lzo.do_compile: $(DEPDIR)/lzo.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_lzo@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/lzo: \
$(DEPDIR)/%lzo: $(DEPDIR)/lzo.do_compile
	cd @DIR_lzo@ && \
		@INSTALL_lzo@
	@DISTCLEANUP_lzo@
	[ "x$*" = "x" ] && touch $@ || true

#
# yajl
#
$(DEPDIR)/yajl.do_prepare: bootstrap @DEPENDS_yajl@
	@PREPARE_yajl@
	touch $@

$(DEPDIR)/yajl.do_compile: $(DEPDIR)/yajl.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_yajl@ && \
	sed -i "s/install: all/install: distro/g" configure && \
	$(BUILDENV) \
	./configure \
		--prefix=/usr && \
	$(MAKE) distro
	touch $@

$(DEPDIR)/yajl: \
$(DEPDIR)/%yajl: $(DEPDIR)/yajl.do_compile
	cd @DIR_yajl@ && \
		@INSTALL_yajl@
	@DISTCLEANUP_yajl@
	[ "x$*" = "x" ] && touch $@ || true

#
# libpcre (shouldn't this be named pcre without the lib?)
#
$(DEPDIR)/libpcre.do_prepare: bootstrap @DEPENDS_libpcre@
	@PREPARE_libpcre@
	touch $@

$(DEPDIR)/libpcre.do_compile: $(DEPDIR)/libpcre.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libpcre@ && \
	$(BUILDENV) \
	./configure \
		--build=$(build) \
		--host=$(target) \
		--prefix=/usr \
		--enable-utf8 \
		--enable-unicode-properties && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libpcre: \
$(DEPDIR)/%libpcre: $(DEPDIR)/libpcre.do_compile
	cd @DIR_libpcre@ && \
		sed -e "s,^prefix=,prefix=$(targetprefix)," < pcre-config > $(crossprefix)/bin/pcre-config && \
		chmod 755 $(crossprefix)/bin/pcre-config && \
		@INSTALL_libpcre@
		rm -f $(targetprefix)/usr/bin/pcre-config
	@DISTCLEANUP_libpcre@
	[ "x$*" = "x" ] && touch $@ || true

#
# libcdio
#
$(DEPDIR)/libcdio.do_prepare: bootstrap @DEPENDS_libcdio@
	@PREPARE_libcdio@
	touch $@

$(DEPDIR)/libcdio.do_compile: $(DEPDIR)/libcdio.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libcdio@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libcdio: \
$(DEPDIR)/%libcdio: $(DEPDIR)/libcdio.do_compile
	cd @DIR_libcdio@ && \
		@INSTALL_libcdio@
	@DISTCLEANUP_libcdio@
	[ "x$*" = "x" ] && touch $@ || true

#
# jasper
#
$(DEPDIR)/jasper.do_prepare: bootstrap @DEPENDS_jasper@
	@PREPARE_jasper@
	touch $@

$(DEPDIR)/jasper.do_compile: $(DEPDIR)/jasper.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_jasper@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/jasper: \
$(DEPDIR)/%jasper: $(DEPDIR)/jasper.do_compile
	cd @DIR_jasper@ && \
		@INSTALL_jasper@
	@DISTCLEANUP_jasper@
	[ "x$*" = "x" ] && touch $@ || true

#
# mysql
#
$(DEPDIR)/mysql.do_prepare: bootstrap @DEPENDS_mysql@
	@PREPARE_mysql@
	touch $@

$(DEPDIR)/mysql.do_compile: $(DEPDIR)/mysql.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_mysql@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--with-atomic-ops=up --with-embedded-server --prefix=/usr --sysconfdir=/etc/mysql --localstatedir=/var/mysql --disable-dependency-tracking --without-raid --without-debug --with-low-memory --without-query-cache --without-man --without-docs --without-innodb && \
	$(MAKE) all
	touch $@

$(DEPDIR)/mysql: \
$(DEPDIR)/%mysql: $(DEPDIR)/mysql.do_compile
	cd @DIR_mysql@ && \
		@INSTALL_mysql@
	@DISTCLEANUP_mysql@
	[ "x$*" = "x" ] && touch $@ || true

#
# libmicrohttpd
#
$(DEPDIR)/libmicrohttpd.do_prepare: bootstrap @DEPENDS_libmicrohttpd@
	@PREPARE_libmicrohttpd@
	touch $@

$(DEPDIR)/libmicrohttpd.do_compile: $(DEPDIR)/libmicrohttpd.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libmicrohttpd@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libmicrohttpd: \
$(DEPDIR)/%libmicrohttpd: $(DEPDIR)/libmicrohttpd.do_compile
	cd @DIR_libmicrohttpd@ && \
		@INSTALL_libmicrohttpd@
	@DISTCLEANUP_libmicrohttpd@
	[ "x$*" = "x" ] && touch $@ || true

#
# libexif
#
$(DEPDIR)/libexif.do_prepare: bootstrap @DEPENDS_libexif@
	@PREPARE_libexif@
	touch $@

$(DEPDIR)/libexif.do_compile: $(DEPDIR)/libexif.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_libexif@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE)
	touch $@

$(DEPDIR)/libexif: \
$(DEPDIR)/%libexif: $(DEPDIR)/libexif.do_compile
	cd @DIR_libexif@ && \
		@INSTALL_libexif@
	@DISTCLEANUP_libexif@
	[ "x$*" = "x" ] && touch $@ || true

#
# minidlna
#
$(DEPDIR)/minidlna.do_prepare: bootstrap ffmpeg libflac libogg libvorbis libid3tag sqlite libexif libjpeg @DEPENDS_minidlna@
	@PREPARE_minidlna@
	touch $@

$(DEPDIR)/minidlna.do_compile: $(DEPDIR)/minidlna.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_minidlna@ && \
	libtoolize -f -c && \
	$(BUILDENV) \
	$(MAKE) \
	DESTDIR=$(prefix)/cdkroot \
	PREFIX=$(prefix)/cdkroot/usr \
	LIBDIR=$(prefix)/cdkroot/usr/lib \
	SBINDIR=$(prefix)/cdkroot/usr/sbin \
	INCDIR=$(prefix)/cdkroot/usr/include \
	PAM_CAP=no \
	LIBATTR=no
	touch $@

$(DEPDIR)/minidlna: \
$(DEPDIR)/%minidlna: $(DEPDIR)/minidlna.do_compile
	cd @DIR_minidlna@ && \
		@INSTALL_minidlna@
	@DISTCLEANUP_minidlna@
	[ "x$*" = "x" ] && touch $@ || true

#
# vlc
#
$(DEPDIR)/vlc.do_prepare: bootstrap libstdc++-dev libfribidi ffmpeg @DEPENDS_vlc@
	@PREPARE_vlc@
	touch $@

$(DEPDIR)/vlc.do_compile: $(DEPDIR)/vlc.do_prepare
	cd @DIR_vlc@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--disable-fontconfig \
		--prefix=/usr \
		--disable-xcb \
		--disable-glx \
		--disable-qt4 \
		--disable-mad \
		--disable-postproc \
		--disable-a52 \
		--disable-qt4 \
		--disable-skins2 \
		--disable-remoteosd \
		--disable-lua \
		--disable-libgcrypt \
		--disable-nls \
		--disable-mozilla \
		--disable-dbus \
		--disable-sdl \
		--enable-run-as-root
	touch $@

$(DEPDIR)/vlc: \
$(DEPDIR)/%vlc: $(DEPDIR)/vlc.do_compile
	cd @DIR_vlc@ && \
		@INSTALL_vlc@
	@DISTCLEANUP_vlc@
	@[ "x$*" = "x" ] && touch $@ || true

#
# djmount
#
$(DEPDIR)/djmount.do_prepare: bootstrap fuse @DEPENDS_djmount@
	@PREPARE_djmount@
	touch $@

$(DEPDIR)/djmount.do_compile: $(DEPDIR)/djmount.do_prepare
	cd @DIR_djmount@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/djmount: \
$(DEPDIR)/%djmount: $(DEPDIR)/djmount.do_compile
	cd @DIR_djmount@ && \
		@INSTALL_djmount@
	@DISTCLEANUP_djmount@
	[ "x$*" = "x" ] && touch $@ || true

#
# libupnp
#
$(DEPDIR)/libupnp.do_prepare: bootstrap @DEPENDS_libupnp@
	@PREPARE_libupnp@
	touch $@

$(DEPDIR)/libupnp.do_compile: $(DEPDIR)/libupnp.do_prepare
	cd @DIR_libupnp@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libupnp: \
$(DEPDIR)/%libupnp: $(DEPDIR)/libupnp.do_compile
	cd @DIR_libupnp@ && \
		@INSTALL_libupnp@
	@DISTCLEANUP_libupnp@
	[ "x$*" = "x" ] && touch $@ || true

#
# rarfs
#
$(DEPDIR)/rarfs.do_prepare: bootstrap libstdc++-dev fuse @DEPENDS_rarfs@
	@PREPARE_rarfs@
	touch $@

$(DEPDIR)/rarfs.do_compile: $(DEPDIR)/rarfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_rarfs@ && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	$(BUILDENV) \
	CFLAGS="$(TARGET_CFLAGS) -D_FILE_OFFSET_BITS=64" \
	./configure \
		--host=$(target) \
		--disable-option-checking \
		--includedir=/usr/include/fuse \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/rarfs: \
$(DEPDIR)/%rarfs: $(DEPDIR)/rarfs.do_compile
	cd @DIR_rarfs@ && \
		@INSTALL_rarfs@
	@DISTCLEANUP_rarfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# sshfs
#
$(DEPDIR)/sshfs.do_prepare: bootstrap fuse @DEPENDS_sshfs@
	@PREPARE_sshfs@
	touch $@

$(DEPDIR)/sshfs.do_compile: $(DEPDIR)/sshfs.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_sshfs@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr
	touch $@

$(DEPDIR)/sshfs: \
$(DEPDIR)/%sshfs: $(DEPDIR)/sshfs.do_compile
	cd @DIR_sshfs@ && \
		@INSTALL_sshfs@
	@DISTCLEANUP_sshfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# gmediarender
#
$(DEPDIR)/gmediarender.do_prepare: bootstrap libstdc++-dev gst_plugins_dvbmediasink libupnp @DEPENDS_gmediarender@
	@PREPARE_gmediarender@
	touch $@

$(DEPDIR)/gmediarender.do_compile: $(DEPDIR)/gmediarender.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_gmediarender@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr \
		--with-libupnp=$(targetprefix)/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/gmediarender: \
$(DEPDIR)/%gmediarender: $(DEPDIR)/gmediarender.do_compile
	cd @DIR_gmediarender@ && \
		@INSTALL_gmediarender@
	@DISTCLEANUP_gmediarender@
	[ "x$*" = "x" ] && touch $@ || true

#
# mediatomb
#
$(DEPDIR)/mediatomb.do_prepare: bootstrap libstdc++-dev ffmpeg libcurl sqlite libexpat @DEPENDS_mediatomb@
	@PREPARE_mediatomb@
	touch $@

$(DEPDIR)/mediatomb.do_compile: $(DEPDIR)/mediatomb.do_prepare
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd @DIR_mediatomb@ && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--disable-ffmpegthumbnailer \
		--disable-libmagic \
		--disable-mysql \
		--disable-id3lib \
		--disable-taglib \
		--disable-lastfmlib \
		--disable-libexif \
		--disable-libmp4v2 \
		--disable-inotify \
		--with-avformat-h=$(targetprefix)/usr/include \
		--disable-rpl-malloc \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/mediatomb: \
$(DEPDIR)/%mediatomb: $(DEPDIR)/mediatomb.do_compile
	cd @DIR_mediatomb@ && \
		@INSTALL_mediatomb@
	@DISTCLEANUP_mediatomb@
	[ "x$*" = "x" ] && touch $@ || true

#
# tinyxml
#
$(DEPDIR)/tinyxml.do_prepare: @DEPENDS_tinyxml@
	@PREPARE_tinyxml@
	touch $@

$(DEPDIR)/tinyxml.do_compile: $(DEPDIR)/tinyxml.do_prepare
	cd @DIR_tinyxml@ && \
	libtoolize -f -c && \
	$(BUILDENV) \
	$(MAKE)
	touch $@

$(DEPDIR)/tinyxml: \
$(DEPDIR)/%tinyxml: $(DEPDIR)/tinyxml.do_compile
	cd @DIR_tinyxml@ && \
		@INSTALL_tinyxml@
	@DISTCLEANUP_tinyxml@
	[ "x$*" = "x" ] && touch $@ || true
	
#
# libnfs
#
$(DEPDIR)/libnfs.do_prepare: bootstrap @DEPENDS_libnfs@
	@PREPARE_libnfs@
	touch $@

$(DEPDIR)/libnfs.do_compile: $(DEPDIR)/libnfs.do_prepare
	cd @DIR_libnfs@ && \
	aclocal -I $(hostprefix)/share/aclocal && \
	autoheader && \
	autoconf && \
	automake --foreign && \
	libtoolize --force && \
	$(BUILDENV) \
	./configure \
		--host=$(target) \
		--prefix=/usr && \
	$(MAKE) all
	touch $@

$(DEPDIR)/libnfs: \
$(DEPDIR)/%libnfs: $(DEPDIR)/libnfs.do_compile
	cd @DIR_libnfs@ && \
		@INSTALL_libnfs@
	@DISTCLEANUP_libnfs@
	[ "x$*" = "x" ] && touch $@ || true

#
# taglib
#
$(DEPDIR)/taglib.do_prepare: bootstrap @DEPENDS_taglib@
	@PREPARE_taglib@
	touch $@

$(DEPDIR)/taglib.do_compile: $(DEPDIR)/taglib.do_prepare
	cd @DIR_taglib@ && \
	$(BUILDENV) \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_RELEASE_TYPE=Release . && \
	$(MAKE) all
	touch $@

$(DEPDIR)/taglib: \
$(DEPDIR)/%taglib: $(DEPDIR)/taglib.do_compile
	cd @DIR_taglib@ && \
		@INSTALL_taglib@
	@DISTCLEANUP_taglib@
	[ "x$*" = "x" ] && touch $@ || true
