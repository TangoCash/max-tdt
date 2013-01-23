#
# misc/tools
#
#$(appsdir)/misc/tools/config.status: bootstrap driver libstdc++-dev libdvdnav libdvdcss bzip2 libpng libjpeg ffmpeg
$(appsdir)/misc/tools/config.status: bootstrap driver libstdc++-dev bzip2 libpng libjpeg ffmpeg
	export PATH=$(hostprefix)/bin:$(PATH) && \
	cd $(appsdir)/misc/tools && \
	libtoolize -f -c && \
	$(CONFIGURE) --prefix= \
	$(if $(MULTICOM324), --enable-multicom324)

$(DEPDIR)/misc-tools: \
$(DEPDIR)/%misc-tools: $(appsdir)/misc/tools/config.status
	$(MAKE) -C $(appsdir)/misc/tools all install DESTDIR=$(prefix)/$*cdkroot \
	CPPFLAGS="\
	$(if $(UFS910), -DPLATFORM_UFS910) \
	$(if $(UFS912), -DPLATFORM_UFS912) \
	$(if $(UFS913), -DPLATFORM_UFS913) \
	$(if $(UFS922), -DPLATFORM_UFS922) \
	$(if $(SPARK), -DPLATFORM_SPARK) \
	$(if $(SPARK7162), -DPLATFORM_SPARK7162) \
	$(if $(FORTIS_HDBOX), -DPLATFORM_FORTIS_HDBOX) \
	$(if $(OCTAGON1008), -DPLATFORM_OCTAGON1008) \
	$(if $(CUBEREVO), -DPLATFORM_CUBEREVO) \
	$(if $(CUBEREVO_MINI), -DPLATFORM_CUBEREVO_MINI) \
	$(if $(CUBEREVO_MINI2), -DPLATFORM_CUBEREVO_MINI2) \
	$(if $(CUBEREVO_MINI_FTA), -DPLATFORM_CUBEREVO_MINI_FTA) \
	$(if $(CUBEREVO_250HD), -DPLATFORM_CUBEREVO_250HD) \
	$(if $(CUBEREVO_2000HD), -DPLATFORM_CUBEREVO_2000HD) \
	$(if $(CUBEREVO_9500HD), -DPLATFORM_CUBEREVO_9500HD) \
	$(if $(ATEVIO7500), -DPLATFORM_ATEVIO7500) \
	$(if $(HS7810A), -DPLATFORM_HS7810A) \
	$(if $(HS7110), -DPLATFORM_HS7110) \
	$(if $(WHITEBOX), -DPLATFORM_WHITEBOX) \
	$(if $(IPBOX9900), -DPLATFORM_IPBOX9900) \
	$(if $(IPBOX99), -DPLATFORM_IPBOX99) \
	$(if $(IPBOX55), -DPLATFORM_IPBOX55) \
	$(if $(PLAYER191), -DPLAYER191)"
	[ "x$*" = "x" ] && touch $@ || true

misc-tools-clean:
	-$(MAKE) -C $(appsdir)/misc/tools distclean
