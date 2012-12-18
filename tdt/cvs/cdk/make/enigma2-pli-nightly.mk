#
# tuxbox/enigma2
#

E_CONFIG_OPTS =

if ENABLE_EXTERNALLCD
E_CONFIG_OPTS += --with-graphlcd
endif

if ENABLE_EPLAYER3
E_CONFIG_OPTS += --enable-libeplayer3
endif

$(DEPDIR)/enigma2-pli-nightly.do_prepare:
	REVISION=""; \
	HEAD="master"; \
	DIFF="0"; \
	REPO="git://openpli.git.sourceforge.net/gitroot/openpli/enigma2"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	rm -rf $(appsdir)/enigma2-nightly.org; \
	rm -rf $(appsdir)/enigma2-nightly.newest; \
	rm -rf $(appsdir)/enigma2-nightly.patched; \
	clear; \
	echo ""; \
	echo "Choose between the following revisions:"; \
	echo "========================================================================================================"; \
	echo " 0) Newest                 - E2 OpenPli gstreamer / libplayer3    (Can fail due to outdated patch)     "; \
	echo " 1) Sat, 17 Mar 2012 19:51 - E2 OpenPli gstreamer              945aeb939308b3652b56bc6c577853369d54a537"; \
	echo " 2) Sat, 18 Aug 2012 11:12 - E2 OpenPli gstreamer / libplayer3 4f3396b610f5524d85e06f51cbd3186b75f4b6d3"; \
	echo " 3) Mon, 20 Aug 2012 19:08 - E2 OpenPli gstreamer / libplayer3 51a7b9349070830b5c75feddc52e97a1109e381e"; \
	echo " 4) Fri, 24 Aug 2012 23:42 - E2 OpenPli gstreamer / libplayer3 002b85aa8350e9d8e88f75af48c3eb8a6cdfb880"; \
	echo " 5) Fri, 05 Oct 2012 21:37 - E2 OpenPli gstreamer / libplayer3 7e38f7f6c911cd16106fb3b131e5c2d3a7ea51c7"; \
	echo " 6) Thu, 08 Nov 2012 17:49 - E2 OpenPli gstreamer / libplayer3 7bbae39ee0c8744cd195de7b1375a549cdb508d8"; \
	echo "========================================================================================================"; \
	echo "Media Framwork : $(MEDIAFW)"; \
	echo "External LCD   : $(EXTERNALLCD)"; \
	read -p "Select         : "; \
	[ "$$REPLY" == "0" ] && DIFF="0"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && REVISION="945aeb939308b3652b56bc6c577853369d54a537"; \
	[ "$$REPLY" == "2" ] && DIFF="2" && REVISION="4f3396b610f5524d85e06f51cbd3186b75f4b6d3"; \
	[ "$$REPLY" == "3" ] && DIFF="3" && REVISION="51a7b9349070830b5c75feddc52e97a1109e381e"; \
	[ "$$REPLY" == "4" ] && DIFF="4" && REVISION="002b85aa8350e9d8e88f75af48c3eb8a6cdfb880"; \
	[ "$$REPLY" == "5" ] && DIFF="5" && REVISION="7e38f7f6c911cd16106fb3b131e5c2d3a7ea51c7"; \
	[ "$$REPLY" == "6" ] && DIFF="6" && REVISION="7bbae39ee0c8744cd195de7b1375a549cdb508d8"; \
	echo "Revision       : "$$REVISION; \
	echo ""; \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] && \
	(cd $(archivedir)/enigma2-pli-nightly.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] || \
	git clone -b $$HEAD $$REPO $(archivedir)/enigma2-pli-nightly.git; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(appsdir)/enigma2-nightly.newest; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(appsdir)/enigma2-nightly; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.org; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-nightly.$$DIFF.diff"
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.patched
	touch $@

$(appsdir)/enigma2-pli-nightly/config.status: \
		bootstrap freetype expat libpng libjpeg libgif libfribidi libid3tag libmad libsigc libreadline libdvbsipp \
		python libxml2 libxslt elementtree zope_interface twisted pyopenssl pythonwifi pilimaging pyusb pycrypto \
		lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2 wpa_supplicant \
		$(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(appsdir)/enigma2-nightly && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(hostprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--prefix=/usr \
			--bindir=/usr/bin \
			--sysconfdir=/etc \
			$(E_CONFIG_OPTS) \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/enigma2-pli-nightly.do_compile: $(appsdir)/enigma2-pli-nightly/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-pli-nightly: enigma2-pli-nightly.do_prepare enigma2-pli-nightly.do_compile
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
	fi
	touch $@

enigma2-pli-nightly-clean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) distclean

enigma2-pli-nightly-distclean:
	rm -f $(DEPDIR)/enigma2-pli-nightly
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_compile
	rm -f $(DEPDIR)/enigma2-pli-nightly.do_prepare
	rm -rf $(appsdir)/enigma2-nightly
	rm -rf $(appsdir)/enigma2-nightly.newest
	rm -rf $(appsdir)/enigma2-nightly.org
	rm -rf $(appsdir)/enigma2-nightly.patched
