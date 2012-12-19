#
# Makefile to build NEUTRINO
#

$(targetprefix)/var/etc/.version:
	echo "imagename=Neutrino-HD" > $@
	echo "homepage=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "creator=`id -un`" >> $@
	echo "docs=http://gitorious.org/open-duckbox-project-sh4/pages/Home" >> $@
	echo "forum=http://gitorious.org/open-duckbox-project-sh4" >> $@
	echo "version=0100`date +%Y%m%d%H%M`" >> $@
	echo "git =`git describe`" >> $@

#
#
#
N_CPPFLAGS = -DNEW_LIBCURL -DFB_BLIT -DBGP_JPG

N_CONFIG_OPTS = --enable-silent-rules

if ENABLE_EXTERNALLCD
N_CONFIG_OPTS += --enable-graphlcd
endif

if ENABLE_EPLAYER3
N_CONFIG_OPTS += --enable-libeplayer3
endif

#
# NEUTRINO TWIN
#
$(DEPDIR)/neutrino-twin.do_prepare:
	rm -rf $(appsdir)/neutrino-twin
	rm -rf $(appsdir)/neutrino-twin.org
	[ -d "$(archivedir)/neutrino-hd.git" ] && \
	(cd $(archivedir)/neutrino-hd.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/neutrino-hd.git" ] || \
	git clone git://c00lstreamtech.de/cst-public-gui-neutrino.git $(archivedir)/neutrino-hd.git; \
	cp -ra $(archivedir)/neutrino-hd.git $(appsdir)/neutrino-twin; \
	(cd $(appsdir)/neutrino-twin; git checkout dvbsi++; cd "$(buildprefix)";); \
	rm -rf $(appsdir)/neutrino-twin/lib/libcoolstream/*.*
	cp -ra $(appsdir)/neutrino-twin $(appsdir)/neutrino-twin.org
	cd $(appsdir)/neutrino-twin && patch -p1 < "$(buildprefix)/Patches/neutrino.twin.diff"
	cd $(appsdir)/neutrino-twin && patch -p1 < "$(buildprefix)/Patches/neutrino.twin.libcool.diff"
	touch $@

$(appsdir)/neutrino-twin/config.status: bootstrap $(EXTERNALLCD_DEP) libdvbsipp freetype libjpeg libpng libungif libid3tag libcurl libmad libvorbisidec libboost openssl libopenthreads sdparm
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-twin && \
		$(BUILDENV) \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		./configure \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/share/tuxbox \
			--with-fontdir=/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)" \
			CXXFLAGS="$(TARGET_CFLAGS) -Os"

$(DEPDIR)/neutrino-twin.do_compile: $(appsdir)/neutrino-twin/config.status
	cd $(appsdir)/neutrino-twin && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino-twin: neutrino-twin.do_prepare neutrino-twin.do_compile
	$(MAKE) -C $(appsdir)/neutrino-twin install DESTDIR=$(targetprefix) && \
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	$(target)-strip $(targetprefix)/usr/local/sbin/udpstreampes
	touch $@

neutrino-twin-clean:
	rm -f $(DEPDIR)/neutrino-twin
	cd $(appsdir)/neutrino-twin && \
		$(MAKE) distclean

neutrino-twin-distclean:
	rm -f $(DEPDIR)/neutrino-twin
	rm -f $(DEPDIR)/neutrino-twin.do_compile
	rm -f $(DEPDIR)/neutrino-twin.do_prepare

#
# neutrino-hd2-exp branch
#
$(DEPDIR)/neutrino-hd2-exp.do_prepare:
	rm -rf $(appsdir)/neutrino-hd2-exp
	rm -rf $(appsdir)/neutrino-hd2-exp.org
	svn co http://neutrinohd2.googlecode.com/svn/branches/nhd2-exp $(appsdir)/neutrino-hd2-exp
	cp -ra $(appsdir)/neutrino-hd2-exp $(appsdir)/neutrino-hd2-exp.org
	cd $(appsdir)/neutrino-hd2-exp && patch -p1 < "$(buildprefix)/Patches/neutrino.hd2.exp.diff"
	touch $@

$(appsdir)/neutrino-hd2-exp/config.status: bootstrap $(EXTERNALLCD_DEP) libfreetype libjpeg libpng libgif libid3tag libcurl libmad libvorbisidec libboost libflac openssl sdparm
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino-hd2-exp && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			$(N_CONFIG_OPTS) \
			--with-boxtype=$(BOXTYPE) \
			--with-tremor \
			--with-libdir=/usr/lib \
			--with-datadir=/share/tuxbox \
			--with-fontdir=/share/fonts \
			--with-configdir=/var/tuxbox/config \
			--with-gamesdir=/var/tuxbox/games \
			--with-plugindir=/var/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS) \
			CPPFLAGS="$(N_CPPFLAGS)"

$(DEPDIR)/neutrino-hd2-exp: neutrino-hd2-exp.do_prepare neutrino-hd2-exp.do_compile
	$(MAKE) -C $(appsdir)/neutrino-hd2-exp install DESTDIR=$(targetprefix) && \
	make $(targetprefix)/var/etc/.version
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

$(DEPDIR)/neutrino-hd2-exp.do_compile: $(appsdir)/neutrino-hd2-exp/config.status
	cd $(appsdir)/neutrino-hd2-exp && \
		$(MAKE) all
	touch $@

neutrino-hd2-exp-clean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	cd $(appsdir)/neutrino-hd2-exp && \
		$(MAKE) clean

neutrino-hd2-exp-distclean:
	rm -f $(DEPDIR)/neutrino-hd2-exp
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_compile
	rm -f $(DEPDIR)/neutrino-hd2-exp.do_prepare

#
#NORMAL
#
$(appsdir)/neutrino/config.status: bootstrap $(EXTERNALLCD_DEP) libfreetype libpng libid3tag openssl libcurl libmad libboost libgif sdparm
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/neutrino && \
		ACLOCAL_FLAGS="-I $(hostprefix)/share/aclocal" ./autogen.sh && \
		$(BUILDENV) \
		./configure \
			--host=$(target) \
			--without-libsdl \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/local/share \
			--with-fontdir=/usr/local/share/fonts \
			--with-configdir=/usr/local/share/config \
			--with-gamesdir=/usr/local/share/games \
			--with-plugindir=/usr/lib/tuxbox/plugins \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/neutrino.do_prepare:
	touch $@

$(DEPDIR)/neutrino.do_compile: $(appsdir)/neutrino/config.status
	cd $(appsdir)/neutrino && \
		$(MAKE) all
	touch $@

$(DEPDIR)/neutrino: neutrino.do_prepare neutrino.do_compile
	$(MAKE) -C $(appsdir)/neutrino install DESTDIR=$(targetprefix) DATADIR=$(targetprefix)/usr/local/share/
	$(target)-strip $(targetprefix)/usr/local/bin/neutrino
	$(target)-strip $(targetprefix)/usr/local/bin/pzapit
	$(target)-strip $(targetprefix)/usr/local/bin/sectionsdcontrol
	touch $@

neutrino-clean neutrino-distclean:
	rm -f $(DEPDIR)/neutrino
	rm -f $(DEPDIR)/neutrino.do_compile
	rm -f $(DEPDIR)/neutrino.do_prepare
	cd $(appsdir)/neutrino && \
		$(MAKE) distclean

